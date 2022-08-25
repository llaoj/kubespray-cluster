# KubesprayCluster

## [MUST] Start kubespray

```shell
docker run --rm -it \
  -v ${PWD}/inventory/mycluster:/kubespray/inventory/mycluster \
  -v ${HOME}/.ssh/id_rsa:/root/.ssh/id_rsa \
  registry.cn-beijing.aliyuncs.com/llaoj/kubespray_kubespray:v2.18.1 bash
```

## Install cluster

```shell
ansible-playbook -i inventory/mycluster/inventory.ini cluster.yml
```

## Add node

```shell
ansible-playbook -i inventory/mycluster/inventory.ini scale.yml
```

## upgrade cluster

```shell
ansible-playbook upgrade-cluster.yml -b -i inventory/mycluster/inventory.ini -e kube_version=v1.22.8

ansible-playbook cluster.yml -i inventory/mycluster/inventory.ini -e kube_version=v1.22.8 -e upgrade_cluster_setup=true

```