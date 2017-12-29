[GitLab CI Runners]
===================

Runners get jobs from the 'coordinator', which is the GitLab
installation to which they've been registered. The entire runner
system is a single `gitlab-runner` binary. Logs go to the system
logger (syslog).

* `gitlab-runner --help`
* [Commands List][] (including signals, etc.)
* Debug mode: `gitlab-runner --debug run`.
* [FAQ][]

If started as root, the runner runs in system mode, otherwise in
user mode. The TOML format [config file] for each mode is:

* system: `/etc/gitlab-runner/config.toml`
* user:   `~/.gitlab-runner/config.toml`.


### Autoscaling

The [Autoscale GitLab CI runners][aws-autoscale] describes how to configure
a system that can spin up and down EC2 instances as the load varies.


Installation
------------

#### [Manual Install]

    # Versions avilable: amd64 386 arm
    wget -O /usr/local/bin/gitlab-runner \
        https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
    chmod +x /usr/local/bin/gitlab-runner

    useradd --create-home --shell /bin/bash \
        --comment 'GitLab Runner' gitlab-runner
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



[FAQ]: https://docs.gitlab.com/runner/faq/README.html
[GitLab CI Runners]: https://docs.gitlab.com/ee/ci/runners/README.html
[aws-autoscale]: https://substrakthealth.com/news/gitlab-ci-cost-savings/
[commands list]: https://docs.gitlab.com/runner/commands/README.html
[config file]: https://docs.gitlab.com/runner/configuration/advanced-configuration.html
[manual install]: https://docs.gitlab.com/runner/install/linux-manually.html
[package install]: https://docs.gitlab.com/runner/install/linux-repository.html
[register]: https://docs.gitlab.com/runner/register/index.html
