#!/bin/bash
if [[ $1 =~ "mp3"$ ]]; then
        echo “mp3 file found”
        mv $1 ~/MUSICA/
elif [[ $1 =~ "mp4"$ ]]; then
        echo “mp4 file found”
        extension=.mkv
        new_file_name=$1$extension
        ffmpeg -i $1 new_file_name
        mv new_file_name ~/FILM/
elif [[ $1 =~ "mkv"$ ]]; then
        echo “mkv file found”
        extension=.mkv
        new_file_name=$1$extension
        ffmpeg -i $1 new_file_name
        mv new_file_name ~/FILM/
fi
