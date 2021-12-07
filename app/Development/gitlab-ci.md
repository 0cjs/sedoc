GitLab CI - Continuous Integration
==================================

* [GitLab](gitlab.md) | [GitLab CI](gitlab-ci.md)
  | [GitLab Runner](gitlab-runner.md)

You specify [GitlLab CI] build descriptions in `.gitlab-ci.yml`.
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

Build Configuration
-------------------

The build description in `.gitlab-ci.yml` specifies a __pipeline__
with multiple __stages__, each containing zero or more __jobs__ that
are executed in parallel. The build aborts if any jobs fail. Stages
default to `build`, `test` and `deploy` if not explicitly set; jobs
are assigned to the `test` stage if not explicitly assigned.

Pipelines must have at least one (visible) job.

GitLab provides a validator form for `.gitlab-ci.yml` files under:
- `/GROUP/PROJECT/-/ci/lint` (GitLab ≥11.x)
- `/ci/lint` (GitLab ≤9.x)

The `/ci/lint` path in your GitLab instance contains a validator for
There are also [example build configs].

### Configuration Parameters

The build description is [YAML][] ([refcard]). Thus values like `true`
and `false` may cause issues when used alone as a YAML item; quote
them to make them strings rather than booleans. Details of all
the following are in the [configuration reference].

__Top-level elements:__

* `stages`: List of stages; default `[build, test, deploy]`).
  Stages are run in order listed. (`types` is a deprecated alias.)
* `image`, `services`, `before_script`, `after_script`, `variables`,
  `cache`: As per job elements below. These are defaults that are
  entirely overridden by (not combined with) settings in a job.
* [Jobs] and hidden jobs; see below.

All other top level elements are names of [jobs], which may not use
any of the above names. Each job is a dictionary with a required
`script` parameter and any other optional parameters. Job names
starting with `.` are 'hidden' and will be ignored; [special YAML
features] can turn them into templates.

__Job parameters:__

* `script`: Commands to be executed (list or multi-line string). These
  are fed into whichever of the [shells] is available on the runner system.
* `image`, `services`: [Docker config][] (if using the [Docker executor]).
  [Extended Docker configuration options][ext-docker] are available to set
  `entrypont`, etc.
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
* [`dependencies`]: List of jobs from previous stages from which artifacts
  should be downloaded.
  - Name collisions will leave only file last written during extraction.
  - Default is all artifacts from previous stages.
  - ≥10.3 the job will fail if the dependences can't be downloaded
    (because they expired or a manual job creating them wasn't run).
  - Not a failure <10.3 or if [dependency validation is disabled][depval].
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
* `before_script`, `after_script`: list or multi-line string (but
  multi-line string not accepted in older versions?). `before_script` and
  and the job script are run in sequence in a single container run; the
  container is then shut down and restarted for `after_script`, which is
  run whether the job succeeds or fails.
* [`environment`]: [Environments] for continuous deployment. Deployments are
  recorded under 'Piplines / Environments' in the project pages.
  Sub-vars: `environment:name`, `url`, `on_stop`, `action`.
* `coverage`: Regexp to extract code coverage statement line from job
   output, e.g., `'/Coverage: \d+\.\d+/'`.
* `retry`: How many times (up to 2) to retry job.

### Variables

[Variables] can be set and interpolated into the build description.
Values must be strings, even for ostensibly boolean or numeric values.
Thus, while `foo: bar` will work, `foo: true` will not; you must
instead write `foo: 'true'`.

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

__Environment variables:__

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

### Inheritance, Templates and Reducing Code Duplication

There are various methods for consolidating duplicate code for DRY.

#### YAML Anchors

≥8.6 supports [YAML anchors][yaml-anchors]. The key here is that a job
named with a leading `.` will not be executed. This allows us to
mark the whole job or specific items with `&name` and then reference
the AST from that name downward with `*name`:

    .build: &build
        script: ./Test
    .otherstuff:
        tags: &ubuntu
            - ubuntu-dev
    build-18:
        <<: *build
        image: ubuntu:18.04
        tags: *ubuntu

#### Extending Definitions

≥11.3 supports [`extends`] directives.

#### Including Files

≥11.4 (≥10.5 [Premium][pricing], ≥10.6 Starter, Ultimate) support
[`include`] directives, which allow the inclusion of other files.
(This is particularly useful for local definitions.)
- The extension must be `.yml` or `.yaml`.
- YAML anchors/aliases do not work across files, but [`extends`] does.
- Regardless of where the `include` directive is, the included files
  are always evaluated first and then merged with the content of
  `.gitlab-ci.yml`.
- The include processing is done once when the pipeline is started and
  that version is used for all jobs; if jobs change included files,
  later stages will not see those changes.
- Includes may be nested.

There are four include methods:
- `local`
- `file`
- `template`
- `remote`


Runners Cache
-------------

See the [caching] documentation for full information.

In GitLab 10.4+ you can manually [clear the runners
cache][clear-cache] for any project from the __CI/CD > Pipelines__
page. If this isn't available, you can also change the [cache key].

For earlier versions, if you don't want to change the cache key, you
can delete the cache containers. These have names matching the glob
`runner-*-cache-*` and each is associated with a Docker volume that
should also be removed (but can't be removed until the container is
removed).


Build Artifacts Management
--------------------------

Detailed info at [Introduction to job artifacts][artifacts].

The [well-known URLs][artifacts-wkurls] for downloading artifacts from
the latest build for a ref (names, but probably not SHA1 IDs) changed
at some point. The current (11.x, maybe earlier?) URLs and their old
9.1 equivalants are:

    #   Current
    https://example.com/GROUP/PROJECT/-/jobs/artifacts/REF/download?job=JOBNAME
    https://example.com/GROUP/PROJECT/-/jobs/artifacts/REF/raw/FILEPATH?job=JOBNAME

    #   9.1
    https://example.com/GROUP/PROJECT/builds/artifacts/REF/download?job=JOBNAME
    https://example.com/GROUP/PROJECT/builds/artifacts/REF/file/FILEPATH?job=JOBNAME



<!-------------------------------------------------------------------->
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
[`extends`]: https://docs.gitlab.com/ee/ci/yaml/#extends
[`include`]: https://docs.gitlab.com/ee/ci/yaml/#include
[artifacts-wkurls]: https://docs.gitlab.com/ee/user/project/pipelines/job_artifacts.html#downloading-the-latest-artifacts
[artifacts]: https://docs.gitlab.com/ee/user/project/pipelines/job_artifacts.html
[cache key]: https://docs.gitlab.com/ce/ci/yaml/README.html#cache-key
[caching]: https://docs.gitlab.com/ce/ci/caching/
[clear-cache]: https://docs.gitlab.com/ce/ci/runners/README.html#manually-clearing-the-runners-cache
[configuration reference]: https://docs.gitlab.com/ee/ci/yaml/README.html
[depval]: https://docs.gitlab.com/ee/administration/job_artifacts.html#validation-for-dependencies
[example build configs]: https://docs.gitlab.com/ee/ci/examples/README.html
[extended-docker]: https://docs.gitlab.com/ce/ci/docker/using_docker_images.html#extended-docker-configuration-options
[fair usage queue]: https://docs.gitlab.com/ee/ci/runners/README.html#how-shared-runners-pick-jobs
[install]: https://about.gitlab.com/installation/
[jobs]: https://docs.gitlab.com/ee/ci/yaml/README.html#jobs
[manual action]: https://docs.gitlab.com/ee/ci/yaml/README.html#manual-actions
[only and except]: https://docs.gitlab.com/ee/ci/yaml/README.html#only-and-except-simplified
[permissions]: https://docs.gitlab.com/ee/user/project/new_ci_build_permissions_model.html
[pricing]: https://about.gitlab.com/pricing/
[refcard]: http://yaml.org/refcard.html
[secret variables]: https://docs.gitlab.com/ee/ci/variables/README.html#secret-variables
[shared or specific]: https://docs.gitlab.com/ee/ci/runners/README.html#shared-vs-specific-runners
[shells]: https://docs.gitlab.com/runner/shells/README.html
[special YAML features]: https://docs.gitlab.com/ee/ci/yaml/README.html#special-yaml-features
[tracing]: https://docs.gitlab.com/ee/ci/variables/README.html#debug-tracing
[triggers]: https://docs.gitlab.com/ee/ci/triggers/README.html
[variables]: https://docs.gitlab.com/ee/ci/variables/README.html
[yaml-anchors]: https://docs.gitlab.com/ee/ci/yaml/#anchors
