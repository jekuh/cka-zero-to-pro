# Lab 21 – Commands & Arguments
- Configuring applications comprises of understanding the following concepts:
- Configuring Command and Arguments on applications
- Configuring Environment Variables
- Configuring Secrets

## 1. 🔵 What Are Commands & Arguments?

Every container needs two things:
- **Command** → WHAT program to run  
- **Arguments** → HOW the program should run  

🧠 Memory Hook:  
**Command = Boss  
Args = Instructions**

## 2. 🟦 Docker vs Kubernetes (Core Mapping)

| Concept | Dockerfile | Kubernetes YAML | Meaning |
|--------|------------|------------------|---------|
| Program to run | ENTRYPOINT | `command:` | The main executable |
| Default arguments | CMD | `args:` | Parameters for the executable |
| Override ENTRYPOINT | `docker run --entrypoint` | `command:` | Replace the main program |
| Override CMD | `docker run <cmd>` | `args:` | Replace default args |

🧠 Easiest way to remember:
**ENTRYPOINT = command**  
**CMD = args**

#Useful commands
k run webapp-green --image=kodekloud/webapp-color --command color=green

## 3. 🟧 How Docker Does It

Example:

```dockerfile
ENTRYPOINT ["sleep"]
CMD ["5"]
```
## 4. 🟧 Full K8 file
 ```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper
spec:
  containers:
  - name: ubuntu
    image: ubuntu
    command: ["sleep"]
    args: ["1200"]

    or 
   command: [ "sleep",  "1200" ]
    or
    command: 
    - "sleep"
    - "200"
```
- Also note that these are properties that you cannot just edit using kubectl edit
- kubectl replace --force 0f /tmp/kubectl-eidt-74682884994.yaml

# Useful Commands
# Start the nginx pod using the default command, but use custom arguments
`kubectl run nginx --image=nginx -- <arg1> <arg2> ... <argN>`
`kubectl run nginx --image=nginx -- --colour green`

# Start the nginx pod using a different command and custom arguments
`kubectl run nginx --image=nginx --command -- <cmd> <arg1> ... <argN>`
