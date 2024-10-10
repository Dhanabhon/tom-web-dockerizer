version: '3.8'
services:
  # NGINX Reverse Proxy
  nginx:
    image: nginx:alpine
    container_name: nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d   # NGINX config folder
      - ./nginx/ssl:/etc/nginx/ssl         # SSL certificates
      - ./nginx/logs:/var/log/nginx        # Logs
    networks:
      - frontend-network
      - backend-network
    depends_on:
      - frontend
      - backend

  # Frontend Service (e.g., React, Vue)
  frontend:
    image: node:14-alpine
    container_name: frontend
    working_dir: /app
    volumes:
      - ./frontend:/app
    command: ["npm", "run", "build"]  # Or start server if SSR
    ports:
      - "8080:8080"   # Expose frontend port
    networks:
      - frontend-network

  # Backend Service (e.g., Node.js, Django, Flask)
  backend:
    image: node:14-alpine   # Change this for Django, Flask, etc.
    container_name: backend
    working_dir: /app
    volumes:
      - ./backend:/app
    environment:
      - DB_HOST=mariadb
      - DB_USER=root
      - DB_PASSWORD=yourpassword
      - DB_NAME=mydb
    command: ["npm", "run", "start"]  # Or equivalent for your backend framework
    ports:
      - "8090:8090"  # Expose backend port
    networks:
      - backend-network
    depends_on:
      - mariadb

  # MariaDB (Database)
  mariadb:
    image: mariadb:latest
    container_name: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=yourpassword
      - MYSQL_DATABASE=mydb
      - MYSQL_USER=myuser
      - MYSQL_PASSWORD=yourpassword
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql   # Persistent storage for database
    networks:
      - backend-network

  # phpMyAdmin (optional)
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin
    environment:
      - PMA_HOST=mariadb
      - MYSQL_ROOT_PASSWORD=yourpassword
    ports:
      - "8081:80"  # Access phpMyAdmin at http://localhost:8081
    depends_on:
      - mariadb
    networks:
      - backend-network

# Volumes for data persistence
volumes:
  db_data:

# Networks for service separation
networks:
  frontend-network:
    driver: bridge
  backend-network:
    driver: bridge
