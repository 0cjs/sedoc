Debian Upgrade and Package Problems
===================================


### Missing nvidia/gv100/acr/ucode_load.bin for module noveau

    W: Possible missing firmware /lib/firmware/nvidia/gv100/acr/ucode_load.bin for module nouveau

Provided only by a newer version of `firmware-misc-nonfree` from
`buster-backports`. The `intel-microcode` package was also suggested, so I
install that as well:

    apt-get -t buster-backports install firmware-misc-nonfree intel-microcode

[Source](https://comeandtechit.wordpress.com/2019/12/09/possible-missing-firmware-lib-firmware-nvidia-gv100-acr-ucode_load-bin-for-module-nouveau/)

### add-apt-repository Failure with Python Exception

On Debian 12, running e.g. `add-apt-repository ppa:kicad/kicad-7.0-releases`
produces an exception `AttributeError: 'NoneType' object has no attribute
'people'`. Adding a missing package w/`apt install python3-launchpadlib`
fixes this.

From [linuxquestions.org thread][aar].

[aar]: https://www.linuxquestions.org/questions/debian-26/debian-bullseye-sid-add-apt-repository-not-working-python-problem-4175720821/
