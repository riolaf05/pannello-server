#!/bin/bash
if [[ $1 =~ "mp3"$ ]]; then
        echo “mp3 file found”
        mv $1 /root/MUSICA/
        #mv $1 /media/pi/extHD/MUSICA/ <- undockerized version
elif [[ $1 =~ "mp4"$ ]]; then
        echo “mp4 file found”
        extension=.mkv
        new_file_name=$1$extension
        ffmpeg -i $1 new_file_name
        mv new_file_name /root/FILM/
        #mv new_file_name /media/pi/extHD/FILM/ <- undockerized version
elif [[ $1 =~ "mkv"$ ]]; then
        echo “mkv file found”
        extension=.mkv
        new_file_name=$1$extension
        ffmpeg -i $1 new_file_name
        mv new_file_name /root/FILM/
        #mv new_file_name /media/pi/extHD/FILM/ <- undockerized version
fi
