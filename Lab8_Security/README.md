# Lab 8: Implementing Security with Authentication, Authorization, and Admission Control

> **Note:** This README contains **instructions only**. YAML file contents are Availle in another files.

---

## 🎯 Objectives

By completing this lab, you will be able to:

* Understand Kubernetes security fundamentals: Authentication, Authorization, Admission Control
* Create and manage Service Accounts
* Implement RBAC using Roles, RoleBindings, and ClusterRoleBindings
* Test authorized vs unauthorized access
* Enforce policies using Admission Controllers (ResourceQuota, NetworkPolicy)
* Validate that security controls are working correctly

---

## ✅ Prerequisites

Before starting, ensure you have:

* Basic Kubernetes knowledge (pods, deployments, services)
* Familiarity with CLI usage
* Understanding of YAML structure (conceptual)
* Basic Linux permissions knowledge
* Working knowledge of `kubectl`

> Al Nafi cloud environment comes pre-configured with Kubernetes and required tools.

---

## 🧪 Lab Environment

The lab environment includes:

* Single-node Kubernetes cluster
* `kubectl` CLI
* Editors (vim, nano)
* Required permissions to complete all tasks

---

## 🛡️ Task 1: Understand Kubernetes Security Architecture

### 1.1 Explore Current Security Context

Run commands to:

* Check current kubeconfig context
* View cluster information
* List all service accounts across namespaces
* Inspect the default service account

### 1.2 Review RBAC Components

* List existing Roles and ClusterRoles
* Inspect a built-in ClusterRole (e.g., `view`)
* List RoleBindings and ClusterRoleBindings

---

## 👥 Task 2: Service Accounts & RBAC Implementation

### 2.1 Create a Dedicated Namespace

* Create a new namespace for the lab
* Set it as the default namespace for your session
* Verify namespace creation

### 2.2 Create Service Accounts

* Create service accounts for:

  * Developer
  * Viewer
  * Admin
* Verify service account creation
* Inspect details of one service account

### 2.3 Create Custom Roles

* Create a **Developer Role** with full access to common resources in the namespace
* Create a **Viewer Role** with read-only permissions
* Apply roles and verify their creation

### 2.4 Create Role Bindings

* Bind Developer Role to Developer Service Account
* Bind Viewer Role to Viewer Service Account
* Bind Admin Service Account to `cluster-admin` role using ClusterRoleBinding
* Verify all bindings

---

## 🔐 Task 3: Test Access Control

### 3.1 Create Test Resources

* Deploy a sample application in the namespace
* Verify pods and deployments

### 3.2 Test Service Account Permissions

* Generate tokens for each service account
* Test actions using each token:

  * Developer: create, list, scale resources
  * Viewer: list-only access
  * Admin: cluster-wide access
* Confirm unauthorized actions fail as expected

### 3.3 Verify Results

* Check which resources were created
* Inspect deployment state after tests

---

## 🚦 Task 4: Admission Controllers

### 4.1 Review Admission Controllers

* Inspect enabled admission controllers
* Create and apply a ResourceQuota in the namespace
* Verify quota enforcement

### 4.2 Test Resource Quota Enforcement

* Attempt to deploy a resource-heavy application
* Observe quota violations
* Review quota usage

### 4.3 Network Policies

* Create network policies to:

  * Deny all ingress traffic by default
  * Allow ingress to specific pods from trusted pods only
* Apply and verify network policies

---

## 🔍 Task 5: Validate Security Implementation

### 5.1 Network Policy Testing

* Deploy an authorized test client pod
* Test connectivity to the application (should succeed)
* Deploy an unauthorized client pod
* Test connectivity again (should fail)

### 5.2 Security Audit

* Review all created resources:

  * Service Accounts
  * Roles
  * RoleBindings
  * ResourceQuotas
  * NetworkPolicies
* Perform final permission tests
* Review quota usage
* Generate a simple summary report using CLI commands

---

## 🧯 Troubleshooting (High-Level)

* Token authentication failures
* RBAC permission issues
* ResourceQuota not enforcing
* NetworkPolicy not blocking traffic
* Verify CNI supports NetworkPolicy

---

## 🧹 Cleanup

* Delete the lab namespace
* Remove cluster-level bindings
* Reset kubectl context to default

---

## 🏁 Conclusion

In this lab, you implemented and validated:

* Authentication using Service Accounts
* Authorization using RBAC
* Admission Control using ResourceQuotas and NetworkPolicies

These practices are essential for:

* Secure Kubernetes clusters
* Least-privilege access
* Multi-tenant environments
* KCNA and real-world production readiness

---

✅ **Lab Complete**
# Lab 8: Implementing Security with Authentication, Authorization, and Admission Control

> **Note:** This README contains **instructions only**. YAML file contents are intentionally omitted.

---

## 🎯 Objectives

By completing this lab, you will be able to:

* Understand Kubernetes security fundamentals: Authentication, Authorization, Admission Control
* Create and manage Service Accounts
* Implement RBAC using Roles, RoleBindings, and ClusterRoleBindings
* Test authorized vs unauthorized access
* Enforce policies using Admission Controllers (ResourceQuota, NetworkPolicy)
* Validate that security controls are working correctly

---

## ✅ Prerequisites

Before starting, ensure you have:

* Basic Kubernetes knowledge (pods, deployments, services)
* Familiarity with CLI usage
* Understanding of YAML structure (conceptual)
* Basic Linux permissions knowledge
* Working knowledge of `kubectl`

> Al Nafi cloud environment comes pre-configured with Kubernetes and required tools.

---

## 🧪 Lab Environment

The lab environment includes:

* Single-node Kubernetes cluster
* `kubectl` CLI
* Editors (vim, nano)
* Required permissions to complete all tasks

---

## 🛡️ Task 1: Understand Kubernetes Security Architecture

### 1.1 Explore Current Security Context

Run commands to:

* Check current kubeconfig context
* View cluster information
* List all service accounts across namespaces
* Inspect the default service account

### 1.2 Review RBAC Components

* List existing Roles and ClusterRoles
* Inspect a built-in ClusterRole (e.g., `view`)
* List RoleBindings and ClusterRoleBindings

---

## 👥 Task 2: Service Accounts & RBAC Implementation

### 2.1 Create a Dedicated Namespace

* Create a new namespace for the lab
* Set it as the default namespace for your session
* Verify namespace creation

### 2.2 Create Service Accounts

* Create service accounts for:

  * Developer
  * Viewer
  * Admin
* Verify service account creation
* Inspect details of one service account

### 2.3 Create Custom Roles

* Create a **Developer Role** with full access to common resources in the namespace
* Create a **Viewer Role** with read-only permissions
* Apply roles and verify their creation

### 2.4 Create Role Bindings

* Bind Developer Role to Developer Service Account
* Bind Viewer Role to Viewer Service Account
* Bind Admin Service Account to `cluster-admin` role using ClusterRoleBinding
* Verify all bindings

---

## 🔐 Task 3: Test Access Control

### 3.1 Create Test Resources

* Deploy a sample application in the namespace
* Verify pods and deployments

### 3.2 Test Service Account Permissions

* Generate tokens for each service account
* Test actions using each token:

  * Developer: create, list, scale resources
  * Viewer: list-only access
  * Admin: cluster-wide access
* Confirm unauthorized actions fail as expected

### 3.3 Verify Results

* Check which resources were created
* Inspect deployment state after tests

---

## 🚦 Task 4: Admission Controllers

### 4.1 Review Admission Controllers

* Inspect enabled admission controllers
* Create and apply a ResourceQuota in the namespace
* Verify quota enforcement

### 4.2 Test Resource Quota Enforcement

* Attempt to deploy a resource-heavy application
* Observe quota violations
* Review quota usage

### 4.3 Network Policies

* Create network policies to:

  * Deny all ingress traffic by default
  * Allow ingress to specific pods from trusted pods only
* Apply and verify network policies

---

## 🔍 Task 5: Validate Security Implementation

### 5.1 Network Policy Testing

* Deploy an authorized test client pod
* Test connectivity to the application (should succeed)
* Deploy an unauthorized client pod
* Test connectivity again (should fail)

### 5.2 Security Audit

* Review all created resources:

  * Service Accounts
  * Roles
  * RoleBindings
  * ResourceQuotas
  * NetworkPolicies
* Perform final permission tests
* Review quota usage
* Generate a simple summary report using CLI commands

---

## 🧯 Troubleshooting (High-Level)

* Token authentication failures
* RBAC permission issues
* ResourceQuota not enforcing
* NetworkPolicy not blocking traffic
* Verify CNI supports NetworkPolicy

---

## 🧹 Cleanup

* Delete the lab namespace
* Remove cluster-level bindings
* Reset kubectl context to default

---

## 🏁 Conclusion

In this lab, you implemented and validated:

* Authentication using Service Accounts
* Authorization using RBAC
* Admission Control using ResourceQuotas and NetworkPolicies

These practices are essential for:

* Secure Kubernetes clusters
* Least-privilege access
* Multi-tenant environments
* KCNA and real-world production readiness

---

✅ **Lab Complete**
# Lab 8: Implementing Security with Authentication, Authorization, and Admission Control

> **Note:** This README contains **instructions only**. YAML file contents are intentionally omitted.

---

## 🎯 Objectives

By completing this lab, you will be able to:

* Understand Kubernetes security fundamentals: Authentication, Authorization, Admission Control
* Create and manage Service Accounts
* Implement RBAC using Roles, RoleBindings, and ClusterRoleBindings
* Test authorized vs unauthorized access
* Enforce policies using Admission Controllers (ResourceQuota, NetworkPolicy)
* Validate that security controls are working correctly

---

## ✅ Prerequisites

Before starting, ensure you have:

* Basic Kubernetes knowledge (pods, deployments, services)
* Familiarity with CLI usage
* Understanding of YAML structure (conceptual)
* Basic Linux permissions knowledge
* Working knowledge of `kubectl`

> Al Nafi cloud environment comes pre-configured with Kubernetes and required tools.

---

## 🧪 Lab Environment

The lab environment includes:

* Single-node Kubernetes cluster
* `kubectl` CLI
* Editors (vim, nano)
* Required permissions to complete all tasks

---

## 🛡️ Task 1: Understand Kubernetes Security Architecture

### 1.1 Explore Current Security Context

Run commands to:

* Check current kubeconfig context
* View cluster information
* List all service accounts across namespaces
* Inspect the default service account

### 1.2 Review RBAC Components

* List existing Roles and ClusterRoles
* Inspect a built-in ClusterRole (e.g., `view`)
* List RoleBindings and ClusterRoleBindings

---

## 👥 Task 2: Service Accounts & RBAC Implementation

### 2.1 Create a Dedicated Namespace

* Create a new namespace for the lab
* Set it as the default namespace for your session
* Verify namespace creation

### 2.2 Create Service Accounts

* Create service accounts for:

  * Developer
  * Viewer
  * Admin
* Verify service account creation
* Inspect details of one service account

### 2.3 Create Custom Roles

* Create a **Developer Role** with full access to common resources in the namespace
* Create a **Viewer Role** with read-only permissions
* Apply roles and verify their creation

### 2.4 Create Role Bindings

* Bind Developer Role to Developer Service Account
* Bind Viewer Role to Viewer Service Account
* Bind Admin Service Account to `cluster-admin` role using ClusterRoleBinding
* Verify all bindings

---

## 🔐 Task 3: Test Access Control

### 3.1 Create Test Resources

* Deploy a sample application in the namespace
* Verify pods and deployments

### 3.2 Test Service Account Permissions

* Generate tokens for each service account
* Test actions using each token:

  * Developer: create, list, scale resources
  * Viewer: list-only access
  * Admin: cluster-wide access
* Confirm unauthorized actions fail as expected

### 3.3 Verify Results

* Check which resources were created
* Inspect deployment state after tests

---

## 🚦 Task 4: Admission Controllers

### 4.1 Review Admission Controllers

* Inspect enabled admission controllers
* Create and apply a ResourceQuota in the namespace
* Verify quota enforcement

### 4.2 Test Resource Quota Enforcement

* Attempt to deploy a resource-heavy application
* Observe quota violations
* Review quota usage

### 4.3 Network Policies

* Create network policies to:

  * Deny all ingress traffic by default
  * Allow ingress to specific pods from trusted pods only
* Apply and verify network policies

---

## 🔍 Task 5: Validate Security Implementation

### 5.1 Network Policy Testing

* Deploy an authorized test client pod
* Test connectivity to the application (should succeed)
* Deploy an unauthorized client pod
* Test connectivity again (should fail)

### 5.2 Security Audit

* Review all created resources:

  * Service Accounts
  * Roles
  * RoleBindings
  * ResourceQuotas
  * NetworkPolicies
* Perform final permission tests
* Review quota usage
* Generate a simple summary report using CLI commands

---

## 🧯 Troubleshooting (High-Level)

* Token authentication failures
* RBAC permission issues
* ResourceQuota not enforcing
* NetworkPolicy not blocking traffic
* Verify CNI supports NetworkPolicy

---

## 🧹 Cleanup

* Delete the lab namespace
* Remove cluster-level bindings
* Reset kubectl context to default

---

## 🏁 Conclusion

In this lab, you implemented and validated:

* Authentication using Service Accounts
* Authorization using RBAC
* Admission Control using ResourceQuotas and NetworkPolicies

These practices are essential for:

* Secure Kubernetes clusters
* Least-privilege access
* Multi-tenant environments
* KCNA and real-world production readiness

---

✅ **Lab Complete**

