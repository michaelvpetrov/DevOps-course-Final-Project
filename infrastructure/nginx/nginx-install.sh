#!/bin/bash

##################################################
### ### ###  #  ### ### ##    
#   ### ##  ###  #  ##  # # BY Michael Petrov 
### # # ### # #  #  ### ##
##################################################
echo "Starting NGINX installation on Ubuntu..."

# Update system packages
echo "Updating system packages..."
sudo apt update -y && apt upgrade -y

# Install NGINX
echo "Installing NGINX..."
sudo apt install -y nginx

# Check if NGINX was installed successfully
if ! nginx -v &>/dev/null; then
    echo "NGINX installation failed. Exiting."
    exit 1
fi

echo "NGINX installed successfully."

# Enable and start NGINX service
echo "Starting and enabling NGINX service..."
sudo systemctl enable nginx
sudo systemctl start nginx

# Check if the service is running
if systemctl status nginx | grep -q "active (running)"; then
    echo "NGINX is running."
else
    echo "Failed to start NGINX. Check logs using 'journalctl -u nginx'."
    exit 1
fi

# Test NGINX
echo "Testing NGINX configuration..."
if nginx -t; then
    echo "NGINX configuration is valid."
else
    echo "NGINX configuration test failed. Check logs."
    exit 1
fi

# Print completion message with access info
IP=$(curl -s ifconfig.me || echo "your server IP")
echo "NGINX installation and configuration completed successfully."
echo "You can access the default page at: http://$IP"
