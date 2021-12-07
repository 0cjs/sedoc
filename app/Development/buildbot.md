Buildbot
========

[Buildbot] \([documentation], [GitHub]) is a build (CI) server written
in Python using [Twisted].

* A _master_ process reads the configuration, runs the web server for
  the UI (default port 8010) and owns the database (SQLite or
  PostgreSQL) of build information.
* Classic _Worker_ processes (running on any OS) contact the master
  (default port 9989) to execute build _jobs_.  Workers initiate
  connections to the master and repos (so they work behind NAT) and
  are designed to have minimal configuration, allowing developers
  easily to maintain their own workers and make them available to a
  project.
* Local and latent worker processes (e.g. Docker containers, EC2
  instances) can be started by the master process.

Configurable Docker images are provided for both daemons; the master
requires an attached PostgreSQL container.

Each daemon has its own directory, `DIR/` below, in which it stores
all data, including configuration, logs (`twistd.log`), the SQLite
database if the master is using that, and run files.

Since arbitrary commands may be run on workers and arbitrary output
(such as environment information) printed to the logs sent to the
servers, workers should not normally be run by your normal interactive
account.

#### Version Information

- 1.8 is the last version to support Python 2.7.
- 0.9 started support for Python 3.
- 0.9.0 added features:
  - Docker latent workers
  - GitLab authentication
  - Visual Studio 2015 steps
- Major API changes occurred with the release of 0.9.0 on 2016-10-06.
  Previous versions are "eight"; the 0.9.x and 1.x versions are
  "nine". The new API in 0.9.x was stabilized with 1.x, from which
  point semantic versioning is used. There is an [Upgrading to Nine]
  document.


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


Worker Configuration
--------------------

Configuration via Python code in the [Twisted `.tac` file][tac],
`DIR/buildbot.tac` ([Docker image version][worker-buildbot.tac]). This
creates a `buildbot_worker.bot.Worker` object with parameters
including `buildmaster_host`, `port`, `workername`, `passwd` and
`basedir`.

Further configuration in:
* `DIR/info/admin`: Name/email of worker administrator.
* `DIR/info/host`: Description of build host (one line?).


Master Configuration
--------------------

### Configuration Files

[Configuration] starts with Python code the [Twisted `.tac` file][tac],
`DIR/buildbot.tac` ([Docker image version][master-buildbot.tac]).
This does minimal setup (mainly logging) and creates a `BuildMaster`
object, passing in a second configuration file that it should use,
usually `DIR/master.cfg`.

`master.cfg` is also executed as Python code. The module-level global
`BuildmasterConfig` must be set to a `dict` of configuration
keys/values; this is usually created along with a short alias to it:

    from buildbot.plugins import *
    c = BuildmasterConfig = {}

The plugins import above brings in all internal and plugin
configuration classes under the [standard top-level plugin package
names][plugins]:  `worker`, `changes`, `schedulers`, `steps`,
`reporters`, `statistics`, `util`, `secrets`, and `webhooks`.

`DIR/` is also added to `sys.path` so you can drop e.g., `foo.py` into
there to import it with `import foo`.

### Configuration Keys

The various [configuration] keys divide into three groups.

#### Server Configuration

* `title`, `titleURL`: Name of Buildbot instance and URL for external
  access to its web UI.
* `db`: Dict of parameters for state database.
  Typically `{'db_url': 'sqlite:///state.sqlite'}`
* `www`: Dict of [configuration parameters][www] for web UI. (By
  default it requires no [authentication].) Parameters include:
  - `port`: (int) Default `None` runs no web server.
  - `plugins`: (dict) plugin names and their config params
  - `authz`, `auth`: Authentication configuration. OAuth2 available
    in various flavors (GitLabAuth, etc.).
  - `change_hook_dialects`, `change_hook_auth`: Change triggers under
    [`/change_hook`]. Dialects include `base`, `gitlab`, ...
* `buildbotNetUsageData`: If/how to report usage data back to Buildbot
  project; set to `basic` to get rid of warning message when not set.

For read-only access to the server, restrict control endpoint access
to an unpopulated `admin` role:

    c['www']['authz'] = util.Authz(
        allowRules=[util.AnyControlEndpointMatcher(role="admins")],
        roleMatchers=[])

#### Worker (and Control Client) Connectivity

* `protocols`: Dict of protocols and their parameters workers may use
  to connect to the master. E.g., `{'pb': {'port': 9989}}`.
* `workers`: List of workers: `[worker.Worker(name, password), ...]`
  Each worker for specific builder should be configured identically,
  as a random one will be used.

Worker configuration is described in detail in [2.5.6 Workers].

As well as "classic" workers (continuously running in a separate
process/host), they may also be local (same process as master;
requires `buildbot-worker` package) and latent (started on demand,
e.g., a new container for [Docker Latent Worker]).

#### Build Configuration

Also see the see next section for more details.

* `change_source`: List of objects that find find out about source
  changes. E.g., a `changes.GitPoller`.
* `schedulers`: List of how to react to incoming changes. E.g.
  `schedulers.SingleBranchScheduler` or `ForceSchedule`.
* `builders`: List of `BuilderConfig` objects used to generate the
  builders, which have server lifetime. Each `Builder`:
  - has a `BuildFactory` that creates the `Build` objects that perform
    the build;
  - holds a queue of build requests;
  - schedules the `Build`s to `workers` above;
  - has a unique work directory on both master (for status info) and
    worker (for checkout/compile/test).
  - [2.3.7 Builders]
* `services`: List of reporter targets to which build status is
  pushed.
* `secretsProviders`: For [Secret Management] in external storage.

[2.3.7 Builders]: https://docs.buildbot.net/1.8.0/manual/concepts.html#builders


Architecture and Configuration
------------------------------

See [2.1 Introduction] and [2.3 Concepts] for further architecture
description. Some class descriptions are found in [3.5 Classes], but
many details are available only in the source code in packages under
[`master/buildbot`].

1. The  [Change Sources] \([`buildbot.changes`] objects) configured in
   `change_source` generate [`Change`] objects when the source
   (usually in a VCS) is updated. The update may be detected by the
   change source subscribing to a remote notification service,
   receiving a [`/change_hook`] notification, or by polling a remote
   service. [2.5.3 Change Sources and Changes].

[Change Sources]: https://docs.buildbot.net/1.8.0/developer/cls-changesources.html
[`buildbot.changes`]: https://github.com/buildbot/buildbot/tree/master/master/buildbot/changes
[`Change`]: https://github.com/buildbot/buildbot/blob/master/master/buildbot/changes/changes.py
[`/change_hook`]: https://docs.buildbot.net/1.8.0/manual/configuration/wwwhooks.html
[2.5.3 Change Sources and Changes]: https://docs.buildbot.net/1.8.0/manual/configuration/changesources.html

2. Each [`Change`] object is delievered to every
   [`buildbot.schedulers`] object (instance of [`BaseScheduler`])
   configured in `schedulers`. These create `BuildSet` objects,

   Each decides if it will generate and queue a build
   request for its configured set of builders.

   Each scheduler creates and submits BuildSet objects to the
   BuildMaster, which is then responsible for making sure the
   individual BuildRequests are delivered to the target Builders.

  `BuildSet`: set of `Build`s run across multiple `builders`.


   XXX Where does [`ForceScheduler`] fit in? And [periodic scheduler]?

[`buildbot.schedulers`]: https://github.com/buildbot/buildbot/tree/master/master/buildbot/schedulers
[`BaseScheduler`]: https://docs.buildbot.net/1.8.0/developer/cls-basescheduler.html
[`ForceScheduler`]: https://docs.buildbot.net/1.8.0/developer/cls-forcesched.html
[periodic scheduler]: https://docs.buildbot.net/1.8.0/manual/configuration/schedulers.html#sched-Periodic

3. The builders, configured in [`builders`]

The [`BuildFactory`] objects (configured in [`builders`])

forcebuilds

[`builders`]
[`BuildFactory`]: https://docs.buildbot.net/1.8.0/developer/cls-buildfactory.html

4. XXX multiple workers/build for load balancing; only one worker will be used.


    repo --> (changes) --> buildmaster --> (status) --> notifiers
                          ^          ^
                          | commands |
                        worker   worker

`BuilderConfig`

See the [Buildbot in 5 minutes][5min-tut] tutorial for more details.


To Read
-------

* [2.2 Installation]
* [3.3.2 Data API]



[2.1 Introduction]: https://docs.buildbot.net/1.8.0/manual/introduction.html
[2.2 Installation]: https://docs.buildbot.net/1.8.0/manual/installation/index.html
[2.3 Concepts]: https://docs.buildbot.net/1.8.0/manual/concepts.html
[2.5.6 Workers]: https://docs.buildbot.net/1.8.0/manual/configuration/workers.html
[3.3.2 Data API]: https://docs.buildbot.net/1.8.0/developer/data.html
[3.5 Classes]: https://docs.buildbot.net/1.8.0/developer/classes.html
[5min-tut]: https://docs.buildbot.net/1.8.0/tutorial/fiveminutes.html
[Buildbot]: https://buildbot.net/
[Docker Latent Worker]: https://docs.buildbot.net/1.8.0/manual/configuration/workers-docker.html
[GitHub]: https://github.com/buildbot/buildbot
[Secret Management]: https://docs.buildbot.net/1.8.0/manual/secretsmanagement.html
[Twisted]: https://twistedmatrix.com/
[Upgrading to Nine]: https://docs.buildbot.net/1.8.0/manual/upgrading/nine-upgrade.html
[`.buildbot` config dir]: https://docs.buildbot.net/1.8.0/manual/cmdline.html#buildbot-config-directory
[`master/buildbot`]: https://github.com/buildbot/buildbot/tree/master/master/buildbot
[`sendchange`]: https://docs.buildbot.net/1.8.0/manual/cmdline.html#sendchange
[authentication]: https://docs.buildbot.net/latest/manual/configuration/www.html#web-authentication
[buildbot-cmd-try]: https://docs.buildbot.net/1.8.0/manual/cmdline.html#developer-tools
[buildbot-cmd]: https://docs.buildbot.net/1.8.0/manual/cmdline.html
[buildbot-worker-cmd]: https://docs.buildbot.net/1.8.0/manual/cmdline.html#worker
[command line index]: https://docs.buildbot.net/1.8.0/bb-cmdline.html
[configuration]: https://docs.buildbot.net/latest/manual/configuration/index.html
[documentation]: https://docs.buildbot.net/latest/
[master-buildbot.tac]: https://github.com/buildbot/buildbot/blob/master/master/docker/buildbot.tac
[tac]: https://twistedmatrix.com/documents/current/core/howto/application.html#twistd-and-tac
[users options]: https://docs.buildbot.net/1.8.0/manual/concepts.html#concepts-users
[worker-buildbot.tac]: https://github.com/buildbot/buildbot/blob/master/worker/docker/buildbot.tac
[www]: https://docs.buildbot.net/latest/manual/configuration/www.html
[plugins]: https://docs.buildbot.net/1.8.0/manual/plugins.html
