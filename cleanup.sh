#!/bin/bash

if [ ! -f "${WORKSPACE}/docker_clean_up_script.sh" ] ; then 
  echo "Required not available in the worksapce"
  exit 1
fi

#copy the docker clean up scripts
sudo cat ${WORKSPACE}docker_clean_up_script.sh>/opt/docker_clean_up_script.sh


CRON_2=`sudo cat /var/spool/cron/root | grep "/opt/docker_clean_up_script.sh"`

if [ "${CRON_2}" == "" ]; then
  echo "*/45 * * * * /opt/docker_clean_up_script.sh >/dev/null 2>&1" >>/var/spool/cron/root
fi