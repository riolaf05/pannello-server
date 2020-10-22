
# Instal Helm 2 on master nodes

wget https://get.helm.sh/helm-v2.16.12-linux-arm.tar.gz \
&& tar -zxvf helm-v2.16.12-linux-arm.tar.gz \
&& sudo mv linux-arm/helm /usr/local/bin/helm \
&& rm helm-v2.16.12-linux-arm.tar.gz && sudo rm -r linux-arm \
&& sudo kubectl --namespace kube-system create sa tiller \
&& sudo kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller \
&& sudo helm init --service-account tiller --upgrade --tiller-image=jessestuart/tiller

### Uninstall Helm 

sudo kubectl -n kube-system delete sa tiller \
&& sudo kubectl delete clusterrolebinding tiller \
&& sudo rm -r /usr/local/bin/helm \
&& sudo kubectl delete deployment -n kube-system $(sudo kubectl get deployments -n kube-system | grep tiller | awk '{ print $1 }')


