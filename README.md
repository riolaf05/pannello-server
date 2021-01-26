
# Server web control panel on a Raspberry Pi Cluster

This is a web UI for Raspberry Pi cluster management

![image](https://github.com/riolaf05/pannello-server/blob/test/cluster.JPG)

Index:

* Prerequisites
* Install K3s
* Install K8s
* Cross-compiling Docker for ARM Architecture
* Services
* Python Deep Learing & Machine Learning Develop Environment
* Codec Conversion Service installation

## Prerequisites

- Install Ansible 2.0+ (only for K8s installation)

```console
echo ansible/hosts >> /etc/ansible/hosts
```
- Ansible will install Docker, Kubernetes, dependencies and create the requiered folders such as: /media/pi/extHD/FILM, /media/pi/extHD/MUSICA, 

```console
/media/pi/extHD/FOTO), bind the main storage in /media/pi/extHD/ etc.
```

- Install Raspbian Buster on each Raspberry and enable SSH and Camera (throught sudo raspi-config)
- Use the playbook in /ansible folder to configure each Raspberry Pi node (only for K8s installation).
- Change Raspberry Pi hostnames and update ansible/hosts, then put hostnames on Ansible hosts file:

```console
echo -e "192.168.1.9\traspberrypi1" | sudo tee -a /etc/hosts
echo -e "192.168.0.10\traspberrypi" | sudo tee -a /etc/hosts
echo -e "192.168.0.12\traspberrypitest" | sudo tee -a /etc/hosts
```

- Disable WiFi nd Bluetooth Driver by adding the following line to /etc/modprobe.d/raspi-blacklist.conf

```console
#wifi
blacklist brcmfmac
blacklist brcmutil
#bt
blacklist btbcm
blacklist hci_uart
```

- Disable Swap: #TODO: fix that in Ansible script
```console
sudo dphys-swapfile swapoff && \
sudo dphys-swapfile uninstall && \
sudo update-rc.d dphys-swapfile remove
```

## K3s installation

1. On master node:

```console
export K3S_KUBECONFIG_MODE="644" \
&& export INSTALL_K3S_EXEC="--no-deploy traefik" \
&& curl -sfL https://get.k3s.io | sh -
```

then get the token with: 

```console
cat /var/lib/rancher/k3s/server/node-token
```

2. On worker node:

```console
curl -sfL https://get.k3s.io | K3S_URL=https://<master_url>:6443 K3S_TOKEN=<token> sh -
```

## Add users

Follow [istructions](https://github.com/riolaf05/pannello-server/blob/develop/context_creation.md).

## K8s instalation

### Kubernetes cluster configuration 

- Pre-pull K8s master images: 
```console
sudo kubeadm config images pull -v3
```

- Init the master:

```console
sudo kubeadm init
```

- Again, on master: 
```console
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

- Install Weave Net network driver, on master:
```console
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

- On slaves: 
```console
sudo kubeadm join --token <token> <master-node-ip>:6443 --discovery-token-ca-cert-hash sha256:<sha256>
```

### Cross-compiling Docker for ARM Architecture

To cross-compile ARM docker on x86:

1. enable Docker BuildX
```console
export DOCKER_CLI_EXPERIMENTAL=enabled \
&& docker buildx --help \
&& docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3 \
&& cat /proc/sys/fs/binfmt_misc/qemu-aarch64 \
```

2. cross-compile
```console
docker buildx create --name mybuilder
docker buildx use mybuilder
docker buildx inspect --bootstrap
docker buildx build --platform linux/arm,linux/arm64,linux/amd64 -t timtsai2018/hello . --push
```

## Install Helm on Raspberry Pi

```console
wget https://get.helm.sh/helm-v3.5.0-linux-arm.tar.gz
tar -zxvf helm-v3.5.0-linux-arm.tar.gz 
rm helm-v3.5.0-linux-arm.tar.gz
sudo mv linux-arm/helm /usr/local/bin/helm
helm repo add stable "https://charts.helm.sh/stable
helm repo update
```
## Services

### 1. Load Balancing

By default, the applications deployed to a Kubernetes cluster are only reachable from within the cluster (default service type is ClusterIP). To make them reachable from outside the cluster you can either configure the service with the type NodePort, which exposes the service on each node's IP at a static port, or you can use a load balancer.

NodePort services are, however, quite limited: they use their own dedicated port range and we can only differentiate apps by their port number. 

For these reasons, we decided to deploy [MetalLB](https://metallb.universe.tf), a load-balancer implementation that is intended for bare metal clusters.

To deploy the load balancer use Helm3: 

```console
helm install metallb stable/metallb --namespace kube-system \
  --set configInline.address-pools[0].name=default \
  --set configInline.address-pools[0].protocol=layer2 \
  --set configInline.address-pools[0].addresses[0]=192.168.1.240-192.168.1.250
```

The kubernetes/load-balancer folder contains the configMaps for MetalLB. 

[Source](https://kauri.io/38-install-and-configure-a-kubernetes-cluster-with/418b3bc1e0544fbc955a4bbba6fff8a9/a)

### 2. Ingress Controller
#### Nginx

1. Deploy ingress controller with Helm3

```console
helm install nginx-ingress stable/nginx-ingress --namespace kube-system \
    --set rbac.create=true \
    --set defaultBackend.enabled=false \
    --set controller.publishService.enabled=true
```

2. Update image for arm:

```console
kubectl set image deployment/nginx-ingress-controller nginx-ingress-controller=quay.io/kubernetes-ingress-controller/nginx-ingress-controller-arm:0.26.1
```

3. Generate SSL key using the provided script:

```console
./kubernetes/nginx/create_cert.sh ssl-cert ssl-cert-secret default myedgegateway.com
```

4. Launch ingress:

```console
kubectl apply -f kubernetes/ingress/nginx-ingress.yaml
```

5. Add `myedgegateway.com` to `/etc/hosts` using the IP address found in `kubectl get ingress edge-gateway-ingress`.

#### Traefik Ingress Controller

Not the built-in Traefik install to install with a custom configuration:

```console
./kubernetes/ingress/install.sh
```

### 3. Cert-manager

Cert Manager is a set of Kubernetes tools used to automatically deliver and manage x509 certificates against the ingress and consequently secure via SSL all the HTTP routes with almost no configuration.

1. Install the CustomResourceDefinition resources:

```console
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.0/cert-manager.crds.yaml
```

2. Install with Helm3

```console
helm repo add jetstack https://charts.jetstack.io && helm repo update
helm install cert-manager jetstack/cert-manager --namespace kube-system  --version v0.16.0
```

3. Configure the certificate issuers

The Certificate issuers are resources from which signed x509 certificates can be obtained, such as **Let’s Encrypt**:

Run the following commands (change <EMAIL> by your email):

```console
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-gateway
spec:
  acme:
    email: <EMAIL>
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-gateway
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
```

4. Launch Ingress:

```console
kubectl apply -f  kubernetes/ingress/nginx-ingress-ssl.yaml
```
### 4. Monitoring 

Intall **Prometheus-Operator** (thanks to [carlosedp/cluster-monitoring](https://github.com/carlosedp/cluster-monitoring))

Also, for K8s cluster monitoring install **Octant**:

```console
wget https://github.com/vmware-tanzu/octant/releases/download/v0.16.1/octant_0.16.1_Linux-ARM.deb
sudo dpkg -i ./octant_0.16.1_Linux-ARM.deb
nohup bash -c "OCTANT_LISTENER_ADDR=0.0.0.0:8900 octant &"
```

### 5. CDCD

WIP

### 6. Nodered

```console
kubectl apply -f kubernetes/nodered/deployment.yaml
kubectl expose deployment nodered --type=LoadBalancer --name=nodered --port 1880
```

### 7. Mosquitto

```console
kubectl apply -f kubernetes/mosquitto/deployment.yaml
kubectl expose deployment mosquitto --type=LoadBalancer --name=mosquitto --port 1883
```

### 8. MongoDB

```console
kubectl apply -f kubernetes/mongodb/persistentVolume.yaml
kubectl apply -f kubernetes/mongodb/persistentVolumeClaim.yaml
kubectl apply -f kubernetes/mongodb/deployment.yaml
kubectl expose deployment mongo --type=LoadBalancer --name=mongo-service --port 27017
```

To log in the first time:

1. `kubectl exec -it <pod-name> mongo admin`

2. Replace `[username]` and `[password]`

```console
db.createUser({ user: "[username]", pwd: "[password]", roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] })
```

3. Creating a Database and add a User with permissions:

```console
kubectl exec -it <pod-name> mongo admin
> db.auth("admin", "adminpassword")

> use yourdatabase
> db.createUser({ user: "youruser", pwd: "yourpassword", roles: [{ role: "dbOwner", db: "yourdatabase" }] })

> db.auth("youruser", "yourpassword")
> show collections
```

[Reference](https://hub.docker.com/r/andresvidal/rpi3-mongodb3/)

### 9. MinIO

```console
cd kubernetes/minio/
```

Apply all items.

### 10. Container Monitoring 

Install Portainer: (see: https://blog.hypriot.com/post/new-docker-ui-portainer/)

```console
docker run -it --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -p 9000:9000 hypriot/rpi-dockerui
```

and open port 9000 on Raspberry master node to enable containers monitoring page. 

## PHP Control Panel 

Note: for each change upload image in pannello-server\startbootstrap-shop-item-gh-pages first with:
```console
docker push rio05docker/web_server_panel:<tagname>
```

* Use:

```console
bash kubernetes/lamp/deploy.sh <circleci build number> 
bash kubernetes/minidlna/deploy.sh #NOT AVAILABLE YET
bash kubernetes/ml-keras/deploy.sh #NOT AVAILABLE YET
```
This will create the K8s resources on the cluster. You can get circleci build number in CircleCI first steps of the latest run on test branch.

* To enable cluster monitoring update pannello-server\startbootstrap-shop-item-gh-pages/hostnames.txt with all nodes hostname and
launch pannello-server\startbootstrap-shop-item-gh-pages/deploy.sh 

Use:

```console
helm install panel pannello-server/kubernetes/lamp/charts/control-panel 
```

to install with helm package manager.

## Control Panel installation with Docker

0) install docker-ce and vcgencmd on local machine

1) install MySQL with Kubernetes: (note, MySQL volume will be put on the node named "rapberrypi")

```console
mkdir /media/pi/extHD1/mysql/

./pannello-server/kubernetes/mysql/build.sh

kubectl expose deployment mysql --type=LoadBalancer --name=mysql --port 3306

kubectl exec -it <mysql-pod-name> bash

mysql -uroot -p

```

..or with Docker..

```console

mkdir $HOME/volumes

docker run --name=mysql --restart=unless-stopped -v /home/pi/volumes:/var/lib/mysql --network=host -e MYSQL_ROOT_PASSWORD=<password> -d hypriot/rpi-mysql

docker exec -it mysql mysql -uroot -p

```

in both cases..

```console
mysql > create database Login;

mysql > use Login;

mysql > CREATE TABLE login
(
ID int NOT NULL AUTO_INCREMENT,
Username varchar(255) NOT NULL,
Password varchar(255),
Email varchar(255),
PRIMARY KEY (ID)
);

mysql > INSERT INTO login (ID, Username, Password, Email) VALUES (null, '<user>', '<pass>', '<email>');
```

NOTE: MySQL container IP is hard-coded inside pannello-server\startbootstrap-shop-item-gh-pages\pannello_controllo\config.php because it is not exposed as a Kubernetes service yet (TODO).

2) launch the add_cronjob.sh script in the local machine

3) go to startbootstrap-shop-item-gh-pages/ and run:
```console
docker build -t "rio05docker/web_server_panel:latest" .
docker push rio05docker/web_server_panel:latest
```
4) run:

```console
docker run -d --restart unless-stopped --name web_server_panel -p 80:80 -p 443:443 -v /tmp:/tmp rio05docker/web_server_panel:latest
```

Use:
```console
openssl req -new -x509 -days 365 -nodes -out /etc/apache2/ssl/apache.pem -keyout /etc/apache2/ssl/apache.key
```
inside the container to create certificate and key when expired.

**TODO: disable non-https connections**

### 10. Private Key Authentication

To enable SSH login through private key:

1) generate key pair:
```console
ssh-keygen -t rsa
```

2) Install public key on server:
```console
ssh-copy-id -i ~/.ssh/id_rsa.pub pi@localhost
```

3) Copy private key on client

4) Turn off password authentication

sudo nano /etc/ssh/sshd_config
```console
PasswordAuthentication no
PubkeyAuthentication yes
```

5) Restart SSH daemon:
```console
sudo service ssh restart
```

6) Open port 22 on router

### 11. Jupyter Notebook 
```console
sudo su - \
&& apt-get update \
&& apt-get install python3-matplotlib -y \
&& apt-get install python3-scipy -y \
&& pip3 install --upgrade pip \
&& sudo pip3 install jupyter \
&& sudo apt-get clean
```

Configuration, to open jupyter notebook from outside networks:
```console
jupyter notebook --generate-config
```

Then open a notebook and generate password hash:

```python
from notebook.auth import passwd
passwd()
```

then update configuration file:

```console
c.NotebookApp.ip = '*'
c.NotebookApp.password = u'sha1:847cb8a5687d:bd62e1c30614656c1cb8dc80b6bc0ad4eb971b77'
```

To enable HTTPS:

```console
cd && mkdir jupyter_keys && cd ~/jupyter_keys/ \
&& openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout myjupyterkey.key -out myjupytercert.pem \
&& chmod 700 ~/jupyter_keys \
&& chmod 600 ~/jupyter_keys/* 
```

### 12. Minidlna Server
Using docker:

```console
        docker run --restart unless-stopped -d --name minidlna \
          --net=host \
          -p 8200:8200 \
          -p 1900:1900/udp \
          -v /media/pi/extHD/MUSICA/:/media/Music \
          -v /media/pi/extHD/FILM/:/media/Videos \
          -v /media/pi/extHD/FOTO/:/media/Pictures \
          -e MINIDLNA_MEDIA_DIR=/media \
           djdefi/rpi-minidlna
```
Based on: https://github.com/djdefi/rpi-docker-minidlna

### 13. REST API Server

It is used to control Raspberry Pi features

Installation:

```console
pip install flask flask-jsonpify flask-sqlalchemy flask-restful --user
cp scripts/restful-server/api-server.py ~/Scripts/ 
cp scripts/restful-server/minidlna-restart.sh ~/Scripts/ && chmod +x ~/Scripts/minidlna-restart.sh
cp scripts/restful-server/motion-start.sh ~/Scripts/ && chmod +x ~/Scripts/motion-start.sh      
cp scripts/restful-server/motion-stop.sh ~/Scripts/ && chmod +x ~/Scripts/motion-stop.sh
```

Then add the following cronjob:

```console
@reboot python3 /home/pi/Scripts/api-server.py
```

optional: open route on <raspberry_ip>:5002

## Control Panel local installation (without docker or K8s)

**NOTE: for the local installation must first uncomment the 33° row in index.php**

local installation: 

* move the pannello_controllo/ folder under: /var/www/html

Note:
The PHP script uses some Linux commands to retrieve temperature and memory usage of the machine.
For those who face the "VCHI Initialization failed" error 
(showed in /temp/temperatura.txt file after opening index.php from client browser) the correct way to fixis is to 
add user www-data to video group. Below is the command:

* sudo usermod -G video www-data

* restart web server. (if you are trying to display this error on a php based webpage.

Default port for "motion" web stream display is 8081

Default port for "minidlna" web UI is 8200

Dlna server used is "Minidlna" (must be instaled)

To enable the "Server Shutdown and Reboot" buttons it is necessary to use a cron job that 
shuts down or reboots the machine if it find the file writen by the PHP script (that cannot 
reboot the machine directly).

## Python Deep Learing & Machine Learning Develop Environment 

```console
docker build -t ml-development ml-development/. 


docker run -it -d --restart unless-stopped -p 8888:8888 -p 6006:6006 ml-development
```

Based on: https://github.com/floydhub/dl-docker

## Codec Conversion service installation
This service is used to change video and music file encoder so they can be played by Minidlna. 

### Installation with Kubernetes:

TODO

### Installation with Docker:

```console
docker run -it --restart=unless-stopped -d -v /media/pi/extHD/FILM/:/FILM -v /media/pi/extHD/MUSICA/:/MUSICA -v /home/pi/Downloads:/transferred_files rio05docker/inotify-video-converter:latest
```

Every file that will be put to /home/pi/Downloads will trigger the conversion scripts.

### Manual Installation: (ITA)
Il file \pannello-server\startbootstrap-shop-item-gh-pages\pannello_controllo\invia_file.php deve essere modificato per puntare alla cartella dove verranno caricati i file..
### DA NON FARE
Per fare un test..
```console
mkdir transferred_files
cd transferred_files
touch test.mp3
var_name=$(ls | sort -V | tail -n 1)
[[ $var_name =~ "mp3"$ ]] && echo "Matches!" || echo "Doesn't match!"
```
### Prerequisites

Preparazione..
Installare Inotify-Tools
Copiare in /home/pi/Downloads/ transferred_files gli script..
* file_conversion.sh
* inotify_check.sh
Quando i file verrano copiati in questa cartella lo script inotify check consentirà ad inotify-tool di controllare l’inserimento di nuovi file e lanciare lo script file_conversion per la conversione dei file video o mp3 e la copia nelle rispettive cartelle.

### SCRIPT PER LA CONVERSIONE DEI FILE MVK – file_converion.sh (metterlo nella cartella transferred_files)
N.B. RICHIEDE DI DEFINIRE PRIMA IL COMANDO update_minidlna tramite "alias"

```console
#!/bin/bash
if [[ $1 =~ "mp3"$ ]]; then
        echo “mp3 file found”
        mv "$1" /media/pi/extHD/MUSICA/
	update_minidlna
elif [[ $1 =~ "mp4"$ ]]; then
        echo “mp4 file found”
        extension=.mkv
        new_file_name=$1$extension
        ffmpeg -i $1 $new_file_name
        mv "$new_file_name" /media/pi/extHD/FILM/
	update_minidlna
elif [[ $1 =~ "mkv"$ ]]; then
        echo “mkv file found”
        extension=.mkv
        new_file_name=$1$extension
        ffmpeg -i $1 $new_file_name
        mv "$new_file_name" /media/pi/extHD/FILM/
	update_minidlna
fi 
```
### SCRIPT PER LA RILEVAZIONE DI NUOVI FILECARICATI TRAMITE INOTIFY - inotify_check.sh (metterlo nella cartella transferred_files)
```console
while inotifywait -r -e MODIFY /home/pi/Downloads/transferred_files; do /home/pi/Downloads/transferred_files/launch_script.sh; done;
```
### SCRIPT CHE RILEVA L'ULTIMO FILE MODIFICATO E LO MANDA ALLO SCRIPT PER LA CONVERSIONE - launch_script.sh (metterlo nella cartella transferred_files)
```console
bash file_conversion.sh "$(ls -1t | head -1)"
```
### COMANDO PER LANCIARE INOTIFYWAIT IN BACKGROUND (lanciarlo all'avvio mettendolo in uno script in /etc/init.sh)
```console
nohup /home/pi/Downloads/transferred_files/inotify_check.sh &
```
