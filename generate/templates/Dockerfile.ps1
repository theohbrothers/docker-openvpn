@"
FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )

RUN apk add --no-cache $( $VARIANT['_metadata']['package'] )=$( $VARIANT['_metadata']['package_version'] ) iptables

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

"@
