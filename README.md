# EKS Cluster Deployment with ArgoCD, Helm Charts, Cert-Manager, and ExternalDNS

## Overview
This project focuses on deploying an **EKS (Elastic Kubernetes Service)** cluster on AWS, integrating key Kubernetes tools such as **ArgoCD**, **Helm Charts**, **Cert-Manager**, and **ExternalDNS**. The goal is to achieve a robust, automated, and scalable infrastructure setup with streamlined GitOps workflows, secure certificate management, and automated DNS updates.

> **Note:** This project is currently **under development** and subject to continuous updates.

## Key Features
- **Amazon EKS:** Managed Kubernetes service for running containerized applications at scale with high availability, security, and seamless AWS integration.
- **ArgoCD:** Declarative GitOps continuous delivery tool for Kubernetes, enabling automatic application deployment from Git repositories.
- **Helm Charts:** Simplifies the deployment and management of complex Kubernetes applications using reusable, version-controlled charts.
- **Cert-Manager:** Automates the management and issuance of TLS/SSL certificates within Kubernetes, integrated with ACME for automated renewals.
- **ExternalDNS:** Dynamically manages DNS records in AWS Route 53 based on Kubernetes resources, automating DNS record creation and updates.

## Why This Setup Matters
- **GitOps with ArgoCD:** Ensures consistent, version-controlled deployments through automated Git synchronization.
- **Scalable Infrastructure:** Utilizes EKS for auto-scaling and high availability.
- **Secure Communication:** Implements TLS/SSL for encrypted traffic with Cert-Manager.
- **Automated DNS Management:** ExternalDNS reduces manual effort by automating DNS configurations.

## Infrastructure Components
- **VPC (Virtual Private Cloud):** Provides a secure, isolated network environment for the cluster.
- **EKS (Elastic Kubernetes Service):** Manages the Kubernetes control plane and worker nodes.
- **ArgoCD:** Manages application deployments based on Git repositories.
- **Helm:** Deploys and manages Kubernetes resources using Helm charts.
- **Cert-Manager:** Handles SSL/TLS certificate issuance and renewal.
- **ExternalDNS:** Automates DNS record updates in AWS Route 53.

## Setup Instructions

### 1. Clone the Repository
```bash
git clone [repo-url]
cd [repo-directory]
```

### 2. Provision EKS Cluster with Terraform
```bash
terraform init
terraform plan
terraform apply
```
This command initializes Terraform, previews the infrastructure changes, and deploys the EKS cluster along with networking components.

### 3. Configure kubectl
```bash
aws eks --region <region> update-kubeconfig --name <cluster-name>
kubectl get nodes
```
Ensure the EKS cluster is active and nodes are ready.

### 4. Install ArgoCD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
To access the ArgoCD UI:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
Open `http://localhost:8080` in your browser.

### 5. Deploy Applications with Helm
```bash
helm repo add [chart-repo-name] [chart-repo-url]
helm install [release-name] [chart-name] -n [namespace]
```

### 6. Setup Cert-Manager
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
```
Configure issuers for certificate management (e.g., Let's Encrypt).

### 7. Configure ExternalDNS
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install externaldns bitnami/external-dns -n kube-system \
  --set provider=aws \
  --set aws.zoneType=public \
  --set policy=upsert-only
```
Ensure proper IAM permissions are in place for Route 53 updates.

## Clean-Up Resources
```bash
terraform destroy
```
This command will tear down the entire infrastructure.

## Future Changes
- **CI/CD Pipeline:** Automate deployment workflows using GitHub Actions.
- **Auto-Scaling:** Implement cluster auto-scaling policies.
- **Monitoring & Observability:** Integrate Prometheus, Grafana, and Loki for monitoring.
- **RBAC & Security Hardening:** Enhance security with fine-grained access control.

## Conclusion
This project aims to establish a modern Kubernetes ecosystem on AWS using EKS, with GitOps practices powered by ArgoCD, secure traffic management via Cert-Manager, and automated DNS configurations using ExternalDNS. Continuous improvements will be made as the project evolves.

