#!/bin/bash
set -x
WORKSPACE=`pwd`
ELASTIC_IP=$1
if [ -z "$ELASTIC_IP" ]
then
      echo "Plesae provide a valid Elastic search IP"
	  exit 1
fi

#Check the required file available  for fluentd in workspace
if [ ! -f "${WORKSPACE}/Dockerfile" ] ; then
  echo "Dockerfile not available in worksapce to build the fluentd container"
  exit 1
fi

 if [ ! -f "${WORKSPACE}/fluent.conf" ]; then
  echo "config file not available in the worksapce to build the fluentd container"
  exit 1
fi

sed -i "s/ELASTIC_IP/${ELASTIC_IP}/g" "${WORKSPACE}/fluent.conf"

#Build the docker image for fluentd
sudo docker build -t fluentd-es .

FLUENTD_PID=`sudo  docker ps | grep fluentd | awk '{print $1}'`

if [ "${FLUENTD_PID}" != "" ]; then
  sudo docker rm -f ${FLUENTD_PID}
fi

#Start fluentd
sudo docker run -d --name fluentd -v  /docker/docker/containers:/docker/docker/containers fluentd-es