# docker-openvpn

[![github-actions](https://github.com/theohbrothers/docker-openvpn/workflows/build/badge.svg)](https://github.com/theohbrothers/docker-openvpn/actions)
[![github-tag](https://img.shields.io/github/tag/theohbrothers/docker-openvpn)](https://github.com/theohbrothers/docker-openvpn/releases/)
[![docker-image-size](https://img.shields.io/microbadger/image-size/theohbrothers/docker-openvpn/latest)](https://hub.docker.com/r/theohbrothers/docker-openvpn)
[![docker-image-layers](https://img.shields.io/microbadger/layers/theohbrothers/docker-openvpn/latest)](https://hub.docker.com/r/theohbrothers/docker-openvpn)

`easy-rsa` is not included. It is not considered best practice to be signing or be able to sign certs on the server.

# Tags

| Tags |
|:-------:| 
| `:v2.3.18-alpine-3.3` | 
| `:v2.3.18-alpine-3.4` | 
| `:v2.3.18-alpine-3.5` | 
| `:v2.4.4-alpine-3.6` | 
| `:v2.4.4-alpine-3.7` | 
| `:v2.4.6-alpine-3.8` | 
| `:v2.4.6-alpine-3.9` | 
| `:v2.4.7-alpine-3.10` | 
| `:v2.4.8-alpine-3.11` |

# Environments variables

| Environment variables | Description | Default Value |
|:-------:|:-------:|:-------:|
| `OPENVPN_SERVER_CONFIG_FILE` | Absolute path to the server config | `/etc/openvpn/server.conf` |
| `OPENVPN_ROUTES` | Space-delimited CIDRs to add iptables `POSTROUTING` NAT rules, performed only when `NAT` is `1` | `192.168.50.0/24 192.168.51.0/24` |
| `NAT` | Whether to use NAT. `0` to disable. `1` to enable. If NAT is enabled, iptables `POSTROUTING` rules will be provisioned | `1` |
| `NAT_INTERFACE` | Interface on which to use NAT. E.g. `eth0` | `eth0` |
| `CUSTOM_FIREWALL_SCRIPT` | Custom script for firewall. If present, this script is executed before any other `iptables` rules are provisioned | `/etc/openvpn/firewall.sh` |