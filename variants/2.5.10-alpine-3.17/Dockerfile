FROM alpine:3.17

RUN set -eux; \
    apk add --no-cache openvpn~=2.5.10 iptables; \
    # Workaround openvpn --version exiting with non-zero exit code on openvpn <= 2.4.x
    openvpn --version | grep -A100 -B100 2.5.10

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
