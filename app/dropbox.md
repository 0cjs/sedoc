Dropbox (dropbox.com)
=====================

Linux client uses `$HOME` to find its directories, including:
- `.dropbox/`
- `.dropbox-dist/`
- `Dropbox/`

You can start a sync client for an alternate account with the following
script, but only one sync client may be running at a time.

    #!/usr/bin/env bash
    basedir=$(cd "$(dirname "$0")" && pwd -P)
    export HOME="$basedir"
    exec dropbox "$@"


`$HOME/Dropbox` may be a symlink, but I think I saw some issues with that.
