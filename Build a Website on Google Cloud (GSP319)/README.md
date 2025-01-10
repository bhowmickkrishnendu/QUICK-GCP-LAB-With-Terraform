# 🚀 Fully Automated GCP Website Deployment (GSP319)

## 🎯 What It Does
This project automates the deployment of a fully functional website on Google Cloud Platform (GCP). It includes the following features:

- Creates a **3-node GKE Cluster**.
- Enables necessary APIs:
  - Cloud Build
  - Google Kubernetes Engine (GKE)
- Builds Docker images for:
  - Monolith service
  - Orders microservice
  - Products microservice
  - Frontend React App
- Deploys and exposes all services using **Kubernetes Deployments** and **LoadBalancer Services**.

---

## 📦 How to Run

### 1. Clone the Repository
```bash
git clone https://github.com/bhowmickkrishnendu/QUICK-GCP-LAB-With-Terraform.git
cd "Build a Website on Google Cloud (GSP319)"/gcp-gke-microservices-deployment
```

### 2. Set Variables
Edit the terraform.tfvars file with your project information:
```bash
project_id = "your-gcp-project-id"
```

### 3. Initialize and Apply Terraform
Run the following commands to initialize and apply the Terraform configuration:
```bash
terraform init
terraform apply -auto-approve
```

### 4. Access the Application
After a few minutes, the frontend LoadBalancer IP will be displayed in the Terraform output. Use this IP to access the deployed application.