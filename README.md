# Tom's Web Dockerizer

## Description
Tom's Web Dockerizer is a flexible and powerful tool that allows users to deploy and manage multiple websites using Docker containers. It provides automated HTTPS (SSL/TLS) via Let's Encrypt and supports a variety of web servers and databases. WordPress installations are highly customizable, with options for setting memory limits, upload size, and more, making it easy for developers to configure their environment according to their needs.

## Features
- Deploy multiple websites in Docker containers
- Support for Nginx, OpenLiteSpeed, and more
- Automatic HTTPS setup and renewal using Let's Encrypt
- WordPress-specific setup with customizable PHP settings
  - Default: `Memory Limit = 256M`, `Upload Max File Size = 1024M`, `Post Max Size = 1024M`
- Choose from various database engines: MariaDB, MySQL, PostgreSQL, MongoDB
- Automatic phpMyAdmin setup for MariaDB/MySQL, accessible via a subdomain (e.g., `phpmyadmin.mywebsite.com`)

## Prerequisites
- Ubuntu 22.04 (or compatible OS)
- Docker and Docker Compose installed on the server

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/tom-web-dockerizer.git
   cd tom-web-dockerizer
2. **Set up Docker and Docker Compose** If you haven't installed Docker and Docker Compose, follow the instructions in the [Docker Documentation](https://docs.docker.com/).
3. **Start the Nginx Proxy and Let's Encrypt Companion** Run the following command to start the Nginx reverse proxy and Let's Encrypt for automatic SSL:
    ```bash
    docker-compose up -d
