#!/bin/sh
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
CONTAINER_NAME="ethereum-$NODE_NAME"
echo "Run container $CONTAINER_NAME session... "

docker exec -it $CONTAINER_NAME sh
