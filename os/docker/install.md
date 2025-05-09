Docker Installation
===================

* [Overview](README.md) | [Install](install.md) | [Config](config.md)
  | [Image Build](image.md) | [Registries](registries.md)
  | [Security](security.md) | [Misc](misc.md) | [Tips](tips.md)
  | [Compose](compose.md)

Install Docker
--------------

If you don't need the latest version of Docker, the system packages that
come with your Linux distribution will generally be fine.

On Debian-derived systems (Debian, Ubuntu, etc.) this package is named
`docker.io`. (Do not confuse this with `docker`; that package is a
compatibility shim for `wmdocker`, a completely different thing.)


Install Docker from Docker instead of OS Distribution
-----------------------------------------------------

#### Versions

The versioning system seems somewhat confusing; their web site talks only
about "Docker Desktop," which is (I suppose) one of the Docker versions
below plus a GUI front-end for management and, for Windows and Mac, a VM
setup for Linux in which to run Docker. In this file we don't cover Docker
Desktop but only the Docker application (server and command line tool)
itself.

| Edition                 | Channel | Releases    | Support
|:------------------------|:--------|:------------|:--------------------
| Enterprise Edition (EE) | -       | Monthly     | stops at next rel.
| Community Edition (CE)  | stable  | 03/06/09/12 | 1 mo. after next rel.
| Community Edition (CE)  | edge    | 2x/year     | 1 year from rel.

[Supported platforms] are Linux servers (various distros and
architectures), Cloud (AWS, Azure), and Desktop (Windows, Mac.)

The [storage driver] you use can be particularly important; as well
as the Docker documentation [atomic-loopback] is good.

#### Debian (as of 2021-08)

Debian has no EE; CE is supported on `x86_64` and `armhf` of Debian 8-10.
Debian 7 supports only `x86_64` and requires a kernel update from 3.2→3.10.
Install can be via manual convenience scripts, .deb package, or [from the
Docker repository][docker debinst] (this for Debian 8+ `x86_64`):

    sudo apt-get remove docker docker-engine docker.io   # Remove old versions

    sudo apt-get update
    sudo apt-get install apt-transport-https ca-certificates \
        curl gnupg lsb-release software-properties-common

    #   Debian ≥11, because apt-key is deprecated
    #   They say /usr/share/keyrings/ but that seems to be wrong.
    curl -fsSL https://download.docker.com/linux/$(
      . /etc/os-release; echo "$ID")/gpg \
      | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    #   apt-get will produce an error if the key is not world readable
    sudo chmod 644 /usr/share/keyrings/docker-archive-keyring.gpg
    #   XXX not sure how to verify fingerprint; see below.

    #   In case above doesn't work in Debian 8-9 (apt-key is deprecated in 11):
    curl -fsSL https://download.docker.com/linux/$(
        . /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
    #   Verify fingerprint: 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
    apt-key fingerprint 0EBFCD88

    #   Add the sources.list entry. Old systems may need to remove signed-by.
    echo "deb \
      [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
      https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" \
      | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    chmod go+r /etc/apt/sources.list.d/docker.list
    #   etckeeper commit here

    apt-get update
    apt-cache madison docker-ce     # If you want to find a specific version
    apt-get install docker-ce=VERSION

    sudo docker run hello-world      # Verify it's working

See [Compose](compose.md) if you need Docker Compose; you cannot use the
Debian-provided `docker-compose` package with the Docker-provided
`docker-ce` package.

#### Ubuntu (as of 2018-10)

[Ubuntu CE] supports 17.10 (edge only), 17.04, 16.04, 14.04 on
`x86_64`, `armhf`, `s390x` and `ppc64le`. ([Ubuntu EE] is also
available.)

`overlay2` is the preferred [storage driver] (kernel v4+); otherwise
use `aufs`. On 14.04 you'll want the `linux-image-extra-*` packages:

    apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual

The rest is as with Debian above.

[Ubuntu CE]: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
[Ubuntu EE]: https://docs.docker.com/engine/installation/linux/docker-ee/ubuntu/

#### RHEL/CentOS

The [storage driver] situation can be tricky. In particular
devicemapper can be bad: [Friends Don't Let Friends Run Docker on
Loopback in Production][atomic-loopback]. The 'File Systems' section
of the RHEL release notes for [7.1] and [7.3] offer further
information.

[7.1]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/7.1_release_notes/chap-red_hat_enterprise_linux-7.1_release_notes-file_systems
[7.3]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/7.3_release_notes/technology_previews_file_systems

#### CoreOS / Container Linux

[CoreOS] is a set of Kubernates-related technologies that includes
[Container Linux], a distro designed to do nothing but run Docker
containers. See also:
- [Reboot strategies on updates][coreos-update]

[Container Linux]: https://coreos.com/os/docs/latest/
[CoreOS]: https://coreos.com/
[coreos-update]: https://coreos.com/os/docs/latest/update-strategies.html

#### Windows

Documentation: [Docker for Windows][dfw] (also called "Docker Desktop,"
but Docker Desktop is also availble for Linux).

The link to the [Docker for Windows Installer][dfwi] is not visible
except when logged into [Docker Hub][hub], though it can be downloaded
without authentication from that link. There is also an [sha256sum][dfwi-sha]
file available.

The installer will enable Microsoft [Hyper-V] on the Windows host (this may
require at least one reboot) and add and start a 2 GB "MobyLinuxVM" VM.
Hyper-V will disable Oracle [VirtualBox]; trying to start a VM with
VirtualBox will produce a "Raw-mode is unavailable courtesy of Hyper-V"
message.

[dfw]: https://docs.docker.com/docker-for-windows/
[dfwi]: https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe
[dfwi-sha]: https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe.sha256sum
[Hyper-V]: https://en.wikipedia.org/wiki/Hyper-V
[VirtualBox]: https://en.wikipedia.org/wiki/VirtualBox

#### Windows on WLS2

XXX alternative to Docker for Windows?



<!-------------------------------------------------------------------->
[HTTP API]: https://docs.docker.com/registry/spec/api/
[atomic-loopback]: https://www.projectatomic.io/blog/2015/06/notes-on-fedora-centos-and-docker-storage-drivers/
[command line]: https://docs.docker.com/edge/engine/reference/commandline/docker/
[docker debinst]: https://docs.docker.com/engine/installation/linux/docker-ce/debian/
[docker build]: https://docs.docker.com/engine/reference/commandline/build/
[docker-ls]: https://github.com/mayflower/docker-ls
[engine CLI]: https://docs.docker.com/engine/reference/commandline/cli/
[hub]: https://hub.docker.com/
[reference documentation]: https://docs.docker.com/reference/
[registry-cli]: https://github.com/andrey-pohilko/registry-cli
[storage driver]: https://docs.docker.com/storage/storagedriver/
[supported platforms]: https://docs.docker.com/engine/installation/#supported-platforms
