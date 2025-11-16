## k8 documentation link: https://kubernetes.io/

## 🔵 What is a ReplicaSet?
ReplicaSet
   ↓ manages or ensures that multiple instances of pods are running at all times 
3 Pods (if 1 dies, RS makes a new one)

A ReplicaSet is the **auto-pod-counter** of Kubernetes.
It ensures that the exact number of Pods you want are always running.(high availability)

## 🟢 Why it exists

✔ Keeps a fixed number of Pods alive
✔ Recreates Pods if they crash (self-healing)
✔ Enables load balancing across multiple pods
✔ Can span across multiple nodes in a cluster
✔ Deletes extra Pods if more than needed
✔ Only focuses on **HOW MANY Pods exist**, not on updates

## 🧠 Memory Hook

**ReplicaSet = Bodyguard Manager**  
If one bodyguard (Pod) disappears, it immediately hires a new one.

## 🟣 When to use ReplicaSets

You rarely use them directly.
Deployments manage ReplicaSets for rolling updates.

## 🟣 Notes
Key difference: ReplicaSets require a selector definition
ReplicaSets use API version "apps/v1"

## 🧩 Key Commands for ReplicaSets

- 🚀 `kubectl create -f filename.yaml`  
  Create a ReplicaSet from a YAML file.
- 📋 `kubectl get replicaset` or  `k get rs`
  View all ReplicaSets in the cluster.
- 🔍 `kubectl describe replicaset <name>`  
  View detailed information about a specific ReplicaSet.
- 📝 `kubectl edit replicaset <name>`  
  Open and modify a ReplicaSet directly in your editor.
- ❌ `kubectl delete replicaset <name>`  
  Delete a specific ReplicaSet.
- ♻️ `kubectl replace -f filename.yaml`  
  Update an existing ReplicaSet using the updated YAML.
- 📈 `kubectl scale rs/<name> --replicas=<number>`  
  Scale a ReplicaSet from the command line **without modifying the YAML file**.

### 🧩 Kubernetes ReplicaSet Example

**File:** `replicaset-definition.yaml`

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp-replicaset
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
          image: nginx
  replicas: 3
  selector:
    matchLabels:
      type: front-end

## 🏷️ Labels and Selectors

- Labels help ReplicaSets identify which Pods they should monitor.  
- Selectors(using `matchLabels`) filter and match Pods with specific labels.  
- This labeling + selector system is used across all Kubernetes objects for organization and targeting.  
- The template section is required even when managing existing Pods, because the ReplicaSet must know how to create new Pods in the future if needed.