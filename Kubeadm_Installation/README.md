# 🚀 Kubernetes Cluster Installation Using kubeadm

> **Hands-on Kubernetes Lab | KCNA / DevOps Fundamentals**

This repository contains a **step-by-step practical lab** to install and configure a **single-node Kubernetes cluster using kubeadm** on Ubuntu Linux.  
Designed for **DevOps engineers, Cloud engineers, and KCNA learners**.

---

## 📌 Table of Contents
- [Overview](#overview)
- [Lab Objectives](#lab-objectives)
- [Prerequisites](#prerequisites)
- [Lab Environment](#lab-environment)
- [Architecture Overview](#architecture-overview)
- [Task 1: System Preparation](#task-1-system-preparation)
- [Task 2: Kernel Configuration](#task-2-kernel-configuration)
- [Task 3: Install Container Runtime](#task-3-install-container-runtime-containerd)
- [Task 4: Install Kubernetes Components](#task-4-install-kubernetes-components)
- [Task 5: Initialize Kubernetes Cluster](#task-5-initialize-kubernetes-cluster)
- [Task 6: Install CNI Network](#task-6-install-cni-network-flannel)
- [Task 7: Verify Cluster](#task-7-verify-cluster)
- [Task 8: Deploy Test Application](#task-8-deploy-test-application)
- [Troubleshooting](#troubleshooting)
- [Conclusion](#conclusion)

---

## 📖 Overview
Kubernetes is a container orchestration platform that automates deployment, scaling, and management of containerized applications.

In this lab, we build a **fully functional Kubernetes cluster using kubeadm**, configure networking, and deploy a test workload.

---

## 🎯 Lab Objectives
- Prepare Linux system for Kubernetes
- Install and configure container runtime
- Install kubeadm, kubelet, kubectl
- Initialize Kubernetes control plane
- Configure Pod networking (Flannel)
- Deploy and test an application
- Validate cluster health

---

## 📚 Prerequisites
- Ubuntu 20.04 or later
- Root or sudo privileges
- Basic Linux CLI knowledge
- Understanding of Docker & containers
- Internet connectivity

---

## 🖥️ Lab Environment
| Component | Details |
|--------|--------|
| OS | Ubuntu 20.04+ |
| CPU | 2 vCPUs |
| RAM | 2 GB minimum |
| Runtime | containerd |
| Cluster Type | Single-node |

---

## 🏗️ Architecture Overview
- **kubeadm** → Cluster bootstrap tool  
- **kubelet** → Node agent  
- **kubectl** → Cluster management CLI  
- **containerd** → Container runtime  
- **Flannel** → Pod networking (CNI)  

---

## 🔧 Task 1: System Preparation

### Step 1.1: Update system
```bash
sudo apt update && sudo apt upgrade -y
Step 1.2: Install required packages
bash
Copy code
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
Step 1.3: Disable swap (mandatory)
bash
Copy code
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
🔧 Task 2: Kernel Configuration
Step 2.1: Load kernel modules
bash
Copy code
sudo modprobe overlay
sudo modprobe br_netfilter
Step 2.2: Persist modules
bash
Copy code
cat <<EOT | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOT
Step 2.3: Enable networking
bash
Copy code
cat <<EOT | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOT

sudo sysctl --system
🐳 Task 3: Install Container Runtime (containerd)
Step 3.1: Add Docker repo
bash
Copy code
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
Step 3.2: Install containerd
bash
Copy code
sudo apt update
sudo apt install -y containerd.io
Step 3.3: Configure containerd
bash
Copy code
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
Step 3.4: Restart runtime
bash
Copy code
sudo systemctl restart containerd
sudo systemctl enable containerd
☸️ Task 4: Install Kubernetes Components
Step 4.1: Add Kubernetes repo
bash
Copy code
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
Step 4.2: Install components
bash
Copy code
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
🚀 Task 5: Initialize Kubernetes Cluster
bash
Copy code
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
Configure kubectl:

bash
Copy code
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
🌐 Task 6: Install CNI Network (Flannel)
bash
Copy code
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
✅ Task 7: Verify Cluster
bash
Copy code
kubectl get nodes
kubectl get pods -A
kubectl cluster-info
🧪 Task 8: Deploy Test Application
bash
Copy code
kubectl create deployment nginx-test --image=nginx
kubectl expose deployment nginx-test --port=80 --type=NodePort
kubectl get svc
Test:

bash
Copy code
NODE_PORT=$(kubectl get svc nginx-test -o jsonpath='{.spec.ports[0].nodePort}')
curl http://localhost:$NODE_PORT
Cleanup:

bash
Copy code
kubectl delete deployment nginx-test
kubectl delete service nginx-test
