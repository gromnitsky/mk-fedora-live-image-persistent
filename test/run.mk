img := out.img

3d:; $(qemu) -device virtio-vga-gl,hostmem=2G,blob=true,venus=true $(img)
vga:; $(qemu) $(img)

qemu := qemu-kvm -machine q35 -bios /usr/share/OVMF/OVMF_CODE.fd -m 4G -display gtk,gl=on -smp 2
