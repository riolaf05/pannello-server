#!/bin/bash

DOCKER_TAG='rpi3_test_'$CIRCLE_BUILD_NUM #CHANGE THIS!

echo "Building docker images"
#docker build -t "rio05docker/inotify-video-converter:latest" inotify-video-converter/
docker build -t "rio05docker/web_server_panel:rpi3_test_$DOCKER_TAG" startbootstrap-shop-item-gh-pages/

echo "Login to docker hub"
docker login -u $DOCKER_USER -p $DOCKER_PASS

info "Pushing docker images"
#docker push rio05docker/inotify-video-converter:latest
docker push rio05docker/web_server_panel:rpi3_test_$DOCKER_TAG

