# Socks my VPN

This is a small Docker image which blends together OpenVPN-Client and a SOCKS proxy server. Use it to isolate network changes.

## Usage

```bash
bash run.sh ~/path/to/vpn-folder/
```
_Alternatively:_

```bash
docker run \
    --rm \
    -it \
    --privileged \
    --device=/dev/net/tun \
    --cap-add=NET_ADMIN \
    --env-file socks.config \
    -p 1080:1080 \
    --volume "~/path/to/vpn-folder/:/vpn/:ro" \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    socks-my-vpn:latest
```


## SOCKS proxy server

The [socks5 server](server.go) is written in Go and forked from https://github.com/serjs/socks5-server.
If works with or without authentication and the configurations can be set in the 
[`socks.config`](socks.config) file.

**Supported config parameters**:

|ENV variable			|Type	|Default|Description|
|-----------------------|-------|-------|-----------|
|`PROXY_USER`			|String	|EMPTY	|Set proxy user (also required existed `PROXY_PASS`)|
|`PROXY_PASSWORD`		|String	|EMPTY	|Set proxy password for auth, used with `PROXY_USER`|
|`PROXY_PORT`			|String	|`1080`	|Set listen port for application|


## Test

Connect to proxy:

_without auth_:
```bash
curl --proxy socks5://127.1:$PROXY_PORT ipinfo.io
```

_with auth_:
```bash
curl --socks5 --user $PROXY_USER:$PROXY_PASSWORD 127.1:$PROXY_PORT ipinfo.io
```