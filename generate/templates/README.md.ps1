@"
# docker-openvpn

[![github-actions](https://github.com/theohbrothers/docker-openvpn/workflows/build/badge.svg)](https://github.com/theohbrothers/docker-openvpn/actions)
[![github-tag](https://img.shields.io/github/tag/theohbrothers/docker-openvpn)](https://github.com/theohbrothers/docker-openvpn/releases/)
[![docker-image-size](https://img.shields.io/microbadger/image-size/theohbrothers/docker-openvpn/latest)](https://hub.docker.com/r/theohbrothers/docker-openvpn)
[![docker-image-layers](https://img.shields.io/microbadger/layers/theohbrothers/docker-openvpn/latest)](https://hub.docker.com/r/theohbrothers/docker-openvpn)

``easy-rsa`` is not included. It is not considered best practice to be signing or be able to sign certs on the server.

| Tags |
|:-------:| $( $VARIANTS | % {
"`n| ``:$( $_['tag'] )`` |"
})

"@
