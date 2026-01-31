# 🚀 Kubernetes Lab 10: Deploying a Stand-Alone Application

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![NGINX](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![Minikube](https://img.shields.io/badge/Minikube-Lab-blue)

## 📖 Overview
This project demonstrates the end-to-end process of deploying a stand-alone NGINX application on a Kubernetes cluster. It covers creating deployment manifests, exposing the application via a NodePort service, managing resources (requests/limits), and customizing web content using ConfigMaps. 

This lab serves as a practical preparation exercise for the **KCNA (Kubernetes and Cloud Native Associate)** certification.

## 🎯 Objectives
By completing this lab, the following skills are demonstrated:
* **Deployment Management:** Creating and deploying Kubernetes manifests with multiple replicas.
* **Networking:** Configuring **NodePort** services to expose applications externally.
* **Resource Management:** setting CPU/Memory requests and limits.
* **Configuration:** Injecting custom data using **ConfigMaps**.
* **Observability:** Monitoring logs, metrics, and analyzing Pod/Service health.

## 🛠️ Prerequisites
* **Kubernetes Cluster:** Minikube (v1.28.3+ recommended)
* **Command Line:** `kubectl` configured
* **OS:** Linux (Ubuntu 20.04 LTS used in this lab)
* **Knowledge:** Docker basics, YAML syntax, and networking fundamentals.

---

## 📂 Repository Structure
```text
.
├── nginx-deployment.yaml          # Initial Deployment Manifest
├── nginx-service.yaml             # NodePort Service Manifest
├── custom-index.html              # Custom HTML content
├── nginx-deployment-updated.yaml  # Updated Deployment with ConfigMap
└── README.md
🚀 Deployment Steps1. Create the DeploymentWe deploy NGINX (v1.25.3) with 3 replicas and specific resource constraints.Command:Bashkubectl apply -f nginx-deployment.yaml
Manifest Highlights (nginx-deployment.yaml):Replicas: 3Resources: * Request: 64Mi Memory / 250m CPULimit: 128Mi Memory / 500m CPU2. Expose the Application (NodePort)To access the application from outside the cluster, we create a Service mapping port 80 to NodePort 30080.Command:Bashkubectl apply -f nginx-service.yaml
Access the App:Bashcurl http://$(minikube ip):30080
3. Monitoring & MetricsOnce running, we can monitor the health and resource usage of the pods.View Logs: kubectl logs -l app=nginx-standaloneCheck Resource Usage: kubectl top pods -l app=nginx-standaloneWatch Status: kubectl get pods -l app=nginx-standalone -w4. Customizing with ConfigMapsInstead of rebuilding the Docker image to change the HTML, we inject a custom index.html file.Create the HTML file:Bash# (Content provided in custom-index.html)
Create the ConfigMap:Bashkubectl create configmap nginx-custom-html --from-file=index.html=custom-index.html
Apply Updated Deployment:Bashkubectl apply -f nginx-deployment-updated.yaml
Verify Update:Refresh your browser or run curl http://$(minikube ip):30080 to see the new dashboard.🔧 Troubleshooting Common IssuesIssuePotential CauseFixPods PendingInsufficient CPU/Memory on NodeCheck kubectl describe nodes and adjust resource requests.ImagePullBackOffNetwork or Typo in Image NameCheck internet connection and image spelling (nginx:1.25.3).Service InaccessibleMinikube Tunnel or FirewallRun minikube tunnel or check security groups.🧹 CleanupTo remove all resources created during this lab:Bashkubectl delete service nginx-standalone-service
kubectl delete deployment nginx-standalone-app
kubectl delete configmap nginx-custom-html
📝 ConclusionThis lab establishes the foundational knowledge required for production Kubernetes deployments. Understanding the relationship between Deployments (state), Services (networking), and ConfigMaps (configuration) is essential for Cloud-Native roles, including DevOps and SRE.
