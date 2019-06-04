#write out current crontab
crontab -l > mycron

#echo new cron into cron file (old version)
#echo "* * * * * /opt/vc/bin/vcgencmd measure_temp > /tmp/temperatura.txt" >> mycron
#echo "* * * * * df -h / > /tmp/memoria.txt" >> mycron

#echo new cron into cron file (new version)
echo "* * * * *  bash /home/pi/scripts/get_server_info.sh" >> mycron

#install new cron file
crontab mycron
rm mycron