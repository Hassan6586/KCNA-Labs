cat > README.md << 'EOF'
# Lab 10: Deploying a Stand-Alone Application in Kubernetes

## 📌 Overview
This repository contains the manifests and step-by-step instructions for **Lab 10**. The goal of this lab is to deploy a stand-alone NGINX web application, expose it to external traffic using a NodePort Service, and customize its content via ConfigMaps.

## 🎯 Objectives
* Deploy a Kubernetes manifest for a stand-alone application.
* Configure a **NodePort Service** for external access.
* Monitor logs and resource metrics (CPU/Memory).
* Inject custom content using **ConfigMaps**.
* Practice troubleshooting common deployment issues.

## 🛠 Prerequisites
* Kubernetes cluster (Minikube or equivalent).
* `kubectl` CLI installed and configured.
* Basic understanding of YAML and Linux command line.

---

## 🚀 Lab Steps

### Task 1: Deploy the Application

**1.1 Verify Cluster Status**
```bash
kubectl cluster-info
kubectl get nodes ```


2.2 Access the App

```Bash
# Get the URL for access
echo "Access application at: http://$(minikube ip):30080"

# Test via terminal
curl http://$(minikube ip):30080
```

