Dropbox (dropbox.com)
=====================

Linux client uses `$HOME` to find its directories, including:
- `.dropbox/`: configuration and running process data
- `.dropbox-dist/`: sync client
- `Dropbox/`: user files in Dropbox account

The actual sync client is a proprietary daemon installed in the above
directories it can be installed in two ways:

1. Follow the instructions at the Dropbox [`install-linux`
   page][install-linux]. This will extract the client to
   `$HOME/.dropbox-dist/`; running `~/.dropbox-dist/dropboxd` will start
   the authentication process if necessary. If `$DISPLAY` is unset, this
   will print the URL to copy to a browser rather than starting a browser.

2. Install the Debian `nautilus-dropbox` package and run `/usr/bin/dropbox
   start -i`. This requires a graphical system; it will download and
   install the client and then start a web browser to authenticate your
   Dropbox account. If `$DISPLAY` is unset, this will break. (Chrome
   creates further files under `.cache/`, `.local` and `.pki/`.)

To authenticate after installation it will start an instance of Chrome (or
another browser?) if available, or print the URL to be copied to another
browser if headless. . Note that merely unsetting `$DISPLAY` on a system
where a graphical browser is available will not print the URL.

`$HOME/Dropbox` may be a symlink, but I think I saw some issues with that.


Alternate Accounts
------------------

You can start a sync client for an alternate account with the following
script, but only one sync client may be running at a time.

    #!/usr/bin/env bash
    basedir=$(cd "$(dirname "$0")" && pwd -P)
    export HOME="$basedir"
    exec dropbox "$@"



<!-------------------------------------------------------------------->
[install-linux]: https://www.dropbox.com/install-linux
