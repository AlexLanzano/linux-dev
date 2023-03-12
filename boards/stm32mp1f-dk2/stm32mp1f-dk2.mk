BOARD_COMPILER = arm-linux-gnueabi
COMPILER := $(PWD)/compiler/$(BOARD_COMPILER)/bin/$(BOARD_COMPILER)-
BOARD_UBOOT_DEFCONFIG = stm32mp15_trusted_defconfig
BOARD_UBOOT_BUILD_FLAGS = ARCH=arm \
                          DEVICE_TREE=stm32mp157c-dk2\
                          CROSS_COMPILE=$(COMPILER) all

BOARD_LINUX_BUILD_FLAGS = ARCH=arm CROSS_COMPILE=$(COMPILER)
BOARD_BUILD_ATF = 1
BOARD_ATF_BUILD_FLAGS = CROSS_COMPILE=$(COMPILER) PLAT=stm32mp1 ARCH=aarch32 ARM_ARCH_MAJOR=7 AARCH32_SP=sp_min DTB_FILE_NAME=stm32mp157a-dk1.dtb STM32MP_SDMMC=1

$(shell mkdir -p images/stm32mp1f-dk2)

build-image: #images/rock-5b/boot.img images/rock-5b/linux.img
	echo TODO
# images/rock-5b/boot.img: images/rock-5b/loader1.img u-boot/u-boot.itb
# 	dd if=/dev/zero of=$@ bs=1M count=0 seek=16
# 	parted -s $@ mklabel gpt
# 	parted -s $@ unit s mkpart idbloader 64 7167
# 	parted -s $@ unit s mkpart vnvm 7168 7679
# 	parted -s $@ unit s mkpart reserved_space 7680 8063
# 	parted -s $@ unit s mkpart reserved1 8064 8127
# 	parted -s $@ unit s mkpart uboot_env 8128 8191
# 	parted -s $@ unit s mkpart reserved2 8192 16383
# 	parted -s $@ unit s mkpart uboot 16384 32734
# 	dd if=images/rock-5b/loader1.img of=$@ seek=64 conv=notrunc
# 	dd if=u-boot/u-boot.itb of=$@ seek=16384 conv=notrunc

# images/rock-5b/loader1.img: u-boot/spl/u-boot-spl.bin boards/rock-5b/prebuilt/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.08.bin
# 	u-boot/tools/mkimage -O arm-trusted-firmware -n rk3588 -T rksd -d boards/rock-5b/prebuilt/rk3588_ddr_lp4_2112MHz_lp5_2736MHz_v1.08.bin:u-boot/spl/u-boot-spl.bin $@

# images/rock-5b/linux.img: images/rock-5b/uImage linux/arch/arm64/boot/dts/rockchip/rk3588.dtb
# 	dd if=/dev/zero of=$@ bs=1G count=0 seek=3
# 	parted -s $@ mklabel gpt
# 	parted -s $@ unit s mkpart boot fat32 2048 616447
# 	parted -s $@ set 1 boot on
# 	parted -s $@ unit s mkpart linux ext4 616448 6291422
# 	sudo losetup -D
# 	sudo losetup /dev/loop0 $@
# 	sudo mkfs.fat -F 32 /dev/loop0p1
# 	sudo mkfs.ext4 -F /dev/loop0p2
# 	mkdir -p tmpmnt
# 	sudo mount /dev/loop0p1 tmpmnt
# 	sudo cp $^ tmpmnt
# 	sudo losetup -d /dev/loop0
# 	sudo umount tmpmnt
# 	rm -rf tmpmnt

# images/rock-5b/uImage: linux/arch/arm64/boot/Image
# 	u-boot/tools/mkimage -A arm64 -O linux -T kernel -C none -a 0x400040 -e 0x400040 -n "Linux Kernel" -d $^ $@
