Docker Registries, Private and Public Images
============================================

* [Overview](README.md) | [Install/Config](config.md) | [Image Build](image.md)
  | [Registries](registries.md) | [Security](security.md) | [Tips](tips.md)


Terminology reminder: a _registry_ is a single server that serves
multiple _[repositories][repository]_ which are sets of related
images.


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

### Alternative Registries to Docker Hub

- Set up your own [Docker Registry][registry].  
  (See section below for more information on this.)
- [Google Cloud][gcp-registry].
- [Amazon Elastic Container Registry][aws-ecr].
- [GitLab].


Registry Operations
-------------------

### Authentication

Use `docker login` to [authenticate] if the registry requires it.
Credentials are stored in `~/.docker/config.json`.

If authentication is required when using the REST API with `curl`,
you can:
- check the headers (with `-i` or `-v`) for the auth type, or
- try `--auto-auth --user USERNAME` or,
- try `-H 'Authorization: Bearer TOKEN'` where _TOKEN_ is taken from
  your `~/.docker/config.json` file, [docker-ls], [registry-cli], or
- something else. I've not been able to get anything to work.

### Listing Images/Repositories/Tags

To list a registry's repositories and a respository's tags:

    curl https://myregistry:5000/v2/_catalog
    curl https://myregistry:5000/v2/REPONAME/tags/list

### Deleting Images

The original Docker API offered no means of deleting an image (as
opposed to all images in a repo) from a registry. Some solutions
(including those for an updated API) are offered at [SO 25436742].

### Other Operations

The [scopeo] command line tool offers further tools for
inspecting/copying/etc. images both locally and in registries.


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


Setting up a Registry
---------------------

The `registry:2` image from Docker Hub is the standard registry
server, documented under [Docker Registry][registry].

Image naming is slightly different from Hub (plain names or
`docker.io/` followed by the name). Rather than the fixed
`user/imagename` format, with `ubuntu` being translated to
`library/ubuntu`, image names are any arbitrary path with 1 or more
components. (File name conflicts are avoided because path components
may not start with `_`.)

### Test Registry Server

[Deploy a registery server][registry-deploy] gives a tutorial on
starting a test version of the server accessed via
`localhost:5000/imagename`. Images are stored in the container itself
and will vanish when the container is deleted.

The server will be listening on all the host's addresses and not using
TLS. The Docker client will access it without TLS when the repository
is given as , but will fail with `remote error: tls: handshake
failure` when trying to access it via the other addresses on which
it's listening. (But see below to change this.)

### Configuration

#### `docker run` Options

The registry container is typically started with:

    docker run -d -p 5000:5000 --restart=always --name registry registry:2

Some configuration is done via `docker run` options, typically:
- `--name registry`: Container name
- `--restart=always`: Restart automatically when Docker daemon (re)starts.
- `-p 5000:5000`: Use standard Docker registry port.
- `-p 127.0.0.1:5000:5000`: Listen on just one interface, not `0.0.0.0`.
  (Both ports must be present only IP addrs, not hostnames, can be used.)
- `-p 5001:5000`: Listen on different port. (Also can use  `-e
  REGISTRY_HTTP_ADDR=0.0.0.0:5001` to change port in container. Note that
  `0.0.0.0` is all interfaces _within the container_.)
- `-v /my/path/to/data:/var/lib/registry`: Use bind mount instead of Docker
  volume for image and data storage.

#### Configuration File and Environment Overrides

See [Configuring a registry][registry-config] for all config options.
Some params (e.g., `version`) are required. Required child params are
needed only if their parent param exists.

A YAML file holds the base configuration; the values can be overridden
via environment variables of form `REGISTRY_*`, e.g. use
`REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/somewhere` to override:

    storage:
        filesystem:
            rootdirectory: /var/lib/registry

Override the entire default config file by bind mounting your config
over `/etc/docker/registry/config.yml`. You may base yours on the
[example config file][registry-exampleconfig].

#### Authentication and TLS Configuration

[HTTP basic authentication][registry-basicauth] is built int. This
will not work without TLS. (Nor will any other authentication system
that sends credentials as clear text.)

TLS setup can be done automatically with [Let's Encrypt ACME
protocol][letsencrypt] (server must use port 443) with [config file
vars][regconf-letsenrypt] `cachefile` (file for Let's Encrypt agent to
cache data) and `email` (email address to register with Let's
Encrypt).

For manual TLS setup, certs are mounted into `/certs` in the container
and `REGISTRY_HTTP_TLS_{CERTIFICATE,KEY}` env vars are set. Typically
also TLS registries are seved on port 443.

The daemon can also be [configured to use insecure
registries][registry-insecure] for addresses other than localhost.

#### Backend Storage

Distributed storage drivers such as AWS S3 can share a single storage
backend amongst multiple registry servers. They must also share the
same HTTP secret to co-ordinate uploads. (And probably want to share
the same Redis cache, if configured.)



<!-------------------------------------------------------------------->
[Docker Hub]: https://hub.docker.com/explore/
[Docker Store]: https://store.docker.com/
[SO 25436742]: https://stackoverflow.com/q/25436742/107294
[SO 28320134]: https://stackoverflow.com/q/28320134/107294
[authenticate]: https://docs.docker.com/registry/spec/auth/jwt/
[aws-ecr]: https://aws.amazon.com/ecr/
[docker pull]: https://docs.docker.com/engine/reference/commandline/pull/
[gcp-registry]: https://cloud.google.com/container-registry/docs/pushing-and-pulling?hl=en_US
[gitlab]: https://about.gitlab.com/2016/05/23/gitlab-container-registry/
[letsencrypt]: https://letsencrypt.org/how-it-works/
[official repos]: https://docs.docker.com/docker-hub/official_repos/
[regconf-letsenrypt]: https://docs.docker.com/registry/#letsencrypt
[registry-basicauth]: https://docs.docker.com/registry/#native-basic-auth
[registry-config]: https://docs.docker.com/registry/configuration/
[registry-deploy]: https://docs.docker.com/registry/deploying/
[registry-exampleconfig]: https://github.com/docker/distribution/blob/master/cmd/registry/config-example.yml
[registry-insecure]: https://docs.docker.com/registry/insecure/
[registry]: https://docs.docker.com/registry
[repo-info]: https://github.com/docker-library/repo-info/tree/master/repos
[repository]: https://docs.docker.com/docker-hub/repos/
[scopeo]: https://github.com/projectatomic/skopeo
