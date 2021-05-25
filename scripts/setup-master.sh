#!/bin/bash

set -euo pipefail

hostname -I

echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc

sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --control-plane-endpoint=master.k8s --apiserver-cert-extra-sans=master.k8s --cri-socket unix:///run/containerd/containerd.sock
kubeadm token create --print-join-command

mkdir ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config

mkdir /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config

#kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
#kubectl apply -f calico.yaml

#kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
#kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml

sudo snap install helm --classic

helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --namespace=kube-system

cat <<EOF | tee /vagrant/share/join-worker.sh
#!/bin/bash
$(kubeadm token create --print-join-command)
EOF
chmod +x /vagrant/share/join-worker.sh 
