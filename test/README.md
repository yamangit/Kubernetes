read -p 'master ip address : ' ipaddr
sha_token = "$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')"
token = "$(kubeadm token list | awk '{print $1}' | sed -n '2 p')"
echo "kubeadm join $ipaddr:6443 --token=$token --discovery-token-ca-cert-hash sha256:$sha_token"
