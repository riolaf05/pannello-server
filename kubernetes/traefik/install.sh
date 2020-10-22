#see: https://unixorn.github.io/post/k3s-on-arm/
for traefik_yaml in traefik-rbac.yaml traefik-configmap.yaml traefik-deployment.yaml traefik-service.yaml
do
  kubectl apply -f $traefik_yaml
done