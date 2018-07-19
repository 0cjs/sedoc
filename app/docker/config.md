Docker Installation and Configuration
=====================================

Registries
----------

You can set up your own registry; see [Deploy a registry
server][registry-deploy].

The default port for docker push/pull is 5000. (Note that the API uses
standard ports 80/443.) The default registry is [Docker Hub] (API at
`index.docker.io`). Specify non-default registries to [docker pull]
with the registry, repository and image name separated by slashes:

    docker pull dr.example.com:5000/stuff/myimage:latest

The registry name/port must contain a `.` or `:`; if the hostname has
no `.`, add the default port of `:5000`.

Registries may require [authentication]. The `docker login` command
can do this; it stores the credentials in `~/.docker/config.json`.

To list the repositories in a registry and tags in a repository:

    curl https://myregistry:5000/v2/_catalog
    curl https://myregistry:5000/v2/REPONAME/tags/list

If authorization is required you can check the headers (with `-i` or
`-v`) for the auth type, or try `--auto-auth --user USERNAME` or try
`-H 'Authorization: Bearer TOKEN'` where _TOKEN_ is taken from your
`~/.docker/config.json` file, [docker-ls], [registry-cli] or something
else. I've not been able to get anything to work.


Public Docker Images
--------------------

[Docker Hub] is the standard repository for public docker images.
Docker Docker will download images from there unless another repo is
explicitly specified. Images are specified in the form of
`NAME[:TAG]`; the tag defaults to `latest` if not specified.

Handy [official repos] and images include:

* __alpine__ (5 MiB): Linux optimized for small size, based on musl libc
  and Busybox. Tags  `edge`, `3.8` (latest), `3.7`, ...
* __busybox__ (1-5 Mib): `1`, `uclibc`, `glibc`, `musl`
* __ubuntu__ (110 MiB): tags `18.04`, `16.04`, (latest) `14.04` (220 MiB)
* __mysql__ (400 MiB): `8`, `5` (latest)
* __centos__ (210 MiB): `7` (latest), `6`
* __debian__ (100 MiB): tags `9` (latest), `8`, `7`
* __buildpack-deps__ (600-850 MiB) Ubuntu/Debian with many build
  dependencies; used as a base for language-specific images.
  Tags `trusty` (14.04), `xenial` (16.04), `stretch`/`latest` (9), etc.
  and `-curl`/-`scm` varients of each (only curl or curl+Git/svn/etc.).
* __node__ (680 MiB): Based on buildpack-deps or alpine.
  Tags `strech`, `wheezy` `alpine`.

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




[Docker Hub]: https://hub.docker.com/explore/
[Docker Machine]: https://docs.docker.com/machine/overview/
[Docker Store]: https://store.docker.com/
[HTTP API]: https://docs.docker.com/registry/spec/api/
[Ubuntu EE]: https://docs.docker.com/engine/installation/linux/docker-ee/ubuntu/
[authentication]: https://docs.docker.com/registry/spec/auth/jwt/
[command line]: https://docs.docker.com/edge/engine/reference/commandline/docker/
[debian]: https://docs.docker.com/engine/installation/linux/docker-ce/debian/
[docker build]: https://docs.docker.com/engine/reference/commandline/build/
[docker pull]: https://docs.docker.com/engine/reference/commandline/pull/
[docker-ls]: https://github.com/mayflower/docker-ls
[engine CLI]: https://docs.docker.com/engine/reference/commandline/cli/
[official repos]: https://hub.docker.com/explore/
[reference documentation]: https://docs.docker.com/reference/
[registry-cli]: https://github.com/andrey-pohilko/registry-cli
[registry-deploy]: https://docs.docker.com/registry/deploying/
[repo-info]: https://github.com/docker-library/repo-info/tree/master/repos
[so-28320134]: https://stackoverflow.com/q/28320134/107294
[supported platforms]: https://docs.docker.com/engine/installation/#supported-platforms
[ubuntu]: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
