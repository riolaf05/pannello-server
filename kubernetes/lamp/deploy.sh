#Cronjobs for external jobs
#TODO: launch add_cronjob.sh as a k8s cronjob

info "Installing server control panel Kubernetes resources"
#Kubernetes jobs
kubectl apply -f resources/persistantVolume.yaml
kubectl apply -f resources/persistantVolumeClaim.yaml
kubectl apply -f resources/secrets.yaml
kubectl apply -f resources/php.yaml
kubectl apply -f resources/ingress.yaml