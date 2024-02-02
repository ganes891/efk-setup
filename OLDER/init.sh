#!/bin/bash
set -x
WORKSPACE=`pwd`
RUN_USER=`echo $SUDO_USER`

#Check the status of kibana
KIBANA_STATUS=`curl -Is http://localhost:5601/app/kibana | head -n 1 | awk '{print $2}'`


if [ "${KIBANA_STATUS}" == "200" ]; then
  echo "Kibana already Installed in this machine"
  exit 1;
fi

#Check if elasticsearch is already running
ES_PID=`sudo  docker ps | grep elasticsearch | awk '{print $1}'`

if [ "$ES_PID" == "" ]; then
   sudo docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:8.12.0
else
  echo "Elastic search is already running ..."
  echo "Skipping ES setup"
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

#Build the docker image for fluentd
sudo docker build -t fluentd-es .

FLUENTD_PID=`sudo  docker ps | grep fluentd | awk '{print $1}'`

if [ "${FLUENTD_PID}" != "" ]; then
  sudo docker rm -f ${FLUENTD_PID}
fi

#Start fluentd
sudo docker run -d --name fluentd --link elasticsearch:es -v  /docker/docker/containers:/docker/docker/containers fluentd-es

#Start kibana
sudo docker run -d --name kibana --link elasticsearch:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:8.12.0


#To install curator
sudo  cat curator.repo >/etc/yum.repos.d/curator.repo
sudo yum install -y elasticsearch-curator

#configure curator
mkdir -p /opt/efk/.curator
cat curator.yml>/opt/efk/.curator/curator.yml
cat delete_indices.yml>/opt/efk/.curator/delete_indices.yml

sleep 10

#Check the status of kibana
KIBANA_STATUS=`curl -Is http://localhost:5601/app/kibana | head -n 1 | awk '{print $2}'`


if [ "${KIBANA_STATUS}" != "200" ]; then
  echo "Kibana not started or Haproxy not configured properly"
  exit 1;
fi

#create the index pattern
sudo sh ${WORKSPACE}/create-index-pattern.sh

CRON_1=`sudo cat /var/spool/cron/root | grep "/opt/efk/.curator/curator.yml"`
if [ "${CRON_1}" == "" ]; then
  echo "0 3 * * * sudo curator /opt/efk/.curator/delete_indices.yml  --config /opt/efk/.curator/curator.yml > /tmp/curator.log" >>/var/spool/cron/root
fi
