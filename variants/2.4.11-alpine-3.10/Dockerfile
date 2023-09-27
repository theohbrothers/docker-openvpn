FROM alpine:3.10

RUN set -eux; \
    apk add --no-cache openvpn~=2.4.11 iptables \
    openvpn --version

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
