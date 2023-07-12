#!/bin/bash

set -x
KUBE_VERSION=v1.22.17
KUBSPRAY_VERSION=v2.18.2

OSS_ENDPOINT=oss-cn-beijing.aliyuncs.com
OSS_ACCESS_KEY_ID=LTAI5tQ4EusZj1ngxtLJqVW2
OSS_ACCESS_KEY=EtC1wYxpuGPx4jVCox9Yuw2FcthDmJ
ACR_REPO=registry.cn-beijing.aliyuncs.com
ACR_USERNAME=rutronnet@163.com
ACR_PASSWORD=AxzkdEMiS7u@6s9

OSS_CLOUD_URL=llaoj/kubernetes/
ACR_IMAGE_REPO=${ACR_REPO}/llaoj

wget -O kubespray-src.zip https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/${KUBSPRAY_VERSION}.zip
unzip -q kubespray-src.zip
SRC_PATH=$(unzip -l kubespray-src.zip | sed -n '5p' | awk '{print $4}')

sed -i "s/\(^kube_version: \).*/\1${KUBE_VERSION}/" "${SRC_PATH}"inventory/sample/group_vars/k8s_cluster/k8s-cluster.yml
cd "${SRC_PATH}"contrib/offline || return
./generate_list.sh -i inventory/sample/inventory.ini
cat temp/files.list
cat temp/images.list

echo "Download files and upload to OSS"
wget -qx -P temp/files -i temp/files.list
tree temp/
wget -q https://gosspublic.alicdn.com/ossutil/1.7.13/ossutil64 && chmod 755 ossutil64
./ossutil64 \
  -e $OSS_ENDPOINT \
  -i $OSS_ACCESS_KEY_ID \
  -k $OSS_ACCESS_KEY \
  cp temp/files/ oss://${OSS_CLOUD_URL} -ruf --acl=public-read

echo "Copy images to ACR"
cat >> temp/images.list <<EOF
quay.io/kubespray/kubespray:${KUBSPRAY_VERSION}
EOF
skopeo login -u $ACR_USERNAME -p $ACR_PASSWORD $ACR_REPO

while IFS= read -r line
do
  myimage=${line#*/}
	myimage=${ACR_IMAGE_REPO}/${myimage/\//_}
	echo "$myimage" >> temp/myimages.list
	skopeo copy docker://"${line}" docker://"${myimage}"
done < temp/images.list

cat temp/myimages.list