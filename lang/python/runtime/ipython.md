IPython - Python REPL
=====================

[IPython] is an enhanced interactive shell for Python that can be
embedded in other programs as well. It has a nice help facility
built in and a tutorial etc. in the [documentation].

IPython's current release is 6.x compatible only with Python ≥ 3.3.
To use lesser Python versions (e.g., 2.7) you'll need to use the
[5.x LTS] release.

The versions included with OS distros tend to be very old; it's best
to `pip3 install --user --upgrade ipython` and use that one. (Be sure
to `hash -v` after the install if you have used a system
`ipython`/`ipython3` in that session.)


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


Common Commands and Functions
-----------------------------

Typing `?` will print a help overview. `x?` prints object details
about `x`; `x??` is verbose.

Prefixing a line with `!` will pass it to the shell to be executed.

IPython 'magic' commands are single-line comands starting with `%`
or multi-line 'cells' starting with a `%%` prefixed command and
consuming all following lines until the first blank line. On a line
alone you can leave off the the `%` prefix if the magic command
isn't shadowed by a variable name.

* `%quickref`: Print IPython quick reference card,
  including brief details of magic commands
* `%magic`: Full details of magic commands
* `%cd`: Change current working directory
* `%run -m MOD`: Load and run module _MOD_ as `__main__`

The following functions are Python [builtins] rather than supplied by
IPython, but tend to be very helpful in interactive use:

* `help(x)`: print documentation about object _x_.
  (With no args enters interactive help utility.)
* `dir(x)`: print documentation about object _x_.

The [inspect] library may also be useful.


Customization
-------------

    ipython3 profile list
    ipython3 profile create

`create` without a name will create the default profile config file,
`~/.ipython/profile_default/ipython_config.py`. (History and the like
will already be in that directory if you've run `ipython` before.)


[5.x LTS]: https://ipython.readthedocs.io/en/5.x/
[IPython]: http://ipython.org/
[SO-ipexit]: https://stackoverflow.com/q/7438112/107294
[builtins]: https://docs.python.org/3/library/functions.html
[documentation]: http://ipython.readthedocs.io/en/stable/
[inspect]: https://docs.python.org/3/library/inspect.html
