# Simple LAMP Vagrant box

Simple LAMP environment inside Vagrant box. Based on official `ubuntu/xenial64` box.

## In the box:

- Ubuntu 16.04
- Apache 2.4
- MySQL 5.7
- PHP 7.0

### Additionally installed:

- PHP cURL
- PHP Mcrypt
- phpMyAdmin
- Git
- Composer

## How to set up:

Assuming that VirtualBox (https://www.virtualbox.org/) and Vagrant (https://www.vagrantup.com/) are already installed on your computer.

1. Clone or download + unzip repository 
2. In your terminal go to the directory and type `vagrant up`
3. Wait
4. Enjoy

## How to use:

After setup is finished, go to http://192.168.33.10/ in your browser. You should see the `phpinfo()` page.
`./www/`(or `/vagrant/www/` inside the box) is your "DocumentRoot". I recommend to keep your projects in the `projects/` folder. And make symlinks from `www/` to `public_html` folder of your project. But it’s up to you.

`phpMyAdmin` is accessible at http://192.168.33.10/phpmyadmin/ Username is 'root', password - '12345678'

*tested with VirtualBox v5.0.26 and Vagrant 1.8.4
