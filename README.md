# KubesprayCluster

## [MUST] Start kubespray

```shell
docker run --rm -it \
  -v ${PWD}/inventory/mycluster:/kubespray/inventory/mycluster \
  -v ${PWD}/files-images.yaml:/kubespray/inventory/mycluster/all/files-images.yaml \
  -v ${HOME}/.ssh/id_rsa:/root/.ssh/id_rsa \
  registry.cn-beijing.aliyuncs.com/llaoj/kubespray:v2.18.0 bash
```

## Install cluster

```shell
ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml
```