# 📦 kubernetes-installer
docker runtime + containerd + kubernetes v1.26 + cilium
 
<img width="858" alt="스크린샷 2023-05-12 오후 3 06 45" src="https://github.com/ghdcksgml1/kubernetes-installer/assets/79779676/7f5d2005-6487-4484-8db8-01b46a1039a6">

## 📍 Guide (both Worker Node and Master Node )

Log in with an administrator account.

```shell
sudo su
```

### 1. git repository clone
```shell
git clone https://github.com/ghdcksgml1/kubernetes-installer/
cd kubernetes-installer
```

<br/>

### 2. docker runtime, containerd install
```shell
sh ./docker-installer.sh
```
<br/>

### 3. k8s, cilium (CNI) install
```shell
sh ./k8s-installer.sh MASTER # Master Node (Control plane)
sh ./k8s-installer.sh WORKER # Worker Node
```
<br/>

---

## 🙏 Integrating Worker Nodes with Master Nodes


![스크린샷 2023-05-12 오후 2 53 37](https://github.com/ghdcksgml1/kubernetes-installer/assets/79779676/a0dd15ed-9818-470d-93d2-39bfa6c826fc)

Copy this part from the master node and paste it on the worker node.

```shell
kubeadm join 10.0.20.203:6443 --token wns1lm.24k4ufvdef08qq2b \
	--discovery-token-ca-cert-hash sha256:fdac1fa49b40e179379ff338cfb43692913c82af516d7f19ffe61acfe6557a8e 
```

<br/><br/>

## 🚀 Trouble Shooting

![스크린샷 2023-05-12 오후 2 20 38](https://github.com/ghdcksgml1/kubernetes-installer/assets/79779676/a0ac6309-7896-417c-ac05-a31841ec301d)

```shell
export KUBECONFIG=/etc/kubernetes/admin.conf
```

or

```shell
export KUBECONFIG=$HOME/.kube/config
```

or

```shell
sudo su
```

<br/><br/><br/>

# 📓 References

- https://velog.io/@jopopscript/docker-설치for-k8s
- https://github.com/boanlab/tools
- https://docs.docker.com/engine/install/ubuntu/
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
