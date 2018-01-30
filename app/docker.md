Docker
======

Handy Commands
--------------

### Shell in Docker Container

    docker exec -it CONTAINER bash -l

* `-i`: Interactive, keep STDIN open even if not attached
* `-t`: Allocate a pseudo-TTY


Public Docker Images
--------------------

[Docker Hub] is the standard repository for public docker images.
Docker Docker will download images from there unless another repo is
explicitly specified. Images are specified in the form of
`NAME[:TAG]`; the tag defaults to `latest` if not specified.

Handy [official repos] and images include:

* __alpine__ (5 MiB): Linux optimized for small size, based on musl libc
  and Busybox. Tags  `edge`, `3.7` (latest), `3.6`, ...
* __busybox__ (1-5 Mib): `1`, `uclibc`, `glibc`, `musl`
* __ubuntu__ (110 MiB): tags `18.04`, `16.04`, (latest) `14.04` (220 MiB)
* __mysql__ (400 MiB): `8`, `5` (latest)
* __centos__ (210 MiB): `7` (latest), `6`
* __debian__ (100 MiB): tags `9` (latest), `8`, `7`

Extended information about these repos may be found in [repo-info].

There is also a [Docker Store]; dunno how this relates to the Hub.

[so-28320134] may help with ways of listing images and tags from
various remotes.


Install Docker
--------------

| Edition                 | Channel | Releases    | Support
|:------------------------|:--------|:------------|:--------------------
| Enterprise Edition (EE) | -       | Monthly     | stops at next rel.
| Community Edition (CE)  | stable  | 03/06/09/12 | 1 mo. after next rel.
| Community Edition (CE)  | edge    | 2x/year     | 1 year from rel.

[Supported platforms] are Linux servers (various distros and
architectures), Cloud (AWS, Azure), and Desktop (Windows, Mac.)

#### [Debian]

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

#### [Ubuntu]

[Ubuntu CE][ubuntu] supports 17.10 (edge only), 17.04, 16.04, 14.04 on
`x86_64`, `armhf`, `s390x` and `ppc64le`. ([Ubuntu EE] is also
available.)

`overlay2` is the preferred storage driver (kernel v4+); otherwise
use `aufs`. On 14.04 you'll want the `linux-image-extra-*` packages:

    apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual

The rest is as with Debian above.


[Docker Machine]
----------------

Use [Docker Machine] to provision virtual machines (local VMs, cloud
instances, whatever) configured with Docker Engine that then let you
use the `docker` command to use them just like a local Docker Engine.
(Docker Machine used to be used to set up a VM and Docker Engine on
Linux and Mac, though that's now been replaced by the "native"
versions of Docker Engine.)



[Docker Hub]: https://hub.docker.com
[Docker Machine]: https://docs.docker.com/machine/overview/
[Docker Store]: https://store.docker.com/
[Ubuntu EE]: https://docs.docker.com/engine/installation/linux/docker-ee/ubuntu/
[debian]: https://docs.docker.com/engine/installation/linux/docker-ce/debian/
[official repos]: https://hub.docker.com/explore/
[repo-info]: https://github.com/docker-library/repo-info/tree/master/repos
[so-28320134]: https://stackoverflow.com/q/28320134/107294
[supported platforms]: https://docs.docker.com/engine/installation/#supported-platforms
[ubuntu]: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
