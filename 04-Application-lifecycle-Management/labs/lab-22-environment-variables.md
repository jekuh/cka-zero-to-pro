# Lab 22 – Environment Variables
## 1. 🔵 What Are Environment Variables?

- Environment variables are **key–value pairs** that you pass to an application **from outside the code**.
Examples:
APP_COLOR=green
DB_HOST=db.service
API_KEY=12345

🧠 Memory Hook:  
**Environment variables = Settings given to the app at runtime, without changing the code.**

---

## 2. 🟦 Why Do We Use Environment Variables?

- ✔ Change app behavior without editing code  
- ✔ Provide configuration values (URL, mode, color, etc.)  
- ✔ Provide secrets (passwords, API keys)  
- ✔ Allow different settings for dev/test/prod  
- ✔ Avoid hardcoding sensitive values  

Think of them as **instructions you whisper to the app before it starts**.

---

## 3. 🟩 How Applications Read Environment Variables

### docker
docker run -e APP_COLOR=blue -e APP_MODE=prod myapp

## 4. 🟥 Environment Variables in Kubernetes
Environment variables are added inside the Pod spec.
## 4.1 Simple env variable
env:
  - name: APP_COLOR
    value: "green"

## 4.2 Env vars from ConfigMap
✅ There are TWO ways to load environment variables from a ConfigMap
## METHOD 1 — Load ONE key only

**✔ When you want ONE specific value from a ConfigMap**
```yaml
env:
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef:
        name: webapp-config-map
        key: APP_COLOR

  ```

## 🧠 Memory Hook:
configMapKeyRef = pick ONE key from ConfigMap

## METHOD 2 — Load ALL keys at once
**✔ When you want to load ALL entries from the ConfigMap**
envFrom:
  - configMapRef:
      name: app-config
This loads ALL keys as separate environment variables.

🧠 Memory Hook:
configMapRef = load whole ConfigMap

## 4.3 Env vars from Secrets
```yaml
env:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: password
## 4.4 Load all Secret or ConfigMap entries
envFrom:
  - secretRef:
      name: app-secret

   ```

## 5. 🟩 What is a ConfigMap?

so when you have so manay  env variables it is sometimes difficult to manage the env variables in the pod  files. you can take this information out pod def file and manage them using **configMaps** 

A ConfigMap is a Kubernetes object used to store non-sensitive configuration data.
Examples of what ConfigMaps store:
- App settings
- URLs
- Feature flags
- File-like configuration (JSON, YAML)
- Key–value pairs

## 6. 🟦 Ways to Create ConfigMaps
## 6.1 From literal key–value pairs
`kubectl create configmap app-config --from-literal=APP_COLOR=blue`

## 6.2 From a file
`kubectl create configmap app-config --from-file=config.json`

## 6.3 From a YAML manifest

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: "green"
  APP_MODE: "production"
```

🧠 Memory Hook:
ConfigMap = Configuration settings. NOT secrets.

## 7. 🟪 Important Notes (Must Remember)
✔ Environment variables load only when the container starts
✔ If you change them → Pod must restart
✔ Good for passwords, URLs, app settings
✔ Prefer Secret for sensitive values
✔ Prefer ConfigMap for normal configuration

## 8. 🟫 Best Practices
- Use Kubernetes Secrets for passwords & tokens
- Use ConfigMaps for non-sensitive configuration
- Never hardcode secrets in images
- Keep environment variable names consistent
- Avoid storing secrets in Git
- Keep config outside code for easier deployments

## 9. 🟦 Example: Pod Using Environment Variables
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: color-app
spec:
  containers:
    - name: app
      image: kodekloud/webapp-color
      env:
        - name: APP_COLOR
          value: "green"

App sees:
APP_COLOR=green
```
⭐ Final Summary
- Environment variables = remote control for your app
- Docker → use -e flags
- Kubernetes → use env: and envFrom:
- Apps read env vars at startup
- Use ConfigMaps and Secrets for clean separation
- Environment variables let you configure your application without editing code.

## Useful commands
`k get configmaps`
`k describe configmaps`
`kubectl create configmap <config-name> --from-literal=<key>=<value>`
`kubectl create configmap app-config --from-literal=APP_COLOR=blue --from-literal=APP_MODE=prod`
