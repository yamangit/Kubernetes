#!/bin/sh

echo "Installing dependencies"
{
apt-get update && apt-get upgrade -y
apt-get install expect -y
clear
}
echo -n "Please enter your loadbalancer IP then press [ENTER]:"
read lb_ip
export lb_ip
sleep 1s
clear
echo -n "Please enter your primary master server IP then press [ENTER]:"
read m_ip
export m_ip
sleep 1s
clear


##############################################################
################# K3s Control plain Install ##################
##############################################################


echo "Starting k8s installation"
{
find $path/src/install_k8s.sh -type f -exec chmod 777 {} \;
sh $path/src/install_k8s.sh
}
echo "Initializing Kubernetes"
{
kubeadm init --pod-network-cidr 10.244.0.0/16  --upload-certs  --control-plane-endpoint="$lb_ip:6443" --v=5
}
echo "Copying Kube config"
{
rm -rf $HOME/.kube
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config  
}

sleep 1s
clear

###############################################################
#################### Installing Network CNI ###################
###############################################################

echo "installing Network CNI"
{
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
}
echo "generating join command"
{
kubeadm token create --print-join-command 2>&1 | tee $path/src/worker_token.sh
echo $(kubeadm token create --print-join-command) --control-plane --certificate-key $(kubeadm init phase upload-certs --upload-certs | grep -vw -e certificate -e Namespace) 2>&1 | tee $path/src/master_token.sh
}
clear
sleep 1s


###############################################################
#################### Adding  Nodes ############################
###############################################################

while true
do
clear
echo "The list of available option than can now be performed are as follows:"
echo "Press 1 to add control plain node"
echo "Press 2 to add worker node"
echo "Press 0 to exit"
echo -n "Enter your option then press [ENTER]:"

read node
if [ $node = 1 ]; then
sleep 1s
clear
 echo "Please enter the ip address of the master node i.e 192.168.1.1  "
 echo -n "then press[ENTER]:" 
 read w_ip
 export w_ip
sleep 1s
clear
 echo "please enter user name of the master node"
 echo -n "then press [ENTER]:"
 read uname
 export uname
sleep 1s
clear
 echo  "please enter master node password"
 echo -n "then press [ENTER]:"
 read pword
 export pword
sleep 1s
clear
 echo "Initializing Node"
 {
# token = $(cat /tmp/master_token)
# export token
# find /tmp/master_token.sh -type f -exec chmod 777 {} \;
 find $path/src/add_k8s_master.exp -type f -exec chmod 777 {} \;
 expect $path/src/add_k8s_master.exp $uname $w_ip $pword $path
 }
clear
elif [ $node = 2 ]; then
 echo "Please enter the ip address of the worker node i.e 192.168.1.1  "
 echo -n "then press[ENTER]:" 
 read w_ip
 export w_ip
sleeps 1s
clear
 echo "please enter user name of the worker node"
 echo -n "then press [ENTER]:"
 read uname
 export uname
sleep 1s
clear 
echo  "please enter worker node password"
 echo -n "then press [ENTER]:"
 read pword
 export pword
sleep 1s
clear
 echo "Initializing Node"
 {
# export tkn=$tkn$(cat /tmp/worker_token)
 find $path/src/add_k8s_worker.exp -type f -exec chmod 777 {} \;
 expect $path/src/add_k8s_worker.exp $uname $w_ip $pword $path
 }
clear
elif [ $node = 0 ]; then
sleep 1s
clear
rm -rf $path/src/worker_token.sh
rm -rf $path/src/master_token.sh
echo "The program will now exit"
sleep 2s
exit 1

else
 echo "Invalind option"
 echo "Please enter a correct option"
sleep 2s
clear

fi
done


