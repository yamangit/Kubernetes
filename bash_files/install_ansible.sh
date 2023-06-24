#!/bin/bash

# Add Ansible PPA repository
sudo apt-add-repository ppa:ansible/ansible -y

# Update package lists
sudo apt update

# Install Ansible
sudo apt install ansible -y