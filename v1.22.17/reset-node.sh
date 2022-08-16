#!/bin/bash -ex

# stop and disable etcd & remove files and dirs
systemctl stop etcd && systemctl disable etcd
rm -rf /var/lib/etcd /backup/k8s /etc/systemd/system/etcd.service

# stop and disable kube_node service
systemctl stop kubelet && systemctl disable kubelet
systemctl stop kube-lb && systemctl disable kube-lb
systemctl stop kube-proxy && systemctl disable kube-proxy

yum remove -y kubelet
yum remove -y kubeadm
yum remove -y kubectl

# umount kubelet filesystems
mount | grep '/var/lib/kubelet' | awk '{print $3}' | xargs umount || true

# remove files and dirs of 'kube_node' nodes
rm -rf "/var/lib/kubelet/" "/var/lib/kube-proxy/" "/etc/systemd/system/kube-lb.service" "/etc/systemd/system/kubelet.service" "/etc/systemd/system/kube-proxy.service" "/etc/kube-lb/" "/etc/kubernetes/" "/root/.kube/config"

# to clean container runtime and networking
systemctl stop docker && systemctl disable docker

yum remove -y docker
yum remove -y containerd

# umount docker filesystem
# as k8s-network-plugins use host-network, '/var/run/docker/netns/default' must be umounted
umount /var/run/docker/netns/default || true
umount /var/lib/docker/overlay || true
echo /var/lib/docker/overlay2/*/merged | xargs umount || true
echo /var/lib/docker/containers/*/mounts/shm | xargs umount || true
echo /var/run/docker/netns/* | xargs umount || true

umount /data/docker/overlay || true
echo /data/docker/overlay2/*/merged | xargs umount || true
echo /data/docker/containers/*/mounts/shm | xargs umount || true

# remove files and dirsz
rm -rf "/var/lib/docker/" "/var/lib/dockershim/" "/var/run/docker/" "/etc/docker/" "/etc/systemd/system/docker.service" "/etc/systemd/system/docker.service.requires/" "/etc/systemd/system/docker.service.d/" "/etc/bash_completion.d/docker" "/usr/bin/docker"
rm -rf "/data/docker/"

# stop and disable containerd service
systemctl stop containerd && systemctl disable containerd

# umount containerd filesystems
mount | grep 'containerd/io.containerd' | awk '{print $3}' | xargs umount || true

# remove files and dirs
rm -rf "/etc/containerd/" "/etc/crictl.yaml" "/etc/systemd/system/containerd.service" "/opt/containerd/" "/var/lib/containerd/" "/var/run/containerd/"
rm -rf "/data/containerd/"
rm -rf "/etc/cni/" "/run/flannel/" "/etc/calico/" "/var/run/calico/" "/var/lib/calico/" "/var/log/calico/" "/etc/cilium/" "/var/run/cilium/" "/sys/fs/bpf/tc/" "/var/lib/cni/" "/var/lib/kube-router/" "/opt/kube/kube-ovn/" "/var/run/openvswitch/" "/etc/origin/openvswitch/" "/etc/openvswitch/" "/var/log/openvswitch/" "/var/run/ovn/" "/etc/origin/ovn/" "/etc/ovn/" "/var/log/ovn/"