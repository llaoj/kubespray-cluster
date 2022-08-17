#!/bin/bash

KUBSPRAY_VERSION=v2.18.1

wget -O kubespray-src.zip https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/${KUBSPRAY_VERSION}.zip
unzip -q kubespray-src.zip
SRC_PATH=$(unzip -l kubespray-src.zip | sed -n '5p' | awk '{print $4}')
echo $SRC_PATH

cp -r inventory/mycluster ${SRC_PATH}/inventory/
cd ${SRC_PATH}/contrib/offline
./generate_list.sh -i inventory/mycluster/inventory.ini
cat temp/files.list
cat temp/images.list

# echo "Download files and upload to OSS"
# wget -qx -P temp/files -i temp/files.list
# tree temp/
# wget -q https://gosspublic.alicdn.com/ossutil/1.7.13/ossutil64 && chmod 755 ossutil64
# ./ossutil64 \
#   -e oss-cn-beijing.aliyuncs.com \
#   -i LTAI5tQ4EusZj1ngxtLJqVW2 \
#   -k EtC1wYxpuGPx4jVCox9Yuw2FcthDmJ \
#   cp temp/files/ oss://rutron/kubernetes/ -ruf --acl=public-read

# echo "Copy images to ACR"
# cat >> temp/images.list <<EOF
# quay.io/metallb/speaker:v0.10.3
# quay.io/metallb/controller:v0.10.3
# EOF
# skopeo login -u rutronnet@163.com -p AxzkdEMiS7u@6s9 registry.cn-beijing.aliyuncs.com
# for image in $(cat temp/images.list)
# do 
# 	myimage=${image#*/}
# 	myimage=registry.cn-beijing.aliyuncs.com/llaoj/${myimage/\//_}
# 	echo $myimage >> temp/myimages.list
# 	skopeo copy docker://${image} docker://${myimage}
# done
# cat temp/myimages.list