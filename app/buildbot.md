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


Common Commands
---------------

(Re)start commands will show the log output if the command fails, or
will otherwise exit silently.

Master:

    buildbot create-master DIR
    buildbot upgrade-master DIR         # When switching to a new version
    buildbot checkconfig DIR|FILE
    buildbot reconfig                   # No change if config broken
    buildbot {restart|start|stop}

Worker:

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
[authentication]: https://docs.buildbot.net/latest/manual/configuration/www.html#web-authentication
[configuration]: https://docs.buildbot.net/latest/manual/configuration/index.html
[documentation]: https://docs.buildbot.net/latest/
[master-buildbot.tac]: https://github.com/buildbot/buildbot/blob/master/master/docker/buildbot.tac
[worker-buildbot.tac]: https://github.com/buildbot/buildbot/blob/master/worker/docker/buildbot.tac
