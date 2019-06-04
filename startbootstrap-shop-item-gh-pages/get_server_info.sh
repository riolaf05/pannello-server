MEMORIA_USATA=$(df -h / | awk '{ print $3 }' | tail -n 1 | sed 's/[^0-9|\.]*//g') 
MEMORIA_TOTALE=$(df -h / | awk '{ print $2 }' | tail -n 1 | sed 's/[^0-9|\.]*//g' )
TEMPERATURA=$(/opt/vc/bin/vcgencmd measure_temp | sed 's/[^0-9|\.]*//g')

echo '<root><memoriaUsata>'$MEMORIA_USATA'</memoriaUsata><memoriaTotale>'$MEMORIA_TOTALE'</memoriaTotale><temperatura>'$TEMPERATURA'</temperatura></root>' > /tmp/my_xml.xml