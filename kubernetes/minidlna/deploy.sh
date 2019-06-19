#!/bin/bash

#Build step, template files will be filled with env parameters
NODE_HOSTNAME=raspberry.local
sed 's|{{ .EXT_HD_PATH }}|/media/pi/extHD|g' resources/persistentVolume.yaml.tpl > resources/persistentVolume.yaml
sed 's|{{ .NODE }}|$NODE_HOSTNAME|g' resources/persistentVolume.yaml.tpl > resources/persistentVolume.yaml

#Deploy step, applying k8s resources
kubectl apply -f resources/persistentVolume.yaml
kubectl apply -f resources/persistentVolumeClaim.yaml
kubectl apply -f resources/pod.yaml