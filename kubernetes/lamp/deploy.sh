#!/bin/bash

#Cronjobs for external jobs
echo "Installing cronjobs"
#TODO: launch add_cronjob.sh as a k8s cronjob

#Kubernetes jobs
echo "Installing server control panel Kubernetes resources"

kubectl apply -f resources/persistantVolume.yaml
kubectl apply -f resources/persistantVolumeClaim.yaml
kubectl apply -f resources/secrets.yaml
kubectl apply -f resources/php.yaml
kubectl apply -f resources/ingress.yaml