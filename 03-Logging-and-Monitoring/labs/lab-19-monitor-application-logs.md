# Lab 19 – Monitor Application Logs
## 1. 🔵 What Are Application Logs?

Application logs are **whatever your application prints to stdout or stderr** inside its container.

Examples:
- `print("User logged in")`
- `console.log("Payment processed")`
- `logger.error("DB connection failed")`

🧠 Memory Hook:  
**Kubernetes does NOT create logs — it only captures what your app prints.**

---

## 2. 🟩 Where Kubernetes Stores Container Logs

Kubernetes stores logs on the **node**, not inside the pod.

### Pod-level log location:
/var/log/pods/<namespace><pod><uid>/<container>.log

⚠️ If the pod dies or node crashes, logs disappear.

---

## 3. 🟦 How to View Application Logs (kubectl commands)

### Usefull commands
```bash
kubectl logs <pod> # follow logs live
kubectl logs <pod> -c <container-name> # show logs for specific container
kubectl logs <pod> --previous # show logs from previous crashed container
kubectl logs --timestamps <pod> # show logs with timestamps
kubectl logs -n <namespace> <pod> # show logs in specific namespace
```

Logs dissapera becasue pods are ephemeral. So when pod restarts, pod is evicted, deployment rollout happens, node dies, node is drained

## 🟧 Centralized Logging (Production Requirement)

- Central logging keeps logs even when pods die.
- Popular Kubernetes logging stacks:
✔ **EFK Stack**
    Elasticsearch
    Fluentd / Fluent Bit
    Kibana
✔ **Loki Stack**
    Loki
    Promtail
    Grafana

✔ **Managed options**
    Datadog
    Splunk
    New Relic
    Google Cloud Logging
    AWS CloudWatch Logs

🧠 Memory Hook:
Nodes die. Pods die. Logs should NOT die.
Centralize logs.