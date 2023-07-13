#!/bin/bash

set -x

KUBSPRAY_VERSION=v2.18.2

wget -O kubespray-src.zip https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/${KUBSPRAY_VERSION}.zip
unzip -oq kubespray-src.zip
SRC_PATH=$(unzip -l kubespray-src.zip | sed -n '5p' | awk '{print $4}')

cp -rf inventory/mycluster "${SRC_PATH}"inventory/
cd "${SRC_PATH}" || return
ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml
