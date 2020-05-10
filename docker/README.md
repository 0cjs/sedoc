Docker
======

* [Overview](README.md) | [Install/Config](config.md) | [Image Build](image.md)
  | [Registries](registries.md) | [Security](security.md) | [Misc](misc.md)
  | [Tips](tips.md) | [Compose](compose.md)

Detailed list of pages here:
* [Overview](README.md)
* [Install/Config](config.md): Docker Installation and Configuration
* [Image Build](image.md): Docker Image Creation and Maintenance
* [Registries](registries.md): Docker Registries, Private and Public Images
* [Security](security.md): Docker Security
* [Miscellaneous Information](misc.md)
* [Tips](tips.md): Docker Tips; handy commands and the like

External Documentation:
* [Reference documentation] for complete documentation.
* [Engine CLI] for `docker` command details.
  (This provides a lot of information not in the manpages.)


Terminology
-----------

#### Containers, Images, Filesystems

A Docker __container__ is one or more process with their own
configuration for access to disk/network resources, UIDs/GIDs, etc. on
the host. Each container has its own _layer_ for the root filesystem
and may also have other filesystems mounted in it. A container is
created from an _image_. A container's root layer and default
configuration may be copied out to a new image with `docker commit`,
which also allows `Dockerfile` commands to be executed as it does
this.

An __image__ (since Docker 1.10) is a set of container configuration
defaults, including a list of _layer IDs_ (not the actual layers
themselves). (Pre-1.10 the image IDs were were conflated with layer
IDs.) The hash/digest of the configuration and layer IDs [determines
the __image ID__][image-ids]. The image ID will not be the same
between two independent builds due to timestamps included in the
configuration information.

Filesystem storage for a container is in one of three forms. All but
layers are configured with `docker run --mount`.
- A __layer__, which stores files changed/deleted its parent layer.
  (These are slower than other forms of storage.) The __layer ID__ is
  [a hash (or digest) of its contents][image-ids] in the form
  _algo:hexstring_, e.g., `sha256:fc92ee...`. There is also a separate
  ID for the compressed version of the layer used in registry manifests.
- __Bind mounts__ (`--mount`) which map an arbitrary host directory or
  file into a container's directory tree. (Devices must be mapped
  separately with `--device`.) Usually used for sharing data between
  host and container. 
- A Docker __volume__, which is an independent store in the host
  filesystem (usu. `/var/lib/docker/volumes`) and not removed when a
  container using it is removed. New empty volumes mounted over an
  existing directory tree in a container will be filled with a copy of
  that directory tree before being mounted over it (hiding it as usual
  for mounts).

#### Image and Layer Management, Aliases, Repositories, Registries

Each Docker instance (daemon) has a local set of images and their
associated layers; these are either created locally using the [`docker
build`] process or pulled (copied) from a registry. Newly built images
will always have a new image ID (see above), but commands that can be
determined to create a layer with identical content to an existing
layer will re-use that existing layer.

As well as their image IDs, images may also be identified by an
__alias__ formed from the __repository name__ and __tag__, e.g.
`alpine:latest`. An alias within a store may point to different images
over time.
- The name portion of an alias is slash-separated components
  consisting of lower-case letters, digits, and separators that may
  not start the name. Separators are single `.`, one or two `_`, and
  any number of `-`.
- The name portion is optionally prefixed by a registry hostname that
  cannot contain `_`. The hostname must either contain a `.` or be
  followed by a `:` and port number. If no hostname is present,
  `registry-1.docker.io` is used.
- The tag portion of an alias is separated by a colon from the name,
  no more than 128 characters, may not start with `.`/`-`, and is
  otherwise letters, digits, and `_`/`.`/`-`. If not specified it
  defaults to `:latest`.

A __registry__ is an image store from which one can __pull__ images to
or __push__ images from a local Docker instance. Registries use a
standard [HTTP API] currently at version 2. Images in registries are
stored in collections known as __repositories__; each collection
usually contains different versions of an image designed for a
particular purpose (e.g., `alpine`). See the [Docker Hub] registry
(and below) for an example.


Further Reading
-------------

* [Explaining Docker Image IDs][image-ids].
* [Terra Nullius]. Blog that covers
  "everyday hacks for Docker," e.g. [multi-stage build][multistage].



<!-------------------------------------------------------------------->
[`docker build`]: https://docs.docker.com/engine/reference/commandline/build/
[engine CLI]: https://docs.docker.com/engine/reference/commandline/cli/
[reference documentation]: https://docs.docker.com/reference/

[Terra Nullius]: https://alexei-led.github.io/
[image-ids]: https://windsock.io/explaining-docker-image-ids/
[multistage]: https://alexei-led.github.io/post/node_docker_multistage/
