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

The command line client to control Dropbox is in `.home/cjs1/bin/dropbox`;
there's no need to install `nautilus-dropbox` if you just use that.
The Dropbox widget for the status tray seems to be included with the
raw binary daemon.

The actual sync client is a proprietary daemon installed in the above
directories it can be installed in two ways, with the first preferred:

1. Per the Dropbox [`install-linux` page ][install-linux] instructions,
   download and extract the headless-capable "raw binary"  client via

       cd "$HOME"
       curl -L "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

   It will be extracted to `$HOME/.dropbox-dist/`; running
   `~/.dropbox-dist/dropboxd` will start the authentication process if
   necessary. If `$DISPLAY` is unset, this will print the URL to copy to a
   browser rather than starting a browser.

   This does not include a `dropbox` control command (the file of that name
   in the distro is the daemon). A copy of the `dropbox` command is in
   [`.home/cjs1/bin/dropbox`][cjs1db].

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
[cjs1db]: https://github.com/0cjs/dot-home-cjs1/blob/master/bin/dropbox
[install-linux]: https://www.dropbox.com/install-linux
