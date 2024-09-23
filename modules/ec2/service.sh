#!/bin/bash

sudo yum update -y

sudo amazon-linux-extras install mariadb10.5

sudo amazon-linux-extras install php8.2


sudo yum install -y httpd 

sudo systemctl start httpd

sudo systemctl enable httpd

sudo usermod -a -G apache ec2-user

sudo chown -R ec2-user:apache /var/www

sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;

find /var/www -type f -exec sudo chmod 0664 {} \;

sudo yum install php-mbstring php-xml -y

sudo systemctl restart httpd

sudo systemctl restart php-fpm

cd /var/www/html

wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz

mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1

rm phpMyAdmin-latest-all-languages.tar.gz