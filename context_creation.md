## K8s user and context creation

1. create private key for TSL connection and certificate

```console
openssl genrsa -out external_usr.key 2048 #Create a private key for user external_usr.
openssl req -new -key external_usr.key -out external_usr.csr -subj "/CN=external_usr/O=external_grp" #Create a certificate sign request .csr specifing user and group
openssl x509 -req -in external_usr.csr -CA CA_LOCATION/ca.crt -CAkey CA_LOCATION/ca.key -CAcreateserial -out external_usr.crt -days 500 #Generate the final certificate
```

2. Save both external_usr.crt and external_usr.key in a safe location (i. e. /home/external_usr/.certs/)

3. Add new user:

```console
kubectl config set-credentials external_usr --client-certificate=/home/external_usr/.certs/external_usr.crt  --client-key=/home/external_usr/.certs/external_usr.key
kubectl config set-context external_usr-context --cluster=default --namespace=default --user=external_usr
```

4. deploy `Role` and `RoleBinding` for new user:

```console
kubectl applf -f kubernetes/role.yaml
kubectl applf -f kubernetes/rolebinding.yaml
```

### Connect from external console

1. Set cluster

```console
kubectl config  set-cluster cluster_name --server=https://<cluster_IP> --certificate-authority=fake-ca-fil
```

2. Copy `external_usr.crt` and `external_usr.key` and set user

```console
kubectl config  set-credentials developer --client-certificate=external_usr.crt --client-key=external_usr.key
```

3. Add context

```console
kubectl config set-context gateway_context --cluster=default --namespace=default --user=external_usr
```

4. Set context (or use [K9S](https://www.google.com/search?q=k9s&rlz=1C1GCEU_itIT832IT832&oq=k9s&aqs=chrome..69i57j46j69i59j0j46j69i60l3.1617j0j7&sourceid=chrome&ie=UTF-8))

```console
kubectl config  use-context gateway_context
```