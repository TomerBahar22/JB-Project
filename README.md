# 🧩 AWS Resource Automation — Terraform, Docker, Jenkins, ArgoCd, and Helm 

This repository demonstrates a **complete DevOps workflow** for deploying a **Flask + boto3 web application** that visualizes your AWS resources (EC2, VPCs, Load Balancers, and AMIs).  
The project is divided into four major stages:

1. **Terraform EC2 Provisioning** — create an EC2 instance and generate SSH key pair  
2. **Dockerized Flask App** — run the AWS Resource Viewer inside Docker  
3. **CI/CD Pipeline with Jenkins** — automate build, lint, security scan, and image push  
4. **Helm on Kubernetes** — deploy the containerized app to a Kubernetes cluster  
5. **ArgoCd Continuous Delivery** - continuously monitor Git changes and auto-sync deployments
---

## 🧱 1. Terraform EC2 Resource Creator
Provisions an **EC2 instance** and generates an **SSH key pair** automatically.

### Requirements
- AWS account and IAM permissions for EC2 & VPC  
- Terraform installed locally  
- Access/Secret keys exported as environment variables  

### Setup
```bash
git clone https://github.com/TomerBahar22/JB-Project.git
cd JB-Project/Terraform/
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
export AWS_REGION=us-east-1

terraform init
terraform apply
```

### Connect to Instance
```bash
chmod 600 builder_key.pem
ssh -i builder_key.pem ubuntu@<EC2_PUBLIC_IP>
```

### Install Docker & Docker Compose
```bash
sudo yum update -y
sudo yum install -y docker git
sudo systemctl enable --now docker
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker --version
docker compose version
```

### Cleanup
```bash
terraform destroy
```

---

## 🐳 2. Dockerized Flask AWS Resource Viewer
Runs a **Flask + boto3** web app inside Docker on your EC2 instance.

### Requirements
- EC2 instance from step 1  
- Open ports:
  - **22** for SSH
  - **5001** for web access  
- Docker & Git installed

### Deploy the App
```bash
git clone https://github.com/TomerBahar22/JB-Project.git #if you havent already 
cd JB-Project/
sudo docker build -t python-web:latest .
sudo docker run -d -p 5001:5001   -e AWS_ACCESS_KEY_ID=<your_access_key>   -e AWS_SECRET_ACCESS_KEY=<your_secret_key>   -e AWS_DEFAULT_REGION=us-east-1   python-web:latest
```

### Access
Visit:
```
http://<EC2_PUBLIC_IP>:5001/
```

### Troubleshooting
- Always use `sudo` with Docker commands.  
- Check logs with `sudo docker logs <container_id>`.  
- Validate the container is running:
  ```bash
  sudo docker ps
  ```

---

## ⚙️ 3. Jenkins CI/CD Integration
Automates build, test, lint, scan, and Docker push using **Jenkins**.

### Requirements
- Jenkins server (on EC2 or Kubernetes)  
- Docker, Docker Compose  
- Docker Hub credentials saved in Jenkins  

### Pipeline Overview
| Stage | Description |
|--------|--------------|
| Clone Repository | Pull code from GitHub |
| Setup Environment | Install dependencies |
| Linting | Run Flake8, Hadolint, ShellCheck |
| Security Scanning | Run Bandit, Trivy |
| Build Image | Build Flask app Docker image |
| Push to Docker Hub | Publish image to Docker Hub |

### Run Pipeline
- Configure credentials (`dockerhub-credentials`)  
- Run Jenkins job with `Jenkinsfile`  
- Verify the image is pushed to your Docker Hub repo.

```bash
Successfully built image tomerbahar2/aws-flask-monitor:latest
Pushed to https://hub.docker.com/r/tomerbahar2/aws-flask-monitor
```

---

## ☸️ 4. Helm Deployment on Kubernetes
Deploys the Dockerized app to **Kubernetes** via Helm chart.

### Requirements
- Kubernetes cluster (minikube, EKS, GKE, etc.)
- `kubectl` and `helm` installed
- AWS credentials stored as Kubernetes Secrets
- Container registry (Docker Hub / ECR)

### Deploy
```bash
git clone https://github.com/TomerBahar22/JB-Project.git #if you havent already 
cd JB-Project/charts/flask-aws-monitor

helm install flask-aws-monitor ./flask-aws-monitor
kubectl get pods
kubectl get svc
```

### Access
- **LoadBalancer**:  
  ```bash
  kubectl get svc flask-aws-monitor
  ```
  Open `http://<EXTERNAL-IP>:5001`
- **Ingress**: use configured hostname  
- **NodePort**: `<NodeIP>:<NodePort>`

---

##  5. ArgoCD Continuous Delivery (GitOps)
**ArgoCD** handles the Continuous Delivery layer of this stack.
Once Jenkins updates your Helm chart (for example, a new Docker image tag), ArgoCD automatically detects the Git change and redeploys the application

### Requirements
- Kubernetes cluster (minikube, EKS, GKE, etc.)
- `kubectl` and `helm` installed

### Deploy
```bash
kubectl create namespace argocd
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd

kubectl port-forward svc/argocd-server -n argocd 8080:443 #Open https://localhost:8080

kubectl -n argocd get secret argocd-initial-admin-secret \ 
  -o jsonpath="{.data.password}" | base64 -d; echo #Get admin Password , Username: admin


git clone https://github.com/TomerBahar22/JB-Project.git #if you havent already 
kubectl apply -f argocd-app.yaml -n argocd
```

## 🧩 Architecture Overview
```text
Terraform  ->  AWS EC2  ->  Dockerized Flask App  ->  Jenkins CI/CD  -> Helm -> ArgoCd  ->  Kubernetes 
```

![Architecture Diagram](snapshot.png)

---

## 🧹 Troubleshooting
- Terraform: check AWS credentials and permissions  
- Docker: confirm service active & port open  
- Jenkins: verify credentials and pipeline syntax  
- Kubernetes: ensure Secrets and Helm values.yaml are correct 
- ArgoCD: if stuck “OutOfSync,” run: 
```bash  
argocd app sync flask-aws-monitor --grpc-web
```

---

## 🧾 License
This project is licensed under the MIT License.
