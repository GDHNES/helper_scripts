#!/bin/bash

###################################################################
# A simple helper script for installing cross-builded RISC-V      #
# kernel generated by "rv_cross_building_kernel.sh". Install      #
# a ${VERSION} kernel by putting ${VERSION}_kernel_install.tar.gz #
# to the same directory of this script and typing "./install_ker- #
# -nel ${VERSION}"                                                #
###################################################################

if [ $# -eq 1 ];
then
	VERSION=$1
	if [ ! -d "$1_kernel_install.tar.gz" ];then
		echo "[ERROR] target kernel zipfile not exist!"
		exit
	fi
	tar -xzf $1_kernel_install.tar.gz
	mv *$1 /boot
	OLDPATH=$(pwd)
	cd _install/lib/modules
	mv ./$1 /lib/modules
	cd ${OLDPATH}
	rm -r _install

	update-initramfs -c -k $1
	u-boot-update
else
	echo "[ERROR] invalid arguement!"
	echo "usage: (somewhere)/install_kernel.sh [\$kernel_version]"
	exit
fi
