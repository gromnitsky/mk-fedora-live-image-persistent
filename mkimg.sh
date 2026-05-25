#!/bin/sh

set -e

usage="Usage: mkimg.sh bootfs.img rootfs.img OUT.img"
p1=${1:?$usage}
p1_size_bytes=`stat -Lc %s "$p1"`
p2=${2:?$usage}
p2_size_bytes=`stat -Lc %s "$p2"`
img=${3:?$usage}
free_space=${FREE_SPACE:-2G}

free_space=`echo "$free_space" | numfmt --from iec`

img_size=$(( p1_size_bytes + p2_size_bytes + 1*1024*1024 + free_space))
p1_size=$(( p1_size_bytes/512 )) # sectors
p2_size=$(( p2_size_bytes/512 ))

# STEP 1: create an empty image & partition it
cp /dev/null "$img"
truncate -s $img_size "$img"

offset=2048                     # sectors

sfdisk -q "$img" << EOF
label: gpt
unit: sectors
sector-size: 512
: start=$offset,                     size=$p1_size, type=U
: start=$((offset+p1_size)),         size=$p2_size, type=L
EOF

# STEP 2: copy bootfs to it
dd if="$p1" bs=4M seek=$(( (offset)*512 ))B \
   of="$img" conv=notrunc,nocreat status=progress

# STEP 3: copy rootfs to it
dd if="$p2" bs=4M seek=$(( (offset+p1_size)*512 ))B \
   of="$img" conv=notrunc,nocreat status=progress
