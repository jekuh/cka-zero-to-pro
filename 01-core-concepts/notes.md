Labs : Pods Deployment ReplicaSet Services Namespace

01 Pod

kubectl run nginx --image=nginx
kubectl run nginx --image=nginx --dry-run=client -o yaml


02 Deployment

kubectl create deployment --image=nginx nginx
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml



03 ReplicaSet
kubectl create deployment nginx --image=nginx --replicas=4


04 Service
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml




Reference:
https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands

https://kubernetes.io/docs/reference/kubectl/conventions/

