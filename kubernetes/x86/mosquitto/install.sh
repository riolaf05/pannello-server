mkdir ~/mosquitto \
&& cp mosquitto/* ~/mosquitto \
&& kubectl expose deployment mosquitto --type=NodePort --name=mosquitto-svc --port=1883 \
&& kubectl apply -f mosquitto-pv.yaml && kubectl apply -f mosquitto-pvc.yaml && kubectl apply -f mosquitto.yaml 

#to delete all
#kubectl delete deployment mosquitto && kubectl delete pcv mosquitto-pv-claim && kubectl delete pv mosquitto-config