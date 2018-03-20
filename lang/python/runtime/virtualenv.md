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

#### Building Alternative Python Versions for Virtualenv

You could try using [pythonz] to build Python, or get the source from
[GitHub] or the Python.org [downloads] area and build it yourself:

    sudo apt-get install build-essential dpkg-dev \
        zlib1g-dev libbz2-dev liblzma-dev \
        libssl-dev libgdbm-dev libncurses5-dev libreadline-dev
    # Use libssl1.0-dev instead for Python <=3.4
    mkdir ~/.local/python34
    ./configure --prefix=/home/cjs/.local/python34
    make -j 4
    #   Check for notices about libs it couldn't build
    make -j 8 install       # Python 2.x may need `altinstall`?

    virtualenv -p ~/.local/python34/bin/python3


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
it's been generated. Instead, create the following (non-executable)
`activate` file that will install the virtualenv if necessary and then
activate it if not already activated.

    [ -n "$BASH_SOURCE" ] \
        || { echo 1>&2 "source (.) this with Bash."; exit 2; }
    (
        cd "$(dirname "$BASH_SOURCE")"
        [ -d .build/virtualenv ] || {
            echo 'Building virtualenv...'
            virtualenv -q .build/virtualenv "$@" \
            && . .build/virtualenv/*/activate \
            && pip install -q -r requirements.txt
        }
    ) \
    && . "$(dirname "$BASH_SOURCE")"/.build/virtualenv/*/activate \
    && export PYTHONPATH="$(dirname "$BASH_SOURCE")/lib"

I use `virtualenv/*/activate` instead of `virtualenv/bin/activate`
because under Windows Python installs the scripts under `Scripts/`
instead of `bin/`. This trick would fail if there were ever more than
one file matched by the pattern, but that should never happen so long
as you leave virtualenv to manage that directory.

The last line is optional; use it if you are putting your `.py` files
for modules in paths under `lib/` rather than off the root of the repo.

After adding new packages in the virtual environment you'll want to
ensure you generate and commit the list of packages your project needs:

    pip freeze > requirements.txt

This would usually be called from your top-level test script, e.g.:

    cd "$(dirname "$0")"
    [[ $VIRTUAL_ENV = $(pwd -P) ]] || . activate



[Project directories]: http://virtualenvwrapper.readthedocs.io/en/latest/projects.html
[downloads]: http://www.python.org/ftp/python
[github]: https://github.com/python/cpython
[hooks]: http://virtualenvwrapper.readthedocs.io/en/latest/scripts.html
[pipenv]: https://docs.pipenv.org/
[plugins]: http://virtualenvwrapper.readthedocs.io/en/latest/plugins.html
[pyenv]: https://github.com/pyenv/pyenv
[pythonz]: https://github.com/saghul/pythonz
[virtualenv]: https://virtualenv.pypa.io/en/stable/
[virtualenvwrapper]: http://virtualenvwrapper.readthedocs.io/en/latest/
[wheel]: http://wheel.rtfd.org/
[zc.buildout]: http://docs.buildout.org/
