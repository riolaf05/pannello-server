
DOCKER_TAG='rpi3_'$CIRCLE_PREVIOUS_BUILD_NUM #CHANGE THIS!

echo "Login to docker hub"
docker login -u $DOCKER_USER -p $DOCKER_PASS

info "Pushing docker images"
#docker push rio05docker/inotify-video-converter:$DOCKER_TAG
docker push rio05docker/web_server_panel:$DOCKER_TAG
