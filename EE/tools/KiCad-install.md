KiCad Installation
==================

Generally the latest releases can be difficult to install if you're not on
a supported OS (and Debian is not supported).

Releases:

    Ver     RelDate         Debian 12               Notes
    ──────────────────────────────────────────────────────────────────────────
    9.0.1   rc1
    9.0.0   2025-02-20      bookworm/backports
    8.0.9   2025-02-19
    6.0.11                  bookworm/stable
    5.1.5   2019-12-06                              (released before this date)

#### Debian 12 ("Buster")

Use the backports from Debian 13 ("Trixie").

    sudo tee /etc/apt/sources.list.d/backports.list >/dev/null
    deb http://deb.debian.org/debian/ bookworm-backports main non-free-firmware non-free contrib
    deb-src http://deb.debian.org/debian/ bookworm-backports main non-free-firmware non-free contrib
    chmod 644 /etc/apt/sources.list.d/backports.list

    sudo apt install -t stable-backports kicad


Building from Source
--------------------

It's a lot of work. Not tried, but some notes:

See the build dependencies list at the bottom of [KiCad Debian
page][inst-debian] is not correct; use:

    #   Packages with the correct names from Debian page:
    sudo apt install cmake doxygen libboost-context-dev libboost-dev \
      libboost-system-dev libboost-test-dev libcairo2-dev libcurl4-openssl-dev \
      libgl1-mesa-dev libglew-dev libglm-dev liboce-foundation-dev \
      liboce-ocaf-dev libssl-dev swig wx-common

    #   Packages named differently from Debian page:
    sudo apt install libngspice0-dev \
      libwxgtk3.2-dev python3-dev python3-wxgtk4.0

    #   XXX No equiv for `python-wxgtk3.0-dev` ?
    #   Myabe python3-wxgtk4.0 above will do it?

E: Unable to locate package python-wxgtk3.0-dev
E: Couldn't find any package by glob 'python-wxgtk3.0-dev'

    git clone https://gitlab.com/kicad/code/kicad.git


Using Ubuntu PPA
----------------

### Debian PPA Attempt

This does not work because Ubuntu 24.04 has slightly newer versions of
libs than Debian 12, producing errors such as:

    libc6 (>= 2.38) but 2.36-9+deb12u10 is to be installed

The remainder here is left for historical reasons, and should be moved
to some docs about generic attempts to install PPAs on Debian.

From [Install on Linux][inst-linux], the officially supported Debian-ish
build is Ubuntu, but, though Debian has `add-apt-repository`,  `sudo
add-apt-repository -P ppa:kicad/kicad-9.0-releases` (even with that -P
option) throws an exception.

So we check the [PPA for KiCad: 9.0 releases]; "Technical details about
this PPA" gives us the `sources.list.d/kicad.list` entries for Noble
(24.04), the Ubuntu LTS after my current Debian 12:

    deb https://ppa.launchpadcontent.net/kicad/kicad-9.0-releases/ubuntu noble main 
    deb-src https://ppa.launchpadcontent.net/kicad/kicad-9.0-releases/ubuntu noble main 

You also need the key: click on the "Signing key" entry and grab the URL
from the `pub` or `uid` line and:

    u='…'       # URL to download key; should produce ASCII-armored version
    cd /usr/share/keyrings/
    curl -sSL "$u" | gpg --dearmor > kicad-9.0-releases
    chmod go+r kicad-9.0-releases

Add in the `.list` file, between `deb` and the URL:

    [arch=amd64 signed-by=/usr/share/keyrings/kicad-9.0-releases]

and `chmod go+r` the file, and `apt update` should now work.


Debian
------

These are old notes that need to be cleaned up.

The [KiCad Debian page][inst-debian] suggests only installing from Debian
`apt` repos or building from source. But Debian is generally far behind in
KiCad versions, even the backports repos. You can install with e.g.

    apt install -t stretch-backports-sloppy kicad

but the old [KiCad Debian page][inst-debian] claimed that
`stretch-backports` has 5.1, but actually it had 5.0; 5.1 was in
`stretch-backports-sloppy`.

Versions available from Debian repos:
- Debian 12: `bookworm` 6.0.11+dfsg-1
- Debian unstable `sid`: 5.1.5
- Debian 10
  - `buster-backports`: 5.1.8
  - `buster`: 5.0.2
- Debian 9
  - `stretch-backports-sloppy`: 5.1.6
  - `stretch-backports`: 5.0.2
  - `stretch`: 4.0.5


<!-------------------------------------------------------------------->
[PPA for KiCad: 9.0 releases]: https://launchpad.net/~kicad/+archive/ubuntu/kicad-9.0-releases
[inst-debian]: https://www.kicad-pcb.org/download/details/debian/
[inst-linux]: https://www.kicad.org/download/linux/
[pcbnewref]: https://docs.kicad.org/5.1/en/pcbnew/pcbnew.html
