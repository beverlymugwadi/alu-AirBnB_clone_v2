#!/usr/bin/env bash
# Setup web servers for the deployment of web_static

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    sudo apt-get -y update
    sudo apt-get -y install nginx
fi

# Create necessary directories
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared

# Create fake HTML file
echo "<html>
  <head>
  </head>
  <body>
    Beverly is Awesome
  </body>
</html>" | sudo tee /data/web_static/releases/test/index.html

# Create or recreate symbolic link
sudo rm -rf /data/web_static/current
sudo ln -s /data/web_static/releases/test/ /data/web_static/current

# Set ownership
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_string="\\n\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}"
sudo sed -i "/server_name _;/a $config_string" /etc/nginx/sites-available/default

# Restart Nginx
sudo service nginx restart

exit 0