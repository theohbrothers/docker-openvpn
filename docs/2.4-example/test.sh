#!/bin/sh
set -eu

cd "$( cd "$( dirname "$0" )" && pwd )"

cleanup() {
    docker compose down --remove-orphans --volumes
}
trap cleanup INT TERM EXIT

# Generate pki and openvpn configs, then start server and client
docker compose up --wait

ERR=
run_test() {
    if "$@"; then
        echo "PASS"
    else
        echo "FAIL"
        ERR=1
    fi
}

echo
echo "Test: Ensure server has no WARNING(s)"
WARNINGS=$( docker compose logs openvpn-server | grep WARNING || true )
run_test test -z "$WARNINGS"
echo "$WARNINGS"
echo
echo "Test: Ensure client has no WARNING(s)"
WARNINGS=$( docker compose logs openvpn-server | grep WARNING || true )
run_test test -z "$WARNINGS"
echo "$WARNINGS"

if [ -n "$ERR" ]; then
    echo "Some tests failed"
    exit 1
fi
echo "All tests succeeded"
