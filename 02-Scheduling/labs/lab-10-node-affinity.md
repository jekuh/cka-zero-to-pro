# Lab 10 – Node Affinity

# Kubernetes Node Affinity 🧲

## 1. What Is Node Affinity?

Node Affinity lets a **Pod choose which Nodes it can run on**, based on **Node labels**.

- Works on **node labels** (e.g. `size=Large`)
- More powerful than `nodeSelector`
- Can be **hard** (must match) or **soft** (prefer to match)

🧠 Memory hook:  
**NodeSelector = simple rule**  
**Node Affinity = advanced matching + preferences**

🎯  EASY-TO-UNDERSTAND ANALOGY
Imagine pods as people choosing hotels (nodes):
**nodeSelector** - “I will only stay in a hotel that has a gym.”
**Node Affinity (hard)** - “I MUST stay in a hotel with a gym AND free breakfast.”
**Node Affinity (soft)** - “I prefer a hotel with a gym, but I’ll accept others if none exist.”


## 2. Types of Node Affinity

### 🔹 Hard rule – `requiredDuringSchedulingIgnoredDuringExecution`
Pod **must** run on a matching node or it stays Pending.

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: size
          operator: In
          values: ["Large"]
```
### 🔹 Soft rule – `preferredDuringSchedulingIgnoredDuringExecution
Pod **prefers** to run on a matching node but can run elsewhere if needed.

```yaml
affinity:
  nodeAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 1
      preference:
        matchExpressions:
        - key: size
          operator: In
          values: ["Large"]
```
- Operators You Can Use
- Inside matchExpressions:
- In – value must be in list
- NotIn – value must not be in list
- Exists – label key must exist (any value)
- DoesNotExist – label key must not exist
- Gt – numeric label value is greater than X
- Lt – numeric label value is less than X


**Useful Commands**
# Add / change node label
`kubectl label nodes <node-name> size=Large`
# Remove label
`kubectl label nodes <node-name> size-`

# See node labels
`kubectl get nodes --show-labels`

# Apply Pod manifest
`kubectl apply -f pod-affinity.yaml`

# Check where pod is running
`kubectl get pods -o wide`


# Taints & Tolerations vs Node Affinity — Summary

## 🟥 Taints & Tolerations = Node REJECTS Pods
- **Taint (Node):** “Keep out unless allowed.”
- **Toleration (Pod):** “I am allowed to enter.”

**Purpose:**  
👉 Block or repel unwanted Pods from certain Nodes.

**Behavior:**  
- Pods **without** toleration → ❌ cannot run on the node  
- Pods **with** toleration → ✔ allowed (but not forced)  
- Used to **protect** nodes (GPU nodes, prod nodes, system nodes)

---

## 🟦 Node Affinity = Pod CHOOSES Nodes
- Pod expresses preferences or requirements for Nodes with certain **labels**.

**Purpose:**  
👉 Attract pods to specific Nodes.

**Behavior:**  
- **Hard rule:** Pod *must* run on matching node  
- **Soft rule:** Pod *prefers* but can run elsewhere  
- Used for **intelligent placement** (SSD nodes, big-memory nodes, GPU nodes)

---

## ⭐ Core Difference (1 Line)
### **Taints push pods AWAY from nodes.  
Node Affinity pulls pods TOWARD nodes.**

---

## 🧠 Mnemonic
- **Taints = Repulsion**  
- **Tolerations = Permission**  
- **Affinity = Attraction**

---

## 🟩 Quick Comparison Table

| Feature | Taints & Tolerations | Node Affinity |
|--------|----------------------|---------------|
| Who controls it? | Node | Pod |
| Purpose | Repel/block pods | Attract/place pods |
| Effect | Restricts scheduling | Prefers/enforces placement |
| Blocks pods? | ✔ Yes | ❌ No |
| Forces placement? | ❌ No | ✔ Yes (hard rule) |

