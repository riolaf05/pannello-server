#!/bin/bash

N_CLUSTER=2 #Select cluster node number

echo "Writing XML configuration file for each node of the cluster"
HOSTNAME=$(hostname)
printf "<root>\n" >> test.txt
for (( c=1; c<=$N_CLUSTER; c++)); do printf "\t<"$HOSTNAME">\n\t\t<temperatura>TEMP_"$HOSTNAME"</temperatura>\n\t\t<memoria_act>MEM__ACT_"$HOSTNAME"</memoria_act>\n\t\t<memoria_tot>MEM__TOT_"$(hostname)"</memoria_tot>\n\t</"$HOSTNAME">\n" >> test.txt; done
printf "</root>\n" >> test.txt

#todo: avvia rsync

#todo: avvia cronjobs per la scrittura di node_param
#Cronjobs for external jobs
echo "Installing cronjobs"
#chmod +x scripts/*
#sed 's|{{ .EXT_HD_PATH }}|$temperatura|g' script/ > /tmp/persistantVolume.yaml

#TODO: launch add_cronjob.sh as a k8s cronjob

#Kubernetes jobs
echo "Installing server control panel Kubernetes resources"

kubectl apply -f resources/persistantVolume.yaml
kubectl apply -f resources/persistantVolumeClaim.yaml
kubectl apply -f resources/secrets.yaml
kubectl apply -f resources/php.yaml
kubectl apply -f resources/ingress.yaml