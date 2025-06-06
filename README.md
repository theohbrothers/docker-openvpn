# docker-openvpn

[![github-actions](https://github.com/theohbrothers/docker-openvpn/actions/workflows/ci-master-pr.yml/badge.svg?branch=master)](https://github.com/theohbrothers/docker-openvpn/actions/workflows/ci-master-pr.yml)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/docker-openvpn?style=flat-square)](https://github.com/theohbrothers/docker-openvpn/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/theohbrothers/docker-openvpn/latest)](https://hub.docker.com/r/theohbrothers/docker-openvpn)

Dockerized `openvpn`.

`easy-rsa` is not included, since is not best practice to be signing or be able to sign certs on the server. it is better to run [`easy-rsa`](https://github.com/theohbrothers/docker-easyrsa) in a separate container.

## Tags

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:2.6.14-alpine-3.22`, `:latest` | [View](variants/2.6.14-alpine-3.22) |
| `:2.6.11-alpine-3.18` | [View](variants/2.6.11-alpine-3.18) |
| `:2.5.10-alpine-3.17` | [View](variants/2.5.10-alpine-3.17) |
| `:2.4.12-alpine-3.12` | [View](variants/2.4.12-alpine-3.12) |
| `:2.4.11-alpine-3.11` | [View](variants/2.4.11-alpine-3.11) |
| `:2.4.11-alpine-3.10` | [View](variants/2.4.11-alpine-3.10) |
| `:2.4.6-alpine-3.9` | [View](variants/2.4.6-alpine-3.9) |
| `:2.4.6-alpine-3.8` | [View](variants/2.4.6-alpine-3.8) |
| `:2.4.4-alpine-3.7` | [View](variants/2.4.4-alpine-3.7) |
| `:2.4.4-alpine-3.6` | [View](variants/2.4.4-alpine-3.6) |
| `:2.3.18-alpine-3.5` | [View](variants/2.3.18-alpine-3.5) |
| `:2.3.18-alpine-3.4` | [View](variants/2.3.18-alpine-3.4) |
| `:2.3.18-alpine-3.3` | [View](variants/2.3.18-alpine-3.3) |

## Usage

It is assumed that you have knowledge of configuring `openvpn`. If needed, refer to the official manuals:

- [Openvpn 2.3 manual](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-3/)
- [Openvpn 2.4 manual](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/)
- [Openvpn 2.5 manual](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-5/)
- [Openvpn 2.6 manual](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-6/)

To run the image, at the least you should mount a `/etc/openvpn/server.conf`, which may be a unified openvpn profile (see INLINE FILE SUPPORT section in the [openvpn manual](https://community.openvpn.net/openvpn/wiki/Openvpn24ManPage)).

```sh
docker run --rm -it --cap-add NET_ADMIN -v /path/to/server.conf:/etc/openvpn/server.conf theohbrothers/docker-openvpn:2.6.14-alpine-3.22
```

## Environment variables

The defaults should work, so that there should be no need to specify any environment variable when running the container.

| Environment variables | Description | Default Value |
|:-------:|:-------:|:-------:|
| `OPENVPN_CONFIG_FILE` | Absolute path to the server config | `/etc/openvpn/server.conf` |
| `OPENVPN_ROUTES` | Space-delimited CIDRs to add iptables `POSTROUTING` `MASQUERADE` rules, performed only when `NAT=1` and `NAT_MASQUERADE=1` | `192.168.50.0/24 192.168.51.0/24` |
| `NAT` | Whether to use NAT. `0` to disable. `1` to enable. | `1` |
| `NAT_INTERFACE` | Interface on which to use NAT. E.g. `eth0` | `eth0` |
| `NAT_MASQUERADE` | Whether to add iptables `POSTROUTING` `MASQUERADE` rules, if `NAT=1`. `0` to disable. `1` to enable. Disable this if running as a client. | `1` |
| `CUSTOM_FIREWALL_SCRIPT` | Full path to a custom script for firewall. If present, this script is executed before any other `iptables` rules are provisioned | `/etc/openvpn/firewall.sh` |

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

## Development

Requires Windows `powershell` or [`pwsh`](https://github.com/PowerShell/PowerShell).

```powershell
# Install Generate-DockerImageVariants module: https://github.com/theohbrothers/Generate-DockerImageVariants
Install-Module -Name Generate-DockerImageVariants -Repository PSGallery -Scope CurrentUser -Force -Verbose

# Edit ./generate templates

# Generate the variants
Generate-DockerImageVariants .
```
