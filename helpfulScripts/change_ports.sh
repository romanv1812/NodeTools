#!/bin/bash

EXTERNAL_IP=$(wget -qO- eth0.me)
NODE_NUMBER=$1
NODE_HOME=$2

sed -i.bak \
    -e "s/\(proxy_app = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$((NODE_NUMBER + 266))58\"/" \
    -e "s/\(laddr = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$((NODE_NUMBER + 266))57\"/" \
    -e "s/\(pprof_laddr = \"\)\([^:]*\):\([0-9]*\).*/\1localhost:$((NODE_NUMBER + 60))60\"/" \
    -e "/\[p2p\]/,/^\[/{s/\(laddr = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$((NODE_NUMBER + 266))56\"/}" \
    -e "/\[p2p\]/,/^\[/{s/\(external_address = \"\)\([^:]*\):\([0-9]*\).*/\1${EXTERNAL_IP}:$((NODE_NUMBER + 266))56\"/; t; s/\(external_address = \"\).*/\1${EXTERNAL_IP}:$((NODE_NUMBER + 266))56\"/}" \
    -e "s/\(prometheus_listen_addr = \":\)\([0-9]*\).*/\1$((NODE_NUMBER + 266))60\"/" \
    $HOME/${NODE_HOME}/config/config.toml

sed -i.bak \
    -e "/\[api\]/,/^\[/{s/\(address = \"tcp:\/\/\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$((NODE_NUMBER + 13))17\4/}" \
    -e "/\[grpc\]/,/^\[/{s/\(address = \"\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$((NODE_NUMBER + 90))90\4/}" \
    -e "/\[grpc-web\]/,/^\[/{s/\(address = \"\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$((NODE_NUMBER + 90))91\4/}" \
    -e "/\[json-rpc\]/,/^\[/{s/\(address = \"\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$((NODE_NUMBER + 85))45\4/}" \
    -e "/\[json-rpc\]/,/^\[/{s/\(ws-address = \"\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$((NODE_NUMBER + 85))46\4/}" \
    $HOME/${NODE_HOME}/config/app.toml

echo "export NODE=http://localhost:$((NODE_NUMBER + 266))57" >> $HOME/.bash_profile
source $HOME/.bash_profile
