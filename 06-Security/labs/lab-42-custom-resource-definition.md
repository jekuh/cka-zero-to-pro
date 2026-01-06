# Lab 42 – Custom Resource Definition

# Custom Resource Definitions (CRDs) — Never Forget Guide

A complete, simple, production-oriented explanation of CRDs in Kubernetes.

---

## 🧠 One-Sentence Truth (Memorize This)

**A CRD lets you teach Kubernetes a new resource type.**

If you understand this, you understand CRDs.

---

## 🧩 The Core Mental Model

Think of Kubernetes as a **dictionary + engine**.

- Built-in words: Pod, Service, Deployment
- **CRD**: you add a new word
- **Custom Resource (CR)**: you use that word
- **Controller / Operator**: makes the word do something

👉 Without a controller, Kubernetes only stores the data.  
👉 With a controller, Kubernetes takes action.

---

## 📘 Real-World Analogy (Never Forget)

Kubernetes = smartphone OS  
- Built-in apps = native resources  
- **CRD** = installing a new app type  
- **CR** = opening the app  
- **Controller** = the app logic  

CRD defines **what exists**  
Controller defines **what happens**

---

## 🔹 What is a CRD?

A **CustomResourceDefinition (CRD)**:
- Extends the Kubernetes API
- Defines a new resource type
- Is stored in etcd
- Is accessible via `kubectl`

After a CRD is installed, this works like magic:
```bash
kubectl get <custom-resource>
```

## Useful commands
- kubectl get crd
- kubectl describe crd <name>
- kubectl get <custom-resource>
- kubectl api-resources