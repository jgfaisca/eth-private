#!/bin/sh
NODE_NAME=$1
NODE_NAME=${NODE_NAME:-"node1"}
CONTAINER_NAME="ethereum-$NODE_NAME"

SERVICE_NAME="$CONTAINER_NAME.service"
echo "Removing systemctl service $SERVICE_NAME"
if systemctl list-units  | grep $SERVICE_NAME ; then
  systemctl stop $SERVICE_NAME
  systemctl disable $SERVICE_NAME
  rm /etc/systemd/system/$SERVICE_NAME
  systemctl daemon-reload
  systemctl reset-failed
else
 echo "$SERVICE_NAME not found"
fi

echo "Destroying container $CONTAINER_NAME..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
