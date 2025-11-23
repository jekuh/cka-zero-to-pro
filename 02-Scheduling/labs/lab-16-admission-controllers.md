# Lab 16 – Admission Controllers

## 1. What Are Admission Controllers?

Admission Controllers are **built-in plugins** or **filters inside the API Server** that can:
- Modify requests
- Validate requests
- Approve or deny object creation
Examples:  
- `NodeRestriction`  
- `NamespaceAutoProvision`  
- `PodSecurity`  
- `LimitRanger`  
- `DefaultStorageClass`  
- `ResourceQuota`

## 🟦 How to Enable / Disable Admission Plugins

- You must edit the **kube-apiserver** startup configuration.
- Depending on the environment (kubeadm, manual cluster, static pod), this will be either:

### 1️⃣ `/etc/kubernetes/manifests/kube-apiserver.yaml`  
(Static Pod — most common in kubeadm)
OR
### 2️⃣ `/etc/systemd/system/kube-apiserver.service`  
(Systemd service — custom/manual clusters)

## 🟩 Example: Enable Specific Admission Plugins

To enable:
- `NodeRestriction`
- `NamespaceAutoProvision`
Add the flag:
```bash
--enable-admission-plugins=NodeRestriction,NamespaceAutoProvision ##( these are deprecated and replaces with NamespaceLifecycle)

to disable plugins
-disable-admission-plugins=DefaultStorageClass

##Full static pod example
apiVersion: v1
kind: Pod
metadata:
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - name: kube-apiserver
    image: k8s.gcr.io/kube-apiserver-amd64:v1.11.3
    command:
    - kube-apiserver
    - --authorization-mode=Node,RBAC
    - --advertise-address=172.17.0.107
    - --allow-privileged=true
    - --enable-bootstrap-token-auth=true
    - --enable-admission-plugins=NodeRestriction,NamespaceAutoProvision
    - --disable-admission-plugins=DefaultStorageClass
```
🧠 **Memory Hook:**  
**Admission Controllers = Airport Security Checkpoints.**  
Nothing enters the cluster until it passes inspection.

Kubernetes checks your request **after authentication + authorization** but before saving anything to etcd.

## 2. Why Admission Controllers Exist

They enforce:
- Security rules (deny privileged containers)
- Resource policies (limits, quotas)
- Best practices (require labels, annotations)
- Mutations (add init containers, sidecars)
- Automation (inject secrets, apply defaults)

Examples where they are used:
- Istio sidecar injection
- OPA Gatekeeper / Kyverno policies
- PodSecurity Standards (Baseline / Restricted)

## useful commands
`kube -apiserver -h | grep anable-admission-plugins` #view enabled admission controllers
`ps -ef | grep kube-apiserver | grep admission-plugins` # check process to see disabled and enabled plugins

`grep enable-admission-plugins /etc/kubernetes/manifests/kube-apiserver.yaml` 

## 3. Two Types of Admission Controllers

### 🔹 1. Mutating Admission Controllers
They **modify** the request before it is stored.

🧠 Memory:  
**Mutating = “Fix or adjust your baggage before boarding.”**

Examples:
- `MutatingAdmissionWebhook`
- Istio sidecar injector
- Add default storage class
- Add tolerations / security settings automatically