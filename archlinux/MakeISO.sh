#!/bin/bash 

if [[ $# -ne 2 ]]
then
    echo "
Usage:
  $0 rom_path iso_size
  
  eg:
  $0 ./roms/ArchLinuxARM-armv7-latest.tar.gz 800

  This creates an 800M image at ./iso/archlinux.iso.
"

    exit 1
fi

ROM=`readlink -e $1`
ISO_SIZE="${2}"
FS_TYPE=ext3
ISO_PATH=./iso/archlinux.iso

mkdir -p /mnt/archlinux
mkdir -p `dirname ${ISO_PATH}`
umount /mnt/archlinux 2> /dev/null
rm -rf "${ISO_PATH}"

echo "Creating image..."
dd if=/dev/zero of="${ISO_PATH}" bs="1M" count=${ISO_SIZE} && \
mkfs -t "${FS_TYPE}" "${ISO_PATH}" && \
mount -o loop "${ISO_PATH}" /mnt/archlinux -t ext3 && \
cd /mnt/archlinux && \
tar -xf "${ROM}"

if [[ $? -eq 0 ]]
then
    echo "Make ISO Success: ${ISO_PATH}"
else
    echo "Make ISO Fail."
fi

umount /mnt/archlinux 2> /dev/null
