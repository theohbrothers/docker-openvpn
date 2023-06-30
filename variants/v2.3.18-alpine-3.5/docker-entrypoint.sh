#!/bin/sh

set -eu -o pipefail

output() {
    echo -e "[$( date -u '+%Y-%m-%dT%H:%M:%S%z' )] $1"
}

error() {
    echo -e "[$( date -u '+%Y-%m-%dT%H:%M:%S%z' )] $1" >&2
}

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
    output "Warning: OPENVPN_SERVER_CONFIG_FILE is deprecated. Use OPENVPN_CONFIG_FILE instead."
    OPENVPN_CONFIG_FILE="$OPENVPN_SERVER_CONFIG_FILE"
fi

if [ "$#" -eq 0 ]; then
    # Provision
    output "Provisioning tun device"
    mkdir -p /dev/net
    if [ ! -c /dev/net/tun ]; then
        mknod /dev/net/tun c 10 200
    fi
    if [ -f "$CUSTOM_FIREWALL_SCRIPT" ]; then
        output "Executing custom firewall script: $CUSTOM_FIREWALL_SCRIPT"
        . "$CUSTOM_FIREWALL_SCRIPT"
    else
        output "Not executing custom firewall script $CUSTOM_FIREWALL_SCRIPT because it does not exist"
    fi
    if [ "$NAT" = 1 ]; then
        output "NAT is enabled"
        output "Provisioning NAT iptables rules"
        output "NAT_INTERFACE: $NAT_INTERFACE"
        if [ "$NAT_MASQUERADE" = 1 ]; then
            output "NAT_MASQUERADE is enabled"
            iptables -t nat -C POSTROUTING -o "$NAT_INTERFACE" -j MASQUERADE > dev/null 2>&1 || iptables -t nat -A POSTROUTING -o "$NAT_INTERFACE" -j MASQUERADE
            if [ -n "$OPENVPN_ROUTES" ]; then
                output "Provisioning NAT iptables rules for OPENVPN_ROUTES=$OPENVPN_ROUTES"
                for r in $OPENVPN_ROUTES; do
                    iptables -t nat -C POSTROUTING -s "$r" -o "$NAT_INTERFACE" -j MASQUERADE > dev/null 2>&1 || iptables -t nat -A POSTROUTING -s "$r" -o "$NAT_INTERFACE" -j MASQUERADE
                done
            else
                output "Not provisioning route iptables rules because OPENVPN_ROUTES is empty"
            fi
        else
            output "Not provisioning NAT iptables rules because NAT_MASQUERADE is disabled."
        fi
    else
        output "NAT is disabled."
        output "Not adding NAT iptables rules"
    fi

    output "Listing iptables rules:"
    iptables -L -nv
    output "Listing iptables NAT rules:"
    iptables -L -nv -t nat

    # Generate the command line. openvpn man: https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/
    set openvpn --cd /etc/openvpn --config "$OPENVPN_CONFIG_FILE"
    output "openvpn command line: $@"
    exec "$@"
elif [ "$#" -gt 0 ] && [ "${1#-}" != "$1" ]; then
    output "openvpn command line: $@"
    exec openvpn "$@"
fi

exec "$@"
