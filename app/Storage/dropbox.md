Dropbox (dropbox.com)
=====================

Linux client uses `$HOME` to find its directories, including:
- `.dropbox/`: configuration and running process data
- `.dropbox-dist/`: sync client
- `Dropbox/`: user files in Dropbox account

### fs.inotify.max_user_watches

Dropbox requires a very high number of user watches from inotify, and will
warn about this. To configure this:

    $ sudo -s
    # cd /etc
    # echo fs.inotify.max_user_watches=100000 >sysctl.d/50-dropbox.conf
    # chmod go+r sysctl.d/50-dropbox.conf
    # # etckeeper add and commit
    # systemctl restart systemd-sysctl      # sysctl -p does not reload .d/*
    # exit
    $ dropbox stop
    $ dropbox start

### Client Installation

Either way you do it below, you probably want to `apt-get install dropbox`
(Debian) to get `/usr/bin/dropbox` (command-line client) and the Dropbox
widget for the status tray (on graphical systems). This will suggest
installing the `nautilus` package, but not automatically bring it in.

The actual sync client is a proprietary daemon installed in the above
directories it can be installed in two ways:

1. Per the Dropbox [`install-linux` page ][install-linux] instructions,
   download and extract the headless-capable client via `cd ~ && curl -L
   "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -`. It will
   be extracted to `$HOME/.dropbox-dist/`; running
   `~/.dropbox-dist/dropboxd` will start the authentication process if
   necessary. If `$DISPLAY` is unset, this will print the URL to copy to a
   browser rather than starting a browser.

2. Install the Debian `nautilus-dropbox` package and run `/usr/bin/dropbox
   start -i`. This requires a graphical system; it will download and
   install the client and then start a web browser to authenticate your
   Dropbox account. If `$DISPLAY` is unset, this will break. (Chrome
   creates further files under `.cache/`, `.local` and `.pki/`.)

To authenticate after installation it will start an instance of Chrome (or
another browser?) if available, or print the URL to be copied to another
browser if headless. . Note that merely unsetting `$DISPLAY` on a system
where a graphical browser is available will not print the URL.

In either case, remember to turn off stuff in selective sync to keep it from
trying to bring over many hundreds of GB of stuff.

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
