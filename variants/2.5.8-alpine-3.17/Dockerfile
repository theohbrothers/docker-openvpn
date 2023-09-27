FROM alpine:3.17

RUN set -eux; \
    apk add --no-cache openvpn~=2.5.8 iptables \
    openvpn --version

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
