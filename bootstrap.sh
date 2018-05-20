#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
HOMEDIRFOLDER='www'
PROJECTFOLDER='projects'

# create project folder
if [ -d "/var/www/html/${HOMEDIRFOLDER}" ];
then
	echo "/var/www/html/${HOMEDIRFOLDER} exists."
else
	sudo mkdir "/var/www/html/${HOMEDIRFOLDER}"
fi

if [ -d "/var/www/html/${PROJECTFOLDER}" ];
then
	echo "/var/www/html/${PROJECTFOLDER} exists."
else
	sudo mkdir "/var/www/html/${PROJECTFOLDER}"
fi

echo "<?php phpinfo(); ?>" > /var/www/html/${HOMEDIRFOLDER}/index.php

# install PPA 'ondrej/php'. The PPA is well known, and is relatively safe to use.
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php

# update / upgrade
sudo apt -y update
sudo apt -y upgrade

# install apache
sudo apt install -y apache2

# removing all old php dependencies (not needed on fresh setup).
#sudo apt-get remove -y php*

# installing php7.1 and php modules
sudo apt-get install -y php7.1 php7.1-cli php7.1-common libapache2-mod-php7.1 php7.1-fpm php7.1-curl php7.1-gd php7.1-bz2 php7.1-mcrypt php7.1-json php7.1-tidy php7.1-mbstring php-redis php-memcached

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt install -y mysql-server
sudo apt install -y php7.1-mysql

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

# install NodeJS and NPM
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs