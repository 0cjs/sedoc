GitHub Tips and Tricks
======================

### Terminology

The _NAME_ in `https://github.com/ORG/NAME` is a "repo"; this includes not
only the Git repo itself (which may be empty of objects) but the
issues/PRs, "Projects" (tables to sort issues/PRs), Wiki, and all metadata.

__Note:__ "Project" has a different meaning from GitLab, where a "project"
is a GitHub "repo."

### Special URLs

Appending `.keys` to a GitHub user URL gives the SSH public keys
that a user has authorised for access to the account. E.g.,
<https://github.com/InnovativeInventor.keys>.

Appending `/stargazers` after the repo name shows everybody who's starred
the repo. (This is linked from "n Stars" in the About panel.)

GitHib creates "invisible" branches for pull requests. Doing a
`git fetch origin pull/###/head` will leave the `FETCH_HEAD` set
to the head of a branch for the code for that PR.

### Forked Repos

Forked repos have many restrictions:
- A fork of a private repo must remain private.
- A private fork (XXX and public?) cannot be transferred to another
  user/org.


GitHub Markdown Rendering
-------------------------

The GitHub web site renders `.md` files in repos, issues, pull requests,
discussions and wikis using [GitHub-flavoured Markdown][gfm]. Additionally,
[math markup][gfmath] is allowed; this is [LaTeX-formatted math][latex]
rendered using [Mathjax]. Note that GitHub has particular configuration of
Mathjax (e.g., with `$` enabled for math mode?), and you need to know this
as well as Mathjax generalities.

Delimiters are:
- Inline: `$` … `$` (not default; enabled on GitHub? Escape `$` as `\$` in ….)
- Escape above with `<span>$</span>` (only in lines with a math expression?)
- Inline: `` $` `` … `` `$ ``
- Display (block): `$$` …lines… `$$`
- Display (block): ` ```math` `\n` …lines…  `\n` ` ``` `


GitHub Merging
--------------

- "Rebase merge" createes new commits from the branch commits even when a
  rebase isn't necessary; that changes only the committer timestamps.


Workflows / Actions
-------------------

References:
- [About workflows][w-about]
- ["Creating your first workflow"][w-first] has a sample workflow.

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

#### Events

References:
- [Triggering a workflow][w-trig]
- [Events that trigger workflows][w-events]

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

#### Jobs

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



<!-------------------------------------------------------------------->
[Mathjax]: https://docs.mathjax.org/en/latest/input/tex/
[gfm]: https://github.github.com/gfm/
[gfmath]: https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/writing-mathematical-expressions
[latex]: http://en.wikibooks.org/wiki/LaTeX/Mathematics

<!-- Workflows ("Actions") -->
[w-about]: https://docs.github.com/en/actions/writing-workflows/about-workflows
[w-actions]: https://docs.github.com/en/actions
[w-events]: https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows
[w-first]: https://docs.github.com/en/actions/writing-workflows/quickstart#creating-your-first-workflow
[w-ghhost]: https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#standard-github-hosted-runners-for-public-repositories
[w-jobs]: https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#jobs
[w-overview]: https://docs.github.com/en/actions/writing-workflows/quickstart
[w-syntax]: https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions
[w-trig]: https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/triggering-a-workflow
[w-vars]: https://docs.github.com/en/actions/learn-github-actions/variables
