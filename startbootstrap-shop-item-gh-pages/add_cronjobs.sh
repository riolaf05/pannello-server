#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "* * * * * /opt/vc/bin/vcgencmd measure_temp > /tmp/temperatura.txt" >> mycron
echo "* * * * * df -h / > /tmp/memoria.txt" >> mycron
#install new cron file
crontab mycron
rm mycron