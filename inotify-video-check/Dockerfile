FROM ubuntu:latest

MAINTAINER Rio<onslaught89@gmail.com>

#TODO: put FTP inside docker

RUN mkdir scripts
RUN mkdir transferred_files
RUN mkdir MUSICA
RUN mkdir FILM

RUN apt-get update && apt-get install -y inotify-tools && apt-get install -y ffmpeg

WORKDIR scripts

COPY . .

ENTRYPOINT ["/bin/bash" "inotify_check.sh"]  