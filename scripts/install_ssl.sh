#!/bin/bash

# Check if the domain is provided
if [ -z "$1" ]; then
  echo "Usage: ./install_ssl.sh <your-domain>"
  exit 1
fi

DOMAIN=$1

# Step 1: Install Certbot and NGINX plugin
echo "Installing Certbot and NGINX plugin..."
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

# Step 2: Obtain the SSL certificate for the domain
echo "Obtaining SSL certificate for $DOMAIN..."
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN

# Step 3: Set up auto-renewal for the SSL certificates
echo "Setting up auto-renewal for SSL certificates..."
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer

# Step 4: Reload NGINX to apply the changes
echo "Reloading NGINX..."
sudo systemctl reload nginx

echo "SSL certificates installed and configured for $DOMAIN. HTTP traffic will be redirected to HTTPS."
