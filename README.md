# fluvio-docker-lan

Configuration and instructions for mirroring between two [Fluvio](https://www.fluvio.io/) clusters running in Docker over a LAN.

Tested with Raspberry Pi 4 running Raspberry Pi OS as remote machine.

Adapted from the Fluvio tutorial [Mirroring Two Local Clusters](https://www.fluvio.io/docs/latest/fluvio/tutorials/mirroring-two-clusters).

## 1. Home Machine
Execute the commands in a terminal on your "home" machine.
```bash
docker compose -f home-docker-compose.yaml up -d
docker exec -it sc-home /bin/sh
fluvio remote register docker-remote
fluvio remote list # Verify output
fluvio topic create mirror-topic --mirror
fluvio topic add-mirror mirror-topic docker-remote
fluvio partition list # Verify output
```

## 2. Copy configuration
Ensure the remote machine has the right `docker-compose` file and the `Dockerfile`, e.g. copy from home machine via `scp`:
```bash
scp remote-docker-compose.yaml Dockerfile <USER>@<REMOTE IP>:~
```

## 3. Remote Machine
```bash
# Log in to remote machine
ssh <USER>@<REMOTE IP>
# Ensure the environment variable is set to your "home" machine IP address 
HOME_IP_ADDRESS=<...> docker compose -f remote-docker-compose.yaml up -d
docker exec -it sc-remote /bin/sh
echo '{"topics":[],"home":{"id":"home","remoteId":"docker-remote","publicEndpoint":"spu-home:9003"}}' > docker-remote-metadata.json
fluvio home connect --file docker-remote-metadata.json
fluvio partition list # Verify output
fluvio home status # Verify output
```