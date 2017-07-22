# GollumOnAzureWebApp

Running Gollum on Azure WebApp

Post on nocentdocent https://wordpress.com/post/nocentdocent.wordpress.com/4428 

to build

mkdir gollum
#copy the Dockerfile and companions files in gollum or clone the github repo
sudo docker build -t gollum:latest gollum

#registry prelabs.azurecr.io

sudo docker login <registry> -u <user> -p <password>

sudo docker tag gollum <registry>/gollum/gollum
sudo docker push <registry>/gollum/gollum

#useful doecker commands
docker image ls

docker run --name c3 --rm gollum:latest /usr/bin/python /usr/bin/init_container.py
docker run --name c3 --rm -v /mnt/home:/home -e "WEBSITE_ROLE_INSTANCE_ID=test" gollum:latest /usr/bin/python /usr/bin/init_container.py

docker run --name c3 --rm -d -v /mnt/home:/home -e "WEBSITE_ROLE_INSTANCE_ID=test" -e "GOLLUMCONF=https://gollum.blob.core.windows.net/config" -e "GOLLUMCONF_KEY=" -e "GOLLUMCUSTOM=wiki" gollum:latest /usr/bin/python /usr/bin/init_container.py


#azcli2 upload / download
az storage blob upload-batch --destination https://gollum.blob.core.windows.net/wiki --source /home/wiki --account-key <key>

az storage blob download-batch --source https://gollum.blob.core.windows.net/wiki --destination /home/wiki --account-key <key>

## future

to be added the the Issues in the github repo when I have time

create a file share
mount the file share https://docs.microsoft.com/en-us/azure/storage/storage-how-to-use-files-linux

//prggollum.file.core.windows.net/wiki /mnt/wiki cifs vers=2.1,username=prggollum,password=XfQW...==,dir_mode=0777,fi$

3.0 doesn't work on ubuntu 16.10
https://azure.microsoft.com/en-us/blog/azure-file-storage-on-premises-access-for-ubuntu/

- add OMS agent, containerized or not? https://github.com/Microsoft/OMS-docker as an option?

Add an EWNV for authorized users 
options[:authorized_users] = ENV["OMNIGOLLUM_AUTHORIZED_USERS"].split(",")
