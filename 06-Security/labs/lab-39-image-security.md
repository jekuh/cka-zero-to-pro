# Lab 39 – Image Security
## 🧠 Core Idea (Never Forget This)

**Pods run images.  
Images come from registries.  
Registries must be trusted and controlled.**

Image security in Kubernetes =  
✔ Who can PULL images  
✔ From WHERE images are pulled  
✔ WHAT images are allowed  

---

## 1️⃣ Public Registry (Default – Development Only)

Example:
```yaml
image: nginx:latest

✔ Easy to use
✔ No authentication needed

Problems
❌ Anyone can pull the image
❌ No access control
❌ Risk of tampered images
❌ Not suitable for production
```
**Mental Hook**
Public registry = public street food
Easy, but risky.

## How Kubernetes Authenticates to Private Registries
Kubernetes uses Secrets of type docker-registry.

- Step 1: Login (Docker side)
docker login private-registry.io

(This proves credentials work)

- Step 2: Create Image Pull Secret in Kubernetes

https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/

`kubectl create secret --help`
 --docker-registry
 -- secret generic

```yaml
kubectl create secret docker-registry regcred \
  --docker-server=private-registry.io \
  --docker-username=registry-user \
  --docker-password=registry-password \
  --docker-email=registry-user@org.com
```
**What this does:**
✔ Stores registry credentials securely
✔ Encoded as a Kubernetes Secret

##  Using imagePullSecrets in Pod Spec
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: private-registry.io/apps/internal-app
  imagePullSecrets:
  - name: regcred

```
  ## imagePullSecrets via ServiceAccount (Best Practice)
Instead of adding secrets to every Pod:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
imagePullSecrets:
- name: regcred

Then in Pod:

spec:
  serviceAccountName: app-sa
```
- it makes it:
✔ Cleaner
✔ Centralized
✔ Production-ready

## Image Security Controls (Production)
🔒 Tag Control
❌ latest (unsafe)
✔ Use versioned tags:
image: myapp:1.3.2

## 🧪 Useful Commands Summary
`kubectl create secret docker-registry`   # Store registry credentials
`kubectl get secrets `                   # Verify secret exists
`kubectl describe pod <pod> `            # Debug image pull errors
`kubectl get sa  `                       # Check ServiceAccounts

## 🚨 Common Image Pull Errors
**Error	Meaning**
- ImagePullBackOff	Auth failed or image not found
- ErrImagePull	Registry unreachable
- 403 Forbidden	Bad credentials
- manifest unknown	Wrong image/tag