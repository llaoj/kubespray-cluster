#!/bin/bash

set -x
KUBSPRAY_VERSION=v2.18.1
OSS_ENDPOINT=oss-cn-beijing.aliyuncs.com
OSS_ACCESS_KEY_ID=LTAI5tQ4EusZj1ngxtLJqVW2
OSS_ACCESS_KEY=EtC1wYxpuGPx4jVCox9Yuw2FcthDmJ
OSS_CLOUD_URL=rutron/kubernetes/
ACR_REPO=registry.cn-beijing.aliyuncs.com
ACR_USERNAME=rutronnet@163.com
ACR_PASSWORD=AxzkdEMiS7u@6s9
MY_IMAGE_REPO=${ACR_REPO}/llaoj

wget -O kubespray-src.zip https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/${KUBSPRAY_VERSION}.zip
unzip -q kubespray-src.zip
SRC_PATH=$(unzip -l kubespray-src.zip | sed -n '5p' | awk '{print $4}')

cd ${SRC_PATH}contrib/offline
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
quay.io/metallb/speaker:v0.10.3
quay.io/metallb/controller:v0.10.3
quay.io/kubespray/kubespray:v2.18.1
EOF
skopeo login -u $ACR_USERNAME -p $ACR_PASSWORD $ACR_REPO
for image in $(cat temp/images.list)
do 
	myimage=${image#*/}
	myimage=${MY_IMAGE_REPO}/${myimage/\//_}
	echo $myimage >> temp/myimages.list
	skopeo copy docker://${image} docker://${myimage}
done
cat temp/myimages.list