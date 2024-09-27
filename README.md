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
   ```
2. **Set up Docker and Docker Compose** If you haven't installed Docker and Docker Compose, follow the instructions in the [Docker Documentation](https://docs.docker.com/).
3. **Start the Nginx Proxy and Let's Encrypt Companion** Run the following command to start the Nginx reverse proxy and Let's Encrypt for automatic SSL:
    ```bash
    docker-compose up -d
    ```
## Usage
### To add a new website:
You can use the shell script `add_website.sh` to add a new website.
    ```bash
    ./add_website.sh [SITE_NAME] [WEB_SERVER] [DB_ENGINE] [USE_WORDPRESS] [MEMORY_LIMIT] [UPLOAD_MAX_FILESIZE] [POST_MAX_SIZE]
    ```
- [SITE_NAME]: The domain name of the site (e.g., `mywebsite.com`)
- [WEB_SERVER]: Web server engine (e.g., `nginx`, `openlitespeed`)
- [DB_ENGINE]: Database engine (e.g., `mariadb`, `mysql`, `postgresql`, `mongodb`)
- [USE_WORDPRESS]: `yes` or `no` if you want to install WordPress
- [MEMORY_LIMIT]: PHP memory limit (optional, default: 256M)
- [UPLOAD_MAX_FILESIZE]: Maximum file upload size (optional, default: 1024M)
- [POST_MAX_SIZE]: Maximum post size (optional, default: 1024M)

#### Example:

    ```bash
    ./add_website.sh mywebsite.com nginx mariadb yes 512M 2048M 2048M
    ```

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

## Verify Setup
After running the `add_website.sh` script, you can follow these steps to verify that everything is working correctly:

### 1. Check Docker Containers
To check if all necessary containers (web server, database, WordPress, phpMyAdmin) are running, use the following command:

```bash
docker ps
```

You should see containers with names like:
- `SITE_NAME-nginx` or `SITE_NAME-ols` (for the web server)
- `SITE_NAME-db` (for the database, e.g., MariaDB or MySQL)
- `SITE_NAME-wordpress` (if WordPress is installed)
- `SITE_NAME-phpmyadmin` (if phpMyAdmin is installed)

### 2. Verify Website Accessibility
Open a browser and navigate to your website:

```
http://mywebsite.com/
```

If everything is set up correctly, the website should load:
- If you installed WordPress, you should see the WordPress setup page.
- If it's a basic website, you should see the default page for your chosen web server (e.g., Nginx welcome page).

### 3. Verify HTTPS
If HTTPS (SSL/TLS) was enabled, verify the website is accessible via HTTPS:

```
https://mywebsite.com/
```

Check for the security lock icon in the browser URL bar to confirm that SSL is working and that the certificate is valid.

### 4. Verify phpMyAdmin Access (If Applicable)
If you selected MariaDB or MySQL as the database, phpMyAdmin will be available at the following URL:

```
http://phpmyadmin.mywebsite.com
```

Log in with your database credentials and check if phpMyAdmin loads correctly.

### 5. Check Docker Logs (Optional)
If something seems wrong, you can inspect the logs for each container by running:

```bash
docker logs [container_name]
```

For example:

```bash
docker logs mywebsite-nginx
docker logs mywebsite-db
```

These logs can help you debug any potential issues.

### 6. Verify Docker Network
To ensure that all containers are connected properly in the same network, run:

```bash
docker network inspect [SITE_NAME-network]
```

For example:

```bash
docker network inspect mywebsite-network
```

This command will show all containers connected to the same network. Check that the web server and database containers are listed.

### 7. Verify WordPress PHP Settings (If WordPress is installed)
If WordPress was installed, you can verify the PHP settings for memory limit, upload max filesize, and post max size:

1. Access the WordPress container using this command:

```bash
docker exec -it [wordpress_container] bash
```

For example:

```bash
docker exec -it mywebsite-wordpress bash
```

2. Check the PHP settings:

```bash
php -i | grep "memory_limit\|upload_max_filesize\|post_max_size"
```

This will show the current PHP settings. Verify that they match what you set in the script.

## Summary
If all these checks pass successfully, it means your website and its associated containers (web server, database, WordPress, phpMyAdmin) are set up and running correctly.

## Contributing
Feel free to fork the project, open issues, and submit pull requests. Contributions are always welcome!

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
