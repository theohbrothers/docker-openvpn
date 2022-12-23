FROM alpine:3.9

RUN apk add --no-cache openvpn=2.4.6-r4 iptables

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
