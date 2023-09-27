@"
FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )

RUN set -eux; \
    apk add --no-cache $( $VARIANT['_metadata']['package'] )$( if ([version]$VARIANT['_metadata']['distro_version'] -le [version]'3.6') { '>=' } else { '~=' } )$( $VARIANT['_metadata']['package_version'] ) iptables; \
    # Workaround openvpn --version exiting with non-zero exit code on openvpn <= 2.4.x
    openvpn --version | grep -A100 -B100 $( $VARIANT['_metadata']['package_version'] )

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

"@
