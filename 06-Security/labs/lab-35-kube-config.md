# Lab 35 – Kube-Config
# Kubernetes kubeconfig — The One-Page Guide You’ll Never Forget

---

## 🔵 What is kubeconfig?
**kubeconfig** is a configuration file that tells `kubectl`:
- WHICH cluster to talk to
- WHO you are (user identity)
- HOW to authenticate (certs / token)
- WHICH namespace to use by default

👉 kubeconfig = **“ID card + address book + rules”** for Kubernetes access.

- Default location: ~/.kube/config
## 🧠 Memory Hook (Tattoo This)

> **kubectl without kubeconfig is like SSH without a key.**

No kubeconfig → no access → no cluster interaction.

---

## 🧩 What kubeconfig Contains (3 Things Only)

1️⃣ **Clusters** → *Where is the API server?*  
2️⃣ **Users** → *Who are you? (cert / token)*  
3️⃣ **Contexts** → *Which user + which cluster + which namespace*

Context = glue that binds everything.

- Kubeconfig location: By default, Kubernetes CLI tools like kubectl look for your kubeconfig file in the **.kube directory** inside your home directory.
- Without kubeconfig you will nmnaually pass credentials everytime. kubeconfig does it for you
```yaml
kubectl get pods
        |
        |-- reads kubeconfig
              |
              |-- current-context
                     |
                     |-- cluster
                     |-- user
```
## 📄 kubeconfig YAML Example

```yaml
apiVersion: v1
kind: Config

clusters:
- name: prod-cluster
  cluster:
    server: https://10.0.0.1:6443
    certificate-authority: /etc/kubernetes/pki/ca.crt

users:
- name: admin-user
  user:
    client-certificate: /etc/kubernetes/pki/admin.crt
    client-key: /etc/kubernetes/pki/admin.key

contexts:
- name: admin@prod
  context:
    cluster: prod-cluster
    user: admin-user
    namespace: default

current-context: admin@prod

```

**🔐 How Authentication Works (Important)**

kubeconfig does NOT authenticate by itself.It points to credentials, usually:
- Client certificates (most common)
- Bearer tokens (ServiceAccounts)
- Exec plugins (cloud IAM: EKS, GKE, AKS)

**Common in production:**
✔ TLS client certificates
✔ Cloud IAM tokens

**🔑 Relationship with Certificates & CSR API**
- kubeconfig references client certificates
- Certificates are created via:
    - OpenSSL (manual)
    - Kubernetes Certificates API (CSR)

**Flow (simple):**
- User generates key + CSR
- CSR submitted to Kubernetes
- Admin approves CSR
- Signed cert returned
- Cert added to kubeconfig

👉 kubeconfig = consumer of certificates, not issuer.

**🔄 Certificate Rotation (High Level)**
- kubelet certificates rotate automatically
- user/admin certs usually rotated manually
- cloud providers automate this

kubeconfig must be updated if certs change.
**🧰 Useful kubeconfig Commands**
- kubectl config view                 # show full kubeconfig (merged)
- kubectl config view --minify        # show only current context
- kubectl config current-context      # show active context
- kubectl config get-contexts         # list all contexts
- kubectl config use-context dev      # switch to another context
- kubectl config get-clusters         # list known clusters
- kubectl config get-users            # list users
- kubectl config set-context --current --namespace=prod  # set default namespace

- k config use-context research --kubeconfig /root/my-kube-config

**🧠 kubeconfig vs Certificates API (Quick Difference)**
| kubeconfig             | Certificates API     |
| ---------------------- | -------------------- |
| Client-side file       | Server-side API      |
| Used by kubectl        | Used by cluster      |
| Stores cert references | Issues & signs certs |
| Access mechanism       | Identity mechanism   |


👉 Certificates API creates identity
👉 kubeconfig uses identity


Add the my-kube-config file to the KUBECONFIG environment variable or as default kube config
- mv /root/my-kube-config **/root/.kube/config**

