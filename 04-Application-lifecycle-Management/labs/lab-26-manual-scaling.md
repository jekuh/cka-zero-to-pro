# Lab 26 – Manual Scaling

`kubectl scale deployment <deployment-name> --replicas=<number>`
``kubectl scale rs <replicaset-name> --replicas=<number>`
kubectl scale statefulset <statefulset-name> --replicas=<number>`

##verify the scaling
`kubectl get deployment <deployment-name>`
`kubectl get rs <replicaset-name>`
`kubectl get statefulset <statefulset-name>`
