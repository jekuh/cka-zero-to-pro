# Lab 34 – Certificates API
# Kubernetes Certificates & CSR (Certificate Signing Request)  
Kubernetes uses **TLS certificates** to secure:
- Users → API Server
- Nodes → API Server
- Control plane → control plane

👉 **CSR is how certificates are REQUESTED and APPROVED in Kubernetes.**

## 🧠 Core Memory Model

Think of Kubernetes like a **secure office building**:

- **Certificate** = ID badge  
- **CSR** = Application form for an ID badge  
- **CA** = Security office  
- **Certificates API** = Front desk  
- **Approval** = Security approval  
- **Rotation** = Renewing an expiring badge  

## 🔵 What is a CSR in Kubernetes?

A **Certificate Signing Request (CSR)** is a request sent to Kubernetes asking:

> “Please sign my public key so I can authenticate.”
Kubernetes stores CSRs as **API objects**.
## 🔵 What is the Certificates API?

The **Certificates API** is the Kubernetes API group that:
- Accepts CSR objects
- Allows admins to approve or deny them
- Issues signed certificates via the cluster CA

API group:

👉 **Yes — the Certificates API is explained here.**

---

## 🔵 Where CSRs Are Used (Real World)

### 1️⃣ New Node Joining a Cluster
- kubelet generates a CSR
- Admin approves it
- Node gets a client certificate
- Node can talk to API server

### 2️⃣ User Access (kubectl users)
- User generates key + CSR
- Admin approves CSR
- User gets cert for kubectl access

### 3️⃣ Certificate Rotation
- kubelet auto-creates new CSR
- Old cert is replaced
- No downtime

---

## 🟢 How CSR Flow Works (Step-by-Step)

1️⃣ Generate private key  
2️⃣ Create CSR file  
3️⃣ Submit CSR to Kubernetes  
4️⃣ Admin reviews CSR  
5️⃣ Approve or deny CSR  
6️⃣ Kubernetes signs cert  
7️⃣ Cert is used for authentication  

---

## 🛠️ Hands-On CSR Example (User or Node)

### Step 1️⃣ Generate a private key
openssl genrsa -out user.key 2048
### Step 2️⃣ Create a CSR
openssl req -new -key user.key -out user.csr -subj "/CN=john/O=dev-team"
### Step 3️⃣ Create Kubernetes CSR YAML
```yaml
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: john-csr
spec:
  request: <BASE64_ENCODED_CSR>
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
```

Encode CSR:  `cat user.csr | base64 | -w 0`

### Step 4️⃣ Submit CSR to Kubernetes
- `kubectl apply -f csr.yaml`
- `kubectl get csr`
- `kubectl get csr <agent-smith> -o yaml`
- `kubectl certificate approve john-csr`
- `kubectl certificate deny john-csr`
- `kubectl delete csr john-csr`
After approal getting the signed cetificate
- `kubectl get csr john-csr -o jsonpath='{.status.certificate}' | base64 --decode > user.crt`


**View certificate contents**
- `openssl x509 -in user.crt -text -noout`
Shows:Subject (CN, O), Issuer (CA), Validity dates, Key usage, SANs