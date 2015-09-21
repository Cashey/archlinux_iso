ISO_PATH="/sdcard/archlinux.iso"
FS_TYPE="ext3"
MOUNT="busybox mount"
CHROOT="busybox chroot"
MOUNT_POINT="/sdcard/mnt/archlinux/"

test ! -f "${MOUNT_POINT}/bin/bash" && \
mkdir -p "${MOUNT_POINT}" && \
${MOUNT} -t ${FS_TYPE} -o loop "${ISO_PATH}" "${MOUNT_POINT}" && \
${MOUNT} -o bind /dev "${MOUNT_POINT}"/dev && \
${MOUNT} -o bind /proc "${MOUNT_POINT}"/proc && \
${MOUNT} -o bind /sys "${MOUNT_POINT}"/sys

path="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin" 
${CHROOT} "${MOUNT_POINT}" /bin/bash -c "export PATH='$path' TERM='$TERM' HOME='/root' USER='root'; exec /bin/bash"