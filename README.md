
# Server web control panel on a Raspberry Pi CLuster

This is a web UI for Raspberry Pi cluster management

### Prerequisites

- Install Ansible 2.0+
- Install Raspbian Stretch on each Raspberry and enable SSH and Camera (throught sudo raspi-config)
- Use the playbook in /ansible folder to configure each Raspberry Pi node, Ansible will
- Change Rasoberry Pi hostnames and update ansible/hosts, then put hostnames on Ansible hosts file:
```console
echo ansible/hosts >> /etc/ansible/hosts
```
- Ansible will install Docker, Kubernetes, create the requiered folders such as: /media/pi/extHD/FILM, /media/pi/extHD/MUSICA, /media/pi/extHD/FOTO), etc.
```
- mount the main storage in /media/pi/extHD/ 

Note: to manually install Docker on Raspberry Pi (optional).
```console
curl -sSL get.docker.com | sh
sudo usermod -aG docker pi
```
log out, then log back in again for the change to take effect
```console
sudo systemctl start docker
```

### CircleCI Continuous Integration 

Actually CircleCI will be triggered on each commit on master branch.

It will build docker images with each new change and will push those changes on Docker Hub.

TODO: enable the build step which do the rollout of the kubernetes resources on the cluster. 

### Installation with Kubernetes 

Note: for each change upload image in pannello-server\startbootstrap-shop-item-gh-pages first with:
```console
docker push rio05docker/web_server_panel:<tagname>
```

Use:

```console
bash kubernetes/lamp/deploy.sh
bash kubernetes/minidlna/deploy.sh #TO BE TESTED
bash kubernetes/ml-keras/deploy.sh #TO BE TESTED
```
This will create the K8s resources on the cluster. 

### Installation with Docker

0) install docker-ce and vcgencmd on local machine

1) launch the add_cronjob.sh script in the local machine

2) go to startbootstrap-shop-item-gh-pages/ and run:
```console
docker build -t "rio05docker/web_server_panel:latest" .
docker push rio05docker/web_server_panel:latest
```
3) run:
```console
docker run -d --restart unless-stopped --name web_server_panel -p 80:80 -p 443:443 -v /tmp:/tmp web_server_panel:latest
```

Use:
```console
openssl req -new -x509 -days 365 -nodes -out /etc/apache2/ssl/apache.pem -keyout /etc/apache2/ssl/apache.key
```
inside the container to create certificate and key when expired.

**TODO: disable non-https connections**

### Local installation

**NOTE: for the local installation must first uncomment the 33° row in index.php**

local installation: 

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

## MINIDLNA SERVER
Using docker:

```console
        docker run --restart unless-stopped -d --name minidlna \
          --net=host \
          -p 8200:8200 \
          -p 1900:1900/udp \
          -v /media/pi/extHD/MUSICA/:/media/Music \
          -v /media/pi/extHD/FILM/:/media/Videos \
          -v /media/pi/extHD/FOTO/:/media/Pictures \
          -e MINIDLNA_MEDIA_DIR=/media \
           djdefi/rpi-minidlna
```
Based on: https://github.com/djdefi/rpi-docker-minidlna


## Python Deep Learing & Machine Learning Develop Environment

```console
docker run -it -d --restart unless-stopped -p 8888:8888 -p 6006:6006 -v /media/pi/extHD/SharedFile:/root/sharedfolder floydhub/dl-docker:cpu jupyter notebook
```

Based on: https://github.com/floydhub/dl-docker

## Codec Conversion 
This service is used to change video and music file encoder so they can be played by Minidlna. 

### Installation with Docker:

```console
docker run -it --restart=unless-stopped -d -v /media/pi/extHD/FILM/:/FILM -v /media/pi/extHD/MUSICA/:/MUSICA -v /home/pi/Downloads:/transferred_files rio05docker/inotify-video-converter:latest
```

Every file that will be put to /home/pi/Downloads will trigger the conversion scripts.

### Manual Installation: (ITA)
Il file \pannello-server\startbootstrap-shop-item-gh-pages\pannello_controllo\invia_file.php deve essere modificato per puntare alla cartella dove verranno caricati i file..
### DA NON FARE
Per fare un test..
```console
mkdir transferred_files
cd transferred_files
touch test.mp3
var_name=$(ls | sort -V | tail -n 1)
[[ $var_name =~ "mp3"$ ]] && echo "Matches!" || echo "Doesn't match!"
```
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
