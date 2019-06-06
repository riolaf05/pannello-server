#Cronjobs for external jobs
info "Installing cronjobs"
#TODO: launch add_cronjob.sh as a k8s cronjob

#Kubernetes jobs
info "Installing server control panel Kubernetes resources"

kubectl apply -f resources/persistantVolume.yaml
kubectl apply -f resources/persistantVolumeClaim.yaml
kubectl apply -f resources/secrets.yaml
kubectl apply -f resources/php.yaml
kubectl apply -f resources/ingress.yaml