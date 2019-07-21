#!/bin/bash

DAY=$(date -d "$D" '+%d')
MONTH=$(date -d "$D" '+%m')
DOCKER_TAG='rpi3_test_'$DAY'_'$MONTH

echo "Build and push subscriber container"
docker build -t "rio05docker/panel-s3-upload-job:$DOCKER_TAG" scripts/.
docker push rio05docker/panel-s3-upload-job:$DOCKER_TAG