# Lab 13 – Static Pods

# Kubernetes Static Pods

## 1. What Are Static Pods?

A **Static Pod** is a Pod that is **created and managed directly by the kubelet**, not by the Kubernetes API server.

🧠 **Memory Hook:**  
**Static Pods = “Kubelet’s personal pods.”**  
They exist even if the API server is down.
---
## 2. How Static Pods Work

- The kubelet continuously watches a directory on each node:

**/etc/kubernetes/manifests**
- Any `.yaml` file placed there is automatically run as a Pod.
- If the Pod is deleted from Kubernetes:
→ The kubelet immediately recreates it.
- If the file is updated:
→ The Pod is automatically updated.

## 3. Why Static Pods Exist

Static Pods are used when Pods must run **even if the control plane is not running**.
Common examples:
- `kube-apiserver`
- `kube-controller-manager`
- `kube-scheduler`
- `etcd`
➡ **The entire Kubernetes control plane runs as Static Pods.**

## 4. Mirror Pods

Even though Static Pods are created by the kubelet, they **appear** in:

```bash
kubectl get pods -A
```
## 5. How to Identify a Static Pod

- Static Pods have:Names ending with the node’s hostname
- Example:kube-apiserver-minikube

No Deployment / DaemonSet managing them
Immediately recreate if deleted
