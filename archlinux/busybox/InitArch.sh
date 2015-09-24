SD_CARD="/mnt/sdcard"
ISO_PATH="${SD_CARD}/archlinux.iso"
FS_TYPE="ext3"
MOUNT="busybox mount"
CHROOT="busybox chroot"
MOUNT_POINT="${SD_CARD}/mnt/archlinux"

if [ ! -f "${MOUNT_POINT}/bin/bash" ]
then
    echo "Mounting image ... "
    mkdir -p "${MOUNT_POINT}"

    ${MOUNT} -t ${FS_TYPE} -o loop "${ISO_PATH}" "${MOUNT_POINT}"
    if [ $? -ne 0 ]
    then
        echo "Mount / fail, quit."
        exit 1
    fi

    ${MOUNT} -o bind /dev "${MOUNT_POINT}"/dev
    if [ $? -ne 0 ]
    then
        echo "Mount /dev fail, quit."
        exit 1
    fi

    mkdir -p "${MOUNT_POINT}"/dev/pts
    ${MOUNT} -o bind /dev/pts "${MOUNT_POINT}"/dev/pts
    if [ $? -ne 0 ]
    then
        echo "Mount /dev/pts fail, quit."
        exit 1
    fi

    mkdir -p "${MOUNT_POINT}"/dev/shm
    ${MOUNT} -o bind /dev/shm "${MOUNT_POINT}"/dev/shm
    if [ $? -ne 0 ]
    then
        echo "Mount /dev/shm fail, quit."
        exit 1
    fi

    ${MOUNT} -o bind /proc "${MOUNT_POINT}"/proc
    if [ $? -ne 0 ]
    then
        echo "Mount /proc fail, quit."
        exit 1
    fi

    ${MOUNT} -o bind /sys "${MOUNT_POINT}"/sys
    if [ $? -ne 0 ]
    then
        echo "Mount /sys fail, quit."
        exit 1
    fi
fi

path="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin" 
${CHROOT} "${MOUNT_POINT}" /bin/bash -c "exec env -i PATH='$path' TERM='$TERM' HOME='/root' USER='root' /bin/bash"
