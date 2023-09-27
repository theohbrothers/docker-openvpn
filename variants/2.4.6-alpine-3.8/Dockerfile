FROM alpine:3.8

RUN set -eux; \
    apk add --no-cache openvpn~=2.4.6 iptables \
    openvpn --version

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
