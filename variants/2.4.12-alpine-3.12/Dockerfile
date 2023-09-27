FROM alpine:3.12

RUN set -eux; \
    apk add --no-cache openvpn~=2.4.12 iptables \
    openvpn --version

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
