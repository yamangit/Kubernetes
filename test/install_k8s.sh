#!/bin/sh

echo "Disabling swap"
swapoff -a; sed -i '/swap/d' /etc/fstab

echo "Disabling Firewall"
systemctl disable --now ufw

echo "Enabling and Loading Kernel modules"
{
cat >> /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter
}
echo "Adding Kernel settings"
{
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system
}

echo "Containerd"
{
sudo apt-get update -y
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt install -y containerd.io
}
{
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i.bak 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml && echo "SystemdCgroup value in /etc/containerd/config.toml updated."
}
sudo systemctl restart containerd

sudo systemctl enable containerd

echo "Installing Kubernetes"
{
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
}
apt update && apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
