@'
#!/bin/sh

set -aeo pipefail

# Env vars
OPENVPN=openvpn
OPENVPN_SERVER_CONFIG_FILE=${OPENVPN_SERVER_CONFIG_FILE:-/etc/openvpn/server.conf}
# OPENVPN_CLIENT_CONFIG_DIR=${OPENVPN_CLIENT_CONFIG_DIR:-/etc/openvpn/ccd}
# OPENVPN_STATUS_FILE=${OPENVPN_STATUS_FILE:-}
# OPENVPN_STATUS_FILE_WRITE_FREQUENCY_SECONDS={$OPENVPN_STATUS_FILE_WRITE_FREQUENCY_SECONDS:-10}
OPENVPN_ROUTES=${OPENVPN_ROUTES:-}
NAT=${NAT:-1}
NAT_INTERFACE=${NAT_INTERFACE:-eth0}
CUSTOM_FIREWALL_SCRIPT=${CUSTOM_FIREWALL_SCRIPT:-/etc/openvpn/firewall.sh}

# Provision
echo "Provisioning tun device"
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi
if [ -f "$CUSTOM_FIREWALL_SCRIPT" ]; then
    echo "Executing custom firewall script $CUSTOM_FIREWALL_SCRIPT 1"
    sh "$CUSTOM_FIREWALL_SCRIPT"
else
    echo "Not executing custom firewall script $CUSTOM_FIREWALL_SCRIPT because it does not exist"
fi
if [ "$NAT" = 1 ]; then
    echo "NAT is enabled"
    echo "Provisioning nat iptables rules"
    iptables -t nat -C POSTROUTING -o "$NAT_INTERFACE" -j MASQUERADE || iptables -t nat -A POSTROUTING -o "$NAT_INTERFACE" -j MASQUERADE
    if [ -n "$OPENVPN_ROUTES" ]; then
        echo "Provisioning nat iptables rules for OPENVPN_ROUTES"
        for r in $OPENVPN_ROUTES; do
            iptables -t nat -C POSTROUTING -s "$r" -o "$NAT_INTERFACE" -j MASQUERADE || iptables -t nat -A POSTROUTING -s "$r" -o "$NAT_INTERFACE" -j MASQUERADE
        done
    else
        echo "Not provisioning route iptables rules because OPENVPN_ROUTES is empty"
    fi
else
    echo "NAT is disabled."
    echo "Not adding nat iptables rules"
fi

echo "Listing iptables rules:"
iptables -L -nv
iptables -L -nv -t nat

# Generate the command line. openvpn man: https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/
echo "Generating command line"
set "$OPENVPN" --cd /etc/openvpn
set "$@" --config "$OPENVPN_SERVER_CONFIG_FILE"
# set "$@" --client-config-dir "$OPENVPN_CLIENT_CONFIG_DIR"
if [ -n "$OPENVPN_STATUS_FILE" ]; then
    set "$@" --status "$OPENVPN_STATUS_FILE" "$OPENVPN_STATUS_FILE_WRITE_FREQUENCY_SECONDS"
fi

# Exec
echo "openvpn command line: $@"
exec "$@"
'@
