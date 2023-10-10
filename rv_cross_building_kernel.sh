#!/bin/bash

##############################################################
# A simple helper script for cross-building RISC-V kernel.   #
# which will build a .tar.gz file containing neccesary       #
# files. Install the kernel by sending the .tar.gz file      #
# to riscv machine and executing "install_kernel.sh" script. #
##############################################################

# LINUXSRC=/root/linux
export LINUXSRC=./linux
export OUTPUT=./build

# export CONFIG=${SOMEWHERE}/config-${VERSION}

export CROSS_COMPILE=riscv64-unknown-linux-gnu-
export ARCH=riscv

OLDPATH=$(pwd)
cd $LINUXSRC

###########################################################
mkdir -p ${OUTPUT}/_install

##################################################################
# cp $CONFIG 

make O=$OUTPUT CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv olddefconfig
make O=$OUTPUT CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv -j${nproc}
make O=$OUTPUT CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv modules -j${nproc}

# build extra kernel module if needed

mkdir -p ${OUTPUT}/_install
make  INSTALL_MOD_PATH=_install modules_install O=${OUTPUT}

# STRIP=${CROSS_COMPILE}strip
# find ${OUTPUT}/_install/ -name "*.ko" | xargs $STRIP --strip-debug \
# 	--remove-section=.comment --remove-section=.note --preserve-dates

VERSION=`ls ${OUTPUT}/_install/lib/modules | awk '{ print $1 }'`
rm ${OUTPUT}/_install/lib/modules/${VERSION}/build

mv ${OUTPUT}/.config ${OUTPUT}/config-${VERSION}
mv ${OUTPUT}/arch/riscv/boot/Image ${OUTPUT}/vmlinux-${VERSION}
mv ${OUTPUT}/System.map ${OUTPUT}/System.map-${VERSION}
tar -zcf ${OUTPUT}/${VERSION}_kernel_install.tar.gz -C ${OUTPUT}  _install/lib  config-${VERSION} vmlinux-${VERSION} System.map-${VERSION}
mv ${OUTPUT}/${VERSION}_kernel_install.tar.gz ${OLDPATH}

cd $OLDPATH