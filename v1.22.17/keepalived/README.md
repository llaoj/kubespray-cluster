# Keepalived

该配置为非抢占式. 由于主从服务器配置均等, 当主MASTER服务器从故障中恢复之后, 并不会抢占会VIP. 这样就减少了一次IP漂移.

在两台服务器上将配置文件拷贝到对应的目录下:

```sh
cd v1.22.17/keepalived

mv healthz /etc/keepalived/healthz
mv keepalived_BACKUPn.conf /etc/keepalived/keepalived.conf
chmod 744 /etc/keepalived/healthz
chmod 644 /etc/keepalived/healthz

mv keepalived.yaml /etc/kubernetes/manifests/
```

完成