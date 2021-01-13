#!/usr/bin/env bash
# Start Apache
echo "Apache start"
sudo systemctl start apache2
sudo systemctl enable apache2
echo "Start SSM agent"
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service