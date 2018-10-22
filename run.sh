#!/bin/bash

# Exit if anything goes wrong
set -o errexit

# Checks
if [[ ! -d $1 ]]; then
    echo "Provide a valid OpenVPN configurations path."
    exit 1
fi

echo "Mounting $(realpath "$1") in /vpn"

# --rm                                      | Automatically removes the container on exit
# --privileged                              | Useful to bring host DNS within the container
# --device=/dev/net/tun                     | Interface the OpenVPN
# --cap-add=NET_ADMIN                       | Network-related capabilities
# --env-file socks.config                   | Source environment file for the socks server
#                                           | alternatively:
#                                           | -e "PROXY_PORT=1081"
# -p 1080:1080                              | Map to localhost 1080/tcp 
# --volume "$(realpath "$1"):/vpn/:ro"      | Map read only OpenVPN configuration path
# --sysctl net.ipv6.conf.all.disable_ipv6=0 | Disable IPv6
docker run \
    --rm \
    -it \
    --privileged \
    --device=/dev/net/tun \
    --cap-add=NET_ADMIN \
    --env-file socks.config \
    -p 1080:1080 \
    --volume "$(realpath "$1"):/vpn/:ro" \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    socks-my-vpn:latest
