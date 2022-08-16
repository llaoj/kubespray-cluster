## Prerequisits

交付的虚拟机要满足: 

- 操作系统为centos
- 内核版本5.x
- 保证 `/var/lib/containerd` 有较大的空间, 按照110个Pod计算在300G左右.
- 所有节点统一的时间服务器配置
- 服务器可以访问外网
- 有可用的yum源, 可以执行yum安装
- 服务器配置的DNS服务器地址既可以顺利的解析内网&外网域名.
- 在集群外规划一台服务器, 安装docker, 它到其他的所有节点ssh互信.

### [可选]清理节点

如果节点之前安装过kubernetes, 执行下面的脚本将数据清理干净.  
这是可选的, 如果是一个新操作系统. 就不用了.

```sh
./reset-node.sh
```

### !!!操作系统准备

执行操作系统配置脚本, 做一些前置的服务器配置, 在所有节点执行下面的脚本以完成安装k8s安装前的准备工作.

```sh
# 如果操作系统内核不是5.x, 脚本会升级内核并重启服务器.
# 服务器启动之后, 再次执行该脚本.
# For centos only
chmod +x ./os-prepare.sh && ./os-prepare.sh
```

### 安装集群

在**集群外**规划一台服务器, 安装docker, 它到其他的所有节点ssh互信. 
为了不在主机上安装kubespray, 我们使用kubespray容器执行集群安装

将所有的主机信息维护到`inventory/mycluster/inventory.ini`中. 然后执行:

```sh
docker run --rm -t --net=host \
  -v /tmp/v1.22.17/inventory/mycluster:/kubespray/inventory/mycluster \
  -v ${HOME}/.ssh:/root/.ssh \
  --entrypoint /bin/bash \
  registry.cn-beijing.aliyuncs.com/llaoj/kubespray_kubespray:v2.18.2 \
  -c chmod +x /kubespray/inventory/mycluster/bootstrap.sh && /kubespray/inventory/mycluster/bootstrap.sh
```

> 如果执行到Gather necessary facts (hardware)遇到时卡住. 可能是因为原来的环境有残留的挂载没有卸载干净. 进入目标服务器, 参考该问题页面解决: https://serverfault.com/questions/630253/ansible-stuck-on-gathering-facts