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

## Usage
### To add a new website:
You can use the shell script `add_website.sh` to add a new website.
    ```bash
    ./add_website.sh [SITE_NAME] [WEB_SERVER] [DB_ENGINE] [USE_WORDPRESS] [MEMORY_LIMIT] [UPLOAD_MAX_FILESIZE] [POST_MAX_SIZE]
- [SITE_NAME]: The domain name of the site (e.g., `mywebsite.com`)
- [WEB_SERVER]: Web server engine (e.g., `nginx`, `openlitespeed`)
- [DB_ENGINE]: Database engine (e.g., `mariadb`, `mysql`, `postgresql`, `mongodb`)
- [USE_WORDPRESS]: `yes` or `no` if you want to install WordPress
- [MEMORY_LIMIT]: PHP memory limit (optional, default: 256M)
- [UPLOAD_MAX_FILESIZE]: Maximum file upload size (optional, default: 1024M)
- [POST_MAX_SIZE]: Maximum post size (optional, default: 1024M)

#### Example:
    ./add_website.sh mywebsite.com nginx mariadb yes 512M 2048M 2048M
    
This command will create a WordPress site with MariaDB and set the PHP memory limit to 512M, upload max file size to 2048M, and post max size to 2048M.

## Automatic HTTPS
Nginx Proxy will automatically handle the reverse proxy and SSL certificates for your website using Let's Encrypt. You don't need to set up HTTPS manually; it will be handled for you.

## Access phpMyAdmin
If you're using MariaDB or MySQL, phpMyAdmin will be automatically installed and accessible via a subdomain:

```
    http://phpmyadmin.mywebsite.com/
```

## Customization
You can easily customize the environment by modifying the shell scripts or Docker configurations to suit your specific needs.

## Contributing
Feel free to fork the project, open issues, and submit pull requests. Contributions are always welcome!

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
