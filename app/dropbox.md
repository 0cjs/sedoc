Dropbox (dropbox.com)
=====================

Linux client uses `$HOME` to find its directories, including:
- `.dropbox/`: configuration and running process data
- `.dropbox-dist/`: sync client
- `Dropbox/`: user files in Dropbox account

The actual sync client is a proprietary daemon installed in the above
directories; `/usr/bin/dropbox` from the Debian `nautilus-dropbox` package
merely runs that, or bootstraps (installs) it if given the `-i` option. It
will start an instance of Chrome for the login as part of the installation
process (this is what creates further files under `.cache/`, `.local` and
`.pki/`.).

`$HOME/Dropbox` may be a symlink, but I think I saw some issues with that.

Alternate Accounts
------------------

You can start a sync client for an alternate account with the following
script, but only one sync client may be running at a time.

    #!/usr/bin/env bash
    basedir=$(cd "$(dirname "$0")" && pwd -P)
    export HOME="$basedir"
    exec dropbox "$@"


