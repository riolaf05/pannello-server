#!/bin/bash

echo "Removing old scripts"
rm /tmp/nodes_param.xml

#Getting node hostnames 
c=0
mapfile -t node_list < hostnames.txt
for i in $node_list; do cluster[$c]=$i && c=$c+1; done
N_CLUSTER=${#cluster[@]}

#Select latest docker image tag:
#DOCKER_TAG="rpi3_prod_latest"

echo "Writing XML configuration file for each node of the cluster"
HOSTNAME=$(hostname)
#printf "<?xml version="1.0"?>\n" >> /tmp/nodes_param.xml
printf "<root>\n" >> /tmp/nodes_param.xml
for (( c=0; c<=$N_CLUSTER-1; c++)); do printf "\t<raspberry name='"${cluster[$c]}"'>\n\t\t<temperatura>TEMP_"${cluster[$c]}"</temperatura>\n\t\t<memoria_act>MEM_ACT_"${cluster[$c]}"</memoria_act>\n\t\t<memoria_tot>MEM_TOT_"${cluster[$c]}"</memoria_tot>\n\t</raspberry>\n" >> /tmp/nodes_param.xml; done
printf "</root>\n" >> /tmp/nodes_param.xml

#TODO: rsync files between nodes

echo "Installing cronjobs"
mkdir $HOME/Scripts
cp scripts/* $HOME/Scripts
chmod +x $HOME/Scripts
bash scripts/add_cronjobs.sh

#echo "Building Docker image"
#docker build -t "rio05docker/web_server_panel:$DOCKER_TAG" .
