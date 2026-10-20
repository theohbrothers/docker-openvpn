# 2.4-example

```sh
# Generate pki and openvpn configs, then start server and client
docker compose up --wait
# Cleanup
docker compose down --remove-orphans --volumes

# Test
./test.sh
```
