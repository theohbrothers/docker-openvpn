# docker-openvpn

[![github-actions](https://github.com/theohbrothers/docker-openvpn/workflows/ci-master-pr/badge.svg)](https://github.com/theohbrothers/docker-openvpn/actions)
[![github-tag](https://img.shields.io/github/tag/theohbrothers/docker-openvpn)](https://github.com/theohbrothers/docker-openvpn/releases/)
[![docker-image-size](https://img.shields.io/microbadger/image-size/theohbrothers/docker-openvpn/latest)](https://hub.docker.com/r/theohbrothers/docker-openvpn)
[![docker-image-layers](https://img.shields.io/microbadger/layers/theohbrothers/docker-openvpn/latest)](https://hub.docker.com/r/theohbrothers/docker-openvpn)

`easy-rsa` is not included. It is not considered best practice to be signing or be able to sign certs on the server.

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:v2.3.18-alpine-3.3` | [View](variants/v2.3.18-alpine-3.3 ) |
| `:v2.3.18-alpine-3.4` | [View](variants/v2.3.18-alpine-3.4 ) |
| `:v2.3.18-alpine-3.5` | [View](variants/v2.3.18-alpine-3.5 ) |
| `:v2.4.4-alpine-3.6` | [View](variants/v2.4.4-alpine-3.6 ) |
| `:v2.4.4-alpine-3.7` | [View](variants/v2.4.4-alpine-3.7 ) |
| `:v2.4.6-alpine-3.8` | [View](variants/v2.4.6-alpine-3.8 ) |
| `:v2.4.6-alpine-3.9` | [View](variants/v2.4.6-alpine-3.9 ) |
| `:v2.4.7-alpine-3.10` | [View](variants/v2.4.7-alpine-3.10 ) |
| `:v2.4.8-alpine-3.11`, `:latest` | [View](variants/v2.4.8-alpine-3.11 ) |


# Quick start

The image assumes you have knowledge of configuring `openvpn`.

To run the image, at the least you should mount a `/etc/openvpn/server.conf`, which may be a unified openvpn profile (see INLINE FILE SUPPORT section in the [openvpn manual](https://community.openvpn.net/openvpn/wiki/Openvpn24ManPage)).

```sh
$ docker run --rm -it --cap-add NET_ADMIN -v /path/to/server.conf:/etc/openvpn/server.conf theohbrothers/docker-openvpn:v2.4.8-alpine-3.11
```

# Environments variables

The defaults should work, so that there is no need to specify any environment variable when running the container.

| Environment variables | Description | Default Value |
|:-------:|:-------:|:-------:|
| `OPENVPN_SERVER_CONFIG_FILE` | Absolute path to the server config | `/etc/openvpn/server.conf` |
| `OPENVPN_ROUTES` | Space-delimited CIDRs to add iptables `POSTROUTING` NAT rules, performed only when `NAT` is `1` | `192.168.50.0/24 192.168.51.0/24` |
| `NAT` | Whether to use NAT. `0` to disable. `1` to enable. If NAT is enabled, iptables `POSTROUTING` rules will be provisioned | `1` |
| `NAT_INTERFACE` | Interface on which to use NAT. E.g. `eth0` | `eth0` |
| `CUSTOM_FIREWALL_SCRIPT` | Custom script for firewall. If present, this script is executed before any other `iptables` rules are provisioned | `/etc/openvpn/firewall.sh` |

# docker-entrypoint.sh

The entrypoint script takes care of (in order):

1. Normalizing environment variables
2. provisioning the `tun` device
3. executing the `CUSTOM_FIREWALL_SCRIPT` if it exists
4. provisioning a `NAT` POSTROUTING iptables rule for tunnel-to-world packets
5. provisioning a `NAT` POSTROUTING iptables rule each entry in `OPENVPN_ROUTES`
6. Listing iptables
7. Generating the final `openvpn` command line

# ipv4 and ipv6 forwarding

If not already enabled on the host, ipv4 and ipv6 forwarding may be enabled at container runtime by using the [`sysctls` key in `docker-compose.yml`](https://docs.docker.com/compose/compose-file/compose-file-v2/#sysctls), or with [`--sysctl` flag in `docker-run`](https://docs.docker.com/engine/reference/commandline/run/#/configure-namespaced-kernel-parameters-sysctls-at-runtime#configure-namespaced-kernel-parameters-sysctls-at-runtime)