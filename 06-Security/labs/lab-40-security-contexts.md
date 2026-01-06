# Lab 40 – Security Contexts
A single, complete, production-focused guide to **SecurityContext** in Kubernetes.

## 🧠 One Mental Model
**Containers are jailed processes.  
SecurityContext builds the jail.**
If you remember only this, you already understand SecurityContext.

## 🔒 What is SecurityContext?

**SecurityContext** defines **how a container runs at the OS level**.

It controls:
- Who the process runs as (user)
- What it can write to
- What kernel powers it has
- Whether it can run as root

👉 It is your **last line of defense** if a container is compromised.
```yaml
securityContext:
  runAsNonRoot: true

👤 Force a Specific User ID
securityContext:
  runAsUser: 1000
```

✔ Forces a non-root UID
✔ Predictable file permissions
✔ Avoids UID 0 (root)

## Best practice: application images should support a non-root UID.

📁 Read-Only Root Filesystem
```yaml
securityContext:
  readOnlyRootFilesystem: true
```
✔ Prevents writing to container filesystem
✔ Stops malware persistence
✔ Blocks runtime tampering

Writable paths must use volumes (e.g. /tmp, /data).

🔐 Drop Linux Capabilities
```yaml
securityContext:
  capabilities:
    drop: ["ALL"]
```

✔ Removes unnecessary kernel powers
✔ Minimizes privilege escalation risk
✔ Strong production default

Linux capabilities are root powers split into pieces — drop what you don’t need.

## 🧱 Example: Secure Pod (All Together)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-app
spec:
  containers:
  - name: app
    image: myapp:v1.2.3
    securityContext:
      runAsNonRoot: true
      runAsUser: 1000
      readOnlyRootFilesystem: true
      capabilities:
        drop: ["ALL"]
```

This is a production-grade baseline.
🚨 What Happens Without SecurityContext?

❌ Containers run as root
❌ Malware can write to disk
❌ Privilege escalation possible
❌ Host risk increases
❌ Compliance failures (PCI, SOC2, ISO)

✅ What Happens With SecurityContext?

✔ App is sandboxed
✔ Damage is contained
✔ Minimal blast radius
✔ Strong compliance posture
✔ Safer multi-tenant clusters

## 🔎 Useful Inspection Commands
- kubectl describe pod <pod-name>      # See applied securityContext
- kubectl get pod <pod> -o yaml        # Full security configuration
- kubectl auth can-i create pods       # Check permissions

## 🚫 Common Production Mistakes

❌ Running containers as root
❌ Writable root filesystem
❌ Excess Linux capabilities
❌ Assuming image security is enough

Image security + SecurityContext = real defense

✅ Production Checklist (Memorize)

✔ runAsNonRoot
✔ runAsUser != 0
✔ readOnlyRootFilesystem
✔ Drop ALL capabilities
✔ Minimal image
✔ No secrets in image

🧠 Final Memory Hook

**“Containers should run like guests, not owners.”**
- Docker builds the container
- Kubernetes runs it
- SecurityContext controls its power
