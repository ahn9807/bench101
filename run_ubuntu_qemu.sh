#/bin/bash

sudo mount /dev/nvme0n1 ./nvme_mnt

INSTALL_PATH=./nvme_mnt/"ubuntu-kvm"
UBUNTU_IMG_URL="https://releases.ubuntu.com/20.04.2/ubuntu-20.04.2-live-server-amd64.iso?_ga=2.267594445.2145028703.1615186104-1743255792.1615186104"
QEMU_ARGS="-enable-kvm -cpu host -vnc localhost:1 -m 64G -smp 6 -drive format=raw,file=$INSTALL_PATH/disk.img,if=virtio,cache=none -net nic -net user,hostfwd=tcp::2222-:22" 
# QEMU_ARGS="-enable-kvm -cpu host -vnc localhost:1 -m 64G -smp 6  -drive format=raw,file=$INSTALL_PATH/disk.img,if=virtio,cache=none -net nic, -net tap,script=./ovs-ifup,downscript=./ovs-ifdown"

mkdir -p $INSTALL_PATH

if ! test -f $INSTALL_PATH/"ubuntu.img"; then 
    wget -O $INSTALL_PATH/ubuntu.img $UBUNTU_IMG_URL -P $INSTALL_PATH
fi;

if ! test -f $INSTALL_PATH/"disk.img"; then
    sudo apt install qemu-utils
    qemu-img create -f raw -o size=30G $INSTALL_PATH/disk.img
    QEMU_ARGS=${QEMU_ARGS}" -cdrom $INSTALL_PATH/ubuntu.img"
fi;

echo $QEMU_ARGS

qemu-system-x86_64 $QEMU_ARGS
