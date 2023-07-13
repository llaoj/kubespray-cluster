## 需要增加*_checksums记录

执行下面命令获取v1.22.17版本kubelet kubectl kubeadm三个二进制组件的sum:

```sh
scripts/download_hash.sh v1.22.17
```

把输出的记录中amd64部分的值粘贴到`roles/download/defaults/main.yml`文件对应的位置, 比如:

```yaml
kubeadm_checksums:
...
  amd64:
  ...
    v1.22.17: 75244faf5726baf432ff2a76d5f188772173adb5ca1c33634d56ba13dbd6e4dc
```
