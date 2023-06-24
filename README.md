## Kubernetes
### This repository contains Bash and Ansible scripts for managing a Kubernetes cluster.
#### Usage
To use the scripts in this repository, follow these steps:
1. Clone the repository to your local machine using the following command:
   sudo git clone https://github.com/PrabhatNew/Kubernetes.git

2. Navigate to the repository directory:
   cd Kubernetes

3. Make the Bash scripts executable using the following command:
   sudo chmod +x -R bash_files

4. Execute hosts.ini.sh file on ansible controller node and execute on_all_nodes.sh command on all the nodes listed on hosts.ini file respectively
   sudo bash hosts.ini.sh and $sudo bash on_all_nodes.sh

5. To execute the ssh-keygen command from the Ansible host to all other IPs on the hosts.ini file, run the following command:
ansible all -i ansible/hosts.ini -m authorized_key -a "user=root key='{{ lookup('file', '~/.ssh/id_rsa.pub') }}'"

This command will copy the SSH public key from the Ansible host to all other hosts specified in the hosts.ini file, allowing you to access the hosts using SSH without a password.


# Detailed README
## Ansible Playbook for Kubernetes, HAproxy and Rancher
This Ansible playbook will install and configure Kubernetes, HAproxy and Rancher on a set of hosts.
## Requirements
1. Ansible 2.9+
2. The Ansible control node (where you'll run the Ansible commands) must be able to SSH to all the nodes without a password. This can be done by generating SSH keys and copying the public key to all the nodes.

## Usage
To use this playbook, you will need to create a hosts.ini file that lists the hosts that you want to install Kubernetes and Rancher on. The hosts file should be in the same directory as the playbook.

## Pre-requisites
1. Execute the hosts.ini.sh bash script to create hosts.ini file and follow instructions carefully. The hosts.ini file will be created with the user inputted hostname, IP addresses, username, location to private key of all the nodes under the corresponding groups. 
2. haproxy.cfg needs to be updated with the correct IP addresses and ports of the nodes before running mainplaybook.yml
3. The nodes must allow port 22 for SSH, port 6443 for Kubernetes API server and 2379-2380 for etcd. These ports need to be opened on any firewall.

## The playbook uses the following playbooks:
* `install_haproxy` - Installs HAProxy on the loadbalancer hosts.
* `configure_haproxy` - Configures HAProxy to load balance traffic to the Kubernetes masters.
* `install_kubernetes` - Installs Kubernetes on the master and worker hosts.
* `init_kubernetes` - Initializes Kubernetes on the first master host.
* `join_worker` - Joins the worker nodes to the Kubernetes cluster.
* `join_master` - Joins the master nodes to the Kubernetes cluster.
* `rancher_setup` - Installs Rancher on the rancher hosts.

## Playbook execution
#### 1. To execute all playbooks at once, run the following command:
ansible-playbook -i hosts.ini mainplaybook.yml

#### 2. To execute playbooks individually, run the following command:

 ######   i. Install and configure Keepalived and HAProxy
    To install and configure Keepalived and HAProxy, run the following command:
    ansible-playbook playbook.yml --tags haproxy

 ######   ii. To install Kubernetes, run the following command:
    ansible-playbook playbook.yml --tags install_kubernetes

 ######   iii. To initialize Kubernetes on the first master host, run the following command:
    ansible-playbook playbook.yml --tags init_kubernetes

 ######   iv. To join the worker nodes to the Kubernetes cluster, run the following command:
    ansible-playbook playbook.yml --tags join_worker

 ######  v. To join the master nodes to the Kubernetes cluster, run the following command:
    ansible-playbook playbook.yml --tags join_master

 ######   vi. To install Rancher, run the following command:
    ansible-playbook playbook.yml --tags rancher_setup
