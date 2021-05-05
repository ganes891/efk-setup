#server setup
#run master branch init.sh

# To Setup EFK in Optimus Environment

# Setups to Fluentd

#Clone the repository to the host machine

cd /tmp

git clone http://10.133.208.121/gitlab/root/efk-setup.git

#Install git if required

sudo yum install -y git

#Navigate to efk-setup folder

cd efk-setup

#Check out to fluentd branch

git checkout fluentd

sudo vi fluent.conf

//replace 186_server by resepective server name

#Run install_fluentd.sh script

#syntax

sudo sh install_fluentd.sh <ELASTIC_SEARCH_IP>

#example

sudo sh install_fluentd.sh 10.133.209.36 

#haproxy entry

```Haproxy
default_backend kibana_server

backend kibana_server
    server kibana_server 10.133.209.36:5601 check 

```








