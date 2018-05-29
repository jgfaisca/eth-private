#!/bin/bash
# reads current node URL

NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
CONTAINER_NAME="ethereum-$NODE_NAME"

ENODE_LINE=$(docker logs $CONTAINER_NAME 2>&1 | grep enode | head -n 1)
# replaces localhost by container IP
MYIP=$(docker exec $CONTAINER_NAME ifconfig eth0 | awk '/inet addr/{print substr($2,6)}')
ENODE_LINE=$(echo $ENODE_LINE | sed "s/127\.0\.0\.1/$MYIP/g" | sed "s/\[\:\:\]/$MYIP/g")
echo "enode:${ENODE_LINE#*enode:}"
