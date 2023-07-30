Python on Linux
===============


Builds from Source
------------------

This applies to manual builds from downloaded source or builds by PythonZ.

Build notices like the following indicate what's missing:

    The necessary bits to build these optional modules were not found:
    _bz2                  _dbm                  _gdbm
    _sqlite3              _tkinter
    To find the necessary bits, look in setup.py in detect_modules() for the module's name.

Or for disabled modules:

    The following modules found by detect_modules() in setup.py have not
    been built, they are *disabled* by configure:
    _sqlite3
    To find the necessary bits, look in setup.py in detect_modules() for the module's name.


Debian (Ubuntu, etc.)
---------------------

Debian splits the standard python distribution into various sub-packages,
so that the `python3` package itself is not a complete distribution. Other
parts you will probably want include:

    python3-distutils       distutils
    python3-tk              tkinter

When building from source, the following modules are not built unless the
necessary development packages are installed. (This list may not be
complete.)

    _bz2        libbz2-dev
    _dbm
    _gdbm
    _sqlite3    libsqlite3-dev
    _tkinter    tk-dev

Sometimes `apt-get --dry-run build-dep` can help with figuring out what you
need.
