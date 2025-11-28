# 🔐 Secure Data Transfer Using Star Graph Encryption  
A MATLAB-based implementation of a graph-theoretic encryption technique using **Star Graphs (K₁ ⊕ Kₙ)**.  
This project performs full encryption and decryption of messages using prime-based encoding, vertex labeling, edge weighting, and star graph visualization.

---

## ⭐ Overview  
This project converts plaintext into mathematical graph structures using:

- Prime-number encoding
- Grid mapping of alphabet
- Vertex label creation through prime multiplication
- Edge-weight transformation using powers of 10
- Star Graph plotting for encryption visualization
- Full reverse decryption algorithm

Inspired by the graph-based encryption model presented in:

**Ali, N. et al. (2024)**  
*“Secure Communication in the Digital Age: A New Paradigm with Graph-Based Encryption Algorithms.”*  
Frontiers in Computer Science, 6, 1454094.

---

## 🔑 Features  
✔ Key-based encryption (k = 2–13)  
✔ Prime-indexed encoding table  
✔ Vertex label generation  
✔ Edge-weight transformation  
✔ Full star-graph visualization in MATLAB  
✔ Complete reversible decryption  
✔ Resistant to brute-force & frequency attacks  
✔ Clean, step-by-step output with explanations  

---

## 🧠 Encryption Workflow  
### **1️⃣ Generate n and select primes**  
- Split into row primes & column primes  
- Create encoding grid for letters A–Z  

### **2️⃣ Vertex creation**

### **3️⃣ Edge-weight transformation**

### **4️⃣ Star Graph creation**
- Center node = 0  
- Leaves = vertex labels  
- Edges = encrypted weights  

### **5️⃣ MATLAB visualization**
Plots full encrypted graph.

---

## 🔓 Decryption Workflow  
For each edge weight:

1. `recovered_vertex = edge_weight + 10^i`  
2. Factor recovered vertex into its prime pair  
3. Lookup letter in encoding table  
4. Reconstruct full message  

---
