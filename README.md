# **CI/CD Infrastructure Project**

This project automates the setup of a CI/CD pipeline with a Jenkins server, worker nodes, backup mechanisms, monitoring tools, and a comprehensive infrastructure management approach. It uses tools like Terraform, Ansible, Kubernetes, and custom scripts to deploy and manage the pipeline.

---

## **Key Features**

- **Automated CI/CD Pipelines**
  - Pipelines for development, staging, production, nightly builds, and data workflows.

- **Infrastructure as Code (IaC)**
  - **Terraform**: Configures AWS resources like VPCs, subnets, route tables, and security groups.
  - **Ansible**: Manages Jenkins configuration and deployment.

- **Monitoring**
  - Integrates Elasticsearch for log monitoring.

- **Backup and Restore**
  - Scripts for artifact backups and restoration to ensure data integrity.

- **Worker Node Management**
  - Automated scripts for adding and managing Jenkins worker nodes.

- **NGINX Setup**
  - Script for installing and configuring NGINX as a reverse proxy.

---

## **Setup Instructions**

### **Prerequisites**
- AWS account with IAM credentials.
- A Linux-based machine with the following tools installed:
  - Terraform
  - Ansible
  - Docker
  - Kubernetes CLI (`kubectl`)

### **Step 1: Configure Infrastructure**
1. Navigate to the `infrastructure/terraform/` directory.
2. Update `variables.tf` with your AWS configurations.
3. Run the following commands:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### **Step 2: Deploy Jenkins**
1. Use `scripts/installJenkins.sh` to set up Jenkins on the server:
   ```bash
   sudo ./scripts/installJenkins.sh
   ```
2. Add worker nodes using `infrastructure/scripts/add-worker.sh`.

### **Step 3: Configure Pipelines**
1. Navigate to the Jenkins UI.
2. Import pipeline scripts from the `pipelines/` directory.

### **Step 4: Set Up Monitoring**
1. Deploy the ELK stack using the configurations in `monitoring/elk/`.
1.1 Use script to install necessary files on server:
   ```bash
	sudo apt-get update
	sudo apt-get install filebeat
	sudo systemctl start filebeat
	sudo systemctl enable filebeat
   ```
   Replace the default /etc/filebeat/filebeat.yml with the filebeat.yml configuration
2. Use `filebeat.yml` to monitor Jenkins logs.
3. Deploy Logstash:
	- Install Logstash on the monitoring server.
	- Save logstash.conf to /etc/logstash/conf.d/logstash.conf
	- Run Logstash:
	```bash
		sudo systemctl start logstash
		sudo systemctl enable logstash
	```

### **Step 5: Backups**
1. Use `backups/artifact-backup.sh` to back up Jenkins artifacts.
2. Restore artifacts using `backups/restore-artifacts.sh`.

---

## **Scripts Overview**

- **`installJenkins.sh`**
  - Automates the installation and configuration of Jenkins on Ubuntu.
  
- **`install_worker.sh`**
  - Sets up Jenkins worker nodes and associates them with the Jenkins master.

- **`install_nginx.sh`**
  - Installs and configures NGINX as a reverse proxy for Jenkins.

- **`add-worker.sh`**
  - Adds new worker nodes to Jenkins dynamically.

- **`health-check.sh`**
  - Monitors the health of Jenkins servers and worker nodes.

---

## **Documentation**

- **`dr-strategy.md`**
  - Disaster recovery plan for ensuring business continuity.

- **`monitoring-setup.md`**
  - Instructions for setting up the ELK stack.

- **`troubleshooting.md`**
  - Solutions for common issues encountered during deployment and operation.

---

## **Contributing**

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature-name`.
3. Commit your changes: `git commit -m "Feature description"`.
4. Push to your branch: `git push origin feature-name`.
5. Create a pull request.

---

## **License**

This project is licensed under the MIT License. See the `LICENSE` file for details.
