#!/bin/bash

read -s -p "Enter root password for MySQL: " MYSQL_ROOT_PASSWORD

# Install LEMP stack
sudo apt-get update
sudo apt-get install nginx php8.1 php8.1-fpm php8.1-mysql mysql-server -y

# disable strict mode
sudo sed -i 's/\[mysqld\]/&\nsql_mode=""\n/' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql

# Set root password for MySQL
sudo mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

echo 'Use the same root password you have been prompted earlier'
echo 'Running MySQL installation..'

sudo mysql_secure_installation
