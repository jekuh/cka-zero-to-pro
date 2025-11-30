# Lab 20 – Rolling Updates & Rollbacks

## 1. 🔵 What Is a Rolling Update?

A **Rolling Update** is Kubernetes’ way of updating your application **without downtime**.

Instead of stopping all old Pods and starting all new Pods, the Deployment updates Pods *gradually*:

- Adds 1 new Pod (new version)
- Removes 1 old Pod
- Repeats until all Pods are updated

🧠 Memory Hook:  
**Rolling Update = Changing the tires of a moving car — car keeps running, users don’t notice.**

---

## 2. 🟩 How Rolling Updates Work (Step-by-Step)

### When you update a Deployment (e.g., v1 → v2):

1. **Create 1 new Pod** (running v2)
2. **Delete 1 old Pod** (running v1)
3. Repeat until all Pods run v2
4. Keep app available throughout the process

This ensures:
- **Zero downtime**
- **Smooth transition**
- **No disruption to users**

### Controlled by:

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1          # how many extra pods we can add temporarily
    maxUnavailable: 1    # how many pods can be unavailable during update
    ```

## 3. 🟧 Useful Commands for Rolling Updates
kubectl create –f deployment-definition.yml ## Create
k get deployments## get
kubectl apply –f deployment-definition.yml.  ## Update
kubectl set image deployment/myapp-deployment \
nginx=nginx:1.9.1## update

kubectl rollout status deployment/myapp-deployment ##status
kubectl rollout history deployment/myapp-deployment ## status
kubectl rollout pause deployment/myapp ##pause  a rollout
kubectl rollout resume deployment/myapp ##resume  a rollout



kubectl rollout undo deployment/myapp # rollaback to previous version
kubectl rollout undo deployment/myapp --to-revision=3 #Roll back to a specific revision
kubectl rollout history deployment/myapp # See rollout history



 ```
4. 🔥 What Is a Rollback?

A Rollback restores your Deployment to a previous working version.
You use rollback when:
    - New version has a bug
    - Pods are crashing
    - Traffic drops
    - App becomes unstable

🧠 Memory Hook:
- Rollback = CTRL + Z (Undo) for Kubernetes Deployments.
- Kubernetes keeps revision history, so rollback is instant.
 