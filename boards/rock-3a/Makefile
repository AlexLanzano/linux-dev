BOARD_COMPILER = aarch64-linux-gnu
COMPILER = $(PWD)/compiler/$(BOARD_COMPILER)/bin/$(BOARD_COMPILER)-
BOARD_UBOOT_DEFCONFIG = rk3568_defconfig
BOARD_UBOOT_BUILD_FLAGS = CHIP="rk3568" \
                          ARCH=arm \
                          CROSS_COMPILE=$(COMPILER) \
                          BL31=../boards/rock-3a/prebuilt/rk3568_bl31_set_pmic_sleep_low_20221018_v1.32.elf \
                          spl/u-boot-spl.bin u-boot.dtb u-boot.itb

BOARD_LINUX_BUILD_FLAGS = ARCH=arm64 CROSS_COMPILE=$(COMPILER)

include $(root-dir)/Makefile.common


.PHONY: all
all: $(clean-target) build-compiler build-u-boot build-linux build-image

.PHONY: clean
clean: clean-u-boot clean-linux clean-image

build-image: images/rock-3a/boot.img images/rock-3a/linux.img

images/rock-3a/boot.img: images/rock-3a/loader1.img u-boot/u-boot.itb
	dd if=/dev/zero of=$@ bs=1M count=0 seek=16
	parted -s $@ mklabel gpt
	parted -s $@ unit s mkpart idbloader 64 7167
	parted -s $@ unit s mkpart vnvm 7168 7679
	parted -s $@ unit s mkpart reserved_space 7680 8063
	parted -s $@ unit s mkpart reserved1 8064 8127
	parted -s $@ unit s mkpart uboot_env 8128 8191
	parted -s $@ unit s mkpart reserved2 8192 16383
	parted -s $@ unit s mkpart uboot 16384 32734
	dd if=images/rock-3a/loader1.img of=$@ seek=64 conv=notrunc
	dd if=u-boot/u-boot.itb of=$@ seek=16384 conv=notrunc

images/rock-3a/loader1.img: u-boot/spl/u-boot-spl.bin boards/rock-3a/prebuilt/rk3568_ddr_1056MHz_v1.10.bin
	u-boot/tools/mkimage -O arm-trusted-firmware -n rk3568 -T rksd -d boards/rock-3a/prebuilt/rk3568_ddr_1056MHz_v1.10.bin:u-boot/spl/u-boot-spl.bin $@

images/rock-3a/linux.img: images/rock-3a/uImage linux/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dtb
	dd if=/dev/zero of=$@ bs=1G count=0 seek=3
	parted -s $@ mklabel gpt
	parted -s $@ unit s mkpart boot fat32 2048 616447
	parted -s $@ set 1 boot on
	parted -s $@ unit s mkpart linux ext4 616448 6291422
	sudo losetup -D
	sudo losetup /dev/loop0 $@
	sudo mkfs.fat -F 32 /dev/loop0p1
	sudo mkfs.ext4 -F /dev/loop0p2
	mkdir -p tmpmnt
	sudo mount /dev/loop0p1 tmpmnt
	sudo cp $^ tmpmnt
	sudo losetup -d /dev/loop0
	sudo umount tmpmnt
	rm -rf tmpmnt

images/rock-3a/uImage: linux/arch/arm64/boot/Image
	u-boot/tools/mkimage -A arm64 -O linux -T kernel -C none -a 0x400040 -e 0x400040 -n "Linux Kernel" -d $^ $@
