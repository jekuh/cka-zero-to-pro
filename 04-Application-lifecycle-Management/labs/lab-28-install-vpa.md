# Lab 28 – Install VPA
# Vertical Pod Autoscaler (VPA) in Kubernetes  
A complete guide to installation, usage, components, and key concepts.

---

# 📌 What Is VPA?

The **Vertical Pod Autoscaler (VPA)** automatically adjusts the **CPU and memory requests/limits** of Pods based on real usage.

Unlike HPA (Horizontal Pod Autoscaler), which adds/removes Pods,  
**VPA adjusts how much CPU/memory each Pod gets.**

---

# ⚠️ Important: VPA Is **NOT** Built Into Kubernetes

VPA does **not** ship with Kubernetes clusters.  
You must **install it manually** from the Kubernetes Autoscaler project.

This applies to:
- Minikube
- kubeadm clusters
- GKE
- EKS
- AKS
- Kind
- K3s

It is **NOT enabled by default** on any platform.

---

# 🌟 Why Use VPA?

Use VPA when:

- Workloads frequently OOM (out-of-memory)
- Workloads underuse CPU/memory and you want efficiency
- You want Kubernetes to automatically pick resource values
- You want to avoid manual tuning of `requests` and `limits`

---

# 🧠 How VPA Works

VPA has three main components:

| Component | Role |
|----------|------|
| **Recommender** | Watches Pod usage and suggests new CPU/memory |
| **Updater** | Decides if a Pod needs to be restarted to apply new resources |
| **Admission Controller** | Mutates Pod spec with recommended values |

Traditional VPA **restarts Pods** to apply changes.  
(It does *not* resize a running Pod.)

---

# 🛠 Installing VPA (Official Method)

## 1️⃣ Clone the autoscaler repo
```bash
git clone https://github.com/kubernetes/autoscaler.git

