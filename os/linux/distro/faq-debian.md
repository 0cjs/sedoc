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

### Upgrades Deferred Due to Phasing

There is a `Phased-Update-Percentage` field in package archives; if this is
under 100% the host will use a deterministic algorithm hashing the source
package name, version and system ID to decide if it's in the given
percentage or not and defer the upgrade if it's not:

    $ sudo apt dist-upgrade
    The following upgrades have been deferred due to phasing:
      apparmor libapparmor1
    0 upgraded, 0 newly installed, 0 to remove and 2 not upgraded.

Debian doesn't seem to use this, but [Ubuntu definitely does][ubuntu-phased],
changing the value from something low to 100% over a few days in order to
tease out problems from a few unfortunates before the package goes out
everywhere.

    #  See the current percentage:
    apt-cache show apparmor | grep -i phased`.

    #   Name packages explicitly to bypass phasing:
    sudo apt install apparmor libapparmor1

    #   Override with a command:
    sudo apt-get -o APT::Get::Always-Include-Phased-Updates=true dist-upgrade

    #   or with a file in /etc/apt/apt.conf.d/, one or more of:
    APT::Get::Always-Include-Phased-Updates "true"
    Update-Manager::Always-Include-Phased-Updates "true"    # GUI updater
    APT::Get::Never-Include-Phased-Updates

[ubuntu-phased]: https://ubuntu.com/server/docs/explanation/software/about-apt-upgrade-and-phased-updates/
