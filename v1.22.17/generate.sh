#!/bin/bash

set -x
KUBE_VERSION=v1.22.17
KUBSPRAY_VERSION=v2.18.2

wget -O kubespray-src.zip https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/${KUBSPRAY_VERSION}.zip
unzip -q kubespray-src.zip
SRC_PATH=$(unzip -l kubespray-src.zip | sed -n '5p' | awk '{print $4}')

sed -i "s/\(^kube_version: \).*/\1${KUBE_VERSION}/" "${SRC_PATH}"roles/kubespray-defaults/defaults/main.yaml
cd "${SRC_PATH}"contrib/offline || return
./generate_list.sh
cat temp/files.list
cat temp/images.list
