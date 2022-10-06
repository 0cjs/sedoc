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
* [Servers, Contexts and Orchestration](server.md)
* [Security](security.md): Docker Security
* [Miscellaneous Information](misc.md)
* [Tips](tips.md): Docker Tips; handy commands and the like

External Documentation:
* [Reference documentation] for complete documentation.
* [Engine CLI] for `docker` command details.
  (This provides a lot of information not in the manpages.)


Terminology
-----------

### Containers, Images, Filesystems

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
configuration information. The caching system will re-use previously built
images if present; see [`image.md`](image.md) for details.

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

### Image and Layer Storage and Naming

Each Docker instance (daemon) has an image store, a local set of images and
their associated layers. These are either created locally using the
[`docker build`] process or pulled (copied) from a _registry._ Newly built
images will always have a new image ID (see above), but the caching system
may re-use previously built or downloaded layers.

#### Aliases, Repositories and Tags

As well as their image IDs, images may also be identified by an __alias__
of no more than 128 characters. (An image _name_ is only part of the alias;
see below.) An alias within a store may point to different images over
time. __NOTE:__ The `docker tag` command is misnamed; sets the entire
alias, not just the tag.

The alias is in two parts, the _repository_ and _tag._ Both of these are
arbitrary strings with no semantic significance to Docker (with one
exception below):
* The tag, while often used as a version number, is never compared with
  other tags by Docker (i.e., it's entirely up to the user whether `latest`
  really is the latest version of an image).
* The "repository" does not refer to storage or location (unlike a Git
  repository). The one exception is that the docker `push` and `pull`
  subcommands will try to use the _hostname_ prefix as a hostname; invalid
  hostnames will not affect any other commands.

All aliases include a __tag,__ whether explicitly specified or not. If
specified it is suffixed to the _repository_ with a colon (`:`) separator.
If not specified the default tag `latest` is used (`alpine` and
`alpine:latest` are the same alias). The tag is no more than 128 characters
long, contains only characters from `[A-Za-z0-9_.-]` and may not start with
`.` or `-`. (In particular note that `:` and `/` are not allowed in tags.)

Some sub-commands that can specify multiple images (docker `ls`, `push`,
`pull --all-tags`, etc.) may take just a _repository_ rather than an
_alias;_ in that case the repository refers to all aliases with that
repository component, regardless of tag.

The __repository__ is one or more slash-separated _name components_ with an
optional _registry hostname_ prefixing the name components.
* A __name component__ is no more than 32 characters from `[a-z0-9]` and
  separators that may not start or end the name. Separators are single `.`,
  one or two `_`, and any number of `-`.
* The __name__ is all (slash-separated) components excepting the optional
  registry hostname. (Per [`docker tag` documentation][docker-tag].)
* The name is optionally prefixed by a registry __hostname__ that cannot
  contain `_`. The hostname must either contain a `.` or be followed by a
  `:` and port number.
* A _name_ with no hostname has an implicit prefix of `docker.io/library/`.
  E.g., `debian:11` becomes `docker.io/library/debian:11`.
  - This implicit prefix cannot be changed; allowing different ones would
    be a [security issue][so 67351972].
  - Some documentation specifies that the hostname `registry-1.docker.io`
    is used; this also works, but only if the `/library/` fragment is still
    included.
* Docker documentation terminology is inconsistent, particuarly with the
  term "name."
  - In [`docker tag`] a repository is sometimes called a "name" and a tag
    is sometimes called a "tag name."
  - [`docker pull`] sometimes uses "name" to refer to a repository and
    sometimes to an alias (e.g., `debian:jessie` and `debian:latest` being
    "different names").

#### Registries

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
* [Terra Nullius]. Blog that covers "everyday hacks for Docker," e.g.
  [multi-stage build][multistage].



<!-------------------------------------------------------------------->
[`docker build`]: https://docs.docker.com/engine/reference/commandline/build/
[engine CLI]: https://docs.docker.com/engine/reference/commandline/cli/
[reference documentation]: https://docs.docker.com/reference/

[`docker pull`]: https://docs.docker.com/engine/reference/commandline/pull/
[`docker tag`]: https://docs.docker.com/engine/reference/commandline/tag/
[so 67351972]: https://stackoverflow.com/a/67351972/107294

[Terra Nullius]: https://alexei-led.github.io/
[image-ids]: https://windsock.io/explaining-docker-image-ids/
[multistage]: https://alexei-led.github.io/post/node_docker_multistage/
