# By Rosario Laface
#deploy the PHP and Apache container from rio05docker/web_server_panel

apiVersion: extensions/v1beta1
# https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
kind: Deployment
metadata:
  name: web-server-panel
  labels:
    rio/iotplatform: lamp
# number of PHP pods (replicas) to run
# increase this number if you need to scale PHP horizontally
# since we have 2, the LoadBalancer will serve our app from all 2
spec:
  replicas: 2
  # The number of old deployments you want to keep around
  revisionHistoryLimit: 5
  # make replicas of kubernetes objects with the label app: web_server_panel
  selector:
    matchLabels:
      app: web-server-panel
  # the pod template describes what type of pod to create
  # when the defined number of replicas are not up
  # in this case, the pod that will be created is the one labeled app: web_server_panel
  template:
    metadata:
      # this label is referenced by the selector for the Deployment, which creates pods
      # and by the selector for the Service, which creates the LoadBalancer
      labels:
        app: web-server-panel
    # details of what container(s) will actually be run in this pod
    spec:
      # deploys PHP and Apache and our custom application from the specified Docker Hub image
      containers:
      # deploys this custom PHP image from Docker Hub
      # https://hub.docker.com/r/rio05docker/web_server_panel/
      - image: rio05docker/web_server_panel:rpi3_test_{{ .CIRCLE_BUILD_NUM }}
        # download a fresh copy of the image if available, even if it has the same version label
        imagePullPolicy: Always
        name: web-server-panel
        #reserving resources from our cluster
        resources:
            limits:
                memory: "1Gi"
                cpu: "1"
            requests:
                cpu: "100m"
                memory: "30Mi"
        # env sets environment variables in the container
        # exactly like environment variables set from the command line
        env:
          # The PHP image will configure an environment variable with the value of MYSQL_USER...
          - name: MYSQL_USER
            valueFrom:
              # rather than embed sensitive details in this config
              # we reference another Kubernetes object
              # in this case, the Secret with the name: mysql-credentials
              secretKeyRef:
                name: mysql-credentials
                # references the user key-value pair from the mysql-credentials Secret
                key: user
          # ... and a password of the value of MYSQL_PASSWORD ...
          - name: MYSQL_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mysql-credentials
                key: password
          # ... and the MYSQL_HOST mysql.default.svc.cluster.local
          # which comes from the Service with the name mysql in the mysql.yaml file
          - name: MYSQL_HOST
            value: mysql.default.svc.cluster.local
        # https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
        livenessProbe:
          tcpSocket:
            port: 80
        # make our mysql pod available within the cluster on port 80
        ports:
        - containerPort: 80
        #The volumeMounts tag is used to mount a container to a volume in a specific port
        volumeMounts:
        - mountPath: /tmp
          name: panel-storage
      restartPolicy: Always
      volumes:
      - name: panel-storage
        persistentVolumeClaim:
          claimName: panel-pv-claim
---
# expose PHP and Apache on port 80 to the world through a load balancer

apiVersion: v1
# https://kubernetes.io/docs/concepts/services-networking/service/
kind: Service
metadata:
  # the name web here means you can reference the PHP pods
  # using the host web.default.svc.cluster.local from within the cluster
  name: panel
  labels:
    "rio/iotplatform": lamp
spec:
  ports:
  # make the service available on this port
  - name: http
    protocol: TCP
    port: 80
  - name: https
    protocol: TCP
    port: 443
  selector:
    # apply this service to the pod with the label app: mysql
    app: web-server-panel
  # a LoadBalancer makes this service available over the public internet
  # all of our PHP/Apache pods are load balanced behind a single public network address

  # this works because we have cloudprovider=aws set on the cluster
  # this actually provisions AWS Elastic Load Balancing https://aws.amazon.com/elasticloadbalancing/
  # try running "kubectl get service web -o wide" after you create the Service
  # You'll get a lengthy DNS name which you can use with a DNS CNAME entry with your own domain
  # like http://xxxxxxxxxxxxxxx.us-east-2.elb.amazonaws.com/
  # this is where the PHP app will be publicly viewable

  # https://kubernetes.io/docs/getting-started-guides/scratch/#cloud-providers
  # https://kubernetes.io/docs/concepts/services-networking/service/#type-loadbalancer
  type: NodePort 
