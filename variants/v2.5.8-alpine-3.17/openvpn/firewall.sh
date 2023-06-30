#!/bin/sh

# This iptables script to controlling traffic in the openvpn tunnel.
# In this example, clients can only perform DNS, HTTP and HTTPS requests to the world.

set -eu -o pipefail

# Drop everything by default from tunnel to world
iptables -P FORWARD DROP
# Allow DNS from tunnel to world
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
# Allow HTTP and HTTPS from tunnel to world
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p tcp -m tcp -m conntrack --ctstate NEW -m multiport --dports 80,443 -j ACCEPT
