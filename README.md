# rompr-docker




## Kubernetes

The purpose of that container is to run on a local k8s cluster. For persistence I use glusterfs - so I use this to mount the prefs and albumart folder. 
I use traefik as ingress controller.


templates/service.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: rompr
spec:
  selector:
    name: rompr
  ports:
  - name: http
    port: 80
    targetPort: 80
```

templates/ingress.yaml
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: rompr
  annotations:
    kubernetes.io/ingress.class: traefik
spec:
  tls:
  - hosts:
    - music.localdomain
  rules:
    - host: music.localdomain
      http:
        paths:
        - backend:
            serviceName: rompr
            servicePort: 80
```

templates/deployment.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rompr
  labels:
    name: rompr
spec:
  replicas: 1
  selector:
    matchLabels:
      name: rompr
  template:
    metadata:
      labels:
        name: rompr
    spec:
      nodeSelector:
        beta.kubernetes.io/arch: amd64
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule     
      volumes:
        - name: gluster-rompr
          persistentVolumeClaim:
            claimName: gluster-rompr
      containers:
      - name: rompr
        image: sebd/rompr:latest
        volumeMounts:
        - name: gluster-rompr
          mountPath: "/var/www/html/prefs"
          subPath: "prefs"
        - name: gluster-rompr
          mountPath: "/var/www/html/albumart"
          subPath: "albumart"
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
```