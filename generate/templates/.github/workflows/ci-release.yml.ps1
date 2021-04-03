@'
name: ci-release

on:
  push:
    branches:
    - release

jobs:
'@

$local:WORKFLOW_JOB_NAMES = $VARIANTS | % { "build-$( $_['tag'].Replace('.', '-') )" }
$( $VARIANTS | % {
@"

  build-$( $_['tag'].Replace('.', '-') ):
    runs-on: ubuntu-18.04
    env:
      VARIANT_TAG: $( $_['tag'] )
      # VARIANT_TAG_WITH_REF: $( $_['tag'] )-`${GITHUB_REF}
      VARIANT_BUILD_DIR: $( $_['build_dir_rel'] )
"@
@'

    steps:
    - uses: actions/checkout@v1
    - name: Display system info (linux)
      run: |
        set -e
        hostname
        whoami
        cat /etc/*release
        lscpu
        free
        df -h
        pwd
        docker info
        docker version
    - name: Login to docker registry
      run: echo "${DOCKERHUB_REGISTRY_PASSWORD}" | docker login -u "${DOCKERHUB_REGISTRY_USER}" --password-stdin
      env:
        DOCKERHUB_REGISTRY_USER: ${{ secrets.DOCKERHUB_REGISTRY_USER }}
        DOCKERHUB_REGISTRY_PASSWORD: ${{ secrets.DOCKERHUB_REGISTRY_PASSWORD }}
    - name: Build and push image
      env:
        DOCKERHUB_REGISTRY_USER: ${{ secrets.DOCKERHUB_REGISTRY_USER }}
      run: |
        set -e

        # Get 'project-name' from 'namespace/project-name'
        CI_PROJECT_NAME=$( echo "${GITHUB_REPOSITORY}" | rev | cut -d '/' -f 1 | rev )

        # Get 'ref-name' from 'refs/heads/ref-name'
        REF=$( echo "${GITHUB_REF}" | rev | cut -d '/' -f 1 | rev )
        SHA_SHORT=$( echo "${GITHUB_SHA}" | cut -c1-7 )

        # Generate the final tags. E.g. 'release-v1.0.0-alpine' and 'release-b29758a-v1.0.0-alpine'
        VARIANT_TAG_WITH_REF="${REF}-${VARIANT_TAG}"
        VARIANT_TAG_WITH_REF_AND_SHA_SHORT="${REF}-${SHA_SHORT}-${VARIANT_TAG}"

        docker build \
          -t "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:${VARIANT_TAG}" \
          -t "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:${VARIANT_TAG_WITH_REF}" \
          -t "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:${VARIANT_TAG_WITH_REF_AND_SHA_SHORT}" \

'@
if ( $_['tag_as_latest'] ) {
@'
          -t "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:latest" \

'@
}
@'
          "${VARIANT_BUILD_DIR}"
        docker push "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:${VARIANT_TAG}"
        docker push "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:${VARIANT_TAG_WITH_REF}"
        docker push "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:${VARIANT_TAG_WITH_REF_AND_SHA_SHORT}"

'@
if ( $_['tag_as_latest'] ) {
@'
        docker push "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:latest"

'@
}
@'
    - name: Clean-up
      run: docker logout
      if: always()
'@
})

@"

  converge-master-and-release-branches:
    needs: [$( $local:WORKFLOW_JOB_NAMES -join ', ' )]
    if: github.ref == 'refs/heads/release'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: Merge release into master (fast-forward)
        run: |
          git checkout master
          git merge release
          git push origin master
"@

@'

  resolve-release-tag:
    runs-on: ubuntu-latest
    outputs:
      TAG: ${{ steps.resolve-release-tag.outputs.TAG }}
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: Resolve release tag
        id: resolve-release-tag
        run: |
          set +e
          # E.g. 20210402
          TODAYS_DATE=$( date -u '+%Y%m%d' )
          # Is this the first tag for this date?
          TODAYS_DATE_TAGS=$( git tag --list | grep "^$TODAYS_DATE" )
          TAG=
          if [ -z "$TODAYS_DATE_TAGS" ]; then
              # E.g. 20210402.0.0
              TAG="$TODAYS_DATE.0.0" # Send this to stdout
          else
              # E.g. if there are 20210402.0.0, 20210402.0.1, 20210402.0.2, this returns 2
              VERSION_MINOR_LATEST=$( echo "$TODAYS_DATE_TAGS" | cut -d '.' -f 3 | sort -nr | head -n1 )
              # Minor version
              VERSION_MINOR=$( expr "$VERSION_MINOR_LATEST" + 1 )
              # E.g. 20210402.0.3
              TAG="$TODAYS_DATE.0.$VERSION_MINOR"  # Send this to stdout
          fi
          echo "TODAYS_DATE: $TODAYS_DATE"
          echo "TODAYS_DATE_TAGS: $TODAYS_DATE_TAGS"
          echo "TAG: $TAG"
          echo "::set-output name=TAG::$TAG"
      - name: Print outputs
        run: echo ${{ steps.resolve-release-tag.outputs.TAG }}
'@

@"

  publish-draft-release:
    needs: [$( $local:WORKFLOW_JOB_NAMES -join ', ' ), resolve-release-tag, converge-master-and-release-branches]
"@
@'

    if: github.ref == 'refs/heads/release'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      # Drafts your next Release notes as Pull Requests are merged into "master"
      - uses: release-drafter/release-drafter@v5
        with:
          config-name: release-drafter.yml
          publish: true
          name: ${{ needs.resolve-release-tag.outputs.TAG }}
          tag: ${{ needs.resolve-release-tag.outputs.TAG }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
'@
