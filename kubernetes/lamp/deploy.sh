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

#Start Rsync to syncronize /tmp/ folder between nodes 
#TODO

echo "Installing cronjobs"
mkdir $HOME/Scripts/
cp startbootstrap-shop-item-gh-pages/scripts/* $HOME/Scripts
chmod +x $HOME/Scripts/*
bash startbootstrap-shop-item-gh-pages/scripts/add_cronjobs.sh

# Installing Kubernetes jobs
echo "Installing server control panel Kubernetes resources"

kubectl apply -f resources/persistantVolume.yaml
kubectl apply -f resources/persistantVolumeClaim.yaml
kubectl apply -f resources/secrets.yaml
kubectl apply -f resources/php.yaml
kubectl apply -f resources/ingress.yaml