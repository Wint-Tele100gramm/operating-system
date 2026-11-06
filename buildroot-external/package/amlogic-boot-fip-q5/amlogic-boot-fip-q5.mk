################################################################################
#
# amlogic-boot-fip-q5
#
################################################################################

# LibreELEC master: jethub-j80 has BL30 gxl_v1.1.3243-377db0f / BL31 Feb 7 2018,
# p212 has BL2 "Built : 11:58:42, May 27 2017" (the combination proven on the Q5)
AMLOGIC_BOOT_FIP_Q5_VERSION = b6600f2857fdf81d11f18ea7a2e44aa989e7bcc4
AMLOGIC_BOOT_FIP_Q5_SITE = https://github.com/LibreELEC/amlogic-boot-fip
AMLOGIC_BOOT_FIP_Q5_SITE_METHOD = git
AMLOGIC_BOOT_FIP_Q5_INSTALL_IMAGES = YES
AMLOGIC_BOOT_FIP_Q5_DEPENDENCIES = uboot

AMLOGIC_BOOT_FIP_Q5_LICENSE = PROPRIETARY
AMLOGIC_BOOT_FIP_Q5_REDISTRIBUTE = NO

AMLOGIC_BOOT_FIP_Q5_BOARD_DIR = $(@D)/sumavision-q5

define AMLOGIC_BOOT_FIP_Q5_BUILD_CMDS
	rm -rf $(AMLOGIC_BOOT_FIP_Q5_BOARD_DIR) $(@D)/fip
	mkdir -p $(AMLOGIC_BOOT_FIP_Q5_BOARD_DIR) $(@D)/fip
	cp -dpf $(@D)/p212/* $(AMLOGIC_BOOT_FIP_Q5_BOARD_DIR)/
	cp -dpf $(@D)/jethub-j80/bl30.bin $(@D)/jethub-j80/bl301.bin \
		$(@D)/jethub-j80/bl31.img $(AMLOGIC_BOOT_FIP_Q5_BOARD_DIR)/
	cp $(BINARIES_DIR)/u-boot.bin $(@D)/fip/bl33.bin
	cd $(@D); ./build-fip.sh sumavision-q5 $(@D)/fip/bl33.bin $(@D)/fip
endef

define AMLOGIC_BOOT_FIP_Q5_INSTALL_IMAGES_CMDS
	$(foreach f,u-boot.bin u-boot.bin.sd.bin u-boot.bin.usb.bl2, \
		cp -dpf "$(@D)/fip/$(f)" "$(BINARIES_DIR)/"
	)
endef

$(eval $(generic-package))
