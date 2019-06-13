echo "Updating cronjobs"

echo "Writing out new crontabs"
echo "* * * * * $HOME/Scripts/get_server_info.sh" > mycron
#echo "* * * * * /opt/vc/bin/vcgencmd measure_temp > /tmp/temperatura.txt" >> mycron
#echo "* * * * * df -h / > /tmp/memoria.txt" >> mycron
#TODO: add cronjob to shut down and reboot cluster

crontab mycron
rm mycron