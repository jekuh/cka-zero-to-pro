# Lab 38 – Service Accounts
## 🔵 What is a ServiceAccount?

A **ServiceAccount** is the identity used by **Pods** to authenticate to the Kubernetes API.

- Humans authenticate using **kubeconfig  + user certs**
- Pods authenticate using **ServiceAccounts + tokens**
- it is mounted as a projected volume within a pod

---

## 🧠 Core Memory Model

Humans → kubeconfig  
Pods → ServiceAccount  
Permissions → RBAC (Roles / ClusterRoles)

ServiceAccount answers:
> “Who is this Pod?”

RBAC answers:
> “What is it allowed to do?”

---

## 🟢 Default Behavior

Every namespace has a default ServiceAccount:
**Useful commands**
`kubectl get sa`
`kubectl create serviceaccount app-sa`
`kubectl api-resources`
`kubectl set serviceaccount deploy/web-dashboard dashboard-sa`
`kubectl create token my-sa --duration=24h`

## 🟢 Create a ServiceAccount
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
```

🟢 Use ServiceAccount in a Pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo
spec:
  serviceAccountName: app-sa
  containers:
  - name: app
    image: nginx

```
## 🔐 How Authentication Works
- Kubernetes generates a token for the ServiceAccount
- Token is mounted into the Pod at:**/var/run/secrets/kubernetes.io/serviceaccount/token**

- The Pod uses this token to call the API server.

## 🧱 ServiceAccount + RBAC (Critical)
- ServiceAccounts have no permissions by default.
- You must bind permissions using RBAC.

**Example RoleBinding:**

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-read
subjects:
- kind: ServiceAccount
  name: app-sa
roleRef:
  kind: Role
  name: read-pods
  apiGroup: rbac.authorization.k8s.io
```
**Test-Permissions**

  `kubectl auth can-i get pods --as system:serviceaccount:default:app-sa`

Most apps:
- Do NOT need Kubernetes API access
- Should NOT have credentials

But by default:
- Token is mounted
- Pod can call the API
- If compromised → attacker can query the cluster

---

## 🚫 automountServiceAccountToken: false

### What it means:
```yaml
automountServiceAccountToken: false
## 🧠 Memory Hook
No token = No API access

apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  automountServiceAccountToken: false
  containers:
  - name: nginx
    image: nginx
