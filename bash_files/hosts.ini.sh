#!/bin/bash

# Call install_ansible.sh script to install Ansible
./install_ansible.sh

# Get the user input for the number of master hosts
echo -n "Enter the number of master hosts: "
read num_master_hosts

# Create the hosts.ini file
touch hosts.ini

# Loop through the number of master hosts and get the hostname, IP address, username, and path to the private key for each host
echo "[master]" >> hosts.ini
for i in $(seq 1 $num_master_hosts); do
  echo -n "Enter the hostname of master host $i: "
  read master_hostname
  echo -n "Enter the IP address of master host $i: "
  read master_ip
  echo -n "Enter the username for master host $i: "
  read master_user
  echo -n "Enter the path to the private key for master host $i: "
  read master_private_key
  echo "$master_hostname ansible_host=$master_ip ansible_user=$master_user ansible_ssh_private_key=$master_private_key" >> hosts.ini
done

# Get the user input for the number of worker hosts
echo -n "Enter the number of worker hosts: "
read num_worker_hosts

# Loop through the number of worker hosts and get the hostname, IP address, username, and path to the private key for each host
echo "[worker]" >> hosts.ini
for i in $(seq 1 $num_worker_hosts); do
  echo -n "Enter the hostname of worker host $i: "
  read worker_hostname
  echo -n "Enter the IP address of worker host $i: "
  read worker_ip
  echo -n "Enter the username for worker host $i: "
  read worker_user
  echo -n "Enter the path to the private key for worker host $i: "
  read worker_private_key
  echo "$worker_hostname ansible_host=$worker_ip ansible_user=$worker_user ansible_ssh_private_key=$worker_private_key" >> hosts.ini
done

# Get the user input for the number of loadbalancer hosts
echo -n "Enter the number of loadbalancer hosts: "
read num_loadbalancer_hosts

# Loop through the number of loadbalancer hosts and get the hostname, IP address, username, and path to the private key for each host
echo "[loadbalancer]" >> hosts.ini
for i in $(seq 1 $num_loadbalancer_hosts); do
  echo -n "Enter the hostname of loadbalancer host $i: "
  read loadbalancer_hostname
  echo -n "Enter the IP address of loadbalancer host $i: "
  read loadbalancer_ip
  echo -n "Enter the username for loadbalancer host $i: "
  read loadbalancer_user
  echo -n "Enter the path to the private key for loadbalancer host $i: "
  read loadbalancer_private_key
  echo "$loadbalancer_hostname ansible_host=$loadbalancer_ip ansible_user=$loadbalancer_user ansible_ssh_private_key=$loadbalancer_private_key" >> hosts.ini
done

# Get the user input for the number of rancher hosts
echo -n "Enter the number of rancher hosts: "
read num_rancher_hosts

# Loop through the number of rancher hosts and get the hostname, IP address, username, and path to the private key for each host
echo "[rancher]" >> hosts.ini
for i in $(seq 1 $num_rancher_hosts); do
  echo -n "Enter the hostname of rancher host $i: "
  read rancher_hostname
  echo -n "Enter the IP address of rancher host $i: "
  read rancher_ip
  echo -n "Enter the username for rancher host $i: "
  read rancher_user
  echo -n "Enter the path to the private key for rancher host $i: "
  read rancher_private_key
  echo "$rancher_hostname ansible_host=$rancher_ip ansible_user=$rancher_user ansible_ssh_private_key=$rancher_private_key" >> hosts.ini
done

# Get the user input for the number of floating_ip hosts
echo -n "Enter the number of floating IP hosts: "
read num_floating_ip_hosts

# Loop through the number of floating IP hosts and get the hostname, IP address, username, and path to the private key for each host
echo "[floating_ip]" >> hosts.ini
for i in $(seq 1 $num_floating_ip_hosts); do
  echo -n "Enter the hostname of floating_ip host $i: "
  read floating_ip_hostname
  echo -n "Enter the IP address of floating_ip host $i: "
  read floating_ip_ip
  echo -n "Enter the username for floating_ip host $i: "
  read floating_ip_user
  echo -n "Enter the path to the private key for floating_ip host $i: "
  read floating_ip_private_key
  echo "$floating_ip_hostname ansible_host=$floating_ip_ip ansible_user=$floating_ip_user ansible_ssh_private_key=$floating_ip_private_key" >> hosts.ini
done

# Move the hosts.ini file to the ansible directory
echo "The hosts.ini file has been created inside ansible folder."
cp hosts.ini ../ansible/