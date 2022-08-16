# KubesprayCluster


## install cluster

```shell
docker run --rm -it \
  -v "${PWD}"/v1.22.5/inventory/mycluster:/kubespray/inventory/mycluster \
  -v "${HOME}"/.ssh/id_rsa:/root/.ssh/id_rsa \
  registry.cn-beijing.aliyuncs.com/llaoj/kubespray:v2.18.0 bash

ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml

```