### Helm installation 

```console
curl https://helm.baltorepo.com/organization/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

### Install custom helm packages
See refs: [create your first Helm Chart](https://docs.bitnami.com/tutorials/create-your-first-helm-chart/)

* To test install script: 
```console
 helm install panel pannello-server/kubernetes/lamp/charts/control-panel --dry-run --debug
```

 * To install control panel: 
 
```console
 helm install panel pannello-server/kubernetes/lamp/charts/control-panel
 ```

 * To upgrade image: 

```console
 helm upgrade panel pannello-server/kubernetes/lamp/charts/control-panel --set=image=<IMAGE:TAG>
 ```