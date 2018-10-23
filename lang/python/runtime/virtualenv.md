virtualenv: Python Isolated Environments
========================================

[virtualenv] creates an environment with its own separate set of
python libraries (as installed with `pip`) and optionally not using
the global libs. This is usually used with [virtualenvwrapper] which
stores environments under `$WORKON_HOME` and provides convenient ways
to manage and switch to environments (including command-line
completion).

Related Software:
* [pyenv] for using different versions of Python (à la rbenv)
* [pipenv]: manages `Pipfile{.lock}`, etc. à la Ruby Bundler
  (supersedes `requirements.txt`)
* [zc.buildout] for application-centric (between Make and Chef)
  assembly and deployment, including non-Python software

Also see [this SO answer][so-41573588] for a summary virtualenv,
pyenv, pyenv-virtualenv, virtualenvwrapper, pyenv-virtualenvwrapper,
pipenv, pyvenv, and venv.


Installation
------------

    pip3 show virtualenvwrapper # Check installed and location
    pip3 install --user virtualenvwrapper

`virtualenvwrapper` will bring in `virtualenv` as a dependency, but
the latter can be installed alone if that's all you need.


virtualenv
----------

    virtualenv DIR              # create new env in given dir
    DIR/bin/python              # run python within the virtual environment
    source DIR/bin/activate     # enter environment (pwd doesn't matter)
                                # This sets $VIRTUAL_ENV
    pip list                    # Lists only packages installed in virtual env
    deactivate                  # exit environment
    rm -rf DIR                  # remove environment

Note that you need not source the `activate` script to run just one
command in the environment; instead you can just run any command from
`DIR/bin`. E.g., `dir/bin/python -m pip list` or `dir/bin/pip list` to
list the packages installed in that environment.

Virtualenv environments don't use `/usr/lib/python3.4/site-packages`
unless you provide the `--system-site-packages` option. You can also
use an alternate interpreter, pip, [wheel]s, etc. by providing
`--extra-search-dir`.

By default, virtualenv installs using the version of python it was
installed with. (The help text for the `-p` option displays this.) If
you want to use a different version, e.g., 2.7 on Debian systems, pass
in the path to that interpreter:

    virtualenv -p /usr/bin/python DIR

#### Using Alternative Python Versions for Virtualenv

See [Python Versions][version] for details on how to build alternate
versions of Python. Once you have one, you can set up a virtualenv to
use it with commands like:

    virtualenv -p ~/.local/python34/bin/python3
    virtualenv -p $(pythonz locate 2.7.3) python2.7.3

See "Virtualenv Information" below for how to figure out whence your
virtualenv was created.


virtualenvwrapper
-----------------

virtualenvwrapper [commands][vw-commands] create/manipulate/use
virtualenvs in directories under `$WORKON_HOME`. Activation of an env
sets `$VIRTUAL_ENV`; any currently activated env is deactivated first.

    virtualenvwrapper           # print command summary

    lsvirtualenv, workon        # list virtual environments
    workon ENV                  # activate $WORKON_HOME/ENV
                                #   opts: -c,--cd, --n,--no-cd
    deactivate                  # deactivate current enviornment
    allvirtualenv CMD           # run CMD in all virtual environments

    cdvirtualenv                # cd $VIRTUAL_ENV/
    cdsitepackages              # cd $VIRTUAL_ENV's site_packages directory
    lssitepackages
    toggleglobalsitepackages

    mkvirtualenv ENV            # create ENV and activate it
    mktmpenv                    # make/activate env, deleted on deactivate
    rmvirtualenv ENV

A virtualenv can be copied with `cpvirtualenv src [TARGETENV]`; the
source does not have to be under `$VIRTUAL_ENV` though the target
always will be. This doesn't always properly rewrite paths embedded in
virtualenvs.

#### Projects

virtualenvwrapper can manage [project directories][vw-projects] to
which one or more virtualenvs are bound. When a virtualenv bound to a
project directory is activated with `workon ENV` the current working
directory will be changed to that project directory. The project dir
for bound virtualenvs is stored in `$WORKON_HOME/ENV/.project`.

A new project directory and its first associated virtualenv are created
under `$PROJECT_HOME` with `mkproject`, which takes a project name, an
optional template, and `mkvirtualenv` and `virtualenv` options. Use
`mkproject -h` for details.

A virtualenv _ENV_ can be bound to an existing directory with
`setvirtualenvproject [ENV]`; the default _ENV_ is the currently
activated virtualenv, `$VIRTUAL_ENV`.

#### Activation Hooks

virtualenvwrapper can be extended with [hooks] and [plugins].

The `$VIRTUAL_ENV/bin` directory contains four hook scripts run during
the activation and deactivation process: `preactivate`, `postactivate`,
`predeactivate`, `postdeactivate`.

When setting, e.g., environment variables, make sure you clean them up
(removing them or restoring saved values) on deactivate. A good way to
handle this is to have the activate script create a shell function that
unsets/restores whatever it set and then deletes itself, and have the
deactivate script just call that. (This keeps all the code but that
one call in a single file where it's easier to see that the activate
and deactivate are in sync.)

    _virtualenv_deactivate_postactivate() {
        FOOBAR="$_OLD_FOOBAR"; unset _OLD_FOOBAR
        unset _virtualenv_deactivate_postactivate
    }

[so-11134336] contains further information about this and more ideas
about how to use it.


Virtualenv Information
----------------------

Virtualenv copies the Python binary into the virtual environment
directory. If you want to see where the binary originally came from,
you can check `sys.real_prefix`, added by the virtualenv setup, which
is the value of `sys.prefix` that was compiled into the Python binary
([so-15469948]).


Using with Git
--------------

In general, the virtualenv directories and files should not be checked
in to the Git repo as these will vary depending on the system on which
it's been generated. Instead, commit and use this (non-executable)
[`activate`](activate) script ([raw download][activate-raw]) for Bash
that will install the virtual environment and pip modules if necessary
and then activate the environment if one is not already activated.
(See below for further notes on this.)

After adding new packages in the virtual environment you'll want to
ensure you generate and commit the list of packages your project needs:

    pip freeze > requirements.txt

This would usually be called from your top-level test script, e.g.:

    cd "$(dirname "$0")"
    . ./activate -q

Note the leading `./` to prevent another `activate` being called if
it's in `$PATH`.


#### Activate Script Notes

1. The last line setting `PYTHONPATH` is optional; use it if you are
   putting your `.py` files for modules in paths under `lib/` rather
   than off the root of the repo. (You may also want to add `bin/`
   if you use files under that as modules.)

2. If passed `-q` as the _first_ option, the virtualenv install (if
   run) will be done quietly, which is useful for automated test
   systems. A side effect is that this will leave an `__activate_quiet`
   variable set (possibly to an empty value) in the current shell.

3. All options (other than an initial `-q`) will be passed to
   `virtualenv` (if run). This can be used to do things like set the
   Python version you want to use (`-p python2`).

4. For Windows compatibility it uses `virtualenv/*/activate` instead
   of `virtualenv/bin/activate`. Under Windows, Python installs
   scripts under `Scripts/` instead of `bin/`; this code works with
   either so long as there's never more than one script named
   `activate` in the subdirs. (That should always be the case so long
   as you leave virtualenv to manage that directory.)



[vw-projects]: http://virtualenvwrapper.readthedocs.io/en/latest/projects.html
[activate-raw]: https://github.com/0cjs/sedoc/raw/master/lang/python/runtime/activate
[downloads]: http://www.python.org/ftp/python
[github]: https://github.com/python/cpython
[hooks]: http://virtualenvwrapper.readthedocs.io/en/latest/scripts.html
[pipenv]: https://docs.pipenv.org/
[plugins]: http://virtualenvwrapper.readthedocs.io/en/latest/plugins.html
[pyenv]: https://github.com/pyenv/pyenv
[so-11134336]: https://stackoverflow.com/a/11134336/107294
[so-15469948]: https://stackoverflow.com/a/15469948/107294
[so-41573588]: https://stackoverflow.com/a/41573588/107294
[version]: ../version.md#building-alternative-versions
[virtualenv]: https://virtualenv.pypa.io/en/stable/
[virtualenvwrapper]: http://virtualenvwrapper.readthedocs.io/en/latest/
[vw-commands]: https://virtualenvwrapper.readthedocs.io/en/latest/command_ref.html
[wheel]: http://wheel.rtfd.org/
[zc.buildout]: http://docs.buildout.org/
