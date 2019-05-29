#!/bin/sh
inotifywait -m -r -q --format '%f' /tmp/test_file_name | while read FILE
do
  ./script_file_name_match.sh $FILE"
done
