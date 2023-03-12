BOARD_COMPILER = arm-linux-gnueabi
COMPILER := $(PWD)/compiler/$(BOARD_COMPILER)/bin/$(BOARD_COMPILER)-
BOARD_UBOOT_DEFCONFIG = stm32mp15_trusted_defconfig
BOARD_UBOOT_BUILD_FLAGS = ARCH=arm \
                          DEVICE_TREE=stm32mp157c-dk2\
                          CROSS_COMPILE=$(COMPILER) all

BOARD_LINUX_BUILD_FLAGS = ARCH=arm CROSS_COMPILE=$(COMPILER)
BOARD_BUILD_ATF = 1
BOARD_ATF_BUILD_FLAGS = CROSS_COMPILE=$(COMPILER) PLAT=stm32mp1 ARCH=aarch32 ARM_ARCH_MAJOR=7 AARCH32_SP=sp_min DTB_FILE_NAME=stm32mp157a-dk1.dtb STM32MP_SDMMC=1

include Makefile.common

.PHONY: all
all: $(clean-target) build-compiler build-arm-trusted-firmware build-u-boot build-linux build-image

.PHONY: clean
clean: clean-u-boot clean-arm-trusted-firmware clean-linux clean-image

build-image: images/$(board)/linux.img
images/$(board)/linux.img: arm-trusted-firmware/build/stm32mp1/release/tf-a-stm32mp157a-dk1.stm32 u-boot/u-boot.stm32
	echo TODO
	dd if=/dev/zero of=$@ bs=1G count=0 seek=1
	parted -s $@ mklabel gpt
	parted -s $@ unit s mkpart fsbl1 34 545
	parted -s $@ unit s mkpart fsbl2 546 1057
	parted -s $@ unit s mkpart uboot 1058 5153
	parted -s $@ unit s mkpart linux 5154 2091997
	dd if=arm-trusted-firmware/build/stm32mp1/release/tf-a-stm32mp157a-dk1.stm32 of=$@ seek=64 conv=notrunc
	dd if=arm-trusted-firmware/build/stm32mp1/release/tf-a-stm32mp157a-dk1.stm32 of=$@ seek=546 conv=notrunc
	dd if=u-boot/u-boot.stm32 of=$@ seek=1058 conv=notrunc
