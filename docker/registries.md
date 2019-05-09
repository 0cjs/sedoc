Docker Registries, Private and Public Images
============================================

* [Overview](README.md) | [Install/Config](config.md) | [Image Build](image.md)
  | [Registries](registries.md) | [Security](security.md) | [Tips](tips.md)


Terminology reminder: a _registry_ serves multiple
_[repositories][repository]_ which are sets of related images.


Registries
----------

The default port for docker push/pull is 5000 (different from the
standard API ports 80/443). The default registry is [Docker Hub][]
(API at `index.docker.io`). Specify non-default registries to [docker
pull] with the registry, repository and image name separated by
slashes:

    docker pull docker-registry.example.com:5000/stuff/myimage:latest
                ___________________________ ____ _____________ ______
                       registry name        port   repository   tag

The port is optional, but the registry name/port must contain a `.` or
`:`. If the hostname has no `.`, add the default port of `:5000`.

Registries may require [authentication]. The `docker login` command
can do this; it stores the credentials in `~/.docker/config.json`.

To list a registry's repositories and a respository's tags:

    curl https://myregistry:5000/v2/_catalog
    curl https://myregistry:5000/v2/REPONAME/tags/list

If authorization is required you can check the headers (with `-i` or
`-v`) for the auth type, or try `--auto-auth --user USERNAME` or try
`-H 'Authorization: Bearer TOKEN'` where _TOKEN_ is taken from your
`~/.docker/config.json` file, [docker-ls], [registry-cli] or something
else. I've not been able to get anything to work.

The [scopeo] command line tool offers further tools for
inspecting/copying/etc. images both locally and in registries.

### Alternative Registries to Docker Hub

- Set up your own: [Deploy a registry server][registry-deploy].
- [Google Cloud][gcp-registry].
- [Amazon Elastic Container Registry][aws-ecr].
- [GitLab].

### Registry Operations

The original Docker API offered no means of deleting an image (as
opposed to all images in a repo) from a registry. Some solutions
(including those for an updated API) are offered at [SO 25436742].


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
* __ubuntu__ (85 MiB): tags `18.10`, `18.04` (latest),
  `16.04` (116 MiB), `14.04` (188 MiB)
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

[SO 28320134] may help with ways of listing images and tags from
various remotes.



<!-------------------------------------------------------------------->
[Docker Hub]: https://hub.docker.com/explore/
[Docker Store]: https://store.docker.com/
[SO 25436742]: https://stackoverflow.com/q/25436742/107294
[SO 28320134]: https://stackoverflow.com/q/28320134/107294
[authentication]: https://docs.docker.com/registry/spec/auth/jwt/
[aws-ecr]: https://aws.amazon.com/ecr/
[docker pull]: https://docs.docker.com/engine/reference/commandline/pull/
[gcp-registry]: https://cloud.google.com/container-registry/docs/pushing-and-pulling?hl=en_US
[gitlab]: https://about.gitlab.com/2016/05/23/gitlab-container-registry/
[official repos]: https://docs.docker.com/docker-hub/official_repos/
[registry-deploy]: https://docs.docker.com/registry/deploying/
[repo-info]: https://github.com/docker-library/repo-info/tree/master/repos
[repository]: https://docs.docker.com/docker-hub/repos/
[scopeo]: https://github.com/projectatomic/skopeo
