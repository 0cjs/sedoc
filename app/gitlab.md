[GitLab]
========

Much like GitHub, UI isn't as good, but does have some features that
GitHub doesn't have. Main selling point over GitHub Enterprise is a
free ("Community") version you can [install] on your own servers. They
have official Docker images which may be the easiest way to use it.
(Not clear if these include the DBMS or rely on an existing one in the OS.)

Other documents related to this:
* [Git/GitLab](../git/gitlab.md): GitLab's configuration and use of
  its hosted Git repos.
* [GitLab Runner](gitlab-runner.md): GitLab's runner for the
  build ("CI/CD") system described below.


Authentication
--------------

GitLab accounts are identified by the _username_, _email address_ or
SSH public key; each must be a unique on the GitLab instance.
Usernames cannot be changed by users, only by admins. (Users can
change their email addresses and SSH keys, though duplicates will not
be allowed.) The _name_ (also user settable, usually the full name of
the user) is used for display within the web interface, but externally
(e.g., in URLs) the username is used.

#### SSH Keys

"[Deploy keys]" (SSH public keys) giving read-only or read-write
access to all or specific projects may also be added; these are not
associated with an account but are designed for use by applications.

#### Access Tokens

If not using a session cookie, [personal access tokens] can be used to
authenticate to the API and Git over HTTP. (A PAT is required if for
these types of access if 2FA is enabled.) Users may have as many of
these as they need, and may expire them by hand or set an expiry date.

Sysadmins may create [impersonation tokens] for arbitrary users that
function in the same way. Admin accounts may also use [sudo] access
against the API to take actions as another user.

It's not clear how tokens are created for services not associated with
a user, but perhaps the [services api] would have some clues.

Examples of use:

  curl https://gitlab.example.com/api/v4/projects?private_token=9koXpg98eAheJpvBs5tK
  curl --header "Private-Token: 9koXpg98eAheJpvBs5tK" \
    https://gitlab.example.com/api/v4/projects


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
* `cache`: See <https://docs.gitlab.com/ee/ci/yaml/README.html#cache>
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

### Runners Cache

In GitLab 10.4+ you can manually [clear the runners
cache][clear-cache] for any project from the __CI/CD > Pipelines__
page. If this isn't available, you can also clear the [cache key].



[deploy keys]: https://docs.gitlab.com/ce/ssh/README.html#deploy-keys
[impersonation tokens]: https://docs.gitlab.com/ce/api/README.html#impersonation-tokens
[personal access tokens]: https://docs.gitlab.com/ce/api/README.html#personal-access-tokens
[services api]: https://docs.gitlab.com/ce/api/services.html
[sudo]: https://docs.gitlab.com/ce/api/README.html#sudo

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
