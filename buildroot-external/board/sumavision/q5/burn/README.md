# UBOOT.USB for the Sumavision Q5

`UBOOT.USB` is loaded into RAM by the Amlogic USB Burning Tool and runs the
burning protocol. It is the JetHub J80 burning U-Boot (vendor 2015.01, from
jethome-tools `bins/j80/UBOOT.USB`, MD5 7754247038dbe7c12bb4e9d8f9e7bdd7)
repacked with the Q5 BL30:

- BL30: LibreELEC amlogic-boot-fip `jethub-j80` (master) bl30.bin + bl301.bin,
  `gxl_v1.1.3243-377db0f` (same as the eMMC FIP, see amlogic-boot-fip-q5);
- BL31, BL33: unchanged from the J80 `UBOOT.USB`.

The stock J80 file carries BL30 `gxl_v1.1.3538`, which resets the S905M2 with
`Wrong chip e0` right after BL2.

Rebuilt with gxlimg (https://github.com/repk/gxlimg):

    gxlimg -t fip --bl2 <any bl2.sign> --bl30 <q5 bl30.enc> \
           --bl31 <j80 bl31.enc> --bl33 <j80 bl33.enc> full.bin
    tail -c +49153 full.bin > UBOOT.USB && truncate -s 802816 UBOOT.USB

`DDR.USB` is not stored here: it is the signed BL2 of the built FIP
(`u-boot.bin.usb.bl2`), copied by `hassos-hook.sh`.
