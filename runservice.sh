#!/bin/bash
#
# Create docker container systemctl service
#
# Usage example:
# ./runservice.sh webserver "'HTTP_PROXY=http://proxy.example.com:80/' 'NO_PROXY=localhost,127.0.0.1'"
#

# Check arguments
if [ "$#" -lt 1 ]; then
   echo "usage: $0 <container_name> [environment_variables]"
   exit 1
fi

NODE_NAME=$1
CONTAINER_ENV=$2
CONTAINER_ENV=${CONTAINER_ENV:-""}
CONTAINER_NAME="ethereum-$NODE_NAME"
SERVICE_NAME="$CONTAINER_NAME.service"

# Check container
CT_ID=$(docker ps --all --quiet --filter name=^/${CONTAINER_NAME}$)
if [ ! "${CT_ID}" ]; then
  echo "Container $CONTAINER_NAME doesn't exist. Aborting..."
  exit 1
else
  echo "$CT_ID"
fi

if [ -f $SERVICE_NAME ] ; then
  echo "Removing old $SERVICE_NAME..."
  rm -f $SERVICE_NAME
else
  echo "Creating $SERVICE_NAME..."
fi

# build container service file
cat <<EOF >> $SERVICE_NAME
[Unit]
Description=Docker container $CONTAINER_NAME
Requires=docker.service
After=docker.service

[Service]
Environment=$CONTAINER_ENV
Restart=always
ExecStart=/usr/bin/docker start -a $CONTAINER_NAME
ExecStop=/usr/bin/docker stop -t 2 $CONTAINER_NAME

[Install]
WantedBy=local.target
EOF

# Start service
mv $SERVICE_NAME /etc/systemd/system/ && sudo systemctl daemon-reload || exit 2
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME
