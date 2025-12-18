# Lab 24 – Multi Container Pods
# Multicontainer Pod Design Patterns in Kubernetes  
A highly memorable guide with metaphors, YAML templates, and imperative commands.

# 🚂 Pods & Containers: The Root Metaphor

**A Pod is a train. Containers are carriages.**  
They share:
- the same **network** (one IP)
- the same **storage** (volumes)
- the same **lifecycle** (scheduled and restarted together)

Every container inside the Pod is a passenger with a role.

# 🎭 The Three Multicontainer Pod Design Patterns 

1. **Init Containers** — The Bodyguards  
2. **Sidecar Containers** — The Assistants  
3. **Co-located Containers** — The Roommates  

These are the official roles Kubernetes expects inside Pods.

---

# 1️⃣ Init Containers — *The Bodyguards Enter First*

## 🧠 Memory Hook  
Before a celebrity enters a room, **bodyguards enter first**, prepare the environment,  
and only then allow the star (main container) to appear.

This is exactly what Init Containers do.

## 🔑 Key traits
- Run **before** main containers  
- Run **sequentially** (one must finish before the next starts)  
- Must **succeed** for the Pod to continue  
- Perfect for **setup**, **checks**, **initialization**

## 💡 Common Use Cases
- Waiting for a database or API to be ready  
- Fetching configuration files  
- Running database migrations  
- Setting permissions  
- Preparing cache / data  

## 🧠 Sticky Definition  
> **Init containers prepare the world so the main container can live in it.**

## USEFUL COMMANDS

- `kubectl apply -f file.yaml`
- `kubectl describe pod podname`
- `kubectl logs podname -c containername`
- `kubectl exec -it podname -c containername -- sh`. 
- `kubectl -n elastic-stack exec -it app -- cat /log/app.log`
- `kubectl get pods -o jsonpath='{.spec.containers[*].name}'`

## 🔧 Init Container — YAML Template

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: init-demo
spec:
  initContainers:
  - name: init-check-db
    image: busybox
    command: ['sh', '-c', 'until nc -z mydb 5432; do echo waiting; sleep 2; done']

  containers:
  - name: main-app
    image: myapp:latest

# INIT PATTERN

spec:
  initContainers:      # 👈 runs first, exits
  - init-a
  - init-b
  containers:
  - main-app

# SIDECAR PATTERN
spec:
  containers:          # 👈 main + helper run together
  - main-app
  - helper-sidecar

# CO-LOCATED CONTAINERS
spec:
  containers:          # 👈 multiple peers, no helper logic
  - app-a
  - app-b
