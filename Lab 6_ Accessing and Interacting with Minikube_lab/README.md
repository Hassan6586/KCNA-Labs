# Lab 6: Accessing and Interacting with Minikube

A hands-on guide to understanding Kubernetes architecture, using kubectl commands, and managing pods in a Minikube cluster.

## 📋 Table of Contents

- [Overview](#overview)
- [Learning Objectives](#learning-objectives)
- [Prerequisites](#prerequisites)
- [Lab Environment](#lab-environment)
- [Lab Tasks](#lab-tasks)
  - [Task 1: Understanding Your Kubernetes Environment](#task-1-understanding-your-kubernetes-environment)
  - [Task 2: Deploy and Manage Pods](#task-2-deploy-and-manage-pods)
  - [Task 3: Diagnose Connectivity Issues](#task-3-diagnose-connectivity-issues)
  - [Task 4: Clean Up Resources](#task-4-clean-up-resources)
- [Troubleshooting Guide](#troubleshooting-guide)
- [kubectl Command Reference](#kubectl-command-reference)
- [What You'll Learn](#what-youll-learn)
- [Next Steps](#next-steps)

---

## 🎯 Overview

This lab provides comprehensive hands-on experience with Kubernetes cluster interaction using Minikube. You'll learn essential kubectl commands, deploy applications, manage pod lifecycles, and troubleshoot common connectivity issues.

**Estimated Time:** 90-120 minutes  
**Difficulty Level:** Beginner to Intermediate

---

## 🎓 Learning Objectives

By completing this lab, you will be able to:

- ✅ Understand the basic architecture and components of a Kubernetes cluster
- ✅ Use kubectl command-line tool to interact with Kubernetes resources
- ✅ List and examine nodes, namespaces, and pods
- ✅ Deploy Pods and manage their lifecycle
- ✅ Retrieve and analyze Pod logs for troubleshooting
- ✅ Diagnose and resolve connectivity issues within a cluster
- ✅ Apply fundamental Kubernetes concepts in hands-on scenarios

---

## ✅ Prerequisites

### Knowledge Requirements

- Basic understanding of containerization concepts (Docker)
- Familiarity with Linux command-line interface
- Basic knowledge of YAML file structure
- Understanding of networking fundamentals
- **No prior Kubernetes experience required** - this lab guides you through the basics

### Technical Requirements

- Completed **Lab 5** (Minikube installation) OR
- Minikube and kubectl installed on your system
- Running Minikube cluster
- Docker runtime environment

> **💡 Al Nafi Pro Tip:** Simply click **Start Lab** to access a pre-configured cloud machine with all tools ready!

---

## 🖥️ Lab Environment

Your Al Nafi cloud machine includes:

- ✅ Minikube pre-installed and configured
- ✅ kubectl command-line tool ready to use
- ✅ Docker runtime environment
- ✅ All necessary dependencies configured
- ✅ Internet connectivity for downloading container images

---

## 🚀 Lab Tasks

## Task 1: Understanding Your Kubernetes Environment

### Step 1.1: Start Minikube and Verify Cluster Status

Start your Minikube cluster:

```bash
minikube start --driver=docker
```

Check Minikube status:

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

Verify kubectl connectivity:

```bash
kubectl cluster-info
```

---

### Step 1.2: List and Examine Nodes

List all nodes in the cluster:

```bash
kubectl get nodes
```

Get detailed node information:

```bash
kubectl get nodes -o wide
```

Describe a specific node:

```bash
kubectl describe node minikube
```

> **📚 Key Concept:** In Minikube, you have one node acting as both control plane and worker, perfect for learning and development.

---

### Step 1.3: Explore Namespaces

List all namespaces:

```bash
kubectl get namespaces
```

Get detailed namespace information:

```bash
kubectl get namespaces -o wide
```

Describe the default namespace:

```bash
kubectl describe namespace default
```

List namespaces with labels:

```bash
kubectl get ns --show-labels
```

> **📚 Key Concept:** Namespaces organize Kubernetes resources. Common namespaces include `default`, `kube-system`, and `kube-public`.

---

### Step 1.4: List and Examine Pods

List pods in the default namespace:

```bash
kubectl get pods
```

List pods in all namespaces:

```bash
kubectl get pods --all-namespaces
```

List pods with additional information:

```bash
kubectl get pods -o wide --all-namespaces
```

Focus on system pods:

```bash
kubectl get pods -n kube-system
```

---

## Task 2: Deploy and Manage Pods

### Step 2.1: Create a Simple Pod

Create a simple nginx pod:

```bash
kubectl run my-nginx-pod --image=nginx:latest --port=80
```

Verify pod creation:

```bash
kubectl get pods
```

Get detailed pod information:

```bash
kubectl get pod my-nginx-pod -o wide
```

Describe the pod:

```bash
kubectl describe pod my-nginx-pod
```

---

### Step 2.2: Create a Pod Using YAML Manifest

Create a YAML file for a more complex pod:

```bash
cat > test-pod.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: test-app-pod
  labels:
    app: test-app
    environment: lab
spec:
  containers:
  - name: test-container
    image: busybox:latest
    command: ['sh', '-c', 'echo "Hello from Kubernetes Pod!" && sleep 3600']
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
EOF
```

Apply the YAML file:

```bash
kubectl apply -f test-pod.yaml
```

Verify both pods are running:

```bash
kubectl get pods
```

---

### Step 2.3: Retrieve and Analyze Pod Logs

Get logs from the nginx pod:

```bash
kubectl logs my-nginx-pod
```

Get logs from the test-app-pod:

```bash
kubectl logs test-app-pod
```

Follow logs in real-time:

```bash
kubectl logs -f test-app-pod
```
_Press Ctrl+C to stop_

Get logs with timestamps:

```bash
kubectl logs test-app-pod --timestamps
```

Get the last 10 lines of logs:

```bash
kubectl logs test-app-pod --tail=10
```

---

### Step 2.4: Execute Commands Inside Pods

Execute a command in the busybox pod:

```bash
kubectl exec test-app-pod -- ls -la
```

Get an interactive shell:

```bash
kubectl exec -it test-app-pod -- sh
```

Inside the pod shell, try these commands:

```bash
# Check the hostname
hostname

# Check network configuration
ip addr

# Check running processes
ps aux

# Exit the pod shell
exit
```

---

## Task 3: Diagnose Connectivity Issues

### Step 3.1: Create a Service for Pod Access

Expose the nginx pod as a service:

```bash
kubectl expose pod my-nginx-pod --port=80 --target-port=80 --name=nginx-service
```

List services:

```bash
kubectl get services
```

Describe the service:

```bash
kubectl describe service nginx-service
```

---

### Step 3.2: Test Connectivity Between Pods

Create a debug pod for network testing:

```bash
kubectl run debug-pod --image=busybox:latest --rm -it --restart=Never -- sh
```

Inside the debug pod, test connectivity:

```bash
# Test DNS resolution
nslookup nginx-service

# Test HTTP connectivity to the service
wget -qO- nginx-service

# Exit the debug pod
exit
```

---

### Step 3.3: Simulate and Resolve a Connectivity Issue

Create a pod with a wrong image name:

```bash
kubectl run broken-pod --image=nginx:nonexistent-tag
```

Check the pod status:

```bash
kubectl get pods
```

Describe the broken pod to see the issue:

```bash
kubectl describe pod broken-pod
```

Check events:

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

Fix the broken pod:

```bash
kubectl delete pod broken-pod
kubectl run fixed-pod --image=nginx:latest
```

Verify the fix:

```bash
kubectl get pods
kubectl describe pod fixed-pod
```

---

### Step 3.4: Advanced Troubleshooting Techniques

Check resource usage:

```bash
kubectl top nodes
kubectl top pods
```

Get detailed cluster information:

```bash
kubectl get all
```

Check pod resource specifications:

```bash
kubectl get pods -o yaml my-nginx-pod
```

Monitor pod status in real-time:

```bash
kubectl get pods -w
```
_Press Ctrl+C to stop watching_

---

### Step 3.5: Network Policy Testing (Optional Advanced)

Create a network policy that blocks traffic:

```bash
cat > deny-all-policy.yaml << EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
EOF
```

Apply the network policy:

```bash
kubectl apply -f deny-all-policy.yaml
```

Test connectivity (should fail):

```bash
kubectl run test-connectivity --image=busybox:latest --rm -it --restart=Never -- wget -qO- nginx-service
```

Remove the network policy:

```bash
kubectl delete networkpolicy deny-all
```

Test connectivity again (should work):

```bash
kubectl run test-connectivity --image=busybox:latest --rm -it --restart=Never -- wget -qO- nginx-service
```

---

## Task 4: Clean Up Resources

### Step 4.1: Remove Created Resources

Delete pods:

```bash
kubectl delete pod my-nginx-pod
kubectl delete pod test-app-pod
kubectl delete pod fixed-pod
```

Delete services:

```bash
kubectl delete service nginx-service
```

Delete YAML files:

```bash
rm test-pod.yaml deny-all-policy.yaml
```

Verify cleanup:

```bash
kubectl get pods
kubectl get services
```

---

### Step 4.2: Stop Minikube (Optional)

Stop your Minikube cluster:

```bash
minikube stop
```

To start it again later:

```bash
minikube start
```

---

## 🔧 Troubleshooting Guide

### Issue 1: Pod Stuck in Pending State

**Symptoms:** Pod shows status as "Pending"

**Diagnosis:**
```bash
kubectl describe pod <pod-name>
kubectl get events
```

**Common Causes:**
- Insufficient resources
- Image pull issues
- Scheduling constraints

---

### Issue 2: Cannot Connect to Service

**Symptoms:** Connection timeouts or refused connections

**Diagnosis:**
```bash
kubectl get endpoints <service-name>
kubectl describe service <service-name>
```

**Common Causes:**
- Service selector doesn't match pod labels
- Wrong port configuration
- Pod not ready

---

### Issue 3: Image Pull Errors

**Symptoms:** Pod shows "ImagePullBackOff" or "ErrImagePull"

**Diagnosis:**
```bash
kubectl describe pod <pod-name>
```

**Common Causes:**
- Incorrect image name or tag
- Network connectivity issues
- Authentication problems with private registries

---

## 📚 kubectl Command Reference

### Cluster Information
```bash
kubectl cluster-info              # Display cluster information
kubectl get nodes                 # List all nodes
kubectl get namespaces            # List all namespaces
```

### Pod Management
```bash
kubectl get pods                  # List pods in default namespace
kubectl get pods -A               # List pods in all namespaces
kubectl describe pod <name>       # Detailed pod information
kubectl logs <pod-name>           # View pod logs
kubectl logs -f <pod-name>        # Follow pod logs
kubectl exec -it <pod> -- <cmd>   # Execute command in pod
```

### Service Management
```bash
kubectl get services              # List all services
kubectl describe service <name>   # Detailed service information
kubectl expose pod <name> --port=<port>  # Expose pod as service
```

### Troubleshooting Commands
```bash
kubectl get events                # View cluster events
kubectl top nodes                 # Node resource usage
kubectl top pods                  # Pod resource usage
kubectl get all                   # List all resources
kubectl get pods -w               # Watch pod status
```

### Resource Cleanup
```bash
kubectl delete pod <name>         # Delete a pod
kubectl delete service <name>     # Delete a service
kubectl delete -f <file.yaml>     # Delete resources from file
```

---

## 🎓 What You'll Learn

### Key Accomplishments

- ✅ Started and managed a Minikube cluster
- ✅ Mastered essential kubectl commands for cluster interaction
- ✅ Listed and examined nodes, namespaces, and pods
- ✅ Deployed pods using command-line and YAML manifests
- ✅ Retrieved and analyzed logs for troubleshooting
- ✅ Tested network connectivity between pods
- ✅ Diagnosed and resolved common Kubernetes issues

### Why This Matters

**KCNA Certification:** These skills are fundamental for the Kubernetes and Cloud Native Associate certification.

**Real-World Applications:**
- Troubleshooting production issues
- Deploying and managing containerized applications
- Understanding cloud-native architecture
- DevOps and SRE practices

**Career Development:** Kubernetes expertise is essential for modern cloud computing roles.

---

## 🚀 Next Steps

Now that you've completed this lab, continue your Kubernetes journey:

1. **Practice Regularly** - Build muscle memory with kubectl commands
2. **Experiment** - Try different pod configurations and scenarios
3. **Explore Advanced Resources** - Learn about Deployments, StatefulSets, and DaemonSets
4. **Study Networking** - Understand Services, Ingress, and Network Policies
5. **Master Troubleshooting** - Practice diagnosing and fixing issues
6. **Learn Storage** - Explore Persistent Volumes and Storage Classes
7. **Try Helm** - Package and deploy applications using Helm charts

---

## 📚 Additional Resources

- [Kubernetes Official Documentation](https://kubernetes.io/docs/home/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Kubernetes Patterns](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/)

---

## 🤝 Contributing

Found an issue or have suggestions? Feel free to open an issue or submit a pull request.

---

## 📝 License

This lab material is provided for educational purposes.

---

**Lab Version:** 1.0  
**Last Updated:** January 2026  
**Maintainer:** Al Nafi Learning Platform  
**Prerequisites:** Lab 5 - Setting Up Minikube

---

## 📊 Lab Progress Checklist

Track your progress through the lab:

- [ ] Task 1.1: Started Minikube and verified cluster status
- [ ] Task 1.2: Listed and examined nodes
- [ ] Task 1.3: Explored namespaces
- [ ] Task 1.4: Listed and examined pods
- [ ] Task 2.1: Created a simple pod
- [ ] Task 2.2: Created a pod using YAML manifest
- [ ] Task 2.3: Retrieved and analyzed pod logs
- [ ] Task 2.4: Executed commands inside pods
- [ ] Task 3.1: Created a service for pod access
- [ ] Task 3.2: Tested connectivity between pods
- [ ] Task 3.3: Simulated and resolved connectivity issues
- [ ] Task 3.4: Used advanced troubleshooting techniques
- [ ] Task 3.5: (Optional) Tested network policies
- [ ] Task 4.1: Cleaned up resources
- [ ] Task 4.2: (Optional) Stopped Minikube

**Congratulations on completing Lab 6! 🎉**
