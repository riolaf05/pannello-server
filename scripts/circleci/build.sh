#!/bin/bash

#export RANDOM_TAG=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) #generate random hash tag for docker images
DOCKER_TAG='rpi3_test_'$CIRCLE_BUILD_NUM #CHANGE THIS!

echo "Building docker images"
#docker build -t "rio05docker/inotify-video-converter:latest" inotify-video-converter/
docker build -t "rio05docker/web_server_panel:rpi3_test_$DOCKER_TAG" startbootstrap-shop-item-gh-pages/

echo "Login to docker hub"
docker login -u $DOCKER_USER -p $DOCKER_PASS

info "Pushing docker images"
#docker push rio05docker/inotify-video-converter:latest
docker push rio05docker/web_server_panel:$DOCKER_TAG

