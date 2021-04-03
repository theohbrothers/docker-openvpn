# docker-openvpn

[![github-actions](https://github.com/theohbrothers/docker-openvpn/workflows/ci-master-pr/badge.svg)](https://github.com/theohbrothers/docker-openvpn/actions)
[![github-tag](https://img.shields.io/github/tag/theohbrothers/docker-openvpn)](https://github.com/theohbrothers/docker-openvpn/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/theohbrothers/docker-openvpn/latest)](https://hub.docker.com/r/theohbrothers/docker-openvpn)

Dockerized `openvpn`.

`easy-rsa` is not included. It is not considered best practice to be signing or be able to sign certs on the server.

## Tags

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:v2.5.0-alpine-3.13`, `:latest` | [View](variants/v2.5.0-alpine-3.13 ) |
| `:v2.4.10-alpine-3.12` | [View](variants/v2.4.10-alpine-3.12 ) |
| `:v2.4.8-alpine-3.11` | [View](variants/v2.4.8-alpine-3.11 ) |
| `:v2.4.7-alpine-3.10` | [View](variants/v2.4.7-alpine-3.10 ) |
| `:v2.4.6-alpine-3.9` | [View](variants/v2.4.6-alpine-3.9 ) |
| `:v2.4.6-alpine-3.8` | [View](variants/v2.4.6-alpine-3.8 ) |
| `:v2.4.4-alpine-3.7` | [View](variants/v2.4.4-alpine-3.7 ) |
| `:v2.4.4-alpine-3.6` | [View](variants/v2.4.4-alpine-3.6 ) |
| `:v2.3.18-alpine-3.5` | [View](variants/v2.3.18-alpine-3.5 ) |
| `:v2.3.18-alpine-3.4` | [View](variants/v2.3.18-alpine-3.4 ) |
| `:v2.3.18-alpine-3.3` | [View](variants/v2.3.18-alpine-3.3 ) |

## Usage

It is assumed that you have knowledge of configuring `openvpn`.

To run the image, at the least you should mount a `/etc/openvpn/server.conf`, which may be a unified openvpn profile (see INLINE FILE SUPPORT section in the [openvpn manual](https://community.openvpn.net/openvpn/wiki/Openvpn24ManPage)).

```sh
docker run --rm -it --cap-add NET_ADMIN -v /path/to/server.conf:/etc/openvpn/server.conf theohbrothers/docker-openvpn:v2.5.0-alpine-3.13
```

## Environment variables

The defaults should work, so that there should be no need to specify any environment variable when running the container.

| Environment variables | Description | Default Value |
|:-------:|:-------:|:-------:|
| `OPENVPN_SERVER_CONFIG_FILE` | Absolute path to the server config | `/etc/openvpn/server.conf` |
| `OPENVPN_ROUTES` | Space-delimited CIDRs to add iptables `POSTROUTING` NAT rules, performed only when `NAT` is `1` | `192.168.50.0/24 192.168.51.0/24` |
| `NAT` | Whether to use NAT. `0` to disable. `1` to enable. If NAT is enabled, iptables `POSTROUTING` rules will be provisioned | `1` |
| `NAT_INTERFACE` | Interface on which to use NAT. E.g. `eth0` | `eth0` |
| `CUSTOM_FIREWALL_SCRIPT` | Custom script for firewall. If present, this script is executed before any other `iptables` rules are provisioned | `/etc/openvpn/firewall.sh` |

## `docker-entrypoint.sh`

The entrypoint script performs (in order):

1. Normalize environment variables
1. Provision the `tun` device
1. Execute the `CUSTOM_FIREWALL_SCRIPT` if it exists
1. Provision a `NAT` POSTROUTING iptables rule for tunnel-to-world packets
1. Provision a `NAT` POSTROUTING iptables rule each entry in `OPENVPN_ROUTES`
1. List iptables
1. Generate the final `openvpn` command line

## IPv4 and IPv6 forwarding

If not already enabled on the host, ipv4 and ipv6 forwarding may be enabled at container runtime by using the [`sysctls` key in `docker-compose.yml`](https://docs.docker.com/compose/compose-file/compose-file-v2/#sysctls), or with [`--sysctl` flag in `docker-run`](https://docs.docker.com/engine/reference/commandline/run/#/configure-namespaced-kernel-parameters-sysctls-at-runtime#configure-namespaced-kernel-parameters-sysctls-at-runtime)
