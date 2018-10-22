#!/bin/bash

echo -e "\n\n\033[0;32m"
echo -e "Starting socks5 server:"
echo -e "- USER=$PROXY_USER"
echo -e "- PASSWORD=$PROXY_PASSWORD"
echo -e "- PORT=$PROXY_PORT"
echo -e "\033[0m"

nohup /socks/server &