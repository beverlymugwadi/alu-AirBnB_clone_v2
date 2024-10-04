#!/usr/bin/env bash
# Web static deployment script

set -e  # Exit immediately if a command exits with a non-zero status

# Update and upgrade the system
apt-get -y update
apt-get -y upgrade

# Install NGINX if not already installed
apt-get -y install nginx

# Create directories for the web static deployment
mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create a test HTML file
echo "Hello, this is a test HTML file." | tee /data/web_static/releases/test/index.html

# Remove any existing symbolic link and create a new one
rm -rf /data/web_static/current
ln -s /data/web_static/releases/test/ /data/web_static/current

# Give ownership of the /data/ directory to the ubuntu user and group
chown -R ubuntu:ubuntu /data/

# Check if the location block already exists in the configuration file
if ! grep -q "location /hbnb_static" /etc/nginx/sites-available/default; then
    # Add the location block if it doesn't exist
    sed -i '/listen 80 default_server;/a location /hbnb_static {\n\talias /data/web_static/current/;\n}' /etc/nginx/sites-available/default
fi

# Test the NGINX configuration for syntax errors
nginx -t

# If NGINX config test passes, restart NGINX
if [ $? -eq 0 ]; then
    service nginx restart
else
    echo "Error: NGINX configuration test failed. Please fix the issues before restarting."
    exit 1  # Exit with an error status if the test fails
fi

# Exit successfully
exit 0
