FROM ubuntu:18.04

RUN mkdir /media/pi/extHD/MUSICA/
RUN mkdir /media/pi/extHD/FILM/
RUN mkdir /home/pi/Downloads/transferred_files

COPY file_conversion.sh /home/pi/Downloads/transferred_files
COPY inotify_check.sh /home/pi/Downloads/transferred_files

VOLUME /home/pi/Downloads/transferred_files /home/pi/Downloads/transferred_files
VOLUME /media/pi/extHD/MUSICA/ /media/pi/extHD/MUSICA/
VOLUME /media/pi/extHD/FILM/ /media/pi/extHD/FILM/

CMD nohup /home/pi/Downloads/transferred_files/inotify_check.sh & 
