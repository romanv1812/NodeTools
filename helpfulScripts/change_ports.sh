#!/bin/bash

EXTERNAL_IP=$(wget -qO- eth0.me)
NODE_NUMBER=$1
NODE_HOME=$2

echo "NODE_NUMBER: $NODE_NUMBER"
echo "NODE_HOME: $NODE_HOME"

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

# Read the updated ports from config files and display them
PROXY_APP_PORT=$(grep -oP 'proxy_app = "tcp://[^:]*:\K[0-9]+' $HOME/${NODE_HOME}/config/config.toml)
LADDR_PORT=$(grep -oP 'laddr = "tcp://[^:]*:\K[0-9]+' $HOME/${NODE_HOME}/config/config.toml)
PPROF_LADDR_PORT=$(grep -oP 'pprof_laddr = "localhost:\K[0-9]+' $HOME/${NODE_HOME}/config/config.toml)
P2P_LADDR_PORT=$(grep -oP 'laddr = "tcp://[^:]*:\K[0-9]+' $HOME/${NODE_HOME}/config/config.toml)
EXTERNAL_ADDRESS_PORT=$(grep -oP 'external_address = ".*:\K[0-9]+' $HOME/${NODE_HOME}/config/config.toml)
PROMETHEUS_LISTEN_ADDR=$(grep -oP 'prometheus_listen_addr = ":\K[0-9]+' $HOME/${NODE_HOME}/config/config.toml)
API_ADDRESS=$(grep -oP 'address = "tcp://[^:]*:\K[0-9]+' $HOME/${NODE_HOME}/config/app.toml)
GRPC_ADDRESS=$(grep -oP 'address = "[^:]*:\K[0-9]+' $HOME/${NODE_HOME}/config/app.toml)
GRPC_WEB_ADDRESS=$(grep -oP 'address = "[^:]*:\K[0-9]+' $HOME/${NODE_HOME}/config/app.toml)
JSON_RPC_ADDRESS=$(grep -oP 'address = "[^:]*:\K[0-9]+' $HOME/${NODE_HOME}/config/app.toml)
WS_ADDRESS=$(grep -oP 'ws-address = "[^:]*:\K[0-9]+' $HOME/${NODE_HOME}/config/app.toml)

echo -e "Proxy App Port: $PROXY_APP_PORT\nLaddr Port: $LADDR_PORT\nPprof Laddr Port: $PPROF_LADDR_PORT\nP2P Laddr Port: $P2P_LADDR_PORT\nExternal Address Port: $EXTERNAL_ADDRESS_PORT\nPrometheus Listen Addr: $PROMETHEUS_LISTEN_ADDR\nAPI Address: $API_ADDRESS\nGRPC Address: $GRPC_ADDRESS\nGRPC-Web Address: $GRPC_WEB_ADDRESS\nJSON-RPC Address: $JSON_RPC_ADDRESS\nWS Address: $WS_ADDRESS"
