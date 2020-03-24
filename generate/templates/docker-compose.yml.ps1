@"
version: '2.1'
services:
  openvpn:
    container_name: openvpn
    image: theohbrothers/docker-openvpn:$( $VARIANT['tag'] )
    ports:
      - "1194:1194/udp"
    cap_add:
      - NET_ADMIN
    # sysctls for the container if it is not set on the host. See: https://docs.docker.com/compose/compose-file/compose-file-v2/#sysctls
    sysctls:
      - net.ipv4.conf.all.forwarding=1
      # - net.ipv6.conf.all.disable_ipv6=0
      # - net.ipv6.conf.default.forwarding=1
      # - net.ipv6.conf.all.forwarding=1
    restart: unless-stopped
    volumes:
      - ./openvpn/server.conf:/etc/openvpn/server.conf
"@
