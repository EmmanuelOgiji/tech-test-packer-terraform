#!/usr/bin/env bash
# Start Apache
echo "Apache start"
sudo systemctl start apache2
sudo systemctl enable apache2
# Install stress
echo "Install stress"
sudo apt-get install stress
stress -60