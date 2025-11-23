# Lab 08 – Labels and Selectors
🔵 What Are Labels?
Labels are key–value tags you attach to Kubernetes objects.
They describe objects so Kubernetes (and you) can find or group them easily.

🧠 Memory Hook

**Labels** = Stickers on a box.
They don’t do anything; they just describe.
**Selectors** = Search filters (just like filtering emails by label).

🟢 Why Labels Exist

✔ To organize your Kubernetes objects
✔ To group pods logically (frontend, backend, DB, etc.)
✔ To filter objects with commands
✔ To allow controllers (ReplicaSets, Deployments) to manage the right pods
✔ To let Services route traffic to the correct pods
✔ To manage large clusters cleanly

🎯 What Are Selectors?

Selectors are how Kubernetes finds objects using labels.
`kubectl get pods --selector app=App1`

🧠 Ultimate Memory Rule
- Labels = Stickers.
- Selectors = Search filters using stickers.
- Everything in Kubernetes uses this system.

📘 Useful Commands
- list all lbales on pods `kubectl get pods --show-labels`
- filter resouces with selectors `kubectl get pods --selector app=App1`
`kubectl get svc --selector tier=backend`
`k get all --selector env=prod,bu=finance,tier=frontend`

```yaml
selector:
matchLabels:
  app: App1. # Match any pod that has app=App1.


🧠 Ultimate Memory Rule
Labels = Stickers.
Selectors = Search filters using stickers.
Everything in Kubernetes uses this system.