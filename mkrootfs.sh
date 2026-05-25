#!/bin/sh

set -e

usage="sudo mkrootfs.sh container-dir out.img"
os=${1:?$usage}
img=${2:?$usage}
label=${ROOTFS_LABEL:-Fedora-Live}

bytes=$(du -sb "$os" | cut -f1)
# FIXME: add 20%
size=$(( bytes * 120 / 100 ))

cp /dev/null "$img"
truncate -s "$size" "$img"
mkfs.ext4 -q -d "$os" -L "$label" "$img"

[ "$SUDO_UID" ] && chown "$SUDO_UID:$SUDO_GID" "$img"
