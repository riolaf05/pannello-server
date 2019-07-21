#!/bin/bash

DOCKER_TAG='rpi3_test_'$CIRCLE_BUILD_NUM 

echo "Login to docker hub"
docker login -u $DOCKER_USER -p $DOCKER_PASS

echo "Pushing docker images"
#docker push rio05docker/inotify-video-converter:$DOCKER_TAG
docker push rio05docker/web_server_panel:$DOCKER_TAG
