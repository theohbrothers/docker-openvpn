@"
FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )

RUN apk add --no-cache $( $VARIANT['_metadata']['package'] )=$( $VARIANT['_metadata']['package_version'] ) iptables

$( if ( $VARIANT['_metadata']['components'] -contains 'ssh' ) {
@"
"@
})
"@
