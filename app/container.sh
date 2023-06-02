echo "=============== Welcome Container ==============="
echo "                 Linuto Start"
echo "================================================="

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
                   -append "console=ttyS0"
exit