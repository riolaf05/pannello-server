FROM ubuntu:latest

MAINTAINER Rio<onslaught89@gmail.com>

#TODO: put FTP inside docker

RUN mkdir /root/transferred_files
RUN mkdir /root/MUSICA
RUN mkdir /root/FILM

RUN apt-get update&& apt-get install -y inotify-tools

WORKDIR ~/transferred_files

COPY file_conversion.sh /root/transferred_files/
COPY inotify_check.sh /root/transferred_files/
COPY launch_script.sh /root/transferred_files/

CMD [ "bash" "/root/transferred_files/inotify_check.sh" ]