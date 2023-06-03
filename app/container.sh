echo "=============== Welcome Container ==============="
echo "                 Linuto Start"
echo "================================================="

echo "Mount rootfs"
mkdir /mnt/root
mount --bind / /mnt/root

if [ ! -f image/bzImage ]; then
    echo "Container setup failed..."
    exit -1
fi

qemu-system-x86_64 -m 128M \
                   -nographic \
                   -kernel ./image/bzImage \
                   -monitor telnet::9898,server,nowait \
                   -enable-kvm \
                   -serial mon:stdio \
                   -append "root=host_fs ro rootfstype=9p rootflags=trans=virtio console=ttyS0" \
                   -fsdev local,id=host_fs,security_model=passthrough,path=/mnt/root \
                   -device virtio-9p-pci,fsdev=host_fs,mount_tag=/dev/root
exit