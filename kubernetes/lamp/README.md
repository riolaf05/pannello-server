### Credits
https://github.com/heptio/example-lamp

### Istruction to deploy:

In order to deploy the Kubernetes resources for control panel use the following commands (contained in deploy.sh):

```console
kubectl apply -f persistantVolume.yaml
kubectl apply -f persistantVolumeClaim.yaml
kubectl apply -f secrets.yaml
kubectl apply -f php.yaml
kubectl apply -f ingress.yaml
```
Last step can take a couple of minutes.

The Persistant Volume is used to put a volume on host's /tmp folder and read the "memoria.txt" and "temperatura.txt" files from there.

Those files contains some information on host harware (TODO: add informations on each node)

The Persistant Volume Claim is used to allow each pod to ask for a Persistant Volume

The Secret resource is used to store MySql credentials.

To bind the containers with the volume use the containers.volumeMounts element in php.yaml (i.e. deployment definition)

Note, for test runs on minikube run first:
```console
minikube addons enable ingress
```

and check minikube exposed IP and ports with:
```console
minikube service panel --url
```
