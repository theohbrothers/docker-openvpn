

FROM alpine:3.13

RUN apk add --no-cache openvpn=2.5.1-r0 iptables

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

COPY openvpn /etc/openvpn
RUN chown -R root:root /etc/openvpn && chmod 750 /etc/openvpn && chmod 750 /etc/openvpn/*.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

