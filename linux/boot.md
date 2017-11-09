Linux Partitioning and Bootup
=============================


GPT Partitioning
----------------

1. Clean "GPT"-type disk partition table
2. Create 01 300MB partition of type "FAT32" with flag "ESP"
   to mount point `/boot/efi`
3. Create 1 partition of type "linux swap" with appropriate size
4. Create 1 partition of type `ext4` Linux desktop to mount point `/`

(From Fernando Schwartz)
