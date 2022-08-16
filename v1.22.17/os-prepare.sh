#!/bin/bash

# For centos only

set -xe

INTERFACE="eth0"

function upgrade_kernel() {
  rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
  yum install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
  sed -i 's/mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/elrepo.repo
  sed -i 's/elrepo.org\/linux/mirrors.aliyun.com\/elrepo/g' /etc/yum.repos.d/elrepo.repo
  yum makecache
  yum --enablerepo=elrepo-kernel install kernel-lt -y
  # 通过下面的命令查看内核启动顺序
  # awk -F\' '$1=="menuentry " {print i++ ": " $2}' /boot/grub2/grub.cfg
  kernel_index=$(awk -F\' '$1=="menuentry " {print i++ ": " $2}' /boot/grub2/grub.cfg | (grep "CentOS Linux (5." || true) | awk -F: '{print $1}')
  if [[ $kernel_index == "" ]]; then
    echo "[error] kernel upgrade failed"
    return 1
  fi
  # 并将内核的序号填写到下面的命令中
  sed -i "s/^GRUB_DEFAULT=.*/GRUB_DEFAULT=$kernel_index/g" /etc/default/grub
  # 生效该配置
  grub2-mkconfig -o /boot/grub2/grub.cfg
  echo "[info] after the server is restarted, execute the script again."
  reboot
}

function check_os() {
  kernel_version=$(uname -r | awk -F'.' '{print $1}')
  if [[ $kernel_version -lt 5 ]]; then
    echo "[warn] kernel version lower than 5.x, upgrading..."
    upgrade_kernel
  fi

  if [[ $INTERFACE != "" ]]; then
    net_interface=$(ip link | (grep -E "^[0-9]+: ($INTERFACE)" || true) | awk -F ': ' '{print $2}')
    if [[ $net_interface == "" ]]; then
      echo "[error] network interface: $INTERFACE does not exist"
      return 1
    fi
    INTERFACE=$net_interface
  fi
}

function prepare() {
  yum update -y
  yum install -y bash-completion conntrack-tools ipset ipvsadm libseccomp nfs-utils psmisc rsync socat

  echo "[debug] disable swap"
  swapoff -a && sysctl -w vm.swappiness=0
  sed -i '/swap/s/^/#/' /etc/fstab

  echo "[debug] load kernel modules"
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

  echo "[debug] setup sunrpc"
  cat <<EOF | sudo tee /etc/modprobe.d/sunrpc.conf
options sunrpc tcp_slot_table_entries=128
options sunrpc tcp_max_slot_table_entries=128
EOF
  sysctl -w sunrpc.tcp_slot_table_entries=128
  sysctl -w sunrpc.tcp_max_slot_table_entries=128

  echo "[debug] config ulimits"
  mkdir -p /etc/systemd/system.conf.d
  cat <<EOF | sudo tee /etc/systemd/system.conf.d/30-k8s-ulimits.conf
[Manager]
DefaultLimitCORE=infinity
DefaultLimitNOFILE=100000
DefaultLimitNPROC=100000
EOF

  echo "[debug] config kernel parameters"
  curl https://llaoj.oss-cn-beijing.aliyuncs.com/config/95-k8s-sysctl.conf -o /etc/sysctl.d/95-k8s-sysctl.conf
  sysctl --system

  echo "[debug] disable NetworkManager"
  systemctl disable NetworkManager || true
  systemctl stop NetworkManager || true

  echo "[debug] disable firewalld"
  systemctl disable firewalld.service || true
  systemctl stop firewalld.service || true
}

check_os
prepare
