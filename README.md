# GollumOnAzureWebApp
Running Gollum on Azure WebApp

to build

mkdir gollum
#copy the Dockerfile and companions files in gollum or clone the github repo
sudo docker build -t gollum gollum

sudo docker login <registry> -u <user> -p <password>

sudo docker tag gollum <registry>/gollum/gollum
sudo docker push <registry>/gollum/gollum
