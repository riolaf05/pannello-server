export EXT_HD_PATH="/mnt/pi/extHD"

#Build step, template files will be filled with env parameters
envtpl < resources/persistantVolume.yaml.tpl > "persistantVolume.yaml"

#Deploy step, applying k8s resources
kubectl apply -f resources/persistantVolume.yaml
kubectl apply -f resources/persistantVolumeClaim.yaml
kubectl apply -f resources/pod.yaml