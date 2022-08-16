#!/bin/bash

wget https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/v2.18.1.zip
unzip -q v2.18.1.zip

cp -r inventory/mycluster kubespray-2.18.1/inventory/
cd kubespray-2.18.1/contrib/offline

./generate_list.sh -i inventory/mycluster/inventory.ini
tree temp/
cat temp/files.list
cat temp/images.list


