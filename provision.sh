#!/usr/bin/env bash
echo "Updating firewall rules for Apache"
sudo ufw allow 'Apache'
echo "Starting Apache"
sudo systemctl start apache2
