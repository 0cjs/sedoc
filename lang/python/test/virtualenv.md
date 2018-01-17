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



[virtualenv]: https://virtualenv.pypa.io/en/stable/
[virtualenvwrapper]: http://virtualenvwrapper.readthedocs.io/en/latest/
[pyenv]: https://github.com/pyenv/pyenv
[pipenv]: https://docs.pipenv.org/
[zc.buildout]: http://docs.buildout.org/
[wheel]: http://wheel.rtfd.org/
[hooks]: http://virtualenvwrapper.readthedocs.io/en/latest/scripts.html
[plugins]: http://virtualenvwrapper.readthedocs.io/en/latest/plugins.html
[Project directories]: http://virtualenvwrapper.readthedocs.io/en/latest/projects.html
