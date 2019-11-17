docker stop rpi-minidlna \
&& docker rm rpi-minidlna \
&& docker run --restart unless-stopped -d --net=host -p 8200:8200 -p 1900:1900/udp -v /media/pi/extHD1/MUSICA/:/media/Music -v /media/pi/extHD1/FILM/:/media/Videos -v /media/pi/extHD1/FOTO/:/media/Pictures -e MINIDLNA_MEDIA_DIR=/media --name=rpi-minidlna djdefi/rpi-minidlna