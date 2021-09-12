#!/bin/sh

# This iptables script is useful for openpvn in server mode. Not so much for client mode.

set -eo pipefail

# Drop everything by default from tunnel to world
iptables -P FORWARD DROP
# Allow DNS from tunnel to world
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
# Allow HTTP and HTTPS from tunnel to world
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p tcp -m tcp -m conntrack --ctstate NEW -m multiport --dports 80,443 -j ACCEPT
