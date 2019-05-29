#!/bin/sh
#while inotifywait -r -e CREATE /home/pi/Downloads/transferred_files; do /home/pi/Downloads/transferred_files/launch_script.sh; done; <- undockerized version
while inotifywait -r -e CREATE /transferred_files; do ./file_conversion.sh "$(ls /transferred_files -1t | head -1)"; done;
