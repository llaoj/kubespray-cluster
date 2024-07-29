#!/bin/bash

set -x

OSS_ENDPOINT=oss-cn-beijing.aliyuncs.com
OSS_CLOUD_URL=llaoj/kubernetes/

# echo "Download files and upload to OSS"
wget -qx -P /tmp/files -i ./files.txt
tree temp/
wget -q https://gosspublic.alicdn.com/ossutil/1.7.13/ossutil64 && chmod 755 ossutil64
./ossutil64 \
  -e $OSS_ENDPOINT \
  -i "$1" \
  -k "$2" \
  cp /tmp/files oss://${OSS_CLOUD_URL} -ruf --acl=public-read