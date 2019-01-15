This is a web UI for raspberry pi and other linux servers management

For the installation move the pannello_controllo/ folder under: /var/www/html

The PHP script uses some Linux commands to retrieve temperature and memory usage of the machine.
For those who face the "VCHI Initialization failed" error 
(showed in /temp/temperatura.txt file after opening index.php from client browser) the correct way to fixis is to 
add user www-data to video group. Below is the command:

sudo usermod -G video www-data

And then restart web server. (if you are trying to display this error on a php based webpage.

Default port for "motion" web stream display is 8081

Default port for "minidlna" web UI is 8200

Dlna server used is "Minidlna" (must be instaled)

To enable the "Server Shutdown and Reboot" buttons it is necessary to use a cron job that 
shuts down or reboots the machine if it find the file writen by the PHP script (that cannot 
reboot the machine directly).

########################## SCRIPT PER LA CONVERSIONE AUTOMATICA DEI FILE CARICATI - ITA ##########################


############################DA NON FARE##############################################
Per fare un test..
mkdir transferred_files
cd transferred_files
touch test.mp3
var_name=$(ls | sort -V | tail -n 1)
[[ $var_name =~ "mp3"$ ]] && echo "Matches!" || echo "Doesn't match!"
#####################################################################################
Preparazione..
Il file \pannello-server\startbootstrap-shop-item-gh-pages\pannello_controllo\invia_file.php deve essere modificato per puntare alla cartella dove verranno caricati i file (transferred_files)..
Installare Inotify-Tools
Copiare in /home/pi/Downloads/ transferred_files gli script..
-	file_conversion.sh
-	inotify_check.sh
Quando i file verrano copiati in questa cartella lo script inotify check consentirà ad inotify-tool di controllare l’inserimento di nuovi file e lanciare lo script file_conversion per la conversione dei file video o mp3 e la copia nelle rispettive cartelle.
######### SCRIPT PER LA CONVERSIONE DEI FILE MVK – file_converion.sh
#!/bin/bash
if [[ $1 =~ "mp3"$ ]]; then
        echo “mp3 file found”
        mv $1 /media/pi/extHD/MUSICA/
elif [[ $1 =~ "mp4"$ ]]; then
        echo “mp4 file found”
        extension=.mkv
        new_file_name=$1$extension
        ffmpeg -i $1 new_file_name
        mv new_file_name /media/pi/extHD/FILM/
elif [[ $1 =~ "mkv"$ ]]; then
        echo “mkv file found”
        extension=.mkv
        new_file_name=$1$extension
        ffmpeg -i $1 new_file_name
        mv new_file_name /media/pi/extHD/FILM/
fi
########### SCRIPT PER LA RILEVAZIONE DI NUOVI FILECARICATI TRAMITE INOTIFY – inotify_check.sh
#!/bin/sh
inotifywait -m -r -q --format '%f' /tmp/test_file_name | while read FILE
do
  ./script_file_name_match.sh $FILE"
done


TODO: lanciare lo script per la rilevazione in background con cron

