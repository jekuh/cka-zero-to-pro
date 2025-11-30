# Lab 15 – Multiple Schedulers

## 1. What Are Multiple Schedulers?

Kubernetes normally uses **one scheduler** (`kube-scheduler`) to decide where Pods should run.

**Multiple schedulers** means running **more than one scheduler** in the same cluster, each with its own scheduling logic.

🧠 **Memory Hook:**  
**Schedulers = different “brains” deciding Pod placement.**

Pods choose the brain that schedules them.

---

## 2. Why Use Multiple Schedulers?

Use cases:
- Custom scheduling rules (GPU-aware, cost-aware)
- Batch job scheduling
- ML/AI workloads needing special logic
- Business rules for node placement
- Experiments with new scheduling algorithms

➡ Default scheduler = general-purpose  
➡ Custom scheduler = special logic for special workloads

---

## 3. How Pods Select a Scheduler

Pods choose their scheduler using:

```yaml
spec:
  schedulerName: my-custom-scheduler
 ``` 
- If this is omitted:schedulerName: default-scheduler
- A custome scheduler  usually runs as a pod
``` yaml
apiVersion: v1
kind: Pod
metadata:
  name: custom-scheduler
spec:
  containers:
  - name: scheduler
    image: my-custom-scheduler-image
    command: ["scheduler", "--scheduler-name=my-custom-scheduler"]
``` 

### Useful Commands
`k get events -o wide` # get all events in the namespace
`k logs <my-custom-scheduler> -n <>`