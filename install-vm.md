```
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
```

```
sudo systemctl enable --now libvirtd
```

```
virsh list --all
```

```
cd ~
wget https://releases.ubuntu.com/20.04/ubuntu-20.04.6-live-server-amd64.iso
sudo mv ~/ubuntu-20.04.6-live-server-amd64.iso /var/lib/libvirt/images/
```


```
sudo apt install bridge-utils
sudo brctl addbr br0
sudo ip link set br0 up

```



```
sudo virt-install \
--name ubuntu20-vm \
--ram 128000 \
--vcpus 128 \
--disk path=/var/lib/libvirt/images/ubuntu20-vm.qcow2,size=200 \
--os-type linux \
--os-variant ubuntu20.04 \
--graphics none \
--console pty,target_type=serial \
--cdrom /var/lib/libvirt/images/ubuntu-20.04.6-live-server-amd64.iso


```

```
chmod +r ~/ubuntu-20.04.6-live-server-amd64.iso
chmod +x ~
```