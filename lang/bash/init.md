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

Note that whether or not the shell is a "login shell" (by the [Bash
manpage definition][Invocation] is not the same as whether the shell
is a "fresh login" in the sense that the profile has ever been run.
The shell process from `ssh host command` is not considered a "login
shell" but has never had any of the profile files run.

Calling `ssh` with no command starts a login shell on the remote,
regardless of whether stdin is a tty or not. Calling ssh with a
command runs `bash -c ...` which is non-login and non-interactive, but
Bash detects it's "connected to a network connection" (the exact
details of how it decides this are not clear) and sources `.bashrc`
anyway.


`.bashrc` Notes
---------------

`.bashrc` is not sourced by an interactive login shell. However, the
default `/etc/profile` and `~/.profile` installed by most distros
will, if run under Bash, explicitly source their respective
`/etc/bash.bashrc` and `.bashrc` files. If you're not using these, you
almost certainly want to do this too. This will cause `.bashrc` to be
executed in some non-interactive situations (e.g., `echo ls | ssh
somehost`, since that's a login shell because it was given no remote
command) but you have to handle that anyway as we see below.

Whether or not the profile is sourced, `.bashrc` is executed in some
non-interactive situations: in particular, when you `ssh somehost
acommand` (see table above). The assumption here appears to be that if
you give a command to be executed by the shell you'll want all your
functions and aliases available, and if the command runs a script or
something else that would generate a subprocess, the subprocess would
not inherit the functions/aliases (nor source `.bashrc`) and thus not
have its environment polluted by that.

Thus, your `.bashrc` should never assume that it's being run in an
interactive environment and do "interactive" things only after
checking to see if the `-i` flag is set (see below). In particular,
you should never generate output if you're not interactive as this
breaks non-interactive programs such as `scp` or `ssh remotehost tar
cf - somedir > somedir.tar`.

Setting `BASH_ENV=~/.bashrc` may be tempting but should not be done;
this will pollute the environment of shell scripts and `bash -c`
invocations. Typical problems include:

* Changes made to `$PATH` or other environment variables
  disrupting the environment set up by the parent process.
* Shell functions or aliases shadowing commands executed by
  a child shell script.

Instead, scripts and invocations that need your functions and/or
aliases should explicitly `source ~/.bashrc` and handle having that
entire environment, presumably designed for interactive use, brought
in and potentially overriding the environment set up by the caller.


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
