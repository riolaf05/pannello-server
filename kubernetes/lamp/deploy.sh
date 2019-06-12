#!/bin/bash

#Cronjobs for external jobs
echo "Installing cronjobs"
chmod +x scripts/*
sed 's|{{ .EXT_HD_PATH }}|/scripts/nodes_params.xml|g' script/ > /tmp/persistantVolume.yaml

#TODO: launch add_cronjob.sh as a k8s cronjob

#Kubernetes jobs
echo "Installing server control panel Kubernetes resources"

kubectl apply -f resources/persistantVolume.yaml
kubectl apply -f resources/persistantVolumeClaim.yaml
kubectl apply -f resources/secrets.yaml
kubectl apply -f resources/php.yaml
kubectl apply -f resources/ingress.yaml