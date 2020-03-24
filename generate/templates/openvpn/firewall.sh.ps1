@'
#!/bin/sh

set -eo pipefail

# Only allow DNS, HTTP, HTTPS from tunnel to world
echo "$NAT_INTERFACE"
iptables -P FORWARD DROP
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p tcp -m tcp -m conntrack --ctstate NEW -m multiport --dports 80,443 -j ACCEPT
'@
