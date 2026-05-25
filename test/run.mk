test:
	qemu-kvm -machine q35 \
	 -bios /usr/share/OVMF/OVMF_CODE.fd \
	 -m 4G out.img
