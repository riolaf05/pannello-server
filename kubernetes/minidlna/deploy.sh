
#Build step, template files will be filled with env parameters
sed 's|{{ .EXT_HD_PATH }}|/media/pi/extHD|g' resources/persistantVolume.yaml.tpl > persistantVolume.yaml

#Deploy step, applying k8s resources
kubectl apply -f resources/persistantVolume.yaml
kubectl apply -f resources/persistantVolumeClaim.yaml
kubectl apply -f resources/pod.yaml