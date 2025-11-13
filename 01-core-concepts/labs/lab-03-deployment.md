## k8 documentation link: https://kubernetes.io/

## 🔵 What is a Deployment?
Deployment = self Healing + Rolling updates
- If a Pod dies → Deployment immediately creates a replacement.
- When you change your app version:v1 → v2 (Create 1 new Pod with v2, Kill 1 old Pod with v1,Repeat gently,No downtime)


Deployments are higher-level Kubernetes objects that manage application deployment in production environments


### 🟢 Key Capabilities of Deployments

- **Rolling Updates**: Upgrade instances one after another to prevent service disruption
- **Rollback Functionality**: Ability to undo recent changes if unexpected errors occur
- **Pause and Resume**: Make multiple changes to the environment and apply them together
    - Examples: upgrading web server versions, scaling, modifying resource allocations

## 🧠 Memory Hook
Deployment = A manager that ensures your Pods run exactly how you want, no matter what happens.
Deployments manage replica sets, which manage pods, forming a hierarchical structure 


## 🧩 Key Commands for Deployments

  Create a deployments from a file.
- 📋 `kubectl create -f <deployment-definition-file> `
      `kubectl apply -f deployment-definition.yml`
     ` kubectl create deployment --image=nginx nginx --replicas=3 --dry-run=client -o yaml > x.yaml`
  View all deployments in the cluster.
- 🔍 `kubectl get deployments <name>` or `k get deploy <name>` or `kubectl get all` 
  Update container image:
- 📝 `kubectl set image deployment/myapp-deployment nginx=nginx:1.9.1`  
  Status.
-  `kubectl rollout status deployment/myapp-deployment`  
  History
- ♻️ `kubectl rollout history deployment/myapp-deployment`  
  Rollback
- 📈 `kubectl rollout undo deployment/myapp-deployment`  

**File:** `deployment-definition.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment. #take note hear
metadata:
  name: myapp
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.0
  replicas: 3
  selector:
    matchLabels:
      type: front-end


## 🏷️ Deployment. Replicaset,Pods
Pod	Runs your app
ReplicaSet	Keeps the right number of Pods
Deployment	Updates, replaces, self-heals, manages ReplicaSets