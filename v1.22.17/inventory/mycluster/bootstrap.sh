#! /bin/bash -x

# 因为kubespray v2.18.2没有内置kubernetes v1.22.17的二进制文件checksum. 所以我们手动增加kubelet kubectl kubeadm二进制文件的checksum.
sed -i 's/v1.22.8: 2e6d1774f18c4d4527c3b9197a64ea5705edcf1b547c77b3e683458d771f3ce7/v1.22.17: 48d200775000567256a8c114cf4f5d389468b175c3add6b232ec3b26f03e8564/g' roles/download/defaults/main.yml
sed -i 's/v1.22.8: 761bf1f648056eeef753f84c8365afe4305795c5f605cd9be6a715483fe7ca6b/v1.22.17: 7506a0ae7a59b35089853e1da2b0b9ac0258c5309ea3d165c3412904a9051d48/g' roles/download/defaults/main.yml
sed -i 's/v1.22.8: fc10b4e5b66c9bfa6dc297bbb4a93f58051a6069c969905ef23c19680d8d49dc/v1.22.17: 75244faf5726baf432ff2a76d5f188772173adb5ca1c33634d56ba13dbd6e4dc/g' roles/download/defaults/main.yml

ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml