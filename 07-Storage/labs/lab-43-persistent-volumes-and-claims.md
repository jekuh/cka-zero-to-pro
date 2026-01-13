# Lab 43 – Persistent Volumes and Claims

`kubectl exec webapp -- cat /log/app.log`

# Kubernetes PV / PVC — 1-Page “Never Forget” Cheat Sheet

## 🖼️ What your images are saying (quick summary)
- **CSI (Container Storage Interface)** = the *standard plugin interface* Kubernetes uses to talk to storage vendors.
  - Like **CNI for networking**, but for **storage**.
  - Vendors/examples (from image): **Amazon EBS, Managed Disk, Portworx, DellEMC, GlusterFS** implement CSI drivers.
- **PV (PersistentVolume)** = an actual “disk/volume” resource in Kubernetes (cluster-side object).
- **PVC (PersistentVolumeClaim)** = an app’s “request/booking” for storage.
- **Access modes** (from image): `ReadWriteOnce (RWO)`, `ReadOnlyMany (ROX)`, `ReadWriteMany (RWX)`.

---

## 🧠 Core Memory Hook (never forget)
**PV = the room 🏨** (real storage)  
**PVC = the booking request 📄** (what the app asks for)  
**Pod uses PVC, not PV.**  
👉 “Pods don’t mount disks. Pods mount *claims*.”

---

## ✅ PV vs PVC (what they are)
### PersistentVolume (PV)
- Cluster resource representing real storage (EBS/NFS/etc).
- Has: **capacity**, **accessModes**, **reclaimPolicy**, and the storage backend.

### PersistentVolumeClaim (PVC)
- Namespace resource that asks for storage.
- Has: **requested size**, **accessModes**, and optionally **storageClassName**.


PV & PVC AccessModes — Never Forget Rule
🧠 The Golden Rule

A PVC can only bind to a PV that supports ALL the access modes the PVC asks for.
---

## 🔗 Binding Flow (what happens)
1) PV exists (static) **OR** StorageClass exists (dynamic)  
2) You create a PVC  
3) Kubernetes **binds** PVC → matching PV (or provisions one via CSI)  
4) Pod mounts PVC and gets persistent storage  
✅ Pod deleted → data remains (PVC/PV still exist)  
⚠️ PVC deleted → PV behavior depends on reclaimPolicy

---

## ♻️ Reclaim Policy (what happens after claim deletion)
- `Retain`  → keep volume/data; manual cleanup
- `Delete`  → delete the underlying disk (common with dynamic provisioning)

---

## 🧩 Minimal PV example (static provisioning)
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  awsElasticBlockStore:              # example backend (cloud-specific)
    volumeID: <volume-id>
    fsType: ext4

## 🚀 Using the same PVC in a Deployment (pod template)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-with-pvc
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx
        volumeMounts:
        - name: mypd
          mountPath: /usr/share/nginx/html
      volumes:
      - name: mypd
        persistentVolumeClaim:
          claimName: myclaim


⚠️ Note: With ReadWriteOnce, multiple replicas can work only if scheduled on the same node (depends on storage). For true multi-writer across nodes, you usually need ReadWriteMany.

## 🔍 Useful kubectl commands (daily + exam)
kubectl get pv                                   # list PVs (cluster scope)
kubectl get pvc -A                               # list PVCs across namespaces
kubectl describe pv <pv-name>                    # see reclaimPolicy, capacity, accessModes
kubectl describe pvc <pvc-name>                  # see events if Pending
kubectl get pv,pvc                               # quick view of binding
kubectl get pod <pod> -o wide                    # see where pod is scheduled (node matters for RWO)
kubectl describe pod <pod>                       # confirm volume mount + events
kubectl get storageclass                         # see StorageClasses (dynamic provisioning)
kubectl describe storageclass <sc-name>          # see provisioner (CSI driver)