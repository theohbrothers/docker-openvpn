FROM alpine:3.22

RUN set -eux; \
    apk add --no-cache openvpn~=2.6.20 iptables; \
    # Workaround openvpn --version exiting with non-zero exit code on openvpn <= 2.4.x
    openvpn --version | grep -F 'OpenVPN 2.6.20 '

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
