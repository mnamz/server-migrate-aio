#!/bin/bash

read -p "Enter domain name: " DOMAIN_NAME

sudo mkdir -p /var/www/${DOMAIN_NAME}

sudo tee /etc/nginx/sites-available/${DOMAIN_NAME} >/dev/null <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name ${DOMAIN_NAME};
    root /var/www/${DOMAIN_NAME};

    index index.php index.html index.htm index.nginx-debian.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/

sudo nginx -t && sudo systemctl restart nginx

sudo tee /var/www/${DOMAIN_NAME}/index.php >/dev/null <<EOF
<?php phpinfo(); ?>
EOF

echo 'Subdomain created, please add A record'