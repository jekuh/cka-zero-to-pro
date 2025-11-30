# Lab 23 – Secrets
## 1. 🔐 What Is a Kubernetes Secret?
A **Secret** is a Kubernetes object used to store **sensitive configuration** such as passwords, API keys, tokens, and certificates.

## 🧠 Memory Hook:  
**If it’s private → put it in a Secret.  
If it's not private → ConfigMap.**

## 2. 🟦 Why We Use Secrets
- Storing sensitive values directly in pod YAML is dangerous:
```yaml
env:
  - name: DB_PASSWORD
    value: secret123
```
## Why?
- Stored in Git forever
- Visible to anyone reading manifests
- May appear in logs
- Not encrypted by default
- Secrets solve this by providing a secure, centralized store.

## 3. 🔐 What Secrets Store
- Secrets commonly hold:
- Database passwords
- API keys
- Authentication tokens
- SSH key
- Certificates
- Private keys
- Docker registry credentials
- Any sensitive key–value pair

## 🧠 Memory Hook:
Anything you wouldn’t post on WhatsApp = put in a Secret.

## 4. 🔒 How Kubernetes Protects Secrets
Secrets are protected through:
**✔ Base64 Encoding**
- Values are stored encoded (not plain text) in YAML.
**✔ RBAC Authorization**
- Only users with permission can view/edit Secrets.
**✔ Hidden in Logs**
- They do not appear in kubectl logs or most describe outputs.
**✔ Optionally Encrypted at Rest**
- etcd can encrypt Secrets (recommended for production).
**✔ Avoids Storing Plain Text in Manifests**
- Sensitive values stay out of Deployment YAML.

## 🧠 Memory Hook for types of secrets
Opaque = simple secrets
TLS = certificates
docker-registry = image pull creds

## 5. 🛠️ Creating Secrets
## 5.1 Create Secret from literals

`kubectl create secret generic db-secret \`
  `--from-literal=DB_USER=admin \`
  `--from-literal=DB_PASSWORD=Pass123`
## 5.2 Create Secret from files
`kubectl create secret generic app-secret \`
  `--from-file=secret.txt`
Multiple files:
`kubectl create secret generic certs-secret \`
  `--from-file=server.crt \`
  `--from-file=server.key`

## 5.3 Declarative YAML
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  DB_USER: YWRtaW4=
  DB_PASSWORD: UGFzczEyMw==
Values must be base64 encoded.
```
Encoding:
`echo -n "admin" | base64`

## 5.4 View Secrets
`kubectl get secrets`
`kubectl describe secret db-secret`
Decode a key:
`echo "YWRtaW4=" | base64 --decode`
## 6. 🧩 Using Secrets in Pods
There are three ways to consume Secrets.

## 6.1 Use ONE key as an environment variable
```yaml
env:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: DB_PASSWORD
```
## 🧠 Memory Hook:
secretKeyRef = ONE key

## 6.2 Load ALL keys from a Secret
```yaml
envFrom:
  - secretRef:
      name: db-secret
```


## 7.3 Mount Secret as a file (volume)
```yaml
volumeMounts:
  - name: secret-vol
    mountPath: /etc/db-secret

volumes:
  - name: secret-vol
    secret:
      secretName: db-secret
Result inside the container:
/etc/db-secret/DB_USER
/etc/db-secret/DB_PASSWORD
```

## 8. 🛡️ Best Practices for Kubernetes Secrets
✔ Use Secrets for all sensitive values
✔ Enable Encryption at Rest in etcd
✔ Restrict access using RBAC
✔ Avoid storing Secrets in Git
✔ Rotate Secrets regularly
✔ Prefer mounting for certificates
✔ Use external secret managers for production: HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, GCP Secret Manager

## 🧠 Memory Hook:
ConfigMap = open book
Secret = locker with a key

## ⭐ Final Summary
- Kubernetes Secrets store sensitive data (passwords, API keys, tokens).
- Use secretKeyRef to map one value, secretRef/envFrom to map all.
- Base64 encoding is required for YAML.
- Secrets can be mounted as files or injected as environment variables.
- Must secure etcd with encryption at rest.
- Production systems often use external secret managers.


