#!/usr/bin/env bash
sudo apt-get -y update
echo "Install Ansible"
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y
echo "Running ansible playbook"
ansible-playbook ./server-playbook.yml