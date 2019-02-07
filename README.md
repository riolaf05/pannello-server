
# Server web control panel 

This is a web UI for raspberry pi and other linux servers management

### Installation

For the installation: 

* move the pannello_controllo/ folder under: /var/www/html

Note:
The PHP script uses some Linux commands to retrieve temperature and memory usage of the machine.
For those who face the "VCHI Initialization failed" error 
(showed in /temp/temperatura.txt file after opening index.php from client browser) the correct way to fixis is to 
add user www-data to video group. Below is the command:

* sudo usermod -G video www-data

* restart web server. (if you are trying to display this error on a php based webpage.

Default port for "motion" web stream display is 8081

Default port for "minidlna" web UI is 8200

Dlna server used is "Minidlna" (must be instaled)

To enable the "Server Shutdown and Reboot" buttons it is necessary to use a cron job that 
shuts down or reboots the machine if it find the file writen by the PHP script (that cannot 
reboot the machine directly).

### SCRIPT PER LA CONVERSIONE AUTOMATICA DEI FILE CARICATI - ITA 

Il file \pannello-server\startbootstrap-shop-item-gh-pages\pannello_controllo\invia_file.php deve essere modificato per puntare alla cartella dove verranno caricati i file..
### DA NON FARE
Per fare un test..
mkdir transferred_files
cd transferred_files
touch test.mp3
var_name=$(ls | sort -V | tail -n 1)
[[ $var_name =~ "mp3"$ ]] && echo "Matches!" || echo "Doesn't match!"

### Prerequisites

Preparazione..
Installare Inotify-Tools
Copiare in /home/pi/Downloads/ transferred_files gli script..
* file_conversion.sh
* inotify_check.sh
Quando i file verrano copiati in questa cartella lo script inotify check consentirà ad inotify-tool di controllare l’inserimento di nuovi file e lanciare lo script file_conversion per la conversione dei file video o mp3 e la copia nelle rispettive cartelle.

### SCRIPT PER LA CONVERSIONE DEI FILE MVK – file_converion.sh (metterlo nella cartella transferred_files)
N.B. RICHIEDE DI DEFINIRE PRIMA IL COMANDO update_minidlna tramite "alias"

```console
#!/bin/bash
if [[ $1 =~ "mp3"$ ]]; then
        echo “mp3 file found”
        mv "$1" /media/pi/extHD/MUSICA/
	update_minidlna
elif [[ $1 =~ "mp4"$ ]]; then
        echo “mp4 file found”
        extension=.mkv
        new_file_name=$1$extension
        ffmpeg -i $1 $new_file_name
        mv "$new_file_name" /media/pi/extHD/FILM/
	update_minidlna
elif [[ $1 =~ "mkv"$ ]]; then
        echo “mkv file found”
        extension=.mkv
        new_file_name=$1$extension
        ffmpeg -i $1 $new_file_name
        mv "$new_file_name" /media/pi/extHD/FILM/
	update_minidlna
fi 
```
### SCRIPT PER LA RILEVAZIONE DI NUOVI FILECARICATI TRAMITE INOTIFY - inotify_check.sh (metterlo nella cartella transferred_files)
```console
while inotifywait -r -e MODIFY /home/pi/Downloads/transferred_files; do /home/pi/Downloads/transferred_files/launch_script.sh; done;
```
### SCRIPT CHE RILEVA L'ULTIMO FILE MODIFICATO E LO MANDA ALLO SCRIPT PER LA CONVERSIONE - launch_script.sh (metterlo nella cartella transferred_files)
```console
bash file_conversion.sh "$(ls -1t | head -1)"
```
### COMANDO PER LANCIARE INOTIFYWAIT IN BACKGROUND (lanciarlo all'avvio mettendolo in uno script in /etc/init.sh)
```console
nohup /home/pi/Downloads/transferred_files/inotify_check.sh &
```
TODO: check upload di più file video contemporaneamente e vedere se le conversioni vengono fatte parallelamente!!

