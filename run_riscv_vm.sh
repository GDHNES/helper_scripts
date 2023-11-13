QEMU="/home/gdhnes/Ccode/dev/qemu-dev/build/qemu-system-riscv64"
#KERNEL="linux/build/arch/riscv/boot/Image"
KERNEL="/home/gdhnes/Ccode/dev/linux-dev/arch/riscv/boot/Image"
OPEN_SBI="/home/gdhnes/Ccode/dev/qemu-dev/build/platform/generic/firmware/fw_jump.elf"

NVME0="riscv64-ubuntu2204.qcow2,format=qcow2"
#NVME1="nvme1.img,format=raw"
# release/Fedora-Developer-37-20221130.n.0-nvme.raw.img,format=raw"

die() {
    echo $*
    exit 1
}

test -x "${QEMU}" || die "Can't find QEMU: ${QEMU}"
test -f "${KERNEL}" || die "Can't find KERNEL: ${KERNEL}"
test -f "${OPEN_SBI}" || die "Can't find OPEN_SBI: ${OPEN_SBI}"

QARGS=""
# machine definition

#defaulting to disable AIA 
#QARGS="${QARGS} -no-reboot -no-user-config -nographic -machine virt -cpu rv64 -smp 2"
# to enable AIA
QARGS="${QARGS} -no-reboot -no-user-config -nographic -machine virt,aia=aplic-imsic,aia-guests=4 -cpu rv64 -smp 2"

QARGS="${QARGS} -m 4G -object memory-backend-file,id=sysmem,mem-path=/dev/shm/4g,size=4G,share=on"

# emulation backends
QARGS="${QARGS} -drive file=${NVME0},read-only=off,id=nvme0"
#QARGS="${QARGS} -drive file=${NVME1},read-only=off,id=nvme1" 
QARGS="${QARGS} -netdev user,id=host-net,hostfwd=tcp::2223-:22"
# emulated devices, use virtio-blk for host OS
QARGS="${QARGS} -device x-riscv-iommu-pci,addr=1.0"
QARGS="${QARGS} -device virtio-blk-pci,disable-legacy=on,disable-modern=off,iommu_platform=on,ats=on,drive=nvme0,addr=3.0"
QARGS="${QARGS} -device virtio-net-pci,romfile=,netdev=host-net,disable-legacy=on,disable-modern=off,iommu_platform=on,ats=on,addr=7.0"

#QARGS="${QARGS} -device nvme,serial=87654321,drive=nvme1,addr=4.0"

# kernel arguments
KARGS="nokaslr earlycon=sbi console=ttyS0 root=/dev/vda1"

# Optional - enable IOMMU DMA translation trace
# QARGS="${QARGS} -trace riscv_iommu_dma"

# run qemu
${QEMU} -bios ${OPEN_SBI} -append "${KARGS}" -kernel ${KERNEL} ${QARGS}
