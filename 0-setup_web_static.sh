#!/usr/bin/env bash
# Web static deployment script

set -e  # Exit immediately if a command exits with a non-zero status
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install nginx
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared
echo "Hello, this is a test HTML file." | sudo tee /data/web_static/releases/test/index.html
sudo rm -rf /data/web_static/current
sudo ln -s /data/web_static/releases/test/ /data/web_static/current
sudo chown -R ubuntu:ubuntu /data/

# Check if the location block already exists in the configuration file
if ! sudo grep -q "location /hbnb_static" /etc/nginx/sites-available/default; then
    echo "Adding location block to NGINX configuration..."
    # Add the location block if it doesn't exist
    sudo sed -i '/listen 80 default_server;/a location /hbnb_static {\n\talias /data/web_static/current/;\n}' /etc/nginx/sites-available/default
else
    echo "Location block already exists."
fi

sudo nginx -t

# If NGINX config test passes, restart NGINX
if [ $? -eq 0 ]; then
    echo "Restarting NGINX..."
    sudo service nginx restart
else
    echo "Error: NGINX configuration test failed. Please fix the issues before restarting."
    exit 1  # Exit with an error status if the test fails
fi

# Exit successfully
exit 0
