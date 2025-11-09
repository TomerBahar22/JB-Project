#  Flask AWS Resource Viewer — CI/CD with Jenkins

This project builds and deploys a **Flask web application** that lists your AWS resources (EC2, VPCs, Load Balancers, AMIs) using a **Jenkins CI/CD pipeline** with Docker integration.

---

##  Requirements
- **kuberetese**  
- **Jenkins** 
- **Docker** and **Docker Compose**
- **Docker Hub** account (for image push)
- **AWS credentials** exported as environment variables:
  ```bash
  export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
  export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
  export AWS_REGION=us-east-1
  ```

---

##  Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/TomerBahar22/Project.git
cd Project
```

### 2. Build and Run Locally
```bash
cd docker_compose
docker-compose up --build
```
Access the Flask app at:
```
http://localhost:5001
```

---

##  Jenkins Pipeline Setup

### 1. Create Jenkins Pipeline
- Open Jenkins → **New Item → Pipeline**
- Set the script path to: `Jenkinsfile`
- Add Docker Hub credentials:
  - ID: `dockerhub-credentials`
  - Variables: `$DOCKERHUB_USR` and `$DOCKERHUB_PSW`

### 2. Run the Pipeline
This pipeline automates testing, scanning, and Docker deployment.

| Stage | Description |
|--------|--------------|
| Clone Repository | Pulls code from GitHub |
| Setup Environment | Installs Python tools and Docker |
| Linting (parallel) | Runs Flake8, Hadolint, ShellCheck |
| Security Scanning (parallel) | Runs Bandit and Trivy |
| Build Docker Image | Builds Flask app image |
| Push to Docker Hub | Publishes image to your repository |

---

##  Verify Pipeline Success
✅ All stages complete successfully  
✅ Docker image pushed to Docker Hub  
✅ Flask app accessible at port **5001**  

---

##  Example Output
```
Successfully built image tomerbahar2/aws-flask-monitor:latest
Pushed to Docker Hub repository: https://hub.docker.com/r/tomerbahar2/aws-flask-monitor
```

---

##  Cleanup
To stop local containers:
```bash
docker-compose down
```

