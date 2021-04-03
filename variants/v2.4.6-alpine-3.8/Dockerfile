

FROM alpine:3.8

RUN apk add --no-cache openvpn=2.4.6-r3 iptables

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

COPY openvpn /etc/openvpn
RUN chown -R root:root /etc/openvpn && chmod 750 /etc/openvpn && chmod 750 /etc/openvpn/*.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

