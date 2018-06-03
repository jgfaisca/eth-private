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

CT=$1
ENV=$2
ENV=${ENV:-""}

# build container service file
cat <<EOF >> $CT.service
[Unit]
Description=Docker container $CT
Requires=docker.service
After=docker.service

[Service]
Environment=$ENV
Restart=always
ExecStart=/usr/bin/docker start -a $CT
ExecStop=/usr/bin/docker stop -t 2 $CT

[Install]
WantedBy=local.target
EOF

# Check container
CT_ID=$(docker ps --quiet --filter status=running --filter name=^/${CT}$)
if [ ! "${CT_ID}" ]; then
  echo "Container $CT doesn't exist. Aborting..."
  exit 1
else
  echo "$CT_ID"
fi

# Start service
cp $CT.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable $CT.service
sudo systemctl start $CT.service
