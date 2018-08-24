[GitLab]
========

Other documents related to this:
* [GitLab](gitlab.md) for general details about GitLab
* [GitLab Runner](gitlab-runner.md) for admin configuration of the
  runner software.


[GitLab CI]
-----------

You specify build descriptions in `.gitlab-ci.yml`.
[Runners](gitlab-runner.md) are triggered by the Web UI, [triggers] or
new commits that do not contain `[ci skip]` or `[skip ci]`) in the
message. The Web UI and triggers require appropriate [permissions]
(basically, ability to push to that branch).

Builds are triggered only for heads of branches and tags. If you push
up two commits on a branch in one push, only the last one will be
tested. If you want to trigger a build of a particular commit that
doesn't have a tag or ref pointing to it, you'll have to add one.

Runners may be [shared or specific]; the former can be used by any
project and use a [fair usage queue]; the latter are assigned to
specific projects and use a FIFO queue. Shared may be converted
to specific but not vice-versa.

The CI system includes continuous deployment (CD) support with
[environments] which, as well as being deployed to, can be monitored,
accessed via web terminals, etc.

### Build Configuration

The build description in `.gitlab-ci.yml` specifies a __pipeline__
with multiple __stages__, each containing zero or more __jobs__ that
are executed in parallel. The build aborts if any jobs fail. Stages
default to `build`, `test` and `deploy` if not explicitly set; jobs
are assigned to the `test` stage if not explicitly assigned.

Pipelines must have at least one (visible) job.

The `/ci/lint` path in your GitLab instance contains a validator for
`.gitlab-ci.yml` files. There are also [example build configs].

#### [Directives]

The [YAML] ([refcard]) build description is a combination of the
following top-level elements.

* `stages`: List of stages; default `[build, test, deploy]`).
  Stages are run in order listed. (`types` is a deprecated alias.)
* `image`, `services`, `before_script`, `after_script`, `variables`,
  `cache`: As per job elements below. These are defaults that are
  entirely overridden by (not combined with) settings in a job.
* [Jobs]; see below.

All other top level elements are names of [jobs], each of which is a
dictionary with a required `script` parameter and any other optional
parameters. Job names starting with `.` are 'hidden' and will be ignored;
[special YAML features] can turn them into templates.

* `script`: Commands to be executed (list or multi-line string). These
  are fed into whichever of the [shells] is available on the runner system.
* `image`, `services`: [Docker config] (if using the [Docker executor])
* `stage`: Stage to contain this job; default `test`.
  (`type` is a deprecated alias.)
* `variables`: Map of job [variables]; if present, entirely replaces
   global var map (i.e., turn off global vars with `variables: {}`).
   Values must be strings (see below).
* `only`, `except`: Lists of Git refs for which job is/is not created.
  Can be quite complex; see [only and except].
* `tags`: List of tags; runner must have all of these tags too.
* `allow_failure: true`: This job doesn't contribute to failure status.
  (But 'CI build passed with warnings' displayed on commit, etc.)
* `when`: [When] to run jobs:
  - `on_success`: (default) when all jobs from prior stages succeeded
  - `on_failure`: when at least one job from prior stage failed
  - `always`: always regardless of any prior job status
  - `manual`: [manual action] started by user in console (blocks pipeline at
    this stage by default; set `allow_failure: false` for non-blocking)
* [`dependencies`]: List of jobs from previous (completed) stages from which
  artifacts should be downloaded. Default is all jobs from previous stages.
  Status is ignored so there's no error trying to download artifacts that
  weren't created due to failure or a manual job that wasn't run.
* [`artifacts`]: Build products to keep after the job has finished.
  These can be downloaded from the GitLab UI. Keys in this map:
  - `paths` (list of shell globs?): files to keep
  - `untracked: true`: Keep all files not tracked by Git
  - `name`: Name of archive (default `artifacts`); `.zip` added when downloaded
  - `when`: When to store (upload) artifacts:
    `on_success` (default), `on_failure`, `always`
  - `expire_in`: When to delete (overridden with 'Keep' button in UI), e.g.
    `3 min 4 sec`, `2h20min`, `6 mos 2 weeks and 1d`.
* `cache`: See <https://docs.gitlab.com/ee/ci/yaml/README.html#cache>.
  You can use `*` globs, but may not end dirs with a `/`.
* `before_script`, `after_script`: list or multi-line string
* [`environment`]: [Environments] for continuous deployment. Deployments are
  recorded under 'Piplines / Environments' in the project pages.
  Sub-vars: `environment:name`, `url`, `on_stop`, `action`.
* `coverage`: Regexp to extract code coverage statement line from job
   output, e.g., `'/Coverage: \d+\.\d+/'`.
* `retry`: How many times (up to 2) to retry job.

#### [Variables]

Variable values must be strings, even for ostensibly boolean or
numeric values. Thus, while `foo: bar` will work, `foo: true` will
not; you must instead write `foo: 'true'`.

Variable definitions may include other variables interpolated with `$`.
Escape `$` by doubling it, `$$`.

    variables:
      ECHO_CMD: 'echo job $CI_JOB_NAME with shell $$SHELL'

[Secret variables] may be defined at the group (subgroups inherit) or
project level (under 'Settings / CI/CD Pipelines'). Job logs may show
them, but the pipelines can be set to private in public or internal
repos. Protected secret variables are passed only to piplines for
protected branches/tags. They can also be limited to certain [environments].

[Tracing] may be turned on by setting variable `CI_DEBUG_TRACE:
'true'`. This appears to be `bash -x`, is very, very noisy and will
probably display all your secrets in the output log.

##### Environment Variables

As well as any variables defined in the build configuration, there are
also a large number of predefined environment variables. These are
described on the [variables] page. There they mention that variable
names changed from GitLab 8.x to 9.0, but the names actually seem to
be determined by the runner version, not the GitLab version.

Selected variables are: , and include (but are not limited to):

* [`GIT_STRATEGY`]: `clone`, `fetch` (also does git clean) or `none`
* [`GIT_CHECKOUT`]: If `false` doesn't check out current branch
  (presumably script will do appropriate stuff, such as a merge)
* [`GIT_SUBMODULE_STRATEGY`]:
* `GET_SOURCES_ATTEMPTS`, `ARTIFACT_DOWNLOAD_ATTEMPTS`,
  `RESTORE_CACHE_ATTEMPTS`: default 1
* `GIT_DEPTH`: for shallow clones

### Runners Cache

See the [caching] documentation for full information.

In GitLab 10.4+ you can manually [clear the runners
cache][clear-cache] for any project from the __CI/CD > Pipelines__
page. If this isn't available, you can also change the [cache key].

For earlier versions, if you don't want to change the cache key, you
can delete the cache containers. These have names matching the glob
`runner-*-cache-*` and each is associated with a Docker volume that
should also be removed (but can't be removed until the container is
removed).



[Docker config]: https://docs.gitlab.com/ee/ci/docker/using_docker_images.html
[Docker executor]: https://docs.gitlab.com/runner/executors/docker.html
[Environments]: https://docs.gitlab.com/ee/ci/environments.html
[GitLab CI]: https://docs.gitlab.com/ee/ci/README.html
[GitLab]: https://gitlab.com
[When]: https://docs.gitlab.com/ee/ci/yaml/README.html#when
[YAML]: https://en.wikipedia.org/wiki/YAML#Syntax
[`GIT_CHECKOUT`]: https://docs.gitlab.com/ee/ci/yaml/README.html#git-checkout
[`GIT_STRATEGY`]: https://docs.gitlab.com/ee/ci/yaml/README.html#git-strategy
[`artifacts`]: https://docs.gitlab.com/ee/ci/yaml/README.html#artifacts
[`dependencies`]: https://docs.gitlab.com/ee/ci/yaml/README.html#dependencies
[`environment`]: https://docs.gitlab.com/ee/ci/yaml/README.html#environment
[cache key]: https://docs.gitlab.com/ce/ci/yaml/README.html#cache-key
[caching]: https://docs.gitlab.com/ce/ci/caching/
[clear-cache]: https://docs.gitlab.com/ce/ci/runners/README.html#manually-clearing-the-runners-cache
[directives]: https://docs.gitlab.com/ee/ci/yaml/README.html
[example build configs]: https://docs.gitlab.com/ee/ci/examples/README.html
[fair usage queue]: https://docs.gitlab.com/ee/ci/runners/README.html#how-shared-runners-pick-jobs
[install]: https://about.gitlab.com/installation/
[jobs]: https://docs.gitlab.com/ee/ci/yaml/README.html#jobs
[manual action]: https://docs.gitlab.com/ee/ci/yaml/README.html#manual-actions
[only and except]: https://docs.gitlab.com/ee/ci/yaml/README.html#only-and-except-simplified
[permissions]: https://docs.gitlab.com/ee/user/project/new_ci_build_permissions_model.html
[refcard]: http://yaml.org/refcard.html
[secret variables]: https://docs.gitlab.com/ee/ci/variables/README.html#secret-variables
[shared or specific]: https://docs.gitlab.com/ee/ci/runners/README.html#shared-vs-specific-runners
[shells]: https://docs.gitlab.com/runner/shells/README.html
[special YAML features]: https://docs.gitlab.com/ee/ci/yaml/README.html#special-yaml-features
[tracing]: https://docs.gitlab.com/ee/ci/variables/README.html#debug-tracing
[triggers]: https://docs.gitlab.com/ee/ci/triggers/README.html
[variables]: https://docs.gitlab.com/ee/ci/variables/README.html
