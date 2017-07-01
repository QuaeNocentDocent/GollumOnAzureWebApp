#!/bin/bash
# ver check 0630

service ssh start
touch /home/LogFiles/node_$WEBSITE_ROLE_INSTANCE_ID_out.log
echo "$(date) Container started" >> /home/LogFiles/node_$WEBSITE_ROLE_INSTANCE_ID_out.log
#uwf status verbose >> /home/LogFiles/node_$WEBSITE_ROLE_INSTANCE_ID_out.log
echo "$(env)" >> /home/LogFiles/node_$WEBSITE_ROLE_INSTANCE_ID_out.log

#mount -t cifs //$SHARE /wiki -o vers=3.0,username=$SHAREACCT,password=$SHAREPWD,dir_mode=0777,file_mode=0777,serverino

#TODO define a cron that copies the git repo to a storage account once a day

#TODO check if it already exists
mkdir /home/wiki
git init /home/wiki

#TODO Schedule a cron job to backup the wiki

#TODO if GOLLUMCONF copy the conf file and start gollum with --config /var/www/yourwiki/config.rb copy the config file from a storage account using azure cli2

/gollum/bin/gollum --port $PORT /home/wiki