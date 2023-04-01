#!/bin/bash

# Update and install Nginx, PHP 8.1, PHP-FPM, MySQL
sudo apt-get update
sudo apt-get install nginx php8.1 php8.1-fpm php8.1-mysql mysql-server -y

sudo mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${PASSWORD}';
FLUSH PRIVILEGES;
EOF

sudo mysql_secure_installation <<EOF

n
y
y
y
y
EOF

sudo sed -i '/\[mysqld\]/a sql_mode=""' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm
sudo systemctl restart mysql
