#!/bin/sh

set -e

usage="sudo mkrootfs.sh FREE_SPACE_SIZE container-dir out.img"
free_space=${1:?$usage}
free_space=`echo "$free_space" | numfmt --from iec`
os=${2:?$usage}
img=${3:?$usage}
label=${ROOTFS_LABEL:-Fedora-Live}

bytes=$(du -sb "$os" | cut -f1)
size=$(( bytes * 120 / 100 + free_space))

cp /dev/null "$img"
truncate -s "$size" "$img"
mkfs.ext4 -q -d "$os" -L "$label" "$img"

[ "$SUDO_UID" ] && chown "$SUDO_UID:$SUDO_GID" "$img"
