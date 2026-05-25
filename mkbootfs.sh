#!/bin/sh

set -e

usage="Usage: sudo mkbootfs.sh kernel_dir out.img"
kernel_dir=${1:?$usage}
img=${2:?$usage}
img_size=100M

boot=`mktemp -d mkbootfs.XXXXXX.tmp`
trap 'rm -rf $boot' 0 1 2 15

mkdir -p "$boot/EFI/BOOT"
grub2-mkimage -O x86_64-efi -o "$boot/EFI/BOOT/BOOTX64.EFI" -p /EFI/BOOT \
              part_gpt fat linux normal configfile search echo

cp -r EFI "$boot"/

for i in vmlinuz initramfs; do
    find "$kernel_dir" -name "$i"\* | grep -v rescue | head -1 |
        xargs -I@ cp @ "$boot"/"$i"
done

cp /dev/null "$img"
truncate -s "$img_size" "$img"

mkfs.vfat "$img" > /dev/null
mcopy -i "$img" -m -s "$boot"/* ::
[ "$SUDO_UID" ] && chown "$SUDO_UID:$SUDO_GID" "$img"
