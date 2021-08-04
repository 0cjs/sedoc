Debian Upgrade and Package Problems
===================================


### Missing nvidia/gv100/acr/ucode_load.bin for module noveau

    W: Possible missing firmware /lib/firmware/nvidia/gv100/acr/ucode_load.bin for module nouveau

Provided only by a newer version of `firmware-misc-nonfree` from
`buster-backports`. The `intel-microcode` package was also suggested, so I
install that as well:

    apt-get -t buster-backports install firmware-misc-nonfree intel-microcode

[Source](https://comeandtechit.wordpress.com/2019/12/09/possible-missing-firmware-lib-firmware-nvidia-gv100-acr-ucode_load-bin-for-module-nouveau/)
