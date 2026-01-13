# Lab 44 – Storage Classes
## 🧠 Start With the Big Picture (MEMORIZE THIS)

There are **two ways storage is created in Kubernetes**:

1️⃣ **Static Provisioning** → Admin creates PV manually  
2️⃣ **Dynamic Provisioning** → Kubernetes creates PV automatically  

👉 **StorageClass enables Dynamic Provisioning**

---

## 🧱 Static Provisioning (OLD WAY)

### How It Works
- Admin manually creates a PersistentVolume (PV)
- User creates a PersistentVolumeClaim (PVC)
- Kubernetes tries to match PVC → PV

### Problems
❌ Manual  
❌ Not scalable  
❌ Hard in cloud environments  
❌ Admin bottleneck  

👉 Used mostly for **on-prem / legacy / NFS**

---

## ⚡ Dynamic Provisioning (MODERN WAY)

### How It Works
- Admin creates a **StorageClass**
- User creates a PVC
- Kubernetes automatically creates a PV

### Flow (IMPORTANT)
StorageClass → defines HOW storage is created
PVC → asks for storage
PV → created automatically
Pod → mounts PVC

🔗 PVC Using a StorageClass (MOST IMPORTANT)
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  storageClassName: fast
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi

👉 Kubernetes does ALL of this automatically:
```
- Reads StorageClass fast
- Calls the storage driver
- Creates a PV
- Binds PVC → PV

💥 No manual PV needed

## 🚦 Default StorageClass (CKA FAVORITE)

- If PVC does NOT specify storageClassName:
- Kubernetes uses the default StorageClass
- Only ONE StorageClass can be default
Check:
`kubectl get storageclass`
Look for:
`(storageclass.kubernetes.io/is-default-class=true)`


## 📈 Volume Expansion (REAL WORLD)

- If enabled in StorageClass:
- allowVolumeExpansion: true
- You can resize PVC:
`kubectl edit pvc myclaim`

- Kubernetes expands the volume automatically (if backend supports it).