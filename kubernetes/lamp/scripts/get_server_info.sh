MEMORIA_USATA=$(df -h / | awk '{ print $3 }' | tail -n 1 | sed 's/[^0-9|\.]*//g') 
MEMORIA_TOTALE=$(df -h / | awk '{ print $2 }' | tail -n 1 | sed 's/[^0-9|\.]*//g' )
#TEMPERATURA=$(/opt/vc/bin/vcgencmd measure_temp | sed 's/[^0-9|\.]*//g')

#NODE_TEMP=TEMP_$(hostname)
NODE_MEM_ACT=MEM__ACT_$(hostname)
NODE_MEM_TOT=MEM__TOT_$(hostname)

#sed 's|{{ .$NODE_TEMP }}|$TEMPERATURA|g' /tmp/nodes_param.xml 
sed 's|{{ .$NODE_MEM_ACT }}|$MEMORIA_USATA|g' /tmp/nodes_param.xml 
sed 's|{{ .$NODE_MEM_TOT }}|$MEMORIA_TOTALE|g' /tmp/nodes_param.xml 
