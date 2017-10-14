Bash Initalization Behaviour
============================

A Bash process may be:

| State               | Invocation
|---------------------|---------------------------------------------------
| Login (**L**)       | `argv[0][0] == '-'`, `--login`
| Interactive (**I**) | `-i`, stdin is tty
| Remote (**R**)      | stdin is "network connection" (see below)

* '•' = set; blank = not set; '-' = not checked or don't care.
* **p**: sources `/etc/profile`
  then first of `~/.bash_profile`, `~/.bash_login`, `~/.profile`
* **rc**: sources `/etc/bash.bashrc` then `~/.bashrc`

| L | I | R | | p | rc | | Example
|:-:|:-:|:-:|-|:-:|:--:|-|-----------------
| • | • | - | | • |    | | `ssh host.com` (sshd sets argv[0]="-bash")
| • |   | - | | • |    | | `ssh host.com </dev/null` (sshd sets argv[0]="-bash")
|   | • |   | |   | •  | | `bash -i`, `bash` on tty
|   |   |   | |   |    | | `bash hello.sh`, `bash -c echo foo`,
|   |   | • | |   | •  | | `ssh host.com 'echo $-'` (ssh runs `bash -c 'echo $-`)

Calling `ssh` with no command starts a login shell on the remote,
regardless of whether stdin is a tty or not. Calling ssh with a
command runs `bash -c ...` which is non-interactive, but Bash detects
it's "connected to a network connection" (the exact details of how it
decides this are not clear) and sources `.bashrc` anyway.


`.bashrc` Notes
---------------

`.bashrc` is not sourced by an interactive login shell. However, the
default `/etc/profile` and `~/.profile` installed by most distros
will, if run under Bash, explicitly source their respective
`/etc/bash.bashrc` and `.bashrc` files.

`.bashrc` should never print anything to stdout as this will confuse
commands like scp etc. (And it should probably never print to stderr,
either.)


Testing State
-------------

Test for interactive by checking if `$-` includes `i` (this does not
work in old Bourne shell; unknown if it works in POSIX shell):

    case $- in
        *i*)    echo interactive;;
        *)      echo or not;;
    esac

You can also check with `if [ "$PS1" ] ...`, but this may not be as
reliable depending on what the user has previously run in his setup.
