#!/bin/bash

# Install net-tools
sudo apt-get update
sudo apt-get install net-tools -y

# Prompt the user for a new hostname
echo "Enter a new hostname:"
read new_hostname

# Change the hostname on the system
sudo hostnamectl set-hostname $new_hostname

# Generate an SSH key pair with default settings
ssh-keygen -t rsa

# Add a sudoers entry for the current user
current_user=$(whoami)

sudo bash -c "cat >> /etc/sudoers << EOF

$current_user ALL=(ALL) NOPASSWD:ALL

EOF"

echo "Added $current_user to sudoers with NOPASSWD access"

# Print out system information
ip=$(hostname -I | awk '{print $1}')
username=$(whoami)
hostname=$(hostname)
rsa_file_location=~/.ssh/id_rsa

echo -e "\n\nSystem Information:"
echo -e "--------------------\n"

echo "IP Address: $ip"
echo "Username: $username"
echo "Hostname: $hostname"
echo "RSA File Location: $rsa_file_location"

echo -e "\n\n"
