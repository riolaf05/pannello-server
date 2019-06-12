echo "Updating cronjobs"
echo "Writing out current crontabs"
crontab -l > mycron
echo "Writing out new crontabs"
echo "* * * * * scripts/get_server_info.sh" >> mycron
#echo "* * * * * /opt/vc/bin/vcgencmd measure_temp > /tmp/temperatura.txt" >> mycron
#echo "* * * * * df -h / > /tmp/memoria.txt" >> mycron
echo "Installing new cron file"
crontab mycron
rm mycron