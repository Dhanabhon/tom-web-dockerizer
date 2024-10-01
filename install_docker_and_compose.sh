#!/bin/bash

# Update and install prerequisites
echo "Step 1: Updating the package database..."
sudo apt-get update -y

echo "Step 2: Installing prerequisites for Docker installation..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
echo "Step 3: Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker's official repository to APT sources
echo "Step 4: Adding Docker's repository to APT sources..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package database again with Docker's packages
echo "Step 5: Updating the package database with Docker packages..."
sudo apt-get update -y

# Install Docker
echo "Step 6: Installing Docker..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Verify Docker installation
echo "Step 7: Verifying Docker installation..."
sudo systemctl status docker --no-pager
if [ $? -ne 0 ]; then
  echo "Error: Docker installation failed."
  exit 1
else
  echo "Docker successfully installed."
fi

# Allow Docker to be run without sudo
echo "Step 8: Adding user to the docker group..."
sudo usermod -aG docker $USER
echo "You may need to log out and log back in for this to take effect."

# Install Docker Compose
echo "Step 9: Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
echo "Step 10: Verifying Docker Compose installation..."
docker-compose --version
if [ $? -ne 0 ]; then
  echo "Error: Docker Compose installation failed."
  exit 1
else
  echo "Docker Compose successfully installed."
fi

# Final message
echo "Docker and Docker Compose have been successfully installed and configured."

