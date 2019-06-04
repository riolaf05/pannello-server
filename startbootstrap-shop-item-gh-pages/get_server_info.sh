MEMORIA_USATA=$(df -h / | awk '{ print $3 }' | tail -n 1 | sed 's/[^0-9|\.]*//g') 
MEMORIA_TOTALE=$(df -h / | awk '{ print $2 }' | tail -n 1 | sed 's/[^0-9|\.]*//g' )