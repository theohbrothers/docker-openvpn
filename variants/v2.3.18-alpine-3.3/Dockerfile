FROM alpine:3.3

RUN apk add --no-cache openvpn>=2.3.18 iptables

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
