# Lab 37 – Cluster Roles

# Kubernetes ClusterRoles & ClusterRoleBindings  
**Role = WHAT you can do  
Binding = WHO can do it  
ClusterRole = WHAT you can do across the ENTIRE cluster**

## 🧠 Mental Model (1-Minute Diagram)

Think of Kubernetes like a country:

- **Namespace** = City
- **Role** = City law
- **ClusterRole** = National law
- **RoleBinding** = Person → City law
- **ClusterRoleBinding** = Person → National law

👉 If something applies to **all namespaces**, it MUST be a **ClusterRole**.
## 🔵 What is a ClusterRole?

A **ClusterRole** defines **permissions that apply cluster-wide**, not limited to a namespace.

ClusterRoles are used for:
- Nodes
- PersistentVolumes
- Namespaces
- StorageClasses
- CRDs
- Metrics
- Cluster-level access

### Examples:
- View nodes
- Manage storage
- Read metrics
- Admin access across all namespaces

## 🔵 What is a ClusterRoleBinding?

A **ClusterRoleBinding** attaches a **ClusterRole** to:
- A **user**
- A **group**
- A **service account**

👉 It grants cluster-wide permissions.

## 🚫 Role vs ClusterRole (Critical Difference)

| Feature | Role | ClusterRole |
|------|------|------------|
| Scope | Single namespace | Entire cluster |
| Access nodes | ❌ No | ✅ Yes |
| Access PVs | ❌ No | ✅ Yes |
| Access namespaces | ❌ No | ✅ Yes |
| Bind cluster-wide | ❌ No | ✅ Yes |

---

## 🧠 Golden Rule

> **If the resource is NOT namespaced → you MUST use a ClusterRole**

Non-namespaced resources:
- nodes
- persistentvolumes
- namespaces
- storageclasses
- clusterroles
- clusterrolebindings
- customresourcedefinitions

## 📄 Example: ClusterRole

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: node-reader
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list", "watch"]
```
  # Create a cluster role named "foo" with API Group specified
  kubectl create clusterrole foo --verb=get,list,watch --resource=rs.apps

## 📄 Example: ClusterRole Binding
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: node-reader-binding
subjects:
- kind: User
  name: dev-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: node-reader
  apiGroup: rbac.authorization.k8s.io
```

or imperative way
`k create clusterrolebinding cluster-admin --clusterrole=cluster-admin --user=user--group=group1`

## 🔍 How to Know if a Resource is Namespaced or Not?
- To  see a full list of  namespaced and non namespaced resources, run the 
`kubectl api-resources  --namespaced=true`# for namespaced resources
`kubectl api-resources` check all details, short names and versions of resources

## 🔑 Important Detail: apiGroups Explained
**Why sometimes apiGroups: [""]?**
"" → core API group
- pods,services,nodes,configmaps,secrets
**Other API groups:**
- apps → deployments, replicasets
- batch → jobs, cronjobs
- rbac.authorization.k8s.io → roles, bindings
## Example
apiGroups: [""]
resources: ["pods"]

apiGroups: ["apps"]
resources: ["deployments"]

apiGroups: ["storage.k8s.io"]
resources: ["storageclasses"]

## 🧪 Useful Commands (With Meaning)
- kubectl get clusterroles                         # List cluster roles
- kubectl get clusterrolebindings                  # List bindings
- kubectl describe clusterrole admin               # Inspect permissions
- kubectl auth can-i get nodes --as dev-user        # Check authorization
- kubectl auth can-i create pods -n dev             # Check namespace access
