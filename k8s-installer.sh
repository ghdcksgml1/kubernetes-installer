#!/bin/bash

sudo ufw disable
# sudo ufw status

sudo swapoff -a

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sudo sysctl --system

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet=1.26.0-00 \
                     kubeadm=1.26.0-00 \
                     kubelet=1.26.0-00
sudo apt-mark hold kubelet kubeadm kubectl
cat <<EOF > /etc/default/kubelet
KUBELET_EXTRA_ARGS=--root-dir="/container/k8s"
EOF
sudo systemctl daemon-reload
sudo systemctl enable kubelet && sudo systemctl start kubelet

NODE=$1
if [ $NODE == "MASTER" ]
then
        kubeadm init

        echo "=======🔼🔼 kubeadm join 부터 토큰까지 복사하여 워커노드에 붙여넣으면 노드가 연동됩니다. 🔼🔼======"

        export KUBECONFIG=/etc/kubernetes/admin.conf
        echo "export KUBECONFIG=/etc/kubernetes/admin.conf" | tee -a ~/.bashrc

        # kubectl taint nodes --all node-role.kubernetes.io/master- # 마스터 노드에 팟 띄우려면 이게 필요

        # cilium 설치
        curl -LO https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
        sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
        rm cilium-linux-amd64.tar.gz
        /usr/local/bin/cilium install

        # 잘 적용됐는지 확인
        kubectl get pod --all-namespaces
        kubectl get nodes
fi
