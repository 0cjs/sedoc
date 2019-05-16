GitLab CI Runners
=================

* [GitLab](gitlab.md) | [GitLab CI](gitlab-ci.md)
  | [GitLab Runner](gitlab-runner.md)

This covers the sysadmin side of GitLab runner configuration. See
[GitLab CI](gitlab-ci.md) for documentation on how to set up your
`.gitlab-ci.yml` file.

- Documentation: [GitLab CI Runners]
- Source code repo: <https://gitlab.com/gitlab-org/gitlab-runner>

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

#### Autoscaling

The [Autoscale GitLab CI runners][aws-autoscale] describes how to configure
a system that can spin up and down EC2 instances as the load varies.


Management
----------

#### Daemon Management and Logging

The `gitlab-runner` command-line program knows how to start, stop,
restart, etc. the daemon. No args gives help.

The running daemon detects changes to `/etc/gitlab-runner/config.toml`
and reloads the config file. Some bad syntax may cause it to exit;
other bad configuration directives (such as `image: { name: ...`) may
not be detected until it tries to run a job.

Logs go to `/var/log/messages` on Ubuntu 14.04.

#### Manually Removing Cache Containers

You may need to manually delete the cache containers (see below) from
time to time. This can be done for all projects with a command like:

    sudo docker rm $(sudo docker ps -a --format='{{.ID}}' \
        --filter name=runner-9b285da7-project-[0-9]*-concurrent-[0-9]*-cache-)

Replace the first `[0-9]*` with a project number, available from
looking at a build log, to remove the containers for a particular
project.


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

The Debian package is available from `packages.gitlab.com`.
You can install the repo with their script:

    curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh \
        | sudo bash

This sets `/etc/apt/sources.list.d/runner_gitlab-ci-multi-runner.list`
to contain something like:

    deb-src https://packages.gitlab.com/runner/gitlab-ci-multi-runner/ubuntu/ xenial main

The repo provides a `gitlab-runner` package (previously named
`gitlab-ci-multi-runner`) that installs the binary, adds a
gitlab-runner user and sets up the system starup scripts using
`gitlab-runner install`.

#### Dockerized Runner Install

`gitlab-runner` can be [run in a Docker container][glr-dockerized],
usually configured so that containers started by the runner will be
run and managed by the host.

GitLab supplies a `gitlab/gitlab-runner` image for the container. This
requires the config dir (containing `config.toml`) and the host's
Docker socket to be bind-mounted into the container (with special
SELinux config if necessary). Sample startup command:

    docker run -d --name gitlab-runner --restart always \
        -v /srv/gitlab-runner/config:/etc/gitlab-runner \
        -v /var/run/docker.sock:/var/run/docker.sock \
        gitlab/gitlab-runner:latest

When the container is started for the first time the standard setup
below can be followed.

### Connection to a GitLab Server

GitLab Runner configuration information is split between the local
configuration file (`/etc/gitlab-runner/config.toml`) on the host
running `gitlab-runner` and the GitLab server.

There are two tokens discussed here:
* The _registration token_ which is used only when creating a new
  runner on the GitLab server.
  * Shared runners use the token from the `/admin/runners` page.
  * Specific runner runners use the token from from project page
    under 'Settings', 'CI/CD Pipelines'.
* The _(runner) token_ which identifies and authenticastes an existing
  runner on the GitLab server. For shared runners this is visible to
  admins on the GitLab server; for specific runners this appears to be
  visible to anybody with admin rights for a project using it.

#### Registration of a New Runner

To create a new runner on GitLab, run `gitlab-runner register`
(`docker exec -it gitlab-runner gitlab-runner register` if running it
in a Docker container) for an interactive registration. This will
always add a new entry to the config file, not replace any existing
ones. Supply at the prompts:
* The GitLab instance URL
* The _registration token_
* The runner's description, tags, whether to run untagged builds,
  and whether to lock the runner to a project. (These can all be
  changed later in the GitLab server's configuration.)

Once the registration succeeds you will be prompted for additional
locally configured information:
* The executor (usually `docker`)
* The default Docker image (e.g., `ubuntu:14.04`)

#### Non-interactive Registration

For non-interactive, use `gitlab-runner register --non-interactive ...`.

#### Connection of an Existing Runner

To have any runner connect as a runner already configured on the
GitLab server you can copy the config file information into the config
file. (The (runner) _token_ field is the key information here. Almost
everything else is ignored except for the executor and some of its
configuration such as the default Docker image.)

The `gitlab-runner register` command also appears as if it offers the
options to do this, but I've not been able to get it to work. With a
previously registered token, using e.g.

    gitlab-runner register --non-interactive \
      --url https://gitlab.mydomain.com \
      --token 0123abcd0000000000000000000000 \
      --executor docker --docker-image ubuntu:14.04

produces

    ERROR: Verifying runner... is removed               runner=0123abcd

(Possibly I should have used `--leave-runner` when testing.)


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
  If changed, the cache path must be explicitly declared as persistent
  (see `volumes` parameter below).
* `environment`
* `output_limit`: Max size of log. Default 4 MB.
* `pre_clone_script`, `pre_build_script`, `post_build_script`

##### Configuration Section: `[[runners.cache]]`

For the [distributed cache] feature. (Shared via AWS S3.)

### Docker Build Container Configuration

Some information here comes from the (incomplete, and not always
correct) [Docker executor] documentation, the rest comes from manual
inspection of cached volumes and containers.

By default two persistent [Docker volume]s are created and populated
before the build container runs; these are mounted on:
`/builds/$GITLAB_USER_ID` and `/cache` (but apparently never both in
the same container). (The `$CI_PROJECT_DIR` directory in which the
build is done is `/builds/$GITLAB_USER_ID/$CI_PROJECT_NAME`.) The
docmentation claims that, unless configured otherwise, only the
`/cache` volume is saved between builds, but it appears from the build
behaviour that the `/builds` volume is also saved in order to avoid a
full `git clone` (instead doing a fetch and working copy clean and
reset) for every build.

The build runs as follows:
1. Start service containers.
2. Run a [gitlab-runner-helper] container which populates the
   `/builds/$GITLAB_USER_ID` volume by cloning the repo,
   downloading any artifacts from previous stages and restoring
   (from the `/cache` volume) any files configured as [cached].
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
* [`pull_policy`]: `always` (default); `never` (use only local
  images); `if-not-present`. See below for more.

Some pull policies have several implications:
- `always` disallows the use of local-only images, since even if it's
  locally present the runner will abort if it can't access the server
  or find a copy of the image on the server. The credentials used to
  access the registry are those of the GitLab who triggered the build,
  ensuring that he is allowed to access data in that image. (For more
  on this, see [issue 1905].) This pull policy will ensure that the
  latest update of the requested image tag is always used.
- `if-not-present` has security issues where users may be able to use
  images which to which their credentials do not allow access, since
  no repository check is made. (For more on this, see the [runner
  image security note].) This also will not fetch an updated image
  unless the local copy of the image is manually deleted, making it
  problematic for tags that are updated (e.g., `:latest`). This can be
  faster if repository access is slow.

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



<!-------------------------------------------------------------------->
[Docker executor]: https://docs.gitlab.com/runner/executors/docker.html
[Docker volume]: https://docs.docker.com/engine/admin/volumes/volumes/
[ENTRYPOINT]: https://docs.docker.com/engine/reference/run/#entrypoint-default-command-to-execute-at-runtime
[FAQ]: https://docs.gitlab.com/runner/faq/README.html
[GitLab CI Runners]: https://docs.gitlab.com/ee/ci/runners/README.html
[GitLab CI and conda]: https://beenje.github.io/blog/posts/gitlab-ci-and-conda
[TOML]: ../lang/toml.md
[`config.toml`]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html
[`executor`]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-executors
[`pull_policy`]: https://docs.gitlab.com/runner/executors/docker.html#how-pull-policies-work
[aws-autoscale]: https://substrakthealth.com/news/gitlab-ci-cost-savings/
[bind mount]: https://docs.docker.com/engine/admin/volumes/bind-mounts/
[cached]: https://docs.gitlab.com/ee/ci/yaml/README.html#cache
[commands list]: https://docs.gitlab.com/runner/commands/README.html
[configuration maps]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/ci/docker/using_docker_images.md#extended-docker-configuration-options
[container links]: https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/
[distributed cache]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runners-cache-section
[gitlab-runner-helper]: https://hub.docker.com/r/gitlab/gitlab-runner-helper/
[gitlab-runner-service]: https://gitlab.com/gitlab-org/gitlab-runner/blob/master/dockerfiles/build/gitlab-runner-service
[glentry]: https://docs.gitlab.com/runner/executors/docker.html#the-entrypoint
[glr-dockerized]: https://docs.gitlab.com/runner/install/docker.html
[issue 1905]: https://gitlab.com/gitlab-org/gitlab-runner/issues/1905#note_18854574
[manual install]: https://docs.gitlab.com/runner/install/linux-manually.html
[package install]: https://docs.gitlab.com/runner/install/linux-repository.html
[post-install]: https://gitlab.com/gitlab-org/gitlab-runner/blob/master/packaging/root/usr/share/gitlab-runner/post-install
[priv-cont-reg]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html#using-a-private-container-registry
[register]: https://docs.gitlab.com/runner/register/index.html
[runner image security note]: https://docs.gitlab.com/runner/security/index.html#usage-of-private-docker-images-with-if-not-present-pull-policy
[service container examples]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/ci/services/README.md
[volumes]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html#volumes-in-the-runners-docker-section
