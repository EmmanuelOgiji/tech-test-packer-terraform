#!/usr/bin/env bash
echo "Installing Apache server"
sudo apt-get -y update
sudo apt-get -y install apache2
sudo mv /home/ubuntu/index.html /var/www/html/index.html
echo "Installing Stress"
sudo apt-get install apache2 stress -y
