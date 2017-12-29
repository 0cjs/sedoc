Docker
======

Handy Commands
--------------

### Shell in Docker Container

    docker exec -it CONTAINER bash -l

* `-i`: Interactive, keep STDIN open even if not attached
* `-t`: Allocate a pseudo-TTY


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



[Docker Machine]: https://docs.docker.com/machine/overview/
[supported platforms]: https://docs.docker.com/engine/installation/#supported-platforms
[debian]: https://docs.docker.com/engine/installation/linux/docker-ce/debian/
[ubuntu]: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
[Ubuntu EE]: https://docs.docker.com/engine/installation/linux/docker-ee/ubuntu/
