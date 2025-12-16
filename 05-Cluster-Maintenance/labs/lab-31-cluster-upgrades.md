# Kubernetes Cluster Upgrades  
A complete, clear, exam-ready and production-ready guide.

## 🔵 What is a Cluster Upgrade?
A **cluster upgrade** updates the Kubernetes **control plane** and **worker nodes** to a newer Kubernetes version.
It upgrades:
- kube-apiserver  
- kube-controller-manager  
- kube-scheduler  
- etcd  
- kubelet  
- kubeadm  
- kubectl  
- cluster add-ons (CNI, CSI, metrics-server)

### 🧠 Memory Hook  
Cluster upgrade = **Upgrade Kubernetes itself (not the OS).**

OS upgrade = Upgrade Linux.  
Cluster upgrade = Upgrade Kubernetes.

# 🟡 Why Do We Upgrade a Cluster?

- New Kubernetes features  
- Security patches  
- Deprecated APIs removed  
- Bug fixes  
- Stability improvements  
- Cloud provider requirements  
- Kubernetes version reaching **End-of-Life**  
  (K8s supports only 3 minor versions at a time)

# 🏛️ Components Upgraded in a Cluster Upgrade

## Control Plane Components:
- kube-apiserver  
- controller manager  
- scheduler  
- etcd  
- admission webhooks  

## Node Components:
- kubelet  
- kube-proxy  

## Add-on Components:
- CNI (Calico, Cilium, Weave)  
- CSI drivers  
- Metrics server  
- Ingress controllers  

# 🟢 Cluster Upgrade Order  
This **NEVER changes**:

1️⃣ **Upgrade control plane first**  
2️⃣ **Upgrade worker nodes**  
3️⃣ **Upgrade add-ons (CNI, CSI, metrics)**

### 🧠 Memory Hook  
**Control Plane → Workers → Add-ons**

# 🛠️ Full Cluster Upgrade Workflow (kubeadm)

## 1️⃣ Upgrade kubeadm on the control-plane node
```bash
vim /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /

**or**

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

apt update
apt-cache madison kubeadm
apt-get install -y kubeadm=1.34.0-1.1
```
## 2️⃣ See upgrade plan
`kubeadm upgrade plan`
`kubeadm upgrade plan v1.34.0`

Shows:Target version, Upgrade path

## 3️⃣ Apply upgrade to the control plane
`kubeadm upgrade apply v1.34.0`
`kubeadm version`
Upgrades:API server, Scheduler, Controller manager, etcd

## 4 Apply upgrade the kubelet version
`apt-get install kubelet=1.34.0-1.1`
`systemctl daemon-reload`
`systemctl restart kubelet`
`k get nodes` here you will see the version

## 🟩 Worker Node Upgrade Workflow
**Step A — Cordon the node**
`kubectl cordon <node>` Stop scheduling new Pods.
**Step B — Drain the node**
`kubectl drain <node> --ignore-daemonsets --delete-emptydir-data`
**Step C — Upgrade kubeadm on the worker**
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

apt update
apt-cache madison kubeadm
`apt-get install -y kubeadm=1.34.0-11`
`kubeadm upgrade node`

**Step D — Upgrade kubelet + kubectl**
`apt-get install -y kubelet=1.29.0-00`
`systemctl daemon-reload`
`systemctl restart kubelet`

**Step E — Uncordon the node**
`kubectl uncordon <node>`

## 🟦 Kubelet Upgrade Example
`kubectl get nodes`
Shows:
nginx
master   v1.11.3
node-1   v1.11.3
node-2   v1.11.3
Upgrade kubelet:

`apt-get install -y kubelet=1.12.0-00`
`systemctl restart kubelet`

kubectl get nodes
Shows:
nginx

master   v1.12.0
node-1   v1.11.3
node-2   v1.11.3
## 🧰 Useful Commands Summary
🔍 Check Kubernetes versions
`kubectl get nodes`
`kubectl version --short`
📦 Check available versions for kubeadm/kubelet
apt-cache madison kubeadm
apt-cache madison kubelet
📤 Upgrade kubeadm

`apt-get install -y kubeadm=<version>`
📤 Upgrade kubelet + kubectl

`apt-get install -y kubelet=<version> kubectl=<version>`
`systemctl restart kubelet`
💡 Plan control plane upgrade

`kubeadm upgrade plan`
🚀 Apply control plane upgrade

`kubeadm upgrade apply v1.X.X`
🧹 Node maintenance commands

`kubectl cordon <node>`
`kubectl drain <node> --ignore-daemonsets --delete-emptydir-data`
`kubectl uncordon <node>`

🧪 Upgrade worker node runtime
kubeadm upgrade node

## 🧠 Final Memory Hooks
- Cluster Upgrade = Upgrade Kubernetes:
- Upgrades API server, etcd, scheduler
- check documentation for this process

vim /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /
apt update

apt-cache madison kubeadm
apt-get install kubeadm=1.34.0-1.1