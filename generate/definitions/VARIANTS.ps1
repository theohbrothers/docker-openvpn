# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    @{
        package = 'openvpn'
        package_version = '2.5.2-r0'
        distro = 'alpine'
        distro_version = '3.13'
        subvariants = @(
            @{ components = @(); tag_as_latest = $true }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.11-r0'
        distro = 'alpine'
        distro_version = '3.12'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.11-r0'
        distro = 'alpine'
        distro_version = '3.11'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.11-r0'
        distro = 'alpine'
        distro_version = '3.10'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.6-r4'
        distro = 'alpine'
        distro_version = '3.9'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.6-r3'
        distro = 'alpine'
        distro_version = '3.8'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.4-r1'
        distro = 'alpine'
        distro_version = '3.7'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.4-r0'
        distro = 'alpine'
        distro_version = '3.6'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.3.18-r0'
        distro = 'alpine'
        distro_version = '3.5'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.3.18-r0'
        distro = 'alpine'
        distro_version = '3.4'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.3.18-r0'
        distro = 'alpine'
        distro_version = '3.3'
        subvariants = @(
            @{ components = @() }
        )
    }
)

$VARIANTS = @(
    foreach ($variant in $VARIANTS_MATRIX){
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    package = $variant['package']
                    package_version = $variant['package_version']
                    package_version_semver = "v$( $variant['package_version'] )" -replace '-r\d+', ''   # E.g. Strip out the '-r' in '2.3.0.0-r1'
                    distro = $variant['distro']
                    distro_version = $variant['distro_version']
                    platforms = & {
                        if ($variant['distro'] -eq 'alpine') {
                            if ($variant['distro_version'] -in @( '3.3', '3.4', '3.5' ) ) {
                              'linux/amd64'
                            }else {
                              'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x'
                            }
                        }
                    }
                    components = $subVariant['components']
                }
                # Docker image tag. E.g. 'v2.3.0-alpine-3.6'
                tag = @(
                        "v$( $variant['package_version'] )" -replace '-r\d+', ''    # E.g. Strip out the '-r' in '2.3.0.0-r1'
                        $subVariant['components'] | ? { $_ }
                        $variant['distro']
                        $variant['distro_version']
                ) -join '-'
                tag_as_latest = if ( $subVariant.Contains('tag_as_latest') ) {
                                    $subVariant['tag_as_latest']
                                } else {
                                    $false
                                }
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'docker-entrypoint.sh' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'docker-compose.yml' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'openvpn/client.conf' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'openvpn/server.conf' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'openvpn/firewall.sh' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}
