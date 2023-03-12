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

NPROC = $(shell nproc)

all: build-compiler build-u-boot build-linux build-image

include boards/$(board)/$(board).mk

.PHONY: build-compiler
build-compiler: compiler/$(BOARD_COMPILER)/bin/$(BOARD_COMPILER)-gcc
compiler/$(BOARD_COMPILER)/bin/$(BOARD_COMPILER)-gcc:
	cd compiler; \
	$(MAKE) CONFIG=configs/$(BOARD_COMPILER).mk

.PHONY: build-u-boot
build-u-boot: $(u-boot-clean-target) u-boot/.config
	cd u-boot; \
	$(MAKE) -j $(NPROC) $(BOARD_UBOOT_BUILD_FLAGS)

u-boot/.config: u-boot/configs/$(BOARD_UBOOT_DEFCONFIG)
	cd u-boot; \
	$(MAKE) $(BOARD_UBOOT_DEFCONFIG)

.PHONY: build-linux
build-linux: $(linux-clean-target) linux/.config
	cd linux; \
	$(MAKE) -j $(NPROC) $(BOARD_LINUX_BUILD_FLAGS)

linux/.config: boards/$(board)/linux_config
	cp $^ $@

.PHONY: build-image


.PHONY: clean
clean: clean-u-boot clean-linux
	rm -rf images/$(board)

.PHONY: clean-u-boot
clean-u-boot:
	cd u-boot; \
	$(MAKE) clean mrproper

.PHONY: clean-linux
clean-linux:
	cd linux; \
	$(MAKE) clean mrproper
