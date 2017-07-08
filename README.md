# GollumOnAzureWebApp
Running Gollum on Azure WebApp

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


#azcli2 upload / download
az storage blob upload-batch --destination https://gollum.blob.core.windows.net/wiki --source /home/wiki --account-key <key>

az storage blob download-batch --source https://gollum.blob.core.windows.net/wiki --destination /home/wiki --account-key <key>