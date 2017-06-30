#!/bin/bash
#uwf allow 2222
service ssh start
touch /home/LogFiles/node_$WEBSITE_ROLE_INSTANCE_ID_out.log
echo "$(date) Container started" >> /home/LogFiles/node_$WEBSITE_ROLE_INSTANCE_ID_out.log
#uwf status verbose >> /home/LogFiles/node_$WEBSITE_ROLE_INSTANCE_ID_out.log
echo "$(env)" >> /home/LogFiles/node_$WEBSITE_ROLE_INSTANCE_ID_out.log

#mount -t cifs //$SHARE /wiki -o vers=3.0,username=$SHAREACCT,password=$SHAREPWD,dir_mode=0777,file_mode=0777,serverino

#I must introduce some logic to avoid redeployment every time
#git clone https://github.com/gollum/gollum /home/gollum
#cd /home/gollum
#git checkout -b 5.x origin/5.x
#
#echo "About to urn bundle install" >> /home/LogFiles/dode_$WEBSITE_RE_INSTANCE_ID_out.log
#bundle install

#TODO define a cron that copies the git repo to a storage account once a day

#TODO check if it already exists
mkdir /home/wiki
git init /home/wiki

#TODO if GOLLUMCONF copy the conf file and start gollum with --config /var/www/yourwiki/config.rb

/home/gollum/bin/gollum --port $PORT /home/wiki