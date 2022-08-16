#!/bin/bash

wget https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/v2.18.1.zip
unzip v2.18.1.zip

cd kubespray-2.18.1/contrib/offline
bash generate_list.sh
tree temp/



