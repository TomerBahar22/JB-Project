#  Terrafrom EC2 Resource Creator + generate ssh keypair

This project provisions an **AWS EC2 instance** using **Terraform** and automatically generates a secure **SSH key pair** for access.  
---

##  Requirements
- An **AWS account** with EC2 and VPC permissions  
- **Access keys** (Access Key ID + Secret Access Key)  
- Locally installed:
  - [Terraform](https://developer.hashicorp.com/terraform/downloads)
  - Git

---

##  Setup Instructions

### 1. Clone the Repository
```bash
git clone "i will fill this later"
cd 
- export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
- export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
- export AWS_REGION=us-east-1 
terraform init 
terraform apply 
```

### 2. Configure AWS Credentials
```bash
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_KEY"
export AWS_REGION=us-east-1 
```

### 3. Initialize and Apply Terraform
```bash
terraform init 
terraform apply 
```

### 4. Connect to the Instance
chmod your key_pair that will crreated and in the output you will get the ssh command to endter your container with the right varibles
```bash
chmod 600 key_pair.pem
ssh -i key_pair.pem ubuntu@<EC2_PUBLIC_IP>
```

### 2. Install Docker & Git
Update packages, install Docker, and start the service:
```bash
sudo yum update -y
sudo yum install -y docker git
sudo systemctl enable docker
sudo systemctl start docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```



## 🐛 Troubleshooting

- **Always use `sudo`** before Docker commands.  



## Example Terraform Output
Outputs:

instance_id = "i-0ca6f7ae975e0dab1"
instance_public_ip = "98.94.82.95"
ssh_command = "ssh -i builder_key.pem ec2-user@98.94.82.95"
ssh_private_key_path = <sensitive>

## Cleanup
```bash
terraform destroy
```


