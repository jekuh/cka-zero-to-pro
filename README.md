# 🚀 CKA Learning Journey — Jude & Derrick

This repository documents our preparation for the **Certified Kubernetes Administrator (CKA)** exam.

We follow this learning strategy:

> **Learn → Practice → Teach → Document**

---

## 📁 Structure

| Folder | Focus |
|--------|--------|
| `01-cluster-architecture` | Control plane, scheduler, etcd, worker nodes |
| `02-workloads-and-scheduling` | Deployments, ReplicaSets, Jobs, autoscaling |
| `03-services-and-networking` | ClusterIP, NodePort, LoadBalancer, Ingress |
| `04-storage` | PV, PVC, StorageClasses |
| `05-security` | RBAC, TLS, Network Policies |
| `cheatsheets/` | kubectl shortcuts & YAML templates |
| `scripts/` | automation scripts (minikube, kubeadm) |

---

## 🧠 Workflow (3x per week)

| Day | Activity |
|-----|----------|
| Monday | Learn & hands-on labs |
| Wednesday | Review + explain to each other |
| Saturday | Mock exam (90 mins, time boxed) |

---

## ✅ Rules
- Every concept must be **documented**
- Every topic must include **hands-on labs**
- Every useful command goes to `cheatsheets/kubectl-shortcuts.md`
- Keep everything **short, command-focused, exam-ready**

---

## 🔥 Goal
Be fully ready to take the CKA exam by January and build muscle memory with Kubernetes.



📁 cka-zero-to-pro
│
├── README.md
│
├── 01-cluster-architecture/
│   ├── notes.md
│   └── labs/
│       ├── lab-01-create-deployment.md
│       └── lab-02-upgrade-cluster.md
│
├── 02-workloads-and-scheduling/
│   ├── notes.md
│   └── labs/
│
├── 03-services-and-networking/
│   ├── notes.md
│   └── labs/
│
├── 04-storage/
│   ├── notes.md
│   └── labs/
│
├── 05-security/
│   ├── notes.md
│   └── labs/
│
├── cheatsheets/
│   ├── kubectl-shortcuts.md
│   ├── common-yaml-templates.md
│   └── troubleshooting.md
│
└── scripts/
    ├── minikube-setup.sh
    ├── kubeadm-multipass.sh
    └── cleanup.sh


