#!/bin/sh
#while inotifywait -r -e MODIFY /home/pi/Downloads/transferred_files; do /home/pi/Downloads/transferred_files/launch_script.sh; done; <- undockerized version
while inotifywait -r -e MODIFY /transferred_files; do scripts/launch_script.sh; done;