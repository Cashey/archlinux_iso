ISO_PATH="/sdcard/archlinux.iso"
FS_TYPE="ext3"
MOUNT="busybox mount"
CHROOT="busybox chroot"
MOUNT_POINT="/sdcard/mnt/archlinux/"

if [ ! -f "${MOUNT_POINT}/bin/bash" ]
then
    echo "Mounting image ... "
    mkdir -p "${MOUNT_POINT}" && \
    ${MOUNT} -t ${FS_TYPE} -o loop "${ISO_PATH}" "${MOUNT_POINT}" && \
    ${MOUNT} -o bind /dev "${MOUNT_POINT}"/dev && \
    ${MOUNT} -o bind /proc "${MOUNT_POINT}"/proc && \
    ${MOUNT} -o bind /sys "${MOUNT_POINT}"/sys
    
    if [[ $? -ne 0 ]]
    then
        echo "Mount fail, quit."
        exit 1
    fi
fi

path="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin" 
${CHROOT} "${MOUNT_POINT}" /bin/bash -c "export PATH='$path' TERM='$TERM' HOME='/root' USER='root'; exec /bin/bash"
