#!/bin/bash

# 링크 해제 후, 재설정
unlink /bin/sh
ln -s /bin/bash /bin/sh

sudo apt-get update
# 설치에 필요한 라이브러리
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce \
                     docker-ce-cli \
                     docker-compose-plugin

# containerd 다운로드 설치
wget https://github.com/containerd/containerd/releases/download/v1.6.14/containerd-1.6.14-linux-amd64.tar.gz
sudo tar Cxzvf /usr/local containerd-1.6.14-linux-amd64.tar.gz

wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv containerd.service /usr/lib/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable --now containerd

# runc 설치
wget https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc

# ck8s구동하기 위한 설정
sudo mkdir -p /etc/containerd/
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd

sudo mkdir -p /opt/cni/bin/
sudo wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz

#설치된 패키지 버전 확인
docker version
apt-cache policy docker-ce | grep Installed \
&& apt-cache policy docker-ce-cli | grep Installed \
&& apt-cache policy containerd.io | grep Installed \
&& apt-cache policy docker-compose-plugin | grep Installed

#현재 사용자 도커권한 부여
sudo usermod -aG docker $USER
id $USER
#사용자 정보 세션에 적용위해 ssh 다시접속

# 도커 구동
sudo service docker start

sudo cp ./daemon.json /etc/docker/daemon.json

# 설정 변경을 위해 재구동
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo chown -R 1000:1000 /container
