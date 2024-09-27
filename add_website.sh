#!/bin/bash

PROJECT_NAME="Tom's Web Dockerizer"
VERSION="v0.0.1"
VERSION_DATE="27-Sep-2024"

# Set parameters
SITE_NAME=$1
WEB_SERVER=$2  # nginx, openlitespeed
DB_ENGINE=$3   # mariadb, mysql, postgresql, mongodb
USE_WORDPRESS=$4  # yes or no

# Default values for PHP settings
MEMORY_LIMIT=${5:-256M}
UPLOAD_MAX_FILESIZE=${6:-1024M}
POST_MAX_SIZE=${7:-1024M}

# Display welcome message and project name
echo "-----------------------------------------------"
echo "Welcome to $PROJECT_NAME!"
echo "We're setting up your website: $SITE_NAME"
echo "-----------------------------------------------"

# Progress 1: Create the directory for the new website
echo "[1/6] Creating directory for the website..."
mkdir -p /var/www/$SITE_NAME
echo "[1/6] Directory created: /var/www/$SITE_NAME"

# Function to create Docker containers
create_docker_container() {
    echo "[2/6] Creating Docker containers for $SITE_NAME with $WEB_SERVER and $DB_ENGINE..."

    # Create a dedicated network for the website
    docker network create $SITE_NAME-network

    if [ "$USE_WORDPRESS" == "yes" ]; then
        # Create php.ini file with specified memory limit, upload max file size, and post max size
        echo "[3/6] Configuring PHP settings for WordPress..."
        mkdir -p /var/www/$SITE_NAME/config
        cat > /var/www/$SITE_NAME/config/php.ini <<EOL
memory_limit = $MEMORY_LIMIT
upload_max_filesize = $UPLOAD_MAX_FILESIZE
post_max_size = $POST_MAX_SIZE
EOL
        echo "PHP settings applied: Memory Limit = $MEMORY_LIMIT, Upload Max File Size = $UPLOAD_MAX_FILESIZE, Post Max Size = $POST_MAX_SIZE"

        # Create a WordPress container
        echo "[4/6] Creating WordPress container..."
        docker run -d --name $SITE_NAME-wordpress \
            -e WORDPRESS_DB_HOST=$SITE_NAME-db \
            -e WORDPRESS_DB_USER=wordpress_user \
            -e WORDPRESS_DB_PASSWORD=wordpress_pass \
            -e WORDPRESS_DB_NAME=$SITE_NAME \
            -v /var/www/$SITE_NAME:/var/www/html \
            -v /var/www/$SITE_NAME/config/php.ini:/usr/local/etc/php/conf.d/php.ini \
            --network $SITE_NAME-network \
            -e VIRTUAL_HOST=$SITE_NAME \
            -e LETSENCRYPT_HOST=$SITE_NAME \
            -e LETSENCRYPT_EMAIL=admin@$SITE_NAME \
            wordpress:latest
    else
        if [ "$WEB_SERVER" == "nginx" ]; then
            # Create a container for Nginx
            echo "[4/6] Creating Nginx container..."
            docker run -d --name $SITE_NAME-nginx \
                -v /var/www/$SITE_NAME:/usr/share/nginx/html \
                -e VIRTUAL_HOST=$SITE_NAME \
                -e LETSENCRYPT_HOST=$SITE_NAME \
                -e LETSENCRYPT_EMAIL=admin@$SITE_NAME \
                --network $SITE_NAME-network \
                nginx
        elif [ "$WEB_SERVER" == "openlitespeed" ]; then
            # Create a container for OpenLiteSpeed
            echo "[4/6] Creating OpenLiteSpeed container..."
            docker run -d --name $SITE_NAME-ols \
                -v /var/www/$SITE_NAME:/var/www/html \
                -e VIRTUAL_HOST=$SITE_NAME \
                -e LETSENCRYPT_HOST=$SITE_NAME \
                -e LETSENCRYPT_EMAIL=admin@$SITE_NAME \
                --network $SITE_NAME-network \
                litespeedtech/openlitespeed
        fi
    fi

    # Create a container for the database
    if [ "$DB_ENGINE" == "mariadb" ] || [ "$DB_ENGINE" == "mysql" ]; then
        echo "[5/6] Creating $DB_ENGINE container..."
        # Create a container for MariaDB or MySQL
        docker run -d --name $SITE_NAME-db \
            -e MYSQL_ROOT_PASSWORD=root_password \
            -e MYSQL_DATABASE=$SITE_NAME \
            -e MYSQL_USER=wordpress_user \
            -e MYSQL_PASSWORD=wordpress_pass \
            --network $SITE_NAME-network \
            mariadb

        # Automatically set up phpMyAdmin
        echo "[6/6] Creating phpMyAdmin container..."
        docker run -d --name $SITE_NAME-phpmyadmin \
            -e PMA_HOST=$SITE_NAME-db \
            -e VIRTUAL_HOST=phpmyadmin.$SITE_NAME \
            -e LETSENCRYPT_HOST=phpmyadmin.$SITE_NAME \
            -e LETSENCRYPT_EMAIL=admin@$SITE_NAME \
            --network $SITE_NAME-network \
            phpmyadmin/phpmyadmin

    elif [ "$DB_ENGINE" == "postgresql" ]; then
        echo "[5/6] Creating PostgreSQL container..."
        docker run -d --name $SITE_NAME-db \
            -e POSTGRES_PASSWORD=root_password \
            -e POSTGRES_DB=$SITE_NAME \
            --network $SITE_NAME-network \
            postgres
    elif [ "$DB_ENGINE" == "mongodb" ]; then
        echo "[5/6] Creating MongoDB container..."
        docker run -d --name $SITE_NAME-db \
            -e MONGO_INITDB_ROOT_USERNAME=admin \
            -e MONGO_INITDB_ROOT_PASSWORD=admin_password \
            --network $SITE_NAME-network \
            mongo
    fi
}

# Call the function to create containers
create_docker_container

# Notify completion
echo "-----------------------------------------------"
echo "Website $SITE_NAME has been successfully set up!"
echo "You can now visit http://$SITE_NAME"
echo "-----------------------------------------------"
