@'
#!/bin/sh
set -eu

# Env vars
OPENVPN_CONFIG_FILE=${OPENVPN_CONFIG_FILE:-/etc/openvpn/server.conf}
OPENVPN_SERVER_CONFIG_FILE=${OPENVPN_SERVER_CONFIG_FILE:-} # Deprecated. For backward compatibility
OPENVPN_ROUTES=${OPENVPN_ROUTES:-}
NAT=${NAT:-1}
NAT_INTERFACE=${NAT_INTERFACE:-eth0}
NAT_MASQUERADE=${NAT_MASQUERADE:-1}
CUSTOM_FIREWALL_SCRIPT=${CUSTOM_FIREWALL_SCRIPT:-/etc/openvpn/firewall.sh}

# Normalization
if [ -n "$OPENVPN_SERVER_CONFIG_FILE" ]; then
    echo "Warning: OPENVPN_SERVER_CONFIG_FILE is deprecated. Use OPENVPN_CONFIG_FILE instead."
    OPENVPN_CONFIG_FILE="$OPENVPN_SERVER_CONFIG_FILE"
fi

# If no args are passed, run the entrypoint. If a flag is passed, run openvpn directly. Else, run the passed command
if [ "$#" -eq 0 ]; then
    # Provision
    echo "Provisioning tun device"
    mkdir -p /dev/net
    if [ ! -c /dev/net/tun ]; then
        mknod /dev/net/tun c 10 200
    fi
    if [ -f "$CUSTOM_FIREWALL_SCRIPT" ]; then
        echo "Executing custom firewall script: $CUSTOM_FIREWALL_SCRIPT"
        . "$CUSTOM_FIREWALL_SCRIPT"
    else
        echo "Not executing custom firewall script $CUSTOM_FIREWALL_SCRIPT because it does not exist"
    fi
    if [ "$NAT" = 1 ]; then
        echo "NAT is enabled"
        echo "Provisioning NAT iptables rules"
        echo "NAT_INTERFACE: $NAT_INTERFACE"
        if [ "$NAT_MASQUERADE" = 1 ]; then
            echo "NAT_MASQUERADE is enabled"
            iptables -t nat -C POSTROUTING -o "$NAT_INTERFACE" -j MASQUERADE > dev/null 2>&1 || iptables -t nat -A POSTROUTING -o "$NAT_INTERFACE" -j MASQUERADE
            if [ -n "$OPENVPN_ROUTES" ]; then
                echo "Provisioning NAT iptables rules for OPENVPN_ROUTES=$OPENVPN_ROUTES"
                for r in $OPENVPN_ROUTES; do
                    iptables -t nat -C POSTROUTING -s "$r" -o "$NAT_INTERFACE" -j MASQUERADE > dev/null 2>&1 || iptables -t nat -A POSTROUTING -s "$r" -o "$NAT_INTERFACE" -j MASQUERADE
                done
            else
                echo "Not provisioning route iptables rules because OPENVPN_ROUTES is empty"
            fi
        else
            echo "Not provisioning NAT iptables rules because NAT_MASQUERADE is disabled."
        fi
    else
        echo "NAT is disabled."
        echo "Not adding NAT iptables rules"
    fi

    echo "Listing iptables rules:"
    iptables -L -nv
    echo "Listing iptables NAT rules:"
    iptables -L -nv -t nat

    # Generate the command line. openvpn man: https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/
    set openvpn --cd /etc/openvpn --config "$OPENVPN_CONFIG_FILE"
    echo "openvpn command line: $@"
    exec "$@"
elif [ "$#" -gt 0 ] && [ "${1#-}" != "$1" ]; then
    echo "openvpn command line: $@"
    exec openvpn "$@"
fi

exec "$@"

'@
