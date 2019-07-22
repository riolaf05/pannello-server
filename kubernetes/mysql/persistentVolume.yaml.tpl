#A PersistentVolume (PV) is a volume plugins like Volumes, 
#but have a lifecycle independent of any individual pod that uses the PV. 

#The configuration file specifies that the volume is at /media/pi on the cluster’s Node. 

#The configuration also specifies a size of 10 gibibytes and an access mode of ReadWriteOnce, 
#which means the volume can be mounted as read-write by a single Node. 

#It defines the StorageClass name manual for the PersistentVolume, 
#which will be used to bind PersistentVolumeClaim requests to this PersistentVolume.
kind: PersistentVolume
apiVersion: v1
metadata:
  name: mysql-volume
  labels:
    type: local
spec:
  storageClassName: local-storage
  local:
    path: "{{ .EXT_HD_PATH }}"
  nodeAffinity: #PersistentVolume nodeAffinity is required when using local volumes. 
                #It enables the Kubernetes scheduler to correctly schedule Pods using local volumes to the correct node.
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - {{ .NODE }}
