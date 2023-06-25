### This repository contains Ansible playbooks and Bash scripts for installing and configuring a Kubernetes v1.27 cluster, HAproxy and Rancher on a set of hosts on ubuntu 22.04.
#### Usage
To use the scripts in this repository, follow these steps:
1. Clone the repository to your Ansible controller (local machine) and to all the nodes in the cluster using the following command:
   ```sh
   sudo git clone https://github.com/PrabhatNew/Kubernetes.git
   ```

2. Navigate to the repository directory
   ```sh 
   cd Kubernetes
   ```

3. Make the Bash scripts executable using the following command:
   ```sh
   sudo chmod +x -R bash_files
   ```
   ```sh
   cd bash_files
   ```

4. The first step is to run the "on_all_nodes.sh" command on all the nodes in your cluster, which will provide you with useful information about each individual node. Once you have this information, you can then execute the "hosts.ini.sh" file on your Ansible controller node and enter the data gathered from the "on_all_nodes.sh" command. 
   ```sh
   bash on_all_nodes.sh
   ```
   and

   ```sh
   sudo bash hosts.ini.sh
   ```

5. View hosts.ini file 
```sh
cat /Kubernetes/ansible/hosts.ini
```

6. With the information on hosts.ini file, execute the ssh-copy-id command from the Ansible host to all other IPs on the hosts.ini file, here is example of the command:
```sh
ssh-copy-id desk@192.168.101.109
ssh-copy-id desk@192.168.101.110
ssh-copy-id desk@192.168.101.111
```
This command will copy the SSH public key from the Ansible host to other hosts specified in the hosts.ini file, allowing you to access the hosts using SSH without a password.

## Playbook execution

#### Test Ansible connection to all hosts.
```sh
cd /Kubernetes/ansible
```
```sh
ansible all -m ping -i hosts.ini 
```
### To execute all playbooks at once, run the following command:
```sh
 ansible-playbook -i hosts.ini mainplaybook.yml 
```

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
```sh
 ansible-playbook -i hosts.ini mainplaybook.yml 
```

#### 2. To execute playbooks individually, run the following command:

 #####   i. Install and configure Keepalived and HAProxy
    To install and configure Keepalived and HAProxy, run the following command:
```sh
 ansible-playbook playbook.yml --tags haproxy 
```

 #####   ii. To install Kubernetes, run the following command:
```sh
 ansible-playbook playbook.yml --tags install_kubernetes 
```

 #####   iii. To initialize Kubernetes on the first master host, run the following command:
```sh
 ansible-playbook playbook.yml --tags init_kubernetes
```

 #####   iv. To join the worker nodes to the Kubernetes cluster, run the following command:
```sh
 ansible-playbook playbook.yml --tags join_worker 
```

 #####  v. To join the master nodes to the Kubernetes cluster, run the following command:
```sh
 ansible-playbook playbook.yml --tags join_master 
```

 #####   vi. To install Rancher, run the following command:
```sh
 ansible-playbook playbook.yml --tags rancher_setup 
```
