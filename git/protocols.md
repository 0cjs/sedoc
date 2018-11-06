Git Protocols for Remotes
=========================

Fetching a branch from a remote specified as a URL, instead of
configured as a named remote in `.git/config`, will leave the head of
the fetched branch in the `FETCH_HEAD` ref.

XXX fill in more below from
<https://git-scm.com/book/en/v2/Git-Internals-Transfer-Protocols>


Filesystem
----------

Directly accesses files on a locally-mounted filesystem. Not
necessarily faster than other protocols when using network file
systems: NFS may be slower than SSH into the machine hosting that
filesystem.

URLs are of two forms:
- `/repos/project.git`: Read files directly and use hard links where
  possible.
- `file:///repos/project.git`: Use network transfer mechanisms, which
  are slower but ensure the cloned repo is fully independent and has
  extraneous refs and objects (stuff not yet GC'd, etc.) left out.


HTTP
----

Git ≤ 1.6.6 supports only "Dumb HTTP"; newer versions also have a
"Smart HTTP" protocol.

#### Smart HTTP

Smart HTTP endpoints are Git-aware and can negotiate with the client,
allowing more capabilities such as push and per-repo authentication.
They can also serve `git://` protocol.

XXX fill in more from
<https://git-scm.com/book/en/v2/Git-on-the-Server-Smart-HTTP>

#### Dumb HTTP

Dumb HTTP endpoints serve just a directory of files;  the client reads
specific files to get the information it needs about what to fetch.
Pushes into this repo (obviously not done via that HTTP server)
require a `post-update` hook to run `git update-server-info` (as done
in `.git/hooks/post-update.sample`) to ensure that the correct files
are present to allow the client to learn enough about the repo to
fetch. See _Pro Git_'s [Git Internals] chapter for details on how it
works.


Git
---

Served by the `git daemon` command; default port is TCP/9418. Repos
must have a `git-daemon-export-ok` file at the top level (of the repo,
not the working copy) or the daemon won't serve them. Push access can
be enabled, though it usually isn't due to lack of authentication.

#### systemd Configuration

`/etc/systemd/system/git-daemon.service`:

    [Unit]
    Description=Start Git Daemon

    [Service]
    ExecStart=/usr/bin/git daemon --reuseaddr --base-path=/srv/git/ /srv/git/
    Restart=always
    RestartSec=500ms
    StandardOutput=syslog
    StandardError=syslog
    SyslogIdentifier=git-daemon
    User=git
    Group=git

    [Install]
    WantedBy=multi-user.target

Enable autostart on boot with `systemctl enable git-daemon`.


SSH
---

The "Git" transport protocol wrapped in SSH. URLs are
`ssh://[user@]server/project.git` or `[user@]server:project.git`
(note the colon in the latter).

After a successful SSH connection, the client will run one of the
following commands on the remote:

    git receive-pack <argument>     # Client push
    git upload-pack <argument>      # Client fetch
    git upload-archive <argument>   # Client archive --remote

#### git-shell

You can set an SSH user's shell to `/usr/bin/git-shell` to allow Git
as above and limited other commands. Ensure that `/usr/bin/git-shell`
appears in `/etc/shells` and that there's a `~/git-shell-commands/`
directory in the home dir readable and searchable by the user.

On startup, if `git-shell-commands` has a `no-interactive-login`
command, that's run and the shell exits. Otherwise a `help` command
will be run, if present, and a `git>` prompt will be presented.

EOF will exit, as will `exit` or `quit`; anything else runs a command
in `~/git-shell-commands`, passing on arguments, if the command file
is present and executable.


Other Network Daemons
---------------------

The GitWeb CGI script can serve web pages allowing browsing of a Git repo.

XXX fill in more from
<https://git-scm.com/book/en/v2/Git-on-the-Server-GitWeb>


References
----------

* _Pro Git, 2nd ed._, [4.1 Git on the Server - The Protocols][4.1]



[4.1]: https://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols
[Git Internals]: https://git-scm.com/book/en/v2/ch00/ch10-git-internals
