#!/bin/bash

# Constants
JENKINS_VERSION="stable"
JENKINS_PORT=8080
JAVA_PACKAGE="openjdk-11-jdk"

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

echo "Starting Jenkins installation on Ubuntu..."

# Update system packages
echo "Updating system packages..."
apt update -y && apt upgrade -y

# Install Java
echo "Installing Java (OpenJDK 11)..."
apt install -y $JAVA_PACKAGE

# Verify Java installation
if ! java -version &>/dev/null; then
    echo "Java installation failed. Exiting."
    exit 1
fi
echo "Java installed successfully."

# Add Jenkins repository and key
echo "Adding Jenkins repository..."
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian $JENKINS_VERSION binary | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list to include Jenkins
apt update

# Install Jenkins
echo "Installing Jenkins..."
apt install -y jenkins

# Enable and start Jenkins service
echo "Starting and enabling Jenkins service..."
systemctl enable jenkins
systemctl start jenkins

# Check if Jenkins started successfully
if systemctl status jenkins | grep -q "active (running)"; then
    echo "Jenkins started successfully."
else
    echo "Failed to start Jenkins. Check logs using 'journalctl -u jenkins'."
    exit 1
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

