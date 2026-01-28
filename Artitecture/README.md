# Lab 3: Understanding Kubernetes Architecture

KCNA | AlNafi Cloud | Al-Razzaq Program

## Objectives
By the end of this lab, you will be able to:
- Identify core Kubernetes cluster components
- Inspect cluster architecture using kubectl
- Examine control plane component logs (API Server, etcd)
- Deploy a Pod and analyze its interaction with nodes and control plane
- Troubleshoot basic cluster issues using CLI

## Prerequisites
- Basic containerization (Docker) knowledge
- Linux command-line familiarity
- YAML file structure basics
- Understanding of client-server architecture
- Completion of previous Kubernetes fundamentals labs

## Lab Environment
- Ubuntu 22.04 LTS (cloud-based)
- Minikube single-node Kubernetes cluster
- Pre-installed kubectl and tools
- Internet access for container images

## Lab Tasks

### 1. Identify Cluster Components
kubectl cluster-info
kubectl get nodes -o wide
kubectl describe nodes
kubectl get pods -n kube-system

### 2. Examine Control Plane Logs
API Server logs:
kubectl logs -n kube-system <apiserver-pod> --tail=50

etcd logs:
kubectl logs -n kube-system <etcd-pod> --tail=30

Scheduler & Controller Manager logs: same approach

### 3. Create & Observe a Pod
Pod manifest example:
apiVersion: v1
kind: Pod
metadata:
  name: nginx-demo
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80

Apply & verify:
kubectl apply -f nginx-pod.yaml
kubectl get pods
kubectl describe pod nginx-demo

Monitor component interactions (scheduler, API Server, kubelet)
Test network connectivity & port-forwarding

### 4. Advanced Component Analysis
Resource usage:
kubectl top nodes
kubectl top pods

RBAC & service accounts:
kubectl get serviceaccounts -n kube-system
kubectl get clusterroles
kubectl get clusterrolebindings

Component health:
kubectl get componentstatuses

### 5. Troubleshooting
Pod stuck in Pending: check events, node resources, scheduler logs
Control plane access issues: verify cluster status, restart Minikube
Network issues: check Pod IP, DNS resolution

### Cleanup
kubectl delete pod nginx-demo
rm nginx-pod.yaml

## Key Takeaways
- Understand Kubernetes architecture and control plane components
- Inspect logs to troubleshoot cluster issues
- Deploy and monitor Pods while observing component interactions
- Gain foundational knowledge for KCNA/CKA certification and real-world cluster management

