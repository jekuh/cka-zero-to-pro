# Kubernetes OS Upgrades & Node Maintenance  
## 🔵 What Are OS Upgrades in Kubernetes?

OS upgrades refer to updating the underlying operating system of Kubernetes nodes:
- Kernel patches  
- Security fixes (CVE updates)  
- Container runtime updates (containerd / CRI-O / runc)  
- OS image updates (cloud provider images)  
- System-level bug fixes and performance improvements  

Nodes must be upgraded carefully because Pods run on nodes.

# 🏨 Hotel Metaphor (The Memory Trick)

This is the easiest way to NEVER forget OS upgrades:
- **Pods = Guests**  
- **Node = Hotel room**  
- **OS upgrade = Renovation**
You cannot renovate a room while guests are inside.
Same rule in Kubernetes:
**You cannot upgrade a node OS while Pods are running on it.**

So Kubernetes uses a safe, predictable workflow:
**Drain → Upgrade → Uncordon**

# 🟢 OS Upgrade Workflow (The 4 Steps)

## 1️⃣ Cordon the Node — Stop New Pods
Prevents the scheduler from placing new Pods on this node.
`kubectl cordon <node>`


## 2️⃣ Drain the Node — Move Existing Pods Away

Evict Pods safely and reschedule them to other nodes.
`kubectl drain <node> --ignore-daemonsets --delete-emptydir-data`

- Evicts Pods managed by Deployments, ReplicaSets, StatefulSets-
- Recreates them immediately on other nodes
- Deletes pods using EmptyDir volumes
- Leaves DaemonSet pods running

## 3️⃣ Upgrade the OS — Renovate the Room

After draining, the node is EMPTY.Now you can safely apply: OS patches, Kernel updates, Security updates, containerd / CRI-O upgrades, Cloud node image updates
**Reboot the node**
Meaning:
"Renovate the empty room safely."

## 4️⃣ Uncordon the Node — Reopen the Room

Allow Kubernetes to schedule Pods on the node again.
`kubectl uncordon <node>`

## 🧠 Memory Hook
Drain → Upgrade → Uncordon
Move guests → Renovate → Reopen

- Kubernetes waits 5 minutes (default eviction timeout) `--pod-eviction-timeout=5m`

🧱 DaemonSet Behavior

**DaemonSet Pods:**
Are NOT evicted during drain
Must always run on every node
Represent node-level components (CNI, kube-proxy, log agents)

This is why drain requires:`--ignore-daemonsets`

## 🧰 Useful Commands Summary
`kubectl get nodes `                    # Check cluster nodes
`kubectl cordon <node>  `               # Stop scheduling new Pods
`kubectl drain <node> --ignore-daemonsets --delete-emptydir-data `  # Evict Pods
`kubectl uncordon <node>   `            # Allow scheduling again

🧠 Why OS Upgrades Are Necessary

- Security: kernel CVEs, kubelet vulnerabilities, runtime CVEs
- Stability: fixing node crashes, kubelet bugs
- Performance: improved CPU/memory handling, better networking
- Cloud provider: deprecated images, forced upgrades
- Reliability: prevent OOM kills, fix disk issues
- OS upgrades keep nodes healthy, secure, and efficient.

## 🔔 How Companies Know It's Time to Upgrade

Real-world Kubernetes teams do NOT rely on memory.
They rely on alerts and automation.

**Common alerts:**
Node NotReady
DiskPressure / MemoryPressure
OS/Kubernetes CVE alerts
Deprecated cloud node image warnings
Kubernetes version nearing End-of-Life
API deprecation warnings
containerd / CRI-O vulnerabilities
Cluster monitoring alerts (Prometheus/Grafana)
Alerts usually notify teams via:Slack, PagerDuty, Opsgenie, Jira / ServiceNow, Email

