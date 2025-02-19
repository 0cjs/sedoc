Linux Partitioning and Bootup
=============================

Emergency Boot
--------------

If the bootloader's been wiped, an [Arch Live][arch-dl] CD has an option to
boot an existing partition, letting you boot any of the OSes on the disk
(including Windows). You may need to use `Tab` to edit the boot line to try
various combinations of disk and partition other than the default `hd0 0`.
On the Thinkpad T510 booted from USB, `hd0` is actually the USB stick and
the parameters to boot Windows 10 are:

    .com32 chain.c32 hd1 1

A Windows BitLocker partition may need a recovery key as well as the PIN if
the bootloader or partitioning on the disk has changed.



GPT Partitioning
----------------

1. Clean "GPT"-type disk partition table
2. Create 01 300MB partition of type "FAT32" with flag "ESP"
   to mount point `/boot/efi`
3. Create 1 partition of type "linux swap" with appropriate size
4. Create 1 partition of type `ext4` Linux desktop to mount point `/`

(From Fernando Schwartz)



<!-------------------------------------------------------------------->
[arch-dl]: https://archlinux.org/download/
