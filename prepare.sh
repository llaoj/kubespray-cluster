#!/bin/bash

wget -O kubespray-2.18.0.tar.gz https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/v2.18.0.tar.gz
mkdir kubespray-2.18.0
tar -zxvf kubespray-2.18.0.tar.gz -C kubespray-2.18.0

cd kubespray-2.18.0/contrib/offline
bash generate_list.sh
tree temp/



