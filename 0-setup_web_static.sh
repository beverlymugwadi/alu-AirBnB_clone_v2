#!/usr/bin/env bash
# Web static deployment script

# Update and upgrade the system
sudo apt-get -y update
sudo apt-get -y upgrade

# Install NGINX if not already installed
sudo apt-get -y install nginx

# Create directories for the web static deployment
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create a test HTML file
echo "Hello, this is a test HTML file." | sudo tee /data/web_static/releases/test/index.html

# Remove any existing symbolic link and create a new one
sudo rm -rf /data/web_static/current
sudo ln -s /data/web_static/releases/test/ /data/web_static/current

# Give ownership of the /data/ directory to the ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Check if the location block already exists in the configuration file
if ! sudo grep -q "location /hbnb_static" /etc/nginx/sites-available/default; then
    # Add the location block if it doesn't exist
    sudo sed -i '/listen 80 default_server;/a location /hbnb_static {\n\talias /data/web_static/current/;\n}' /etc/nginx/sites-available/default
fi

# Test the NGINX configuration for syntax errors
sudo nginx -t

# If NGINX config test passes, restart NGINX
if [ $? -eq 0 ]; then
    sudo service nginx restart
else
    echo "Error: NGINX configuration test failed. Please fix the issues before restarting."
fi

# Exit successfully
exit 0
