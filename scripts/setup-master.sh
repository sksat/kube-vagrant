#!/bin/bash

set -euo pipefail

hostname -I

echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint=master.k8s --apiserver-cert-extra-sans=master.k8s --cri-socket unix:///run/containerd/containerd.sock
kubeadm token create --print-join-command

cat <<EOF | tee /vagrant/share/join-worker.sh
#!/bin/bash
$(kubeadm token create --print-join-command)
EOF
chmod +x /vagrant/share/join-worker.sh 
