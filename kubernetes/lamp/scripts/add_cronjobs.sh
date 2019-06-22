echo "Updating cronjobs"
echo "Writing out current crontabs"
crontab -l > mycron

if grep -q "get_server_info.sh" mycron 
then
    echo "Cronjob already set!"
else
    echo "Writing out new crontabs"
    echo "* * * * * $HOME/Scripts/get_server_info.sh" >> mycron
    #echo "* * * * * /opt/vc/bin/vcgencmd measure_temp > /tmp/temperatura.txt" >> mycron
    #echo "* * * * * df -h / > /tmp/memoria.txt" >> mycron

    echo "Installing new cron file"
    crontab mycron
    rm mycron
fi

