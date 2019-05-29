FROM ubuntu:latest

MAINTAINER Rio<onslaught89@gmail.com>

#TODO: put FTP inside docker

RUN mkdir /root/transferred_files
RUN mkdir /root/MUSICA
RUN mkdir /root/FILM

RUN apt-get update&& apt-get install -y inotify-tools

WORKDIR /root/transferred_files

COPY . .

ENTRYPOINT ["/bin/bash"]  