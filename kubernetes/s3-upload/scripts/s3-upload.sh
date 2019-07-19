#!/bin/bash

#S3KEY="my aws key"
#S3SECRET="my aws secret" # pass these in #use k8s secrets

DAY=$(date -d "$D" '+%d')
MONTH=$(date -d "$D" '+%m')
YEAR=$(date -d "$D" '+%y')
COMMIT_MSG='commit_'$DAY'_'$MONTH'_'$YEAR

function putS3
{
  path=$1
  file=$2
  aws_path=$3
  bucket='my-aws-bucket'
  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:public-read"
  content_type='application/x-compressed-tar'
  string="PUT\n\n$content_type\n$date\n$acl\n/$bucket$aws_path$file"
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  curl -X PUT -T "$path/$file" \
    -H "Host: $bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$bucket.s3.amazonaws.com$aws_path$file"
}


if git rev-parse --git-dir ; then #this check if there is a git repo in folder 
                                  #NOTE: this script must be executed inside git root folder
	git add . 
    list=$(git diff --name-status HEAD | cut -f2) #list last modified or added files
    #TODO: what if list is empty?
    for i in &list; do putS3 "$path" "${file##*/}" "$i"; done  #puts each new file into S3 #TODO: choose folder
    git commit -m $COMMIT_TAG
else
    git init
    git commit -m $COMMIT_TAG
    putS3 "$path" "${file##*/}" .
fi



