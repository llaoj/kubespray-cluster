#!/bin/bash

wget -O kubespray.tar.gz https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/v2.18.0.tar.gz
tar -zxvf kubespray.tar.gz -C kubespray-2.18.0

cd kubespray-2.18.0/contrib/offline
bash generate_list.sh
tree temp/



