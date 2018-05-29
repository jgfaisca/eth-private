#!/bin/sh
#
# Runs a bootnode with ethereum official "alltools" image.
#

IMGNAME="ethereum/client-go:alltools-v1.7.3"
DATA_ROOT=${DATA_ROOT:-$(pwd)}
#NODE_NET="--public" # comment to disable public bootnode option
NODE_NET="--private"
PORT_ARG=
#VERSION="-v5"
PORT="39601"  # listen port
CONTAINER_NAME="ethereum-bootnode"

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
    PORT_ARG="-p 0.0.0.0:$PORT:30301/udp"
fi

echo "Destroying old container $CONTAINER_NAME..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

# creates ethereum network
[ ! "$(docker network ls | grep ethereum)" ] && docker network create ethereum
[[ -z $BOOTNODE_SERVICE ]] && BOOTNODE_SERVICE="127.0.0.1"

echo "Running new container $CONTAINER_NAME..."
docker run -d --name $CONTAINER_NAME \
    -v $DATA_ROOT/.bootnode:/opt/bootnode \
    --network ethereum \
    $PORT_ARG \
    $IMGNAME bootnode --nodekey /opt/bootnode/boot.key $VERSION --verbosity=3 "$@"
