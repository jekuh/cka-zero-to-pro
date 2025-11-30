# Lab 11 – Resource Limits & Resource Quotas
## 1. Resource Limits (Pod-level)

**Resource Limits** control how much **CPU and Memory each container is allowed to use**.

They prevent a single Pod from overusing resources on a node.

### 🧠 Memory Hook  
**Limits = “Maximum allowance per container.”**

### CPU Limit  
- Measured in millicores (`500m = 0.5 CPU`)  
- If exceeded → container is **throttled** (slowed down)

### Memory Limit  
- Measured in `Mi`, `Gi`  
- If exceeded → container is **killed (OOMKilled)**

### Useful Commands
`kubectl get resourcequota --all-namespaces`
`kubectl get resourcequota -n <namespace>`
`kubectl describe resourcequota <quota-name> -n <namespace>`

### Example
```yaml
resources:
  requests:
    cpu: "200m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "256Mi"

```
- Requests = minimum guaranteed
- Limits = maximum allowed

## 2.Resource Quotas (Namespace-level)
A Resource Quota sets a maximum amount of resources a whole namespace can use.
It limits:
    - Number of Pods
    - Total CPU requests/limits
    - Total Memory requests/limits
    - Services, PVCs, Jobs (optional)

🧠 Memory Hook
**Quota**= “Total budget for the entire namespace.”
### Example
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: ns-quota
spec:
  hard:
    pods: "10"
    requests.cpu: "2"
    requests.memory: "4Gi"
    limits.cpu: "4"
    limits.memory: "8Gi"
```
