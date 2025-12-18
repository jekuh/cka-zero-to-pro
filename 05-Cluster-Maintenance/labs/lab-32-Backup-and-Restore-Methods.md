# Lab 32 – Backup and Restore Methods
## 🔵 The Golden Rule (Never Forget This)

Kubernetes does NOT back up anything for you.

👉 **You must back up:**
1. **Cluster state (etcd)**
2. **Application data (Persistent Volumes)**
Backing up only one is NOT enough.
## 🧠 Simple Memory Model

- **etcd** = Kubernetes brain / ledger  
- **Persistent Volumes** = application data / files  

If etcd is lost → cluster is gone  
If PVs are lost → data is gone  

👉 **You must back up BOTH**
## 🔴 What Exactly Needs Backup?

### 1️⃣ etcd (Cluster State)
Contains:
- Pods
- Deployments
- Services
- ConfigMaps
- Secrets
- RBAC
- Namespaces
- StatefulSets
- Everything created with `kubectl`

If etcd is lost:
❌ No cluster configuration  
❌ No secrets  
❌ No workloads  
### 2️⃣ Persistent Volumes (App Data)
Contains:
- Database files
- User uploads
- Logs
- Stateful app data

Stored outside etcd. If PVs are lost:
❌ Applications come back  
❌ Data does NOT
---
check version
`kubectl get pods -n kube-system | grep etcd`
`kubectl exec -n kube-system etcd-controlplane -- etcdctl version`


## 🟢 etcd Backup & Restore (Mandatory)

### Backup etcd
`etcdctl version`

```bash
ETCDCTL_API=3 etcdctl\
  --endpoints=https://127.0.0.1:2379 \ # points to the etcd server (default: localhost:2379)
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \ # path to the CA cert
  --cert=/etc/kubernetes/pki/etcd/server.crt \ # path to the Client /server cert
  --key=/etc/kubernetes/pki/etcd/server.key \ # path to the Client key
 snapshot save snapshot.db
```
```yaml
etcdutl backup \
  --data-dir /var/lib/etcd \
  --backup-dir /backup/etcd-backup
  ```
  This copies the etcd backend database and WAL files to the target location.

**Checking Snapshot Status**
You can inspect the metadata of a snapshot file using:
`etcdutl snapshot status  /backup/etcd-snapshot.db \`
 ` --write-out=table`
This shows details like size, revision, hash, total keys, etc. It is helpful to verify snapshot integrity before restore.

**Restoring ETCD**
Using etcdutl
To restore a snapshot to a new data directory:

`etcdutl snapshot restore /backup/etcd-snapshot.db --data-dir /var/lib/etcd-restored`
POINT ETCD TO THE RESTORED DATA
`vim /etc/kubernetes/manifests/etcd.yaml`


To use a backup made with etcdutl backup, simply copy the backup contents back into /var/lib/etcd and restart etcd.

🟢 Persistent Volume Backup
Methods:
- Storage-level snapshots (EBS, GCE PD, Azure Disk)
- Backup tools (Velero)
- Database-native backups (mysqldump, pg_dump)

🔵 Velero — Explained Simply ( research more into valero)
Velero is a Kubernetes backup tool that can:

- Back up Kubernetes objects (YAMLs)
- Back up Persistent Volumes
- Restore to the same or a new cluster
- Migrate clusters
