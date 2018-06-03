#!/bin/sh

# Remove systemctl services
if systemctl list-unit-files | grep ethereum- >/dev/null ; then
   echo "Removing systemctl services... "
   systemctl stop ethereum-*.service
   for CONTAINER_NAME in $(docker ps -a --format "{{.Names}}"); do
	SERVICE_NAME="$CONTAINER_NAME.service"
   	if systemctl list-unit-files | grep $SERVICE_NAME >/dev/null  ; then
   		systemctl disable $SERVICE_NAME
		rm /etc/systemd/system/$SERVICE_NAME
   	fi
   done
   systemctl daemon-reload
   systemctl reset-failed
fi

# Destroy containers"
echo "Destroying containers..."
docker stop $(docker ps -q -f name=ethereum)
docker rm $(docker ps -aq -f name=ethereum)
