#!/bin/sh

set -e

usage="sudo mkrootfs.sh container-dir out.img"
os=${1:?$usage}
img=${2:?$usage}
label=${ROOTFS_LABEL:-Fedora-Live}

# Apparent size: actual content bytes, unaffected by source block size
apparent=$(du -sb --apparent-size "$os" | cut -f1)
# FIXME: Add 20% for ext4 metadata: inode tables, journal, group descriptors
size=$(( apparent * 120 / 100 ))

cp /dev/null "$img"
truncate -s "$size" "$img"
mkfs.ext4 -q -d "$os" -L "$label" "$img"

[ "$SUDO_UID" ] && chown "$SUDO_UID:$SUDO_GID" "$img"
