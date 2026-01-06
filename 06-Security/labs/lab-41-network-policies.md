# Lab 41 – Network Policies

# Kubernetes NetworkPolicy — Never Forget Cheat Sheet

## 🧠 Core Memory Model (REMEMBER THIS FIRST)

**By default, Kubernetes networking is OPEN.**

Every Pod can:
- Talk to every other Pod
- Talk across namespaces
- Talk to the internet

👉 **NetworkPolicy = Firewall rules for Pods**

No NetworkPolicy → ❌ No isolation  
NetworkPolicy applied → ✅ Traffic is restricted

## 🧱 What a NetworkPolicy Does

A NetworkPolicy:
- SELECTS Pods (using labels)
- DEFINES allowed traffic
- DENIES everything else implicitly

👉 NetworkPolicies are **ALLOW rules**, not DENY rules.

## 🚦 Traffic Directions

- **Ingress** → Incoming traffic to Pods
- **Egress** → Outgoing traffic from Pods

If a direction is listed in `policyTypes`, that direction becomes **DENY by default**.

---

## 📜 Example: Allow DB Traffic ONLY from API Pods

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-policy
spec:
  podSelector:
    matchLabels:
      role: db        # Protect DB Pods
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: api-pod   # Only API Pods allowed
    ports:
    - protocol: TCP
      port: 3306          # MySQL port
```
## 🏷️ Allow Traffic From a Namespace (IMPORTANT – CKA FAVORITE)

NetworkPolicies can allow traffic **by namespace**, not just by Pod labels.

### 🧠 Key Rule
- `podSelector` → selects Pods
- `namespaceSelector` → selects Namespaces
- You can use **either or both**

---

### ✅ Example: Allow Ingress From a Specific Namespace

Allow traffic **to DB Pods** only from Pods running in the `frontend` namespace.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-frontend-namespace
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: frontend
```
## 🌐 Allow Traffic Using IP Blocks (External Access)

`ipBlock` is used when traffic comes from **outside the cluster** or from **unknown Pods**.

### 🧠 When to Use `ipBlock`
- External services
- On-prem servers
- Load balancers
- Legacy systems
- Monitoring tools outside Kubernetes

⚠️ `ipBlock` **does NOT work with podSelector or namespaceSelector** together.

---

### ✅ Example: Allow Ingress From a CIDR Range

Allow traffic to DB Pods **only from a specific IP range**:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-external-ips
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  ingress:
  - from:
    - ipBlock:
        cidr: 192.168.1.0/24
          name: frontend
```
In your YAML, you have this inside a single from: list:
          name: frontend
```yaml
from:
- podSelector:
    matchLabels:
      name: api-pod
- namespaceSelector:
    matchLabels:
      kubernetes.io/metadata.name: prod
- ipBlock:
    cidr: 192.168.5.10/32
 ``` 
Instead, Kubernetes interprets it as:
- Allow traffic from sources that match ALL of these at once And that is impossible, because:
- podSelector → applies to Pods
- namespaceSelector → applies to Namespaces
- ipBlock → applies to IP addresses (external)

## 🏷️ How Pods Are Selected

NetworkPolicies NEVER use Pod names.
They ONLY use labels.
```yaml
podSelector:
  matchLabels:
    role: db
```
👉 If labels don’t match → rule does NOT apply

## 🚨 Important Production Reality

NetworkPolicies ONLY work if the CNI plugin supports them.

✅ CNIs that SUPPORT NetworkPolicy
Calico
Cilium
Kube-router
Romana

❌ CNIs that DO NOT enforce NetworkPolicy
Flannel (default mode)

👉 If CNI doesn’t support it → policy is IGNORED

## 🔍 Useful Commands (Daily Use)
- kubectl get networkpolicy                 # List policies
- kubectl describe networkpolicy <name>     # Inspect rules
- kubectl get pods --show-labels            # Verify pod labels
- kubectl get nodes -o wide                 # Debug traffic paths



🧠 The Golden Rule (Works for BOTH)

Each item under to: or from: = OR
Selectors inside the same item = AND

This rule applies to:

ingress.from

egress.to

CORRECT Egress Example (Split Rules)
egress:
- to:
  - podSelector:
      matchLabels:
        role: db
  ports:
  - protocol: TCP
    port: 5432

- to:
  - namespaceSelector:
      matchLabels:
        name: prod
  ports:
  - protocol: TCP
    port: 443

- to:
  - ipBlock:
      cidr: 8.8.8.8/32
  ports:
  - protocol: UDP
    port: 53

Meaning Now

✔ Allow DB access
✔ Allow prod namespace HTTPS
✔ Allow DNS to Google