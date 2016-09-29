#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
HOMEDIRFOLDER='www'
PROJECTFOLDER='projects'

# create project folder
sudo mkdir "/var/www/html/${HOMEDIRFOLDER}"
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

echo "<?php phpinfo(); ?>" > /var/www/html/${HOMEDIRFOLDER}/index.php

# update / upgrade
sudo apt -y update
sudo apt -y upgrade

# install apache and php 7
sudo apt install -y apache2
sudo apt install -y php libapache2-mod-php
# install cURL and Mcrypt
sudo apt install -y php-curl
sudo apt install -y php-mcrypt

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt install -y mysql-server
sudo apt install -y php-mysql

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt install -y phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${HOMEDIRFOLDER}"
    <Directory "/var/www/html/${HOMEDIRFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
sudo service apache2 restart
# restart mysql
sudo service mysql restart

# install git
sudo apt install -y git

# install Composer
sudo apt install -y composer