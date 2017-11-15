ipython - Python REPL
=====================

[IPython] is an enhanced interactive shell for Python that can be
embedded in other programs as well. It has a nice help facility
built in and a tutorial etc. in the [documentation].

The versions included with OS distros tend to be very old; it's best
to `pip3 install --user --upgrade ipython` and use that one. (Be sure
to `hash -v` after the install if you have used a system
`ipython`/`ipython3` in that session.) The most recent version is 6.x.


Invocation
----------

To run a command or file and then drop into the interpreter:

    ipython -i -c 'x = 7'
    ipython -i somefile.py -- arg1 arg2

Use `--` to ensure that args passed to a file are not interpreted
as `ipython` args.

#### Exiting

Exit with `exit`, `quit` or EOF (Ctrl-D). To [exit without
confirmation][SO-ipexit] when using EOF, run with `--no-confirm-exit`
or add to your config (see below):

    c.TerminalInteractiveShell.confirm_exit = False


Customization
-------------

    ipython3 profile list
    ipython3 profile create

`create` without a name will create the default profile config file,
`~/.ipython/profile_default/ipython_config.py`. (History and the like
will already be in that directory if you've run `ipython` before.)


[IPython]: http://ipython.org/
[documentation]: http://ipython.readthedocs.io/en/stable/
[SO-ipexit]: https://stackoverflow.com/q/7438112/107294
