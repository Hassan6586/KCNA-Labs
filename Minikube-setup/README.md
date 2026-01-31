# Lab 5: Setting Up a Single-Node Kubernetes Cluster with Minikube

A comprehensive guide to installing, configuring, and managing a local Kubernetes cluster using Minikube.

## 📋 Table of Contents

- [Overview](#overview)
- [Learning Objectives](#learning-objectives)
- [Prerequisites](#prerequisites)
- [Lab Environment](#lab-environment)
- [Installation Guide](#installation-guide)
- [Lab Tasks](#lab-tasks)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [What You'll Learn](#what-youll-learn)
- [Next Steps](#next-steps)

## 🎯 Overview

This lab walks you through setting up a single-node Kubernetes cluster using Minikube. You'll learn how to install the necessary tools, start and manage a Kubernetes cluster, deploy applications, and troubleshoot common issues.

**Estimated Time:** 60-90 minutes

## 🎓 Learning Objectives

By completing this lab, you will be able to:

- Install and configure Minikube on a Linux system
- Start and manage a single-node Kubernetes cluster
- Use kubectl to interact with and verify cluster health
- Understand basic Kubernetes cluster components and their status
- Stop and restart a Minikube cluster while maintaining persistence
- Troubleshoot common Minikube installation and startup issues

## ✅ Prerequisites

Before starting this lab, you should have:

- Basic understanding of Linux command line operations
- Familiarity with containerization concepts (Docker basics)
- Understanding of what Kubernetes is and its basic architecture
- Knowledge of YAML file structure (helpful but not required)
- Access to a terminal or command prompt

### System Requirements

- **Operating System:** Ubuntu 20.04 LTS or newer
- **CPU:** Minimum 2 cores
- **RAM:** Minimum 4GB
- **Disk Space:** At least 20GB free
- **Docker:** Pre-installed and running
- **Internet Connection:** Required for downloading packages

> **Note:** Al Nafi provides ready-to-use Linux-based cloud machines for this lab. Simply click **Start Lab** to access your pre-configured environment.

## 🖥️ Lab Environment

Your Al Nafi cloud machine comes pre-configured with:

- Ubuntu 20.04 LTS or newer
- Docker runtime installed and configured
- Internet connectivity for downloading required packages
- Sufficient resources (2 CPU cores, 4GB RAM minimum)

## 📦 Installation Guide

### Task 1: Installing Minikube

#### Step 1.1: Update System Packages

Ensure your system is up to date:

```bash
sudo apt update && sudo apt upgrade -y
```

#### Step 1.2: Install Required Dependencies

Install essential tools for Minikube:

```bash
sudo apt install -y curl wget apt-transport-https
```

#### Step 1.3: Download and Install Minikube

Download the latest Minikube binary:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```

Install Minikube to system PATH:

```bash
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

Verify installation:

```bash
minikube version
```

**Expected Output:**
```
minikube version: v1.32.0
commit: 8220a6eb95f0a4d75f7f2d7b14cef975f050512d
```

#### Step 1.4: Install kubectl

Download kubectl:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

Install kubectl:

```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Verify installation:

```bash
kubectl version --client
```

**Expected Output:**
```
Client Version: v1.29.0
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
```

---

## 🚀 Lab Tasks

### Task 2: Starting Your First Minikube Cluster

#### Step 2.1: Start Minikube

Start your Kubernetes cluster with Docker driver:

```bash
minikube start --driver=docker
```

> **Note:** First startup may take 3-5 minutes while downloading Kubernetes components.

**Expected Output:**
```
😄  minikube v1.32.0 on Ubuntu 20.04
✨  Using the docker driver based on user configuration
👍  Starting control plane node minikube in cluster minikube
🚜  Pulling base image ...
🔥  Creating docker container (CPUs=2, Memory=4000MB) ...
🐳  Preparing Kubernetes v1.28.3 on Docker 24.0.7 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring bridge CNI (Container Networking Interface) ...
🔎  Verifying Kubernetes components...
🌟  Enabled addons: default-storageclass, storage-provisioner
🏄  Done! kubectl is now configured to use "minikube" cluster
```

#### Step 2.2: Verify Cluster Status

Check cluster status:

```bash
minikube status
```

**Expected Output:**
```
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

#### Step 2.3: Verify kubectl Context

Ensure kubectl is connected to Minikube:

```bash
kubectl config current-context
```

**Expected Output:**
```
minikube
```

---

### Task 3: Verifying Cluster Health and Resources

#### Step 3.1: Check Cluster Information

Get cluster details:

```bash
kubectl cluster-info
```

**Expected Output:**
```
Kubernetes control plane is running at https://192.168.49.2:8443
CoreDNS is running at https://192.168.49.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

#### Step 3.2: List All Nodes

View cluster nodes:

```bash
kubectl get nodes
```

**Expected Output:**
```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   2m    v1.28.3
```

Get detailed node information:

```bash
kubectl describe node minikube
```

#### Step 3.3: Check System Pods

View system pods:

```bash
kubectl get pods -n kube-system
```

**Expected Output:**
```
NAME                               READY   STATUS    RESTARTS   AGE
coredns-5dd5756b68-xxxxx          1/1     Running   0          3m
etcd-minikube                     1/1     Running   0          3m
kube-apiserver-minikube           1/1     Running   0          3m
kube-controller-manager-minikube  1/1     Running   0          3m
kube-proxy-xxxxx                  1/1     Running   0          3m
kube-scheduler-minikube           1/1     Running   0          3m
storage-provisioner               1/1     Running   0          3m
```

#### Step 3.4: Check Available Resources

Enable metrics server:

```bash
minikube addons enable metrics-server
```

Wait a few minutes, then check resource usage:

```bash
kubectl top node
```

#### Step 3.5: List Namespaces

View all namespaces:

```bash
kubectl get namespaces
```

**Expected Output:**
```
NAME              STATUS   AGE
default           Active   5m
kube-node-lease   Active   5m
kube-public       Active   5m
kube-system       Active   5m
```

---

### Task 4: Testing Cluster Functionality

#### Step 4.1: Deploy a Test Application

Create an nginx deployment:

```bash
kubectl create deployment hello-minikube --image=nginx:latest
```

Check deployment status:

```bash
kubectl get deployments
```

**Expected Output:**
```
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
hello-minikube   1/1     1            1           30s
```

#### Step 4.2: Expose the Deployment

Create a NodePort service:

```bash
kubectl expose deployment hello-minikube --type=NodePort --port=80
```

Check the service:

```bash
kubectl get services
```

**Expected Output:**
```
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
hello-minikube   NodePort    10.96.xxx.xxx   <none>        80:xxxxx/TCP   15s
kubernetes       ClusterIP   10.96.0.1       <none>        443/TCP        8m
```

#### Step 4.3: Access the Application

Get the service URL:

```bash
minikube service hello-minikube --url
```

Test with curl:

```bash
curl $(minikube service hello-minikube --url)
```

Clean up test resources:

```bash
kubectl delete deployment hello-minikube
kubectl delete service hello-minikube
```

---

### Task 5: Stopping and Restarting the Cluster

#### Step 5.1: Stop the Cluster

Stop Minikube while preserving state:

```bash
minikube stop
```

**Expected Output:**
```
✋  Stopping node "minikube"  ...
🛑  Powering off "minikube" via SSH ...
🛑  1 node stopped.
```

Verify stopped state:

```bash
minikube status
```

#### Step 5.2: Restart the Cluster

Start the cluster again:

```bash
minikube start
```

**Expected Output:**
```
😄  minikube v1.32.0 on Ubuntu 20.04
✨  Using the docker driver based on existing profile
👍  Starting control plane node minikube in cluster minikube
🔄  Restarting existing docker container for "minikube" ...
🏄  Done! kubectl is now configured to use "minikube" cluster
```

#### Step 5.3: Verify Persistence

Check that cluster components are intact:

```bash
kubectl get nodes
kubectl get pods -n kube-system
kubectl get pv
kubectl get storageclass
```

---

### Task 6: Exploring Minikube Features

#### Step 6.1: Access Kubernetes Dashboard

Enable the dashboard addon:

```bash
minikube addons enable dashboard
```

Launch the dashboard:

```bash
minikube dashboard --url
```

> **Note:** This provides a URL to access the dashboard in your browser.

#### Step 6.2: Manage Addons

List available addons:

```bash
minikube addons list
```

Enable the ingress addon:

```bash
minikube addons enable ingress
```

Verify ingress is running:

```bash
kubectl get pods -n ingress-nginx
```

#### Step 6.3: Check Configuration

View Minikube configuration:

```bash
minikube config view
```

Get cluster IP address:

```bash
minikube ip
```

---

## 🔧 Troubleshooting

### Issue 1: Minikube Won't Start

**Solution:**

```bash
# Check Docker status
sudo systemctl status docker

# Start Docker if needed
sudo systemctl start docker

# Delete and recreate cluster
minikube delete
minikube start --driver=docker
```

### Issue 2: kubectl Commands Not Working

**Solution:**

```bash
# Check current context
kubectl config current-context

# Set context to minikube
kubectl config use-context minikube
```

### Issue 3: Insufficient Resources

**Solution:**

```bash
# Restart with more resources
minikube delete
minikube start --driver=docker --memory=4096 --cpus=2
```

### Issue 4: Network Issues

**Solution:**

```bash
# Check status
minikube status

# Restart with different network settings
minikube delete
minikube start --driver=docker --network-plugin=cni
```

---

## 🧹 Cleanup

When finished with the lab:

```bash
# Stop the cluster
minikube stop

# Delete the cluster (optional)
minikube delete

# Remove binaries (optional)
sudo rm /usr/local/bin/minikube
sudo rm /usr/local/bin/kubectl
```

---

## 🎓 What You'll Learn

### Key Accomplishments

- ✅ Installed Minikube and kubectl
- ✅ Created a single-node Kubernetes cluster
- ✅ Verified cluster health and components
- ✅ Deployed and exposed applications
- ✅ Managed cluster lifecycle (stop/start)
- ✅ Explored Minikube addons and features

### Why This Matters

- **Development & Testing:** Safe local environment for Kubernetes development
- **Learning Platform:** Experiment without cloud costs
- **KCNA Certification:** Supports Kubernetes certification objectives
- **Career Skills:** Kubernetes expertise is highly valued
- **Production Foundation:** Concepts scale to production clusters

---

## 🚀 Next Steps

Now that you have a working cluster, explore:

1. Deploy multi-pod applications with services
2. Learn Kubernetes networking and storage
3. Work with ConfigMaps and Secrets
4. Explore Helm charts for application packaging
5. Practice different deployment strategies

---

## 📚 Additional Resources

- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Kubernetes Official Docs](https://kubernetes.io/docs/home/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

---

## 📝 License

This lab material is provided for educational purposes.

---

**Lab Version:** 1.0  
**Last Updated:** January 2026  
**Maintainer:** Al Nafi Learning Platform
