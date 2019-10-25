#!/usr/bin/env bash

echo "export PATH=$PATH:/usr/local/bin" >> /root/.bash_profile
echo "export PATH=$PATH:/usr/local/bin" >> /root/.bashrc
echo "export PATH=$PATH:/usr/local/bin" >> /home/centos/.bash_profile
source ~/.bash_profile

sudo yum install -y update
sudo yum install -y wget openssl

sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_12.x | sudo -E bash -

sudo yum install -y nodejs
node -v 
npm -v


sudo yum -y install nodejs unzip

sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config 

sudo /usr/bin/systemctl daemon-reload

sudo /usr/bin/systemctl restart sshd


#Install Docker
sudo yum remove -y docker-ce*
sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux  docker-engine-selinux docker-engine
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
export VERSION=18.03 && curl -sSL get.docker.com | sh
sudo yum -y install git
sudo groupadd docker
sudo usermod -aG docker centos
sudo sed -i -e 's|-H fd://|-H unix://|g' /etc/systemd/system/docker.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl enable docker
sudo systemctl start docker

#Install docker-compose
sudo yum install -y epel-release
sudo yum install -y python-pip
sudo pip install docker-compose
sudo yum upgrade -y python*

#Install kubernetes
setenforce 0
cat << EOF >/etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system
swapoff -a

cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

sudo yum install -y kubelet-1.15.3 kubeadm-1.15.3 kubectl-1.15.3 --disableexcludes=kubernetes
systemctl enable kubelet && systemctl start kubelet

# Install helm
curl -L https://git.io/get_helm.sh | bash
# helm init

# Executed manually with regular user

# sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --kubernetes-version=v1.15.3 > /home/centos/kubetoken.txt
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config
# kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml


# git clone https://github.com/hashicorp/consul-helm.git
# kubectl create serviceaccount --namespace kube-system tiller
# kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
# helm init --upgrade --service-account tiller
