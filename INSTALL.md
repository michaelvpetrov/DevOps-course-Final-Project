
# **Installation Guide for CI/CD Infrastructure**

This document provides detailed steps to set up and configure the CI/CD infrastructure, including Jenkins, worker nodes, monitoring tools, and backups.

---

## **Prerequisites**

Ensure the following requirements are met:
1. AWS account with proper IAM permissions.
2. A Linux-based control machine with the following tools installed:
   - Terraform
   - Ansible
   - Docker
   - Kubernetes CLI (`kubectl`)
   - AWS CLI
3. SSH access to the target servers.
4. Open required ports in your firewall (80, 443, 22, etc.).

---

## **1. Infrastructure Setup**

### **1.1. Configure Infrastructure with Terraform**
1. Navigate to the Terraform directory:
   ```bash
   cd infrastructure/terraform
   ```
2. Update the `variables.tf` file with your AWS configurations:
   - Define region, VPC CIDR, instance types, and other required parameters.

3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Preview the changes:
   ```bash
   terraform plan
   ```
5. Apply the configuration:
   ```bash
   terraform apply
   ```
   - This will provision the VPC, subnets, route tables, security groups, and EC2 instances.

---

## **2. Jenkins Installation**

### **2.1. Install Jenkins on the Master Node**
1. SSH into the Jenkins master server:
   ```bash
   ssh -i ~/.ssh/your-key.pem ubuntu@<jenkins-master-ip>
   ```
2. Run the Jenkins installation script:
   ```bash
   sudo ./scripts/installJenkins.sh
   ```

3. Access Jenkins:
   - Open your browser and navigate to `http://<jenkins-master-ip>:8080`.
   - Use the initial admin password (found in `/var/lib/jenkins/secrets/initialAdminPassword`) to log in.

---

## **3. Add Worker Nodes**

1. SSH into each worker node:
   ```bash
   ssh -i ~/.ssh/your-key.pem ubuntu@<worker-node-ip>
   ```
2. Run the worker installation script:
   ```bash
   sudo ./infrastructure/scripts/install_worker.sh
   ```

3. Verify the worker nodes in the Jenkins UI:
   - Navigate to **Manage Jenkins > Nodes and Clouds**.

---

## **4. Monitoring Setup**

### **4.1. ELK Stack**
1. Install Elasticsearch, Logstash, and Kibana on the monitoring server:
   ```bash
   sudo apt install elasticsearch logstash kibana
   ```
2. Configure Filebeat on Jenkins servers using the provided `filebeat.yml` configuration.

3. Start and enable the ELK services:
   ```bash
   sudo systemctl start elasticsearch logstash kibana
   sudo systemctl enable elasticsearch logstash kibana
   ```

4. Access Kibana at:
   ```
   http://<kibana-server-ip>:5601
   ```

---

## **5. Backup Configuration**

1. Use `artifact-backup.sh` to back up Jenkins artifacts:
   ```bash
   ./backups/artifact-backup.sh
   ```

2. Use `restore-artifacts.sh` to restore backups:
   ```bash
   ./backups/restore-artifacts.sh
   ```

---

## **6. Testing**

1. Verify Jenkins pipelines by running test builds for development and staging.
2. Check monitoring dashboards in Grafana and Kibana.
3. Simulate a disaster recovery scenario to validate backups.

---

## **Post-Installation Notes**

- Update `hosts.ini` to manage the infrastructure with Ansible.
- Configure security group rules as needed.
- Document any customizations made during setup.

For further assistance, refer to the `troubleshooting.md` file.
