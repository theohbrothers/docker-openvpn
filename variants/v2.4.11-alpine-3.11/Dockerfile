FROM alpine:3.11

RUN apk add --no-cache openvpn=2.4.11-r0 iptables

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
