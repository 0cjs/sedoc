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
    source DIR/bin/activate     # enter environment (pwd doesn't matter)
                                # This sets $VIRTUAL_ENV
    pip list                    # Lists only packages installed in virtual env
    deactivate                  # exit environment
    rm -rf DIR                  # remove environment

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


virtualenvwrapper
-----------------

    #  virtualenvwrapper commands create/use virtualenvs in $WORKON_HOME
    #  activation of an env automatically deactivates any current env
    #
    mkvirtualenv ENV            # create env ENV and activate it
    mktmpenv                    # make/activate env, deleted on deactivate
    lsvirtualenv | workon       # list virtual environments
    workon ENV                  # activate $WORKON_HOME/ENV
    cdvirtualenv                # cd to $WORKON_HOME/ENV (current env)
    lssitepackages              # list packages in this env
    cdsitepackages
    rmvirtualenv ENV

virtualenvwrapper can be extended with [hooks] and [plugins].

[Project directories] for hacking-in-progress may be bound to a virtualenv.


Using with Git
--------------

In general, the virtualenv directories and files should not be checked
in to the Git repo as these will vary depending on the system on which
it's been generated. Instead, commit and use this (non-executable)
[`activate`](activate) script ([raw download][activate-raw])
that will install the virtual environment and pip modules if necessary
and then activate the environment if one is not already activated.
(See below for further notes on this.)

After adding new packages in the virtual environment you'll want to
ensure you generate and commit the list of packages your project needs:

    pip freeze > requirements.txt

This would usually be called from your top-level test script, e.g.:

    cd "$(dirname "$0")"
    [[ $VIRTUAL_ENV = $(pwd -P) ]] || . activate -q

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



[Project directories]: http://virtualenvwrapper.readthedocs.io/en/latest/projects.html
[activate-raw]: https://github.com/0cjs/sedoc/raw/master/lang/python/runtime/activate
[downloads]: http://www.python.org/ftp/python
[github]: https://github.com/python/cpython
[hooks]: http://virtualenvwrapper.readthedocs.io/en/latest/scripts.html
[pipenv]: https://docs.pipenv.org/
[plugins]: http://virtualenvwrapper.readthedocs.io/en/latest/plugins.html
[pyenv]: https://github.com/pyenv/pyenv
[so-41573588]: https://stackoverflow.com/a/41573588/107294
[version]: ../version.md#building-alternative-versions
[virtualenv]: https://virtualenv.pypa.io/en/stable/
[virtualenvwrapper]: http://virtualenvwrapper.readthedocs.io/en/latest/
[wheel]: http://wheel.rtfd.org/
[zc.buildout]: http://docs.buildout.org/
