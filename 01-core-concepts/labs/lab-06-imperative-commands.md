# Lab 06 – Imperative Commands

`kubectl run --help`

Create an NGINX Pod
`kubectl run nginx --image=nginx`

Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)
`kubectl run nginx --image=nginx --dry-run=client -o yaml`
`kubectl run httpd --image=httpd:alpine --port=80 --expose=true` #creates a pod and service

Create a deployment
`kubectl create deployment --image=nginx nginx`

Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)
`kubectl create deployment --image=nginx nginx --dry-run=client -o yaml`
`kubectl create deployment --image=nginx nginx --replicas=3 --labels="app=hazelcast,env=prod" --dry-run=client -o yaml > nginx-deployment.yaml`

Make necessary changes to the file (for example, adding more replicas) and then create the deployment.

`kubectl create -f nginx-deployment.yaml`
`kubectl exec -it curl -n dev -- sh`

Create Service
`kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml`
`k expose deploy web --port=80 -n dev` # this will automatically use the pods labels as selectors
`kubectl expose deployment nginx --port=80`

**Update Objects**
- `kubectl apply -f nginx.yaml` - update from yaml
- `kubectl edit deployment nginx` -edit deployment
- `kubectl scale deployment nginx --replicas=5 `-scale a deployment
- `kubectl set image deployment nginx nginx=nginx:1.18` - update deployment image

**Kubectl explain resources commands examples**
`K api-resouces`
`k explain pods`
`k explain pods.spec`
`k explain pods --recursive`
