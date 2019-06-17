#!/bin/bash

DOCKER_TAG='rpi3_test_'$CIRCLE_BUILD_NUM #CHANGE THIS!

echo "Building docker images"
#docker build -t "rio05docker/inotify-video-converter:latest" inotify-video-converter/
docker build -t "rio05docker/web_server_panel:$DOCKER_TAG" startbootstrap-shop-item-gh-pages/


