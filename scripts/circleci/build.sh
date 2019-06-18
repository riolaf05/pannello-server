#!/bin/bash

DOCKER_TAG='rpi3_'$CIRCLE_BUILD_NUM 

echo "Building docker images"
#docker build -t "rio05docker/inotify-video-converter:$DOCKER_TAG" inotify-video-converter/
docker build -t "rio05docker/web_server_panel:$DOCKER_TAG" startbootstrap-shop-item-gh-pages/


