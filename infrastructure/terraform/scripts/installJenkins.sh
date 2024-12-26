#!/bin/bash

# Constants
JENKINS_VERSION="stable"
JENKINS_PORT=8080
JAVA_PACKAGE="openjdk-11-jdk"

echo "Starting Jenkins installation on Ubuntu..."

# Update system packages
echo "Updating system packages..."
sudo apt update -y && apt upgrade -y

# Install Java
echo "Installing Java (OpenJDK 11)..."
sudo apt install -y $JAVA_PACKAGE

# Verify Java installation
if ! java -version &>/dev/null; then
    echo "Java installation failed. Exiting."
    exit 1
fi
echo "Java installed successfully."

# Add Jenkins repository and key
echo "Adding Jenkins repository..."
sudo curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian $JENKINS_VERSION binary | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list to include Jenkins
sudo apt update

# Install Jenkins
echo "Installing Jenkins..."
sudo apt install -y jenkins

# Enable and start Jenkins service
echo "Starting and enabling Jenkins service..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Check if Jenkins started successfully
if systemctl status jenkins | grep -q "active (running)"; then
    echo "Jenkins started successfully."
else
    echo "Failed to start Jenkins. Check logs using 'journalctl -u jenkins'."
    exit 1
fi

# Configure firewall to allow Jenkins traffic (if UFW is active)
if ufw status | grep -q "Status: active"; then
    echo "Configuring UFW to allow Jenkins traffic on port $JENKINS_PORT..."
    ufw allow $JENKINS_PORT/tcp
    ufw reload
else
    echo "UFW is not active. Skipping firewall configuration."
fi

# Display initial admin password
echo "Fetching the initial admin password..."
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    echo "Jenkins is installed. Access it at: http://<your-server-ip>:$JENKINS_PORT"
    echo "Initial Admin Password:"
    cat /var/lib/jenkins/secrets/initialAdminPassword
else
    echo "Initial admin password not found. Check Jenkins logs for details."
fi

echo "Jenkins installation completed successfully on Ubuntu."

