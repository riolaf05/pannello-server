#!/bin/bash

N_CLUSTER=2 #Select cluster node number

echo "Writing XML configuration file for each node of the cluster"
HOSTNAME=$(hostname)
printf "<root>\n" >> /tmp/nodes_param.xml
for (( c=1; c<=$N_CLUSTER; c++)); do printf "\t<"$HOSTNAME">\n\t\t<temperatura>TEMP_"$HOSTNAME"</temperatura>\n\t\t<memoria_act>MEM_ACT_"$HOSTNAME"</memoria_act>\n\t\t<memoria_tot>MEM_TOT_"$(hostname)"</memoria_tot>\n\t</"$HOSTNAME">\n" >> /tmp/nodes_param.xml; done
printf "</root>\n" >> /tmp/nodes_param.xml

#TODO: Start Rsync to syncronize /tmp/ folder between nodes 

echo "Installing cronjobs"
chmod +x scripts/*
bash scripts/add_cronjobs.sh

# Installing Kubernetes jobs
echo "Installing server control panel Kubernetes resources"

kubectl apply -f resources/persistantVolume.yaml
kubectl apply -f resources/persistantVolumeClaim.yaml
kubectl apply -f resources/secrets.yaml
kubectl apply -f resources/php.yaml
kubectl apply -f resources/ingress.yaml