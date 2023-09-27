# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    @{
        package = 'openvpn'
        package_version = '2.6.5'
        distro = 'alpine'
        distro_version = '3.18'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.5.8'
        distro = 'alpine'
        distro_version = '3.17'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.12'
        distro = 'alpine'
        distro_version = '3.12'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.11'
        distro = 'alpine'
        distro_version = '3.11'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.11'
        distro = 'alpine'
        distro_version = '3.10'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.6'
        distro = 'alpine'
        distro_version = '3.9'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.6'
        distro = 'alpine'
        distro_version = '3.8'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.4'
        distro = 'alpine'
        distro_version = '3.7'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.4.4'
        distro = 'alpine'
        distro_version = '3.6'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.3.18'
        distro = 'alpine'
        distro_version = '3.5'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.3.18'
        distro = 'alpine'
        distro_version = '3.4'
        subvariants = @(
            @{ components = @() }
        )
    }
    @{
        package = 'openvpn'
        package_version = '2.3.18'
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
                    job_group_key = $variant['package_version']
                }
                # Docker image tag. E.g. 'v2.6.5-alpine-3.18'
                tag = @(
                        $variant['package_version']
                        $subVariant['components'] | ? { $_ }
                        $variant['distro']
                        $variant['distro_version']
                ) -join '-'
                tag_as_latest = if ($variant['package_version'] -eq $local:VARIANTS_MATRIX[0]['package_version'] -and $subVariant['components'].Count -eq 0) { $true } else { $false }
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
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'docker-entrypoint.sh' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'docker-compose.yml' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'openvpn/client.conf' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'openvpn/server.conf' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'openvpn/firewall.sh' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}
