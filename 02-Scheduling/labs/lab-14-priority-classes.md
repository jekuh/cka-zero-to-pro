# Lab 14 – Priority Classes

## 1. What Are Priority Classes?

A **PriorityClass** defines how **important** a Pod is compared to other Pods.

🧠 **Memory Hook:**  
**PriorityClass = “VIP level for Pods.”**  
Higher priority =  
- Gets scheduled first  
- Is evicted last when the node is under pressure

---

## 2. Why Priority Classes Exist

When the cluster is full or a node is overloaded:

- Kubernetes must decide **which Pods to keep**  
- High-priority Pods should survive  
- Low-priority Pods can be sacrificed

Use PriorityClasses for:
- Ingress controllers
- Core business services
- Monitoring, logging, security agents
- Databases / stateful critical apps

---



## 3. PriorityClass Example

```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 100000          # higher number = more important
globalDefault: false
description: "High priority for important workloads"

## then use in  a pod 
apiVersion: v1
kind: Pod
metadata:
  name: important-app
spec:
  priorityClassName: high-priority
  containers:
  - name: app
    image: nginx
```

### Useful Commands
`kubectl apply -f high-priority.yaml`
`k get priorityclasses  or k get pc`
`kubectl create priorityclass high-priority --value=1000 --description="high priority"`
`kubectl get pods -o custom-columns="NAME:.metadata.name,PRIORITY:.spec.priorityClassName"`

## Preemption & preemptionPolicy

- Preemption = Kubernetes removes (evicts) lower-priority Pods to make room for a higher-priority Pod.
- By default, preemption is enabled for high-priority Pods.
**preemptionPolicy (Pod spec)**
You can control this behavior:
**PreemptLowerPriority (default)**
→ Pod is allowed to evict lower-priority Pods if needed.

**Never**
→ Pod will not preempt (evict) others.
→ If there is no space, it just stays Pending