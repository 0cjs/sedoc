[GitLab CI Runners]
===================

Source code repo: <https://gitlab.com/gitlab-org/gitlab-runner>

Runners get jobs from the 'coordinator', which is the GitLab
installation to which they've been registered. The entire runner
system is a single `gitlab-runner` binary. Logs go to the system
logger (syslog).

* `gitlab-runner --help`
* [Commands List][] (including signals, etc.)
* Debug mode: `gitlab-runner --debug run`.
* [FAQ][]

If started as root, the runner runs in system mode, otherwise in user
mode. (The latter will not work with a properly secured Docker
installation.) The [TOML] format [config file][`config.toml`] for each
mode is:

    system  /etc/gitlab-runner/config.toml
    user    ~/.gitlab-runner/config.toml

### Autoscaling

The [Autoscale GitLab CI runners][aws-autoscale] describes how to configure
a system that can spin up and down EC2 instances as the load varies.


Installation
------------

#### [Manual Install]

This is from the docs, but is more or less the process done by the
Debian package [post-install] script.

    # Versions avilable: amd64 386 arm
    wget -O /usr/local/bin/gitlab-runner \
        https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
    chmod +x /usr/local/bin/gitlab-runner

    useradd --system --create-home --shell /bin/bash \
        --comment 'GitLab Runner' gitlab-runner
    # Set up /etc/init/gitlab-runner.conf or systemd unit.
    gitlab-runner install --user=gitlab-runner \
        --working-directory=/home/gitlab-runner
    gitlab-runner start

To update, `gitlab-runner stop`, download the new binary, restart.

#### [Package Install]

The Debian package is `gitlab-ci-multi-runner` from `packages.gitlab.com`.
You can install the repo with their script:

    curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh \
        | sudo bash

This sets `/etc/apt/sources.list.d/runner_gitlab-ci-multi-runner.list`
to contain something like:

    deb-src https://packages.gitlab.com/runner/gitlab-ci-multi-runner/ubuntu/ xenial main

### Registration

You'll need a registration token:
* Shared runner: from `admin/runners` page.
* Specific runner: from project page, 'Settings', 'CI/CD Pipelines'.

Run `gitlab-runner register` (`docker exec -it gitlab-runner
gitlab-runner register` if running it in a Docker container) for an
interactive registration. This will always add a new entry to the
config file, not replace any existing ones.

* You'll be asked for the GitLab instance URL.
* The (registration) token comes from GitLab Admin UI.
* The description, tags, etc. can be changed in GitLab admin UI.
* If using a docker executor, the image you choose is the default for
  projects that don't specify one.

For non-interactive, use `gitlab-runner register --non-interactive ...`.


Configuration
-------------

Settings are made in [`config.toml`].

##### Configuration Section: Top Level

* `concurrent`: Concurrency level (default 1).
* `log_level`: Lower prio than command line setting. Values:
  `debug`, `info`, `warn`, `error`, `fatal`, `panic`.
* `check_interval`: How often to check GitLab for new builds.
* `sentry_dsn`: Send all system-level errors to Sentry.
* `metrics_server`: Prometheus HTTP server `host:port`.

##### Configuration Section: `[[runners]]`

* `name`: Ignored as a comment.
* `url`: GitLab instance
* `clone_url`: Overrides `url` if that can't be used to clone
* `token`: Runner token
* `tls-ca-file`, `tls-cert-file`, `tls-key-file`
* `limit`: Limits job concurrency, if less than `concurrent` above.
  Default 0 (no limit).
* `request_concurrency`: Limit number of concurrent requests for new
  jobs from GitLab. Default 1.
* [`executor`]: Which system to use to run the build.
* `shell`: One of `bash`, `sh`, `cmd`, `powershell`.
* `builds_dir`, `cache_dir`: Change build and cache dir mount paths.
  The cache path must be explicitly declared as persistent
  (see `volumes` below).
* `environment`
* `output_limit`: Max size of log. Default 4 MB.
* `pre_clone_script`, `pre_build_script`, `post_build_script`

##### Configuration Section: `[[runners.cache]]`

For the [distributed cache] feature. (Shared via AWS S3.)

### Docker Build Container Configuration

The [Docker executor] documentation gives details on what's summarized
below.

Two directories, `/builds/$GITLAB_USER_ID` and `/cache`, are
bind-mounted into the Docker containers used for the build. (The
`$CI_PROJECT_DIR` directory in which the build is done is
`/builds/$GITLAB_USER_ID/$CI_PROJECT_NAME`.)

The build runs as follows:
1. Start service containers.
2. Run a [gitlab-runner-helper] container which populates the above
   directories by cloning the repo, downloading any artifacts from
   previous stages and restoring the cache.
3. Run the build containers which do the pipeline stages.
4. Run the helper image again to save the cache and new build artifacts.
5. Shut down and remove all containers.

The build containers [do not override][glentry] the [ENTRYPOINT] of
their images, so if that's set the specified script will not be
executed. This can be used for security purposes....

##### Configuration Section: [`[runners.docker]`][Docker executor]

* `image`: Image name for build container.
  (Also available in `.gitlab-ci.yml`.)
* `services`: List of image names or [configuration maps]
  for the services containers, if necessary. See below.
  (Also available in `.gitlab-ci.yml`.)
* `tmpfs`, `services_tmpfs`: Map of tmpfs mounts, usually used to
  speed tests that do a lot of IO.
* `volumes`: List of storage paths persisted between builds (see below).
  The default cache dir is automatically in this list.
* `privileged`: Enable privileged mode to use Docker-in-Docker.
* [`pull_policy`]: `never` (use only local images), `if-not-present`
  (faster; will not fetch updated images unless local image manually
  deleted), `always` (default).

###### Volume Configuration

The `volumes` parameter is a list of strings.
* `"/path/to/bind/in/container"` mounts a [Docker volume] that persists
  between uses of the build container. The volume name is managed by
  gitlab-runner.
* `"/path/to/bind/from/host:/path/to/bind/in/container:ro"` does a
  [bind mount]. Use `rw` for a read-only mount.

Examples:
* [Volumes in the [runners.docker] section][volumes]
* At the end of the [GitLab CI and conda] blog post

#### Docker Service Containers

The runner can start extra containers to provide services to the build
container; these are usually used to provide heavy-weight services
such as MySQL. These use Docker [container links] (the `--link` option
to `docker run`).

The containers have the `/builds` directory mounted in them.

When started the waits until it can open a TCP connection to the first
exposed service in each container to ensure that they're alive, as per
the [gitlab-runner-service] script.

There are [service container examples].

#### Private Container Registry

See [Using a private container registry][priv-cont-reg].



[Docker executor]: https://docs.gitlab.com/runner/executors/docker.html
[Docker volume]: https://docs.docker.com/engine/admin/volumes/volumes/
[ENTRYPOINT]: https://docs.docker.com/engine/reference/run/#entrypoint-default-command-to-execute-at-runtime
[FAQ]: https://docs.gitlab.com/runner/faq/README.html
[GitLab CI Runners]: https://docs.gitlab.com/ee/ci/runners/README.html
[GitLab CI and conda]: https://beenje.github.io/blog/posts/gitlab-ci-and-conda
[TOML]: https://en.wikipedia.org/wiki/TOML
[`config.toml`]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html
[`executor`]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-executors
[`pull_policy`]: https://docs.gitlab.com/runner/executors/docker.html#how-pull-policies-work
[aws-autoscale]: https://substrakthealth.com/news/gitlab-ci-cost-savings/
[bind mount]: https://docs.docker.com/engine/admin/volumes/bind-mounts/
[commands list]: https://docs.gitlab.com/runner/commands/README.html
[configuration maps]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/ci/docker/using_docker_images.md#extended-docker-configuration-options
[container links]: https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/
[distributed cache]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runners-cache-section
[gitlab-runner-helper]: https://hub.docker.com/r/gitlab/gitlab-runner-helper/
[gitlab-runner-service]: https://gitlab.com/gitlab-org/gitlab-runner/blob/master/dockerfiles/build/gitlab-runner-service
[glentry]: https://docs.gitlab.com/runner/executors/docker.html#the-entrypoint
[manual install]: https://docs.gitlab.com/runner/install/linux-manually.html
[package install]: https://docs.gitlab.com/runner/install/linux-repository.html
[post-install]: https://gitlab.com/gitlab-org/gitlab-runner/blob/master/packaging/root/usr/share/gitlab-runner/post-install
[priv-cont-reg]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html#using-a-private-container-registry
[register]: https://docs.gitlab.com/runner/register/index.html
[service container examples]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/ci/services/README.md
[volumes]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html#volumes-in-the-runners-docker-section
