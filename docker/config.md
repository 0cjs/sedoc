Docker Installation and Configuration
=====================================

* [Overview](README.md) | [Install/Config](config.md) | [Image Build](image.md)
  | [Registries](registries.md) | [Security](security.md) | [Tips](tips.md)

Install Docker
--------------

| Edition                 | Channel | Releases    | Support
|:------------------------|:--------|:------------|:--------------------
| Enterprise Edition (EE) | -       | Monthly     | stops at next rel.
| Community Edition (CE)  | stable  | 03/06/09/12 | 1 mo. after next rel.
| Community Edition (CE)  | edge    | 2x/year     | 1 year from rel.

[Supported platforms] are Linux servers (various distros and
architectures), Cloud (AWS, Azure), and Desktop (Windows, Mac.)

The [storage driver] you use can be particularly important; as well
as the Docker documentation [atomic-loopback] is good.

#### Debian

[Debian] has no EE; CE is supported on `x86_64` and `armhf` of Debian
8-10. Debian 7 supports only `x86_64` and requires a kernel update
from 3.2→3.10. Install can be via manual convenience scripts, .deb
package, or from the Docker repository (this for Debian 8+ `x86_64`):

    apt-get remove docker docker-engine docker.io   # Remove old versions

    sudo apt-get install apt-transport-https ca-certificates \
        curl gnupg2 software-properties-common

    #   Add Docker GPG key. Verify the fingerprint is:
    #   9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
    curl -fsSL https://download.docker.com/linux/$(
        . /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88

    #   This will install in `/etc/apt/sources.list`; you may want to move
    #   the new lines to `/etc/apt/source.list.d/docker.list`.
    add-apt-repository "deb [arch=amd64] \
        https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
        $(lsb_release -cs) stable"

    apt-get update
    apt-cache madison docker-ce     # If you want to find a specific version
    apt-get install docker-ce=VERSION

    docker run hello-world      # Verify it's working

#### Ubuntu

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

[7.1]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/7.1_release_notes/chap-red_hat_enterprise_linux-7.1_release_notes-file_systems)
[7.3]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/7.3_release_notes/technology_previews_file_systems

#### CoreOS / Container Linux

[CoreOS] is a set of Kubernates-related technologies that includes
[Container Linux], a distro designed to do nothing but run Docker
containers. See also:
- [Reboot strategies on updates][coreos-update]

[Container Linux]: https://coreos.com/os/docs/latest/
[CoreOS]: https://coreos.com/
[coreos-update]: https://coreos.com/os/docs/latest/update-strategies.html


Managment Systems
-----------------

* [Docker Machine] provisions virtual machines (local VMs, cloud
  instances, whatever) configured with Docker Engine that then let you
  use the `docker` command to use them just like a local Docker
  Engine. (Docker Machine used to be used to set up a VM and Docker
  Engine on Linux and Mac, though that's now been replaced by the
  "native" versions of Docker Engine.)
* [Deis Workflow] builds on Kubernetes to provide developer-driven app
  deployment.

[Deis Workflow]: https://deis.com/docs/workflow/
[Docker Machine]: https://docs.docker.com/machine/overview/



<!-------------------------------------------------------------------->
[HTTP API]: https://docs.docker.com/registry/spec/api/
[atomic-loopback]: https://www.projectatomic.io/blog/2015/06/notes-on-fedora-centos-and-docker-storage-drivers/
[command line]: https://docs.docker.com/edge/engine/reference/commandline/docker/
[debian]: https://docs.docker.com/engine/installation/linux/docker-ce/debian/
[docker build]: https://docs.docker.com/engine/reference/commandline/build/
[docker-ls]: https://github.com/mayflower/docker-ls
[engine CLI]: https://docs.docker.com/engine/reference/commandline/cli/
[reference documentation]: https://docs.docker.com/reference/
[registry-cli]: https://github.com/andrey-pohilko/registry-cli
[storage driver]: https://docs.docker.com/storage/storagedriver/
[supported platforms]: https://docs.docker.com/engine/installation/#supported-platforms
