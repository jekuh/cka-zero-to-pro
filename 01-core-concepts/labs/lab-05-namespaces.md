# Lab 05 – Namespaces
## 🔵 What are Namespaces?
- They allow Kubernetes to separate environments, avoid naming conflicts, and apply different rules to different groups of resources.
- Each namespace has its own policies, quotas, and access rules
- Namespaces help avoid accidental deletion or modification across environments

## 🧠 Memory Hook
- Namespaces = Different households with their own rules, resources, and people.
- Same first name inside the same house = conflict
- Same first name in different houses = OK

## 🟢 Why Namespaces Exist (Key Capabilities)

**Avoid name conflicts**
**Environment isolation** dev / test / prod separation → no accidents between them
**Security (RBAC per namespace)** Different teams access ONLY their own namespace
**Resource quotas** Limit CPU, RAM so one team doesn’t eat the whole cluster
**Organizational clarity** Each project or team keeps resources isolated and clean

## 🧩 How Communication Works
**Same Namespace** → Short Name dbservice
**Different Namespace** → Full DNS Name
`dbservice.dev.svc.cluster.local` 

## 🧩 Key Commands for Namespaces
 
Create Namespace `kubectl create namespace dev`
List Namespaces `kubectl get namespaces` `k get ns --no-headers | wc -l`
List Pods in a Namespace `kubectl get pods -n dev`
List Pods Across All Namespaces `kubectl get pods --all-namespaces`
Switch Current Namespace `kubectl config set-context --current --namespace=dev`
Apply Resource Quotas `kubectl apply -f quota.yaml -n dev`
Delete a Namespace `kubectl delete namespace dev`

File: dev-namespace.yaml
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev


kubectl apply -f dev-namespace.yaml

🔥 Advanced namespace tasks (RBAC, quotas, network policies)