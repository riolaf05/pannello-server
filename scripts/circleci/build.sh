info "Building docker images"
docker build -t "rio05docker/inotify-video-converter:latest" inotify-video-converter/
docker build -t "rio05docker/web_server_panel:latest" startbootstrap-shop-item-gh-pages/

info "Pushing docker images"
#docker push rio05docker/inotify-video-converter:latest
#docker push rio05docker/web_server_panel:latest
