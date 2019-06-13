#!/bin/bash

echo "Removing old scripts"
rm /tmp//nodes_param.xml

N_CLUSTER=2 #Select cluster node number
cluster[0]="raspberrypi"
cluster[1]="raspberrypi1"

echo "Writing XML configuration file for each node of the cluster"
HOSTNAME=$(hostname)
printf "<?xml version="1.0"?>\n"
printf "<root>\n" >> /tmp/nodes_param.xml
for (( c=0; c<=$N_CLUSTER-1; c++)); do printf "\t<raspberry name='"${cluster[$c]}"'>\n\t\t<temperatura>TEMP_"${cluster[$c]}"</temperatura>\n\t\t<memoria_act>MEM_ACT_"${cluster[$c]}"</memoria_act>\n\t\t<memoria_tot>MEM_TOT_"${cluster[$c]}"</memoria_tot>\n\t</raspberry>\n" >> /tmp/nodes_param.xml; done
printf "</root>\n" >> /tmp/nodes_param.xml

#TODO: copy xml params file with SSH on all machines

#Start Rsync to syncronize /tmp/ folder between nodes 
#TODO

echo "Installing cronjobs"
mkdir $HOME/Scripts
cp scripts/* $HOME/Scripts
chmod +x $HOME/Scripts
bash scripts/add_cronjobs.sh

echo "PBuilding Docker image"
docker build -t "rio05docker/web_server_panel:rpi3_latest" .
