#!/bin/bash

set -x

# disable SELINUX
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# disable swap
swapoff -a && sysctl -w vm.swappiness=0
sed -i '/swap/s/^/#/' /etc/fstab

# kernel modules
modprobe sunrpc
modprobe ip_vs
modprobe ip_vs_rr
modprobe ip_vs_wrr
modprobe ip_vs_sh
modprobe br_netfilter
modprobe nf_conntrack
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
sunrpc
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
br_netfilter
nf_conntrack
EOF

# sunrpc
cat <<EOF | sudo tee /etc/modprobe.d/sunrpc.conf
options nf_conntrack hashsize=131072
options sunrpc tcp_slot_table_entries=128
options sunrpc tcp_max_slot_table_entries=128
EOF
sysctl -w sunrpc.tcp_slot_table_entries=128


# ulimits
mkdir /etc/systemd/system.conf.d
cat <<EOF | sudo tee /etc/systemd/system.conf.d/30-k8s-ulimits.conf
[Manager]
DefaultLimitCORE=infinity
DefaultLimitNOFILE=100000
DefaultLimitNPROC=100000
EOF

curl http://gitlab.cosmoplat.com/21001713/deployment-manual/-/raw/master/95-k8s-sysctl.conf -o /etc/sysctl.d/95-k8s-sysctl.conf
sysctl --system

# disable NetworkManager
systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl status NetworkManager

# disable firewalld
systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl status firewalld