#!/bin/sh
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
CONTAINER_NAME="ethereum-$NODE_NAME"
echo "Restart container $CONTAINER_NAME... "

docker restart $CONTAINER_NAME
