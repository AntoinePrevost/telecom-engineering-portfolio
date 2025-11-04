# Quick Deployment Guide

## Prerequisites
- AWS CLI configured with proper permissions (EC2, Route53, IAM)
- Terraform and Ansible installed
- Domain name with Route 53 hosted zone
- Existing VPC in AWS

## Configuration
Create `terraform/terraform.tfvars`:
```hcl
vpc_name = "your-vpc-name"
zone_dns = "your-domain.com"
site_name = "streaming"
nombre_instance_front = 2
nombre_instance_back = 1
# Add other required variables
```

## Deployment

### 1. Deploy Infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Configure Services
```bash
cd ../ansible/ansible-project
ansible-playbook -i inventory.ini playbook.yaml
```

### 3. Verify Deployment
```bash
# Test DNS resolution
nslookup streaming.your-domain.com

# Test HTTPS access
curl -I https://streaming.your-domain.com

# SSH to bastion for service checks
ssh -i terraform/streaming-bastion-key.pem ubuntu@<BASTION_IP>
```

## Scaling & Maintenance

### Scale Infrastructure
```bash
# Update instance count in terraform.tfvars
nombre_instance_front = 3
terraform apply
ansible-playbook -i inventory.ini playbook.yaml --limit server-front
```

### Key Operations
- **SSL Renewal**: Automatic via Let's Encrypt
- **Monitoring**: Check `/var/log/nginx/` logs via bastion
- **Updates**: `ansible all -i inventory.ini -m apt -a "upgrade=yes" --become`
- **Backup**: `terraform show > backup.txt`