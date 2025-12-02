# Lab 27 – Horizontal Pod Autoscaling
# Horizontal Pod Autoscaler (HPA) in Kubernetes  
# 🚀 What Is HPA?

The **Horizontal Pod Autoscaler (HPA)** automatically adjusts the **number of Pod replicas** in a Deployment, ReplicaSet, or StatefulSet based on **real-time metrics** such as:

- CPU utilization  
- Memory utilization  
- Custom metrics (Prometheus, external metrics, etc.)

> **HPA = Kubernetes automatically increases or decreases the number of Pods based on load.**

---

# 🎯 Why Use HPA?

- Handle unpredictable traffic  
- Maintain performance  
- Reduce cost by scaling down when idle  
- Automate replica management  
- Remove the need for constant human scaling

---

# 🧠 How HPA Works (Simple Explanation)

HPA continuously checks metrics from the **metrics-server**.  
If the target utilization is exceeded → HPA scales up  
If utilization falls too low → HPA scales down

Simple flow:metrics → HPA → updates replicas → Deployment/RS → Pods created/deleted

# 🧰 Prerequisite

You *must* have **metrics-server** installed:

`kubectl get deployment metrics-server -n kube-system`

## Useful HPA Commands
`kubectl get hpa`
`kubectl describe hpa <name>`
`kubectl get hpa -w ## watch hpa decisions live`
`kubectl top pod`
`kubectl top node`




## CPU-based autoscaling
`kubectl autoscale deployment <deployment-name> \`
  `--min=1 --max=10 \`
  `--cpu-percent=50`
  example : `kubectl autoscale deployment webapp --min=2 --max=10 --cpu-percent=60`
  example: HPA YAML Template (memory based)
  ```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: memory-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: webapp
  minReplicas: 1
  maxReplicas: 8
  metrics:
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 70
```


*** check the kubernetes autoscaling course *** got indept knowledge on scaling


## Other informations
# In-Place Pod Resizing (Vertical Pod Scaling) in Kubernetes  
A concise, exam-ready summary of the new vertical scaling feature.

---

# 📌 What Is In-Place Pod Resizing?

**In-Place Pod Resizing** (also called **Vertical Pod Scaling**) allows you to change the CPU and memory  
**resources of a running Pod without restarting it.**

Traditionally, updating resource requests/limits forces a Pod restart.  
With this feature enabled, Kubernetes can resize Pods **live**, avoiding restarts and downtime.

---

# 🌟 Feature Availability

- Introduced in **Kubernetes v1.27**  
- Feature gate: **InPlacePodVerticalScaling**
- **Alpha** (disabled by default)
- Must be explicitly enabled on **kube-apiserver** and **kubelet**

Enable on cluster components:

```bash
FEATURE_GATES=InPlacePodVerticalScaling=true


- only cpu amd memory resources can be changed