#!/bin/bash

wget https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/v2.18.1.zip
unzip -q v2.18.1.zip

cp -r inventory/mycluster kubespray-2.18.1/inventory/
cd kubespray-2.18.1/contrib/offline
./generate_list.sh -i inventory/mycluster/inventory.ini
cat temp/files.list
cat temp/images.list

wget -x -P temp/files -i temp/files.list
tree temp/

wget https://gosspublic.alicdn.com/ossutil/1.7.13/ossutil64
chmod 755 ossutil64
# ./ossutil64 cp localfolder/ oss://examplebucket/desfolder/ -r


