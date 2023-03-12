.DEFAULT_GOAL = all

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Please define $1$(if $2, ($2))))

$(call check_defined, board)

# Clean U-Boot and Linux if building for new board
ifneq ($(shell cat .board), $(board))
u-boot-clean-target = clean-u-boot
linux-clean-target = clean-linux
$(shell echo "$(board)" > .board)
endif

TEST = build-compiler build-u-boot build-linux build-image
NPROC = $(shell nproc)
BUILD_TARGETS =


include boards/$(board)/$(board).mk

BUILD_TARGETS += build-compiler
.PHONY: build-compiler
build-compiler: compiler/$(BOARD_COMPILER)/bin/$(BOARD_COMPILER)-gcc
compiler/$(BOARD_COMPILER)/bin/$(BOARD_COMPILER)-gcc:
	cd compiler; \
	$(MAKE) CONFIG=configs/$(BOARD_COMPILER).mk

ifdef BOARD_BUILD_ATF
BUILD_TARGETS += build-arm-trusted-firmware
.PHONY: build-arm-trusted-firmware
build-arm-trusted-firmware:
	cd arm-trusted-firmware; \
	$(MAKE) -j $(NPROC) $(BOARD_ATF_BUILD_FLAGS)
endif

BUILD_TARGETS += build-u-boot
.PHONY: build-u-boot
build-u-boot: $(u-boot-clean-target) u-boot/.config
	cd u-boot; \
	$(MAKE) -j $(NPROC) $(BOARD_UBOOT_BUILD_FLAGS)

u-boot/.config: u-boot/configs/$(BOARD_UBOOT_DEFCONFIG)
	cd u-boot; \
	$(MAKE) $(BOARD_UBOOT_DEFCONFIG)

BUILD_TARGETS += build-linux
.PHONY: build-linux
build-linux: $(linux-clean-target) linux/.config
	cd linux; \
	$(MAKE) -j $(NPROC) $(BOARD_LINUX_BUILD_FLAGS)

linux/.config: boards/$(board)/linux_config
	cp $^ $@

BUILD_TARGETS += build-image

all: $(BUILD_TARGETS)


CLEAN_TARGETS =

CLEAN_TARGETS += clean-image
.PHONY: clean-image
clean-image:
	rm -rf images/$(board)

CLEAN_TARGETS += clean-u-boot
.PHONY: clean-u-boot
clean-u-boot:
	cd u-boot; \
	$(MAKE) clean mrproper

ifdef BOARD_BUILD_ATF
CLEAN_TARGETS += clean-arm-trusted-firmware
.PHONY: clean-arm-trusted-firmware
clean-arm-trusted-firmware:
	cd arm-trusted-firmware; \
	$(MAKE) distclean
endif

CLEAN_TARGETS += clean-linux
.PHONY: clean-linux
clean-linux:
	cd linux; \
	$(MAKE) clean mrproper

.PHONY: clean
clean: $(CLEAN_TARGETS)
