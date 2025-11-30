# Lab 12 – Daemon Sets

An easy way to create a DaemonSet is to start by generating a Deployment YAML using:

kubectl create deployment elasticsearch
--image=registry.k8s.io/fluentd-elasticsearch:1.20
-n kube-system --dry-run=client -o yaml > fluentd.yaml

# Kubernetes DaemonSets

## 1. What Is a DaemonSet?

A **DaemonSet** ensures that **one copy of a specific Pod runs on every node** in the cluster (or on selected nodes).

🧠 **Memory Hook:**  
**DaemonSet = “One Pod on every soldier in the army.”**  
- Nodes = soldiers  
- Pod = agent  
- DaemonSet = commander

If a new node joins → it gets the Pod.  
If a node leaves → the Pod is removed.

---

## 2. Why DaemonSets Exist

DaemonSets run **node-level services**, tools that MUST run on every node:

- Logging agents (Fluentd, Filebeat, Logstash)
- Monitoring agents (Node Exporter, Datadog)
- Security agents (Falco, Sysdig)
- Networking plugins (Calico, Cilium, AWS CNI)
- Storage drivers (local-volume provisioners)

➡ **If your software must run on all nodes → use a DaemonSet.**


**Useful Commands**

`kubectl get daemonsets -A` # List all DaemonSets
`kubectl describe daemonset <name> -n <namespace> `# Detailed info
`kubectl get pods -n <namespace> -o wide` # See pods created by DaemonSet

---

## 3. DaemonSet Behavior

- Creates **1 Pod per node**
- Automatically adds Pods to **new nodes**
- Automatically removes Pods from **deleted nodes**
- Deleting the DaemonSet removes **all Pods** across all nodes

---

## 4. DaemonSet vs Deployment

| Feature | DaemonSet | Deployment |
|--------|-----------|------------|
| Pod count | One per node | Any number |
| Purpose | Node-level services | Application workloads |
| Autoscaling | No (depends on node count) | Yes |
| Scheduling | On all or selected nodes | Anywhere |

🧠 **Memory Hook:**  
**Deployment = run many pods**  
**DaemonSet = run pods everywhere**

---

## 5. Basic DaemonSet Example

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: log-agent
spec:
  selector:
    matchLabels:
      app: log-agent
  template:
    metadata:
      labels:
        app: log-agent
    spec:
      containers:
      - name: log-agent
        image: fluent/fluentd

```