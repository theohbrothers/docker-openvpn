@"
version: '2.1'
services:
  openvpn-server:
    build:
      dockerfile: Dockerfile
      context: .
    environment:
      - OPENVPN_CONFIG_FILE=/etc/openvpn/server.conf
      - NAT_MASQUERADE=1
      # - CUSTOM_FIREWALL_SCRIPT=/etc/openvpn/firewall.sh
    volumes:
      - ./openvpn/server.conf:/etc/openvpn/server.conf
      # - ./openvpn/firewall.sh:/etc/openvpn/firewall.sh
    ports:
      - 1194:1194/udp
    cap_add:
      - NET_ADMIN
    # sysctls for the container if it is not set on the host. See: https://docs.docker.com/compose/compose-file/compose-file-v2/#sysctls
    sysctls:
      - net.ipv4.conf.all.forwarding=1
      # - net.ipv6.conf.all.disable_ipv6=0
      # - net.ipv6.conf.default.forwarding=1
      # - net.ipv6.conf.all.forwarding=1
    restart: unless-stopped

  openvpn-client:
    build:
      dockerfile: Dockerfile
      context: .
    environment:
      - OPENVPN_CONFIG_FILE=/etc/openvpn/client.conf
      - NAT_MASQUERADE=0
      # - CUSTOM_FIREWALL_SCRIPT=/etc/openvpn/firewall.sh
    volumes:
      - ./openvpn/client.conf:/etc/openvpn/client.conf
      # - ./openvpn/firewall.sh:/etc/openvpn/firewall.sh
    cap_add:
      - NET_ADMIN
    # sysctls for the container if it is not set on the host. See: https://docs.docker.com/compose/compose-file/compose-file-v2/#sysctls
    sysctls:
      - net.ipv4.conf.all.forwarding=1
      # - net.ipv6.conf.all.disable_ipv6=0
      # - net.ipv6.conf.default.forwarding=1
      # - net.ipv6.conf.all.forwarding=1
    restart: unless-stopped
"@
