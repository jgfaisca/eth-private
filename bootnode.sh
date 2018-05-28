#!/bin/sh
#
# Runs a bootnode with ethereum official "alltools" image.
#
docker stop ethereum-bootnode
docker rm ethereum-bootnode
IMGNAME="ethereum/client-go:alltools-stable"
DATA_ROOT=${DATA_ROOT:-$(pwd)}
NODE_NET="--public" # comment to disable public bootnode option
PORT_ARG=
PORT="30301"  # listen port

# generate bootnode key if needed
mkdir -p $DATA_ROOT/.bootnode
if [ ! -f $DATA_ROOT/.bootnode/boot.key ]; then
    echo "$DATA_ROOT/.bootnode/boot.key not found, generating..."
    docker run --rm \
        -v $DATA_ROOT/.bootnode:/opt/bootnode \
        $IMGNAME bootnode --genkey /opt/bootnode/boot.key
    echo "...done!"
fi

# check public bootnode option
if [ "$NODE_NET" = "--public" ]; then
    PORT_ARG="-p 0.0.0.0:$PORT:$PORT/udp"
fi

# creates ethereum network
[ ! "$(docker network ls | grep ethereum)" ] && docker network create ethereum
[[ -z $BOOTNODE_SERVICE ]] && BOOTNODE_SERVICE="127.0.0.1"
docker run -d --name ethereum-bootnode \
    -v $DATA_ROOT/.bootnode:/opt/bootnode \
    --network ethereum \
    $PORT_ARG \
    $IMGNAME bootnode --nodekey /opt/bootnode/boot.key --verbosity=3 "$@"


