#!/bin/bash 

ROM=~/work/archlinux/roms/ArchLinuxARM-armv7-latest.tar.gz  # must be abslute path
ISO_SIZE=800M
FS_TYPE=ext3
ISO_PATH=./iso/archlinux.iso

mkdir -p /mnt/archlinux
umount /mnt/archlinux 2> /dev/null
rm -rf "${ISO_PATH}"

dd if=/dev/zero of="${ISO_PATH}" bs="${ISO_SIZE}" count=1 && \
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
