## K8s user and context creation

1. create private key for TSL connection and certificate

```console
openssl genrsa -out external_usr.key 2048 #Create a private key for user external_usr.
openssl req -new -key external_usr.key -out external_usr.csr -subj "/CN=external_usr/O=external_grp" #Create a certificate sign request .csr specifing user and group
openssl x509 -req -in external_usr.csr -CA CA_LOCATION/ca.crt -CAkey CA_LOCATION/ca.key -CAcreateserial -out external_usr.crt -days 500 #Generate the final certificate
```

2. Save both employee.crt and employee.key in a safe location (i. e. /home/external_usr/.certs/)

3. Add new user

kubectl config set-credentials external_usr --client-certificate=/home/external_usr/.certs/external_usr.crt  --client-key=/home/external_usr/.certs/external_usr.key
kubectl config set-context external_usr-context --cluster=default --namespace=default --user=external_usr

kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  namespace: default
  name: external-usr
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"] # You can also use ["*"]


kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: external-usr-binding
  namespace: office
subjects:
- kind: User
  name: external_usr
  apiGroup: ""
roleRef:
  kind: Role
  name: external-usr
  apiGroup: ""


```bash
kubectl --context=employee-context run --image bitnami/dokuwiki mydokuwiki
kubectl --context=employee-context get pods
```

