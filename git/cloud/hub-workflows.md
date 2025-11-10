GitHub Workflows / Actions
==========================

* [General](hub-general.md) | [Workflows](hub-workflows.md)
  | [Tips](hub-tips.md)
  |

References:
- [About workflows][w-about]
- ["Creating your first workflow"][w-first] has a sample workflow.
- [Monitoring Workflows][w-mon] (including notifications)
- [About status checks][statchk]

[GitHub Actions][actions] is the overall name for the _workflows_ system
and also the name of steps within jobs. Output is viewed on the "Actions"
tab of the GitHub repo/project.

Each workflow is in a `.github/workflows/NAME.yml`, per [Workflow
syntax][w-syntax], including the following top-level properties:
- `name:` Displayed under "Actions" tab; `.gh/wf/…` path if absent.
- `run-name:` Overrides default name of run generated from workflow.
  (Variables available.)
- `on:` Name or list of _events_ that trigger the workflow.
- `env:` Map of vars available to all steps.
- `defaults:` Default settings for all jobs.
- `concurrency:` defines concurrency group for this run (to cancel previous
  running jobs).
- `jobs:` List of jobs; each runs on a _runner._

Runners run a single job at a time. GitHub-provided runners are fresh VMs
(Ubuntu, Windows, macOS), or you can provide your own.

### Forked Repositories

Workflows default to disabled in forked repositories; the "Actions"
tab in the forked repo will offer an option to enable them.

The existence of workflows in forked repos will not be recognised unless
you have them on the default branch. If you go to the "Actions" tab and
it's prompting you to create workflows, you need to copy the
`main`/`master`/whatever branch from the upstream to your fork repo, set
the default branch to that, and then the "Actions" tab should show you a
prompt about enabling workflows. Once you've started a workflow, you
can then change the default branch back to `fork`/whatever, and delete
the `main`/`master`/whatever branch that was a copy from the source repo.
(XXX Also maybe try setting the default branch to your dev branch?)

Typically forks will still not be configured to run the workflows on the
development branch you're using. Various solutions are discussed in
[so-71057825] and other answers, but the easiest work-around seems to be
generate a commit on your branch changing the trigger events section to
just `on: push`, and push that.


Events
------

References:
- [Triggering a workflow][w-trig]
- [Events that trigger workflows][w-events]
- [Manually running a workflow][w-manual]

Each event has a commit SHA and ref (set as [variables][w-vars]
`GITHUB_SHA` and `GITHUB_REF` in executing workflows). For each event,
`.github/workflows/` is searched and workflow runs are triggered for any
workflow whose `on:` matches the event. (Some events also require that the
workflow be on the repo's default branch.)

Workflows that generate events using `GITHUB_TOKEN` do not trigger other
workflows recurisvely (excepting `workflow_dispatch` and
`repository_dispatch`). Other tokens will trigger recursive workflows.

As well as a single event (`push`) or list of events (`[push, fork]`) you
can qualify events with _activity types_ (`created`, `deleted`, etc.) and
_filters_ (`branches: [foo, bar]`). You can also use `if:` in the job
definitions.

Printing `${{github.event}}` or `${{toJSON(github.event)}}` to see
properties of the triggering event.

Commonly used events:
- `push`:
- `pull_request`: [Action types][w-ev-pr];
  default `[opened, synchronize, reopened]`
  - `synchronize:` is a head update on ref.
  - `paths: […]` useful to skip long tests on unmodifed files?
- `workflow-dispatch`: Can run only workflow definitions committed on the
  default branch. Triggered from "Actions" tab, selecting the workflow and,
  if it has this event, you will see a "Run workflow" button. (You can
  select a different branch to run it on with the "Branch" dropdown.)
  Workflow fields to fill in may be defined. [[w-manual]] for more info.


Jobs
----

Each _job_ has sequence of _steps_ that execute actions specified either
with `run: …` lines or `uses: actions/checkout@v4` etc. for a third-party
action.

The `jobs:` section is a map of job ID (an aribtrary string) to job
parameters map. See [[w-jobs]].

- `name:`: (optional) Name displayed in the Actions UI.
- `runs-on:` Runner selection characteristic or list.
- `steps:` List of steps (`run:` and/or `uses:`).


For `runs-on:`, [GitHub-hosted runners][w-ghhost] are free and unlimited
for public repos, and are charged per-minute for private repos. GitHub
provides:
- `ubuntu-latest`, `ubuntu-24.04`, `ubuntu-22.04`, `ubuntu-20.04`
- `ubuntu-24.04-arm`, `ubuntu-22.04-arm`
- `macos-latest`, `macos-15`, `macos-14`, `macos-13`
- `windows-latest`, `windows-2025`, `windows-2022`, `windows-2019`

The `steps:` list is a series of maps each of which must contain `run:` to
run a script or `uses:` to use a reusable extension called an _action_
(e.g., `uses: actions/checkout@v4`). Additional parameters include:
- `name:`: Displayed in workflow output instead of `Run …`.


Status Checks
-------------

[Status checks][statchk] may be _checks_ or _commit statuses._ Both can be
created with REST API endpoints; workflows create only _checks._ A "Checks"
tab appears for PRs with checks; commit statuses are visible only only
the commits list for the PR (or branch?).

Workflows generate _checks_:
- 



<!-------------------------------------------------------------------->
[statchk]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks

<!-- Workflows ("Actions") -->
[so-71057825]: https://stackoverflow.com/a/71057825/107294
[w-about]: https://docs.github.com/en/actions/writing-workflows/about-workflows
[w-actions]: https://docs.github.com/en/actions
[w-ev-pr]: https://docs.github.com/en/webhooks/webhook-events-and-payloads#pull_request
[w-events]: https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows
[w-first]: https://docs.github.com/en/actions/writing-workflows/quickstart#creating-your-first-workflow
[w-ghhost]: https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#standard-github-hosted-runners-for-public-repositories
[w-jobs]: https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#jobs
[w-manual]: https://docs.github.com/en/actions/how-tos/managing-workflow-runs-and-deployments/managing-workflow-runs/manually-running-a-workflow
[w-mon]: https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows
[w-overview]: https://docs.github.com/en/actions/writing-workflows/quickstart
[w-syntax]: https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions
[w-trig]: https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/triggering-a-workflow
[w-vars]: https://docs.github.com/en/actions/learn-github-actions/variables
