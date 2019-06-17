
DOCKER_TAG='rpi3_test_'$CIRCLE_SHA1 #CHANGE THIS!

echo "Login to docker hub"
docker login -u $DOCKER_USER -p $DOCKER_PASS

info "Pushing docker images"
#docker push rio05docker/inotify-video-converter:latest
docker push rio05docker/web_server_panel:$DOCKER_TAG
