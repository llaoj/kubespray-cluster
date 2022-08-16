#!/bin/bash

wget https://github.com/kubernetes-sigs/kubespray/archive/refs/tags/v2.18.1.zip
unzip -q v2.18.1.zip

cp -r inventory/mycluster kubespray-2.18.1/inventory/
cd kubespray-2.18.1/contrib/offline
./generate_list.sh -i inventory/mycluster/inventory.ini
cat temp/files.list
cat temp/images.list

# download files and upload to aliyun oss
wget -qx -P temp/files -i temp/files.list
tree temp/
wget -q https://gosspublic.alicdn.com/ossutil/1.7.13/ossutil64
chmod 755 ossutil64
./ossutil64 \
  -e oss-cn-beijing.aliyuncs.com \
  -i LTAI5tQ4EusZj1ngxtLJqVW2 \
  -k EtC1wYxpuGPx4jVCox9Yuw2FcthDmJ \
  cp temp/files/ oss://rutron/kubernetes/ -ruf --acl=public-read

echo "Copy images to ACR"
skopeo login -u rutronnet@163.com -p AxzkdEMiS7u@6s9 registry.cn-beijing.aliyuncs.com
for image in $(cat temp/images.list); do 
	myimage=${image#*/}
	myimage=registry.cn-beijing.aliyuncs.com/llaoj/${myimage/\//_}
	echo ${myimage}
	# skopeo copy docker://${image} docker://${myimage}; 
done