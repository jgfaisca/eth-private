#!/bin/bash
IMGNAME="ethereum/client-go:stable"
#IMGNAME="ethereum/client-go:v1.7.3"
ETH_NET_ID="3963"
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
NODE_NET="--public" # comment to disable public node option
DETACH_FLAG=${DETACH_FLAG:-"-d"}
CONTAINER_NAME="ethereum-$NODE_NAME"
DATA_ROOT=${DATA_ROOT:-"$(pwd)/.ether-$NODE_NAME"}
DATA_HASH=${DATA_HASH:-"$(pwd)/.ethash"}
RPC_PORTMAP=
RPC_ARG=
PORT_ARG=
NODE_PORT="30303"
BOOTNODE_URL=${BOOTNODE_URL:-"null"}

if [[ ! -z $RPC_PORT ]]; then
    RPC_ARG='--rpc --rpcaddr=0.0.0.0 --rpcapi=db,eth,net,web3,personal --rpccorsdomain "*"'
    RPC_PORTMAP="-p $RPC_PORT:8545"
fi

# check BOOTNODE_URL variable
if [ "$BOOTNODE_URL" = "null" ]; then
    echo "Usage: BOOTNODE_URL=enode://...@ip_address:port $(echo "$0")"
    exit 1
fi

# check public node option
if [ "$NODE_NET" = "--public" ]; then
    PORT_ARG="-p 0.0.0.0:$NODE_PORT:$NODE_PORT/tcp -p 0.0.0.0:$NODE_PORT:$NODE_PORT/udp"
fi

echo "Destroying old container $CONTAINER_NAME..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

echo "Running new container $CONTAINER_NAME..."
docker run $DETACH_FLAG --name $CONTAINER_NAME \
    -v $DATA_ROOT:/root/.ethereum \
    -v $DATA_HASH:/root/.ethash \
    $RPC_PORTMAP \
    $PORT_ARG \
    $IMGNAME --bootnodes=$BOOTNODE_URL --networkid $ETH_NET_ID $RPC_ARG --cache=512 --verbosity=4 --maxpeers=27 ${@:2}
