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
installation.) The [TOML] format [config file] for each mode is:

* system: `/etc/gitlab-runner/config.toml`
* user:   `~/.gitlab-runner/config.toml`.


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


Registration
------------

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

See the [Advanced configuration][config file] documentation.

You will almost certainly want to increase `concurrent` in the global
section. `limit` in the `[[runners]]` section defaults to 0 (no limit)
but can be set to further limit particular runners.

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

The following [configuration variables][Docker executor] are available
in both `.gitlab-ci.yml` and the `[runners.docker]` section of
`config.toml`:

* `image`: Image name for build container
* `services`: List of image names or [configuration maps] for the
  services images, if necessary. See below.
  
The following configuration variables are used only in the
`[runners.docker]` section of `config.toml`:

* `tmpfs`, `services_tmpfs`: Map of tmpfs mounts, usually used to
  speed tests that do a lot of IO.
* `volumes`: List of storage paths persisted between builds. The default
  cache dir is automatically in this list. These can be in custom cache
  containers or on host paths; the latter may be read-only. See the end
  of [GitLab CI and conda] for an example.
* `privileged`: Enable privileged mode to use Docker-in-Docker.
* [`pull_policy`]: `never` (use only local images), `if-not-present`
  (faster; will not fetch updated images unless local image manually
  deleted), `always` (default).


The following configuration variables are used only in the
`[runners]` section of `config.toml`:

* `builds_dir`, `cache_dir`: Change build and cache dir mount paths.
  The cache path must be explicitly declared as persistent (above).

### Docker Service Containers

The runner can start extra containers to provide services to the build
container; these are usually used to provide heavy-weight services
such as MySQL. These use Docker [container links] (the `--link` option
to `docker run`).

The containers have the `/builds` directory mounted in them.

When started the waits until it can open a TCP connection to the first
exposed service in each container to ensure that they're alive, as per
the [gitlab-runner-service] script.

There are [service container examples].



[Docker executor]: https://docs.gitlab.com/runner/executors/docker.html
[ENTRYPOINT]: https://docs.docker.com/engine/reference/run/#entrypoint-default-command-to-execute-at-runtime
[FAQ]: https://docs.gitlab.com/runner/faq/README.html
[GitLab CI Runners]: https://docs.gitlab.com/ee/ci/runners/README.html
[GitLab CI and conda]: https://beenje.github.io/blog/posts/gitlab-ci-and-conda
[TOML]: https://en.wikipedia.org/wiki/TOML
[`pull_policy`]: https://docs.gitlab.com/runner/executors/docker.html#how-pull-policies-work
[aws-autoscale]: https://substrakthealth.com/news/gitlab-ci-cost-savings/
[commands list]: https://docs.gitlab.com/runner/commands/README.html
[config file]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html
[configuration maps]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/ci/docker/using_docker_images.md#extended-docker-configuration-options
[container links]: https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/
[gitlab-runner-helper]: https://hub.docker.com/r/gitlab/gitlab-runner-helper/
[gitlab-runner-service]: https://gitlab.com/gitlab-org/gitlab-runner/blob/master/dockerfiles/build/gitlab-runner-service
[glentry]: https://docs.gitlab.com/runner/executors/docker.html#the-entrypoint
[manual install]: https://docs.gitlab.com/runner/install/linux-manually.html
[package install]: https://docs.gitlab.com/runner/install/linux-repository.html
[post-install]: https://gitlab.com/gitlab-org/gitlab-runner/blob/master/packaging/root/usr/share/gitlab-runner/post-install
[register]: https://docs.gitlab.com/runner/register/index.html
[service container examples]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/ci/services/README.md
