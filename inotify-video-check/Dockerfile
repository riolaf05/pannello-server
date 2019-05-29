FROM ubuntu:latest

MAINTAINER Rio<onslaught89@gmail.com>

#TODO: put FTP inside docker

RUN mkdir ~/transferred_files
RUN mkdir ~/MUSICA
RUN mkdir ~/FILM

RUN apt-get update&& apt-get install -y inotify-tools

WORKDIR ~/transferred_files

COPY file_conversion.sh ~/transferred_files/
COPY inotify_check.sh ~/transferred_files/
COPY launch_script.sh ~/transferred_files/

CMD [ "~/transferred_files/inotify_check.sh &" ]