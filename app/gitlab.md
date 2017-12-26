[GitLab]
========

Much like GitHub, UI isn't as good, but does have some features that
GitHub doesn't have. Main selling point over GitHub Enterprise is a
free ("Community") version you can [install] on your own servers. They
have official Docker images which may be the easiest way to use it.
(Not clear if these include the DBMS or rely on an existing one in the OS.)


[GitLab CI]
-----------

You specify build descriptions in `.gitlab-ci.yml`. Runners are
triggered by the Web UI, [triggers] or new commits that do not contain
`[ci skip]` or `[skip ci]`) in the message. Triggers require
[permissions].


### [Build Configuration]

The build description in `.gitlab-ci.yml` specifies a __pipeline__
with multiple __stages__, each containing zero or more __jobs__ that
are executed in parallel. The build aborts if any jobs fail. Stages
default to `build`, `test` and `deploy` if not explicitly set; jobs
are assigned to the `test` stage if not explicitly assigned.

The `/ci/lint` path in your GitLab instance contains a validator for
`.gitlab-ci.yml` files. There are also [example build configs].

#### Directives

The [YAML] ([refcard]) build description is a combination of the
following top-level elements.

* `image` and `services`: [Docker config] (if using the `docker` executor)
* `before_script`, `after_script`: list or multi-line string
* `stages`, `types`: List of stages; default `[build, test, deploy]`).
  Stages are run in order listed. `types` is a deprecated alias.
* `variables`: Map of [variables] defined for all jobs.
* `cache`: See <https://docs.gitlab.com/ee/ci/yaml/README.html#cache>

All other top level elements are names of [jobs], each of which is a
dictionary with a required `script` parameter and any other optional
parameters. Job names starting with `.` are 'hidden' and will be ignored;
[special YAML features] can turn them into templates.

* `script`: Commands to be executed (list or multi-line string)
* `image`, `services`: As above.
* `stage`: Stage to contain this job; default `test`.
* `type`: Deprecated alias for `stage`.
* `variables`: Map of job [variables]; if present, entirely replaces
   global var map. Turn off global vars with `variables: {}`.
* `only`, `except`: Lists of Git refs for which job is/is not created.
  Can be quite complex; see [only and except].
* `tags`: List of tags; runner must have all of these tags too.
* `allow_failure: true`: This job doesn't contribute to failure status.
* `when`: [When] to run jobs:
  - `on_success`: (default) when all jobs from prior stages succeeded
  - `on_failure`: when at least one job from prior stage failed
  - `always`: always regardless of any prior job status
  - `manual`: [manual action] started by user in console (blocks pipeline at
    this stage by default; set `allow_failure: false` for non-blocking)
* `environment`: [Environments] for continuous deployment. Deployments are
  recorded under 'Piplines / Environments' in the project pages.
* `coverage`: Regexp to extract code coverage statement line from job
   output, e.g., `'/Coverage: \d+\.\d+/'`.
* `retry`: How many times (up to 2) to retry job.

#### [Variables]

Variable definitions may include other variables; `$` needs to be
escaped as `$$` if this isn't intended:

    variables:
      ECHO_CMD: 'echo job $CI_JOB_NAME with shell $$SHELL'

As well as any variables defined in the build configuration, there are
also a large number of preset variables. These are described on the
[variables] page, and include (but are not limited to):

* [`GIT_STRATEGY`]: `clone`, `fetch` (also does git clean) or `none`
* [`GIT_CHECKOUT`]: If `false` doesn't check out current branch
  (presumably script will do appropriate stuff, such as a merge)
* [`GIT_SUBMODULE_STRATEGY`]:
* `GET_SOURCES_ATTEMPTS`, `ARTIFACT_DOWNLOAD_ATTEMPTS`,
  `RESTORE_CACHE_ATTEMPTS`: default 1
* `GIT_DEPTH`: for shallow clones


### [Runners]

The [Autoscale GitLab CI runners][aws-autoscale] describes how to configure
a system that can spin up and down EC2 instances as the load varies.



[Build Configuration]: https://docs.gitlab.com/ee/ci/yaml/README.html
[Docker config]: https://docs.gitlab.com/ee/ci/docker/using_docker_images.html
[Environments]: https://docs.gitlab.com/ee/ci/environments.html
[GitLab CI]: https://docs.gitlab.com/ee/ci/README.html
[GitLab]: https://gitlab.com
[When]: https://docs.gitlab.com/ee/ci/yaml/README.html#when
[YAML]: https://en.wikipedia.org/wiki/YAML#Syntax
[`GIT_CHECKOUT`]: https://docs.gitlab.com/ee/ci/yaml/README.html#git-checkout
[`GIT_STRATEGY`]: https://docs.gitlab.com/ee/ci/yaml/README.html#git-strategy
[aws-autoscale]: https://substrakthealth.com/news/gitlab-ci-cost-savings/
[example build configs]: https://docs.gitlab.com/ee/ci/examples/README.html
[install]: https://about.gitlab.com/installation/
[jobs]: https://docs.gitlab.com/ee/ci/yaml/README.html#jobs
[manual action]: https://docs.gitlab.com/ee/ci/yaml/README.html#manual-actions
[only and except]: https://docs.gitlab.com/ee/ci/yaml/README.html#only-and-except-simplified
[permissions]: https://docs.gitlab.com/ee/user/project/new_ci_build_permissions_model.html
[refcard]: http://yaml.org/refcard.html
[runners]: https://docs.gitlab.com/ee/ci/runners/README.html
[special YAML features]: https://docs.gitlab.com/ee/ci/yaml/README.html#special-yaml-features
[triggers]: https://docs.gitlab.com/ee/ci/triggers/README.html
[variables]: https://docs.gitlab.com/ee/ci/variables/README.html
