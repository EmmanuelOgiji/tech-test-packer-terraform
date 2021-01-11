#!/usr/bin/env bash
echo "Installing Apache server"
sudo apt-get update -y
sudo apt-get install apache2 -y
sudo mv /home/ubuntu/index.html /var/www/html/index.html
