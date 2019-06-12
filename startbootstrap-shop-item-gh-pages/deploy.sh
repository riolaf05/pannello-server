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

#Docker run:
docker run -d --restart unless-stopped --name web_server_panel -p 80:80 -p 443:443 -v /tmp:/tmp web_server_panel:latest
