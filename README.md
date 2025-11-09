#  Python EC2 Resource Viewer (Helm on Kubernetes)

This project provides a simple **Flask + boto3** web application, containerized and deployed to **Kubernetes using Helm**.  
When deployed, the app can display available resources in your AWS account.  

---

##  Requirements
- **Kubernetes Cluster** (minikube, kind, EKS, GKE, AKS, etc.)  
- **kubectl** CLI configured to access your cluster  
- **Helm 3** installed  
- **AWS credentials** stored as Kubernetes Secrets (with permission to list EC2 resources)  
- **Container Registry** (e.g. Docker Hub, ECR, GCR) for your app image  

---

##  Setup Instructions

### 1. Clone the Repository (K8S branch)
```bash
git clone -b K8S https://github.com/TomerBahar22/Project.git
cd Project/charts/flask-aws-monitor
```

---

### Or pull image from Docker Hub ([Docker Image](https://hub.docker.com/r/tomerbahar2/python-web))
```bash
docker pull tomerbahar2/python-web
```

---

### 2. Configure Values
Edit `values.yaml` to match your setup:
```yaml
image:
  repository: <your-registry>/python-web
  tag: latest

aws:
  region: us-east-1
  # accessKey and secretKey should come from a Kubernetes Secret or from the representing field 
```

---

### 3. Deploy with Helm
Install the Helm chart into your cluster:
```bash
helm install flask-aws-monitor ./flask-aws-monitor
```

Check resources:
```bash
kubectl get pods
kubectl get svc
```

---

## 🌐 Access the App
Depending on your Service type:

- **LoadBalancer**:  
  ```bash
  kubectl get svc flask-aws-monitor
  ```
  Then open `http://<EXTERNAL-IP>:5001`

- **Ingress**: use the configured hostname in your ingress rules  

- **NodePort**: access via `<NodeIP>:<NodePort>`  

![Architecture Diagram](snapshot.png)

---

## 🐛 Troubleshooting

- Check pod logs:
  ```bash
  kubectl logs -l app.kubernetes.io/name=flask-aws-monitor
  ```
- Describe resources:
  ```bash
  kubectl describe deployment flask-aws-monitor
  kubectl describe svc flask-aws-monitor
  ```
- Test in cluster:
  ```bash
  kubectl port-forward svc/flask-aws-monitor 5001:5001
  curl http://127.0.0.1:5001/
  ```
- Verify AWS credentials Secret is mounted correctly.  

---

✅ With this Helm setup, your Flask app will be up and accessible through your Kubernetes cluster’s **LoadBalancer, Ingress, or NodePort** depending on your configuration.  
