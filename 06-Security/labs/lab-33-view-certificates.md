# Lab 33 – View Certificates
This file explains **Kubernetes security from zero → certificates → verification**
## 🧠 THE BIG PICTURE (Memorize This)

Kubernetes security is built on **4 layers**:

1. **Authentication** — Who are you?
2. **Authorization** — What can you do?
3. **Admission Control** — Should this request be allowed?
4. **Encryption (TLS)** — Is communication secure?

If you understand **TLS certificates**, everything else clicks.
## 🔐 CORE SECURITY PRIMITIVES

### 1️⃣ Authentication (WHO are you?)
Kubernetes supports:
- TLS certificates (most common)
- ServiceAccounts (Pods)
- Tokens
- LDAP / OIDC (external identity)

👉 Kubernetes **does NOT manage users**
It only **verifies identity**.
### 2️⃣ Authorization (WHAT can you do?)

Handled by:
- **RBAC** (Role-Based Access Control)
RBAC answers:
- Which user?
- Which resource?
- Which verb? (get, list, create, delete)
### 3️⃣ Admission Controllers (SHOULD it be allowed?)

Examples:
- NodeRestriction
- PodSecurity
- ResourceQuota

They act **after auth**, **before persistence in etcd**.
### 4️⃣ Encryption (TLS — HOW is it protected?)

ALL Kubernetes communication is secured using:
> **TLS certificates**

## 🔐 TLS & CERTIFICATES — THE FOUNDATION
### 🧠 Mental Model (Never Forget)

- **CA (Certificate Authority)** = Trusted Boss
- **Certificate** = ID Card
- **Private Key** = Proof you own the ID

If you lose the **private key**, identity is lost.
## 🏛️ CERTIFICATE AUTHORITY (CA)

The CA signs all cluster certificates.
Files:
- `ca.key` → private key (VERY SECRET)
- `ca.crt` → public certificate (shared)

Created using:
```bash
openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
```
👤 CLIENT CERTIFICATES (Users & Components)
Examples:
kube-admin
kube-scheduler
kube-controller-manager
kube-proxy
kubelet (client)

Key idea:
CN = username
O / OU = group

Example (admin user):
/CN=kube-admin/O=system:masters
👉 system:masters = cluster admin group

**🖥️ SERVER CERTIFICATES (Services)**
Used by:
kube-apiserver
etcd
kubelet (server)

They identify services, not users.

**🔗 WHO TALKS TO WHOM (IMPORTANT)**
Component	           Acts As	          Uses Certificate
kubectl → API Server	Client	          admin.crt
API Server → etcd	    Client	          apiserver-etcd-client.crt
API Server → kubelet	Client	          apiserver-kubelet-client.crt
kubelet → API Server	Client	          kubelet-client.crt
etcd	                Server	          etcdserver.crt

**📁 WHERE CERTS LIVE (kubeadm clusters)**
/etc/kubernetes/pki/
├── ca.crt
├── ca.key
├── apiserver.crt
├── apiserver.key
├── apiserver-etcd-client.crt
├── apiserver-kubelet-client.crt
├── etcd/
│   ├── ca.crt
│   ├── server.crt
│   ├── server.key
│   ├── peer.crt
│   └── peer.key

**🔍 HOW TO CHECK CERTIFICATE DETAILS (VERY IMPORTANT)**
View certificate content:
- anything to do with the kubernetes api server are under the pki directory
`openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout`
Look for:
- Subject (CN) → who this cert belongs to
- Issuer → who signed it (CA)
- Validity → expiry date
- SANs → DNS/IPs the cert is valid for

**🔎 CHECK WHAT CERTS COMPONENTS USE**
**- kube-apiserver:**
`cat /etc/kubernetes/manifests/kube-apiserver.yaml`  | grep "\-\-etcd"
Look for:
--tls-cert-file
--tls-private-key-file
--client-ca-file
--etcd-certfile
--etcd-keyfile

**- etcd:**
- anything to with the etcd server, try to check under the etcd directory
`cat /etc/kubernetes/manifests/etcd.yaml`
Look for:
--cert-file
--key-file
--trusted-ca-file
--peer-cert-file
--peer-key-file

🚨 COMMON TLS ERROR (VERY IMPORTANT)
Error:
tls: bad certificate
Means:
- Wrong CA
- Expired certificate
- CN / SAN mismatch
- Wrong cert used for client vs server

🔄 CERTIFICATE ROTATION (kubeadm)
- Check expiry:
`kubeadm certs check-expiration`
- Renew:
`kubeadm certs renew all`

Restart control plane:
`systemctl restart kubelet`

**🧠 FINAL MEMORY HOOK (LOCK THIS IN)**
CA signs trust
CN = identity
OU = group
Private key = proof
TLS secures everything
RBAC decides permissions

If TLS breaks → cluster breaks.
