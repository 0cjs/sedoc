Buildbot
========

[Buildbot] \([documentation], [GitHub]) is a build (CI) server written
in Python using [Twisted].

* A _master_ process reads the configuration, runs the web server for
  the UI (default port 8010) and owns the database (SQLite or
  PostgreSQL) of build information.
* _Worker_ processes (running on any OS) contact the master (default
  port 9989) to execute build _jobs_. Configurable Docker images are
  provided for both daemons; the master requires an attached
  PostgreSQL container.

Each daemon has its own directory, `DIR/` below, in which it stores
all data, including configuration, logs (`twistd.log`), the SQLite
database if the master is using that, and run files.

Since arbitrary commands may be run on workers and arbitrary output
(such as environment information) printed to the logs sent to the
servers, workers should not normally be run by your normal interactive
account.


Command Line Tools
------------------

- Both command-line tools take `--verbose`, `--help` (on main command
  and subcommands) and `--version` options.
- (Re)start commands will show the log output if the command fails, or
  will otherwise exit silently.
- There's a [command line index] of subcommands for all tools.

### Buildmaster

Interaction with the buildmaster is done with the [`buildbot` command
line tool][buildbot-cmd]:

    buildbot create-master [-r] DIR         # -r for relocatable buildbot.tac
    buildbot upgrade-master DIR             # When switching to a new version
    buildbot checkconfig DIR|FILE           # DIR checks buildbot.tac, too
    buildbot reconfig                       # No change if config broken
    buildbot {restart|start} [--nodaemon]
    buildbot stop [--clean] [--no-wait]     # Waits for shutdown

There is also a [`buildbot try`][buildbot-cmd-try] command for use by
developers which will upload a patch (usually generated on the fly
from the local VCS tree) directly to the buildmaster. (This is to make
it easy to test alternate platform builds during development.) This is
complex and requires client-side configuration and a `Try_Userpass`
scheduler (if using `Pb` protocol) or a `Try_Jobdir` scheduler (if
using SSH to the buildmaster host).

The [`sendchange`] subcommand tells the buildmaster about source
changes. It's typically used by a post-commit/post-push hook. The
master is configured with `c['change_source']` set to a a
`PbChangeSource`.

The `user` subcommand manages users in the buildmaster's database.
See [Users Options].

Commands above may use configuration from the [`.buildbot` config dir].

### Workers

The [`buildbot-worker` command line tool][buildbot-worker-cmd] is for
management of individual workers only. The full set of commands is:

    buildbot-worker create-worker DIR
    buildbot-worker {restart|start|stop} DIR

Various information about the current environment is often printed to the
build logs, so when starting workers it may be worth being careful of what
user you are and what's in the environment.


Configuration
-------------

### Master

[Configuration] starts with Python code in `DIR/buildbot.tac` ([sample
of Docker image version][master-buildbot.tac]). This does minimal
setup (mainly logging) and creates a `BuildMaster` object, passing in
a second configuration file that it should use, usually
`DIR/master.cfg`.

`master.cfg` is also executed as Python code. The module-level global
`BuildmasterConfig` must be set to a `dict` of configuration
keys/values; this is usually created along with a short alias to it:

    from buildbot.plugins import *
    c = BuildmasterConfig = {}

`DIR/` is also added to `sys.path` so you can drop e.g., `foo.py` into
there to import it with `import foo`.

Common [configuration] keys:

* `workers`: List of workers: `[worker.Worker(name, password), ...]`
* `protocols`: Dict of protocols and their parameters workers may use
  to connect to the master. E.g., `{'pb': {'port': 9989}}`.
* `change_source`: List of objects that find find out about source
  changes. E.g., a `changes.GitPoller`.
* `schedulers`: List of how to react to incoming changes. E.g.
  `schedulers.SingleBranchScheduler` or `ForceSchedule`.
* `builders`: List of configuration objects for how to perform builds.
* `services`: List of reporter targets to which build status is
  pushed.
* `title`, `titleURL`: Name of Buildbot instance and URL for external
  access to its web UI.
* `www`: Dict of configuration parameters for web UI. (By default it
  requires no [authentication].) Parameters include:
  - `port`: (int)
  - `plugins`: (dict) plugin names and their config params
  - `authz`, `auth`: Authentication configuration.
* `db`: Dict of parameters for state database.
  Typically `{'db_url': 'sqlite:///state.sqlite'}`
* `buildbotNetUsageData`: If/how to report usage data back to Buildbot
  project; set to `basic` to get rid of warning message when not set.

### Workers

Configuration via Python code in `DIR/buildbot.tac` ([sample of Docker
image version][worker-buildbot.tac]). This creates a
`buildbot_worker.bot.Worker` object with parameters including
`buildmaster_host`, `port`, `workername`, `passwd` and `basedir`.

Further configuration in:
* `DIR/info/admin`: Name/email of worker administrator.
* `DIR/info/host`: Description of build host (one line?).



[Buildbot]: https://buildbot.net/
[GitHub]: https://github.com/buildbot/buildbot
[Twisted]: https://twistedmatrix.com/
[`.buildbot` config dir]: https://docs.buildbot.net/1.8.0/manual/cmdline.html#buildbot-config-directory
[`sendchange`]: https://docs.buildbot.net/1.8.0/manual/cmdline.html#sendchange
[authentication]: https://docs.buildbot.net/latest/manual/configuration/www.html#web-authentication
[buildbot-cmd-try]: https://docs.buildbot.net/1.8.0/manual/cmdline.html#developer-tools
[buildbot-cmd]: https://docs.buildbot.net/1.8.0/manual/cmdline.html
[buildbot-worker-cmd]: https://docs.buildbot.net/1.8.0/manual/cmdline.html#worker
[command line index]: https://docs.buildbot.net/1.8.0/bb-cmdline.html
[configuration]: https://docs.buildbot.net/latest/manual/configuration/index.html
[documentation]: https://docs.buildbot.net/latest/
[master-buildbot.tac]: https://github.com/buildbot/buildbot/blob/master/master/docker/buildbot.tac
[users options]: https://docs.buildbot.net/1.8.0/manual/concepts.html#concepts-users
[worker-buildbot.tac]: https://github.com/buildbot/buildbot/blob/master/worker/docker/buildbot.tac
