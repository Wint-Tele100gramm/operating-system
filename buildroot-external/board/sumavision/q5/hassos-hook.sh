#!/bin/bash
# shellcheck disable=SC2155

function haos_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    mkdir -p "${BOOT_DATA}/amlogic"
    cp "${BINARIES_DIR}/meson-gxl-s905m2-sumavision-q5.dtb" "${BOOT_DATA}/amlogic/"

    if ls "${BINARIES_DIR}"/*.dtbo 1> /dev/null 2>&1; then
        mkdir -p "${BOOT_DATA}/overlays"
        cp "${BINARIES_DIR}"/*.dtbo "${BOOT_DATA}/overlays/"
    fi
    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/haos-config.txt"
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"
}

# The burn image is produced by jethome-tools for the J80 (same partition
# layout), but the J80 DDR.USB/UBOOT.USB carry a BL30 that rejects the S905M2
# ("Wrong chip e0"). Replace them with ones that work on the Q5:
#  - DDR.USB   = signed BL2 of our own FIP (first 48 KiB of u-boot.bin)
#  - UBOOT.USB = JetHub burning U-Boot repacked with the Q5 BL30 (burn/UBOOT.USB)
function q5_prepare_burn_tools() {
    local bins="${HOST_DIR}/share/jethome-tools/bins/j80"

    if [ ! -d "${bins}" ]; then
        return 0
    fi
    if [ ! -f "${BOARD_DIR}/burn/UBOOT.USB" ]; then
        echo "ERROR: ${BOARD_DIR}/burn/UBOOT.USB is missing (see burn/README.md)"
        return 1
    fi

    cp -f "${BINARIES_DIR}/u-boot.bin.usb.bl2" "${bins}/DDR.USB"
    cp -f "${BOARD_DIR}/burn/UBOOT.USB" "${bins}/UBOOT.USB"
}

function haos_post_image() {
    convert_disk_image_xz
    q5_prepare_burn_tools
    convert_disk_image_burn
}
