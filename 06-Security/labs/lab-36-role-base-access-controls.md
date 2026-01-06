# Lab 36 – Role Base Access Controls
“RBAC in Kubernetes controls access by binding subjects (users, groups, service accounts) to roles that define allowed actions on resources within a namespace or across the cluster.”
---

## 🔐 What is RBAC? (Never Forget This)

RBAC controls **WHO can do WHAT on WHICH resources** in Kubernetes.

Think of it as:
- WHO → User / ServiceAccount
- WHAT → Verbs (get, list, create, delete…)
- WHICH → Resources (pods, deployments, services…)
- WHERE → Namespace or cluster-wide
## 🧠 RBAC Core Building Blocks

### 1️⃣ Role / ClusterRole (Permissions)
Defines **WHAT actions are allowed**.

- Role → Namespace-scoped
- ClusterRole → Cluster-wide

### 2️⃣ RoleBinding / ClusterRoleBinding (Assignment)
Binds permissions to **users, groups, or service accounts**.

## 🧩 RBAC Mental Model (1 Line)

> **Role = rules  
> Binding = who gets the rules**

No binding = no access.
## 🟢 Role (Namespace-scoped permissions)

- To inspect the environment and identify the authorization modes configured on the cluster, the most inmportant place to check id the kube-apiserver. it is configured only the kube-api server via flags

`ls /etc/kubernetes/manifests/`
`cat /etc/kubernetes/manifests/kube-apiserver.yaml `
`k get roles --all-namespaces --no-headers | wc -l`
`kubectl get rolebinding kube-proxy -n kube-system -o yaml` or `kubectl describe rolebinding kube-proxy -n kube-system`

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: dev
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]

##imperative command
 kubectl create role developer --verb=list --verb=create --verb=delete --resource=pods -n dev
 kubectl create role developer --verb=list,create,delete --resource=pods -n dev
```
## 🟢 RoleBinding (Assign Role to a user)
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods-binding
  namespace: dev
subjects:
- kind: User
  name: dev-user
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io

##imperative command
kubectl create rolebinding read-pods --role=pod-reader --user=dev-user  -n dev

```

## 🧰 Most Useful Imperative Commands
- kubectl get roles -n dev                      # List roles in namespace
- kubectl get rolebindings -n dev               # List role bindings

## 🔍 Check Permissions (VERY IMPORTANT)
`kubectl auth can-i create deployments --as dev-user -n dev` # can a user do something
`kubectl auth can-i get pods  --as system:serviceaccount:dev:my-sa -n dev` # check service accounts

## 🧠 RBAC Rules That Never Change
- Kubernetes is deny by default
- No RoleBinding → no access
- Roles do nothing unless bound
- Namespaces matter
- ClusterRole can be used with:
- RoleBinding (namespace-limited)
- ClusterRoleBinding (cluster-wide)

