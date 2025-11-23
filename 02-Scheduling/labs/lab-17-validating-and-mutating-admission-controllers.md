# Lab 17 – Validating and Mutating Admission Controllers

# Mutating vs Validating Admission Controllers

## 🚀 What Are Admission Controllers?
Admission controllers are **interceptors** inside the Kubernetes API Server.  
They inspect or modify API requests **before objects are stored in etcd**.

They run **after** authentication & authorization, but **before** persistence.

There are two types:
- **Mutating Admission Controllers**
- **Validating Admission Controllers**

---

## 🔧 1. Mutating Admission Controllers (Modify Requests)

Mutating controllers can **change** the request before it is saved.

Examples:
- Add missing labels/annotations  
- Inject sidecars (e.g., Istio)  
- Default fields (e.g., `DefaultStorageClass`)  
- Modify security settings  

### 🧠 Memory Hook  
**Mutating = “Auto-fix / auto-complete the request.”**

### Example actions:
- Add resource limits if missing  
- Add tolerations  
- Insert default values  
- Patch Pod specs  

---

## 🛑 2. Validating Admission Controllers (Approve or Deny)

Validating controllers **do NOT modify** requests — they only *allow* or *reject*.

Examples:
- Deny privileged pods  
- Enforce label rules  
- Enforce PodSecurity/PSPs  
- Block deployments without required fields  

### 🧠 Memory Hook  
**Validating = “Security guard at the door: Yes or No.”**

---

## 🔍 Key Differences

| Feature             | Mutating | Validating |
|---------------------|----------|------------|
| Can modify request? | ✔ Yes    | ❌ No      |
| Can deny request?   | ✔ Yes    | ✔ Yes      |
| Runs first?         | ✔ Yes    | ❌ No (runs after mutating) |
| Typical use         | Auto-fix | Enforce policies |

---

## 🧬 Execution Order

1️⃣ **Mutating Admission Controllers**  
→ Modify the object (if needed).  

2️⃣ **Validating Admission Controllers**  
→ Verify final object and accept/reject.  

This ensures policies apply after all mutations.

---

## 💡 Example Plugins

### Mutating:
- `DefaultStorageClass`
- `MutatingAdmissionWebhook`
- `PodPreset`

### Validating:
- `ResourceQuota`
- `PodSecurity`
- `ValidatingAdmissionWebhook`

---

## 🏁 Summary (Memorize)

- **Mutating = Fix request**  
- **Validating = Check and approve request**  
- Mutating runs **before** validating  
- Both operate in the Kubernetes API Server  


