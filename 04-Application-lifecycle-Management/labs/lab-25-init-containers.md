# Lab 25 – Init Containers

# Init Containers in Kubernetes  
A complete, memorable guide to understanding and using init containers.

---

# 🚀 What Are Init Containers?

Init containers are **special containers that run before the main application containers** in a Pod.  
They run **sequentially**, **must succeed**, and **prepare the environment** for your main app.

Think of them as:

> **Bodyguards who enter the room before the celebrity (your app) to ensure everything is safe and ready.**

---

# 🧠 Key Characteristics

### ✔ Run Before Main Containers  
They start first, and all *must* complete before the Pod’s main containers launch.

### ✔ Sequential Execution  
If you have multiple init containers:
- Init #1 runs and completes  
- Then init #2 runs  
- And so on...

### ✔ Must Exit Successfully  
If an init container fails:
- Kubernetes retries it  
- The Pod does **not** move forward  
- Main containers **never start** until all init containers succeed

### ✔ Cannot Be Restarted Independently  
Only the **Pod restart policy** applies as a whole.

---

# 🎯 Why Use Init Containers?

Init containers are perfect for:

### 🔹 1. Environment Setup  
- Setting permissions  
- Creating directories  
- Copying config files into shared volumes  

### 🔹 2. Dependency Checks  
- Wait for a database  
- Wait for an API  
- Perform DNS checks  
- Network warm-up  

### 🔹 3. Preloading Data  
- Download assets  
- Pull configuration from Git or S3  
- Generate files before app starts  

### 🔹 4. Running One-Time Scripts  
- Database migration  
- Schema validation  
- Pre-flight tests  

## Useful Commands
 `k logs orange -c init-myservice` # View logs from a specific init container:
 `kubectl logs mypod --all-containers=true` # Get logs from all init containers:


# 🧩 YAML Template: Minimal Example

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: init-demo
spec:
  restartPolicy: Always

  initContainers:
  - name: init-job
    image: busybox
    command: ['sh', '-c', 'echo "Init container running"; sleep 5']

  containers:
  - name: app
    image: nginx
    ports:
    - containerPort: 80


