# Lab 18 – Monitoring Cluster Components
## 🔵 What Is Logging?
**Logging = “What happened?”**
Logs show:
- Errors
- Crash messages
- Application output
- Pod/container events

📌 Logs come from:
- Containers (stdout/stderr)
- Kubelet
- API server
- Controller manager
- etcd

### Useful Commands
```bash
kubectl logs <pod>
kubectl logs <pod> -f
kubectl logs <pod> --previous
kubectl top pod
kubectl top node
```
**Centralized Logging Options**
- EFK (Elasticsearch + Fluentd + Kibana)
- Loki + Promtail + Grafana (modern, cheaper)
- Logging operators (e.g., Fluent Bit)

🧠 Memory Hook:
Logging = Dashcam video. It records what happened.

## 🟩 What Is Monitoring?
Monitoring = “How healthy is the system right now?”
Monitoring collects metrics, such as:
    CPU / Memory usage
    Pod restarts
    Node health
    API latency
    Network traffic

**Monitoring Stack**
- Prometheus → collects metrics
- Grafana → visualizes metrics
- Alertmanager → sends alerts

🧠 Memory Hook:
Monitoring = Car dashboard. Shows real-time health.

**NB**
- You must enable the Metrics Server before you can use:`kubectl top pods`,
`kubectl top nodes`
- Because Metrics Server is the component that provides CPU & memory metrics to the Kubernetes API.
- Without it → Kubernetes has no resource metrics pipeline, so kubectl top and the HPA cannot work.
- Because Kubernetes is designed to be modular and lightweight.
Not everyone needs metrics collection (e.g., IoT, edge deployments).
- Cloud providers like:EKS, GKE, AKS usually install a version automatically.

**Deploy the metrics server**
`kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`