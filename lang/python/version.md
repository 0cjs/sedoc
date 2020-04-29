Python Versions
===============

Python's reference implementation is the [CPython] interpreter. The
latest versions for various releases are listed on the [downloads]
page. There are two major versions; details about all versions are
listed in a later section.
* 3.7.2 (2018-12-24): current
* 2.7 (2010): [legacy], supported until 2020 (latest 2.7.16 2019-03-04).

The [EOL for Python 2.7][27eol] is 2020; there will be no 2.8. Many
major sofware packages will [drop support for Python 2][27drop] by the
end of 2020 as well.


Version Attributes
------------------

The `sys` module has the following attributes:
- `version`: String with version, build, compiler, etc. info. Examples:
  - `'2.7.6 (default, Nov 13 2018, 12:45:42) \n[GCC 4.8.4]'`
  - `'3.6.5 (default, Apr  1 2018, 05:46:30) \n[GCC 7.3.0]'`
- `version_info`: Named tuple of `(major,minor,micro,releaselevel,serial)`.
  All `int` except `releaselevel`: `alpha`, `beta`, `candidate`, `final`.
- `hexversion`: `int` encoded per [API and ABI versioning]; view with `hex()`.
- `implementation`: (≥3.3) Attributes (not all documented here):
   - `name`: `cpython` or other lower-case `str`
   - `cache_tag`: Used in filenames of cached modules.
   - Implementation-specific attributes starting with underscore.
- `api_version`: C API version of the interpreter (`int`).


Interpreter Paths
-----------------

[PEP 394] recommends that `python2` and `python3` always be available.
`#!/usr/bin/env python` should be used only for scripts compatible
with both 2 and 3.
- Through 2018, PEP 394 recommends that `python` be Python 2. Most
  Linux distros through 2018 adhere to this unless the admin specifies
  otherwise.
- Arch made `python` be Python 3 long ago.
- RHEL ≥8: No default `python`.
- Windows should use `py` to interpret shebangs; see
  [`runtime/win`](runtime/win.md).


Version Reference
-----------------

### CPython Releases

Python 3 minor versions get bug support fixes for 18 months from
release and security fixes for five years. See also the table of [all
versions]. Point versions below may be; see [downloads] for lastest
info.

| SupportEnd | Version| RelDate    | RelNotes |
|------------|--------|------------|----------|
| 2024-10    | 3.8    | 2019-10-20 | [rel3.8] |
| 2023-06-27 | 3.7.3  | 2018-06-27 | [rel3.7] |
| 2021-12-23 | 3.6.8  | 2016-12-23 | [rel3.6] |
| 2020-09-13 | 3.5.7  | 2015-09-13 |          |
| 2020-01-01 | 2.7.16 | 2010-07-03 |          |
| 2019-03-16 | 3.4.10 | 2014-03-16 |          |

### OS- and Distribution-shipped Versions

Distro EOL is EOL for maintenance releases; full updates may have
stopped earlier. EOL dates in the past are in parens.

| OS/Distro     | `python`  |`python3`  | Distro EOL | Distro Release
|---------------|-----------|-----------|------------|----------------
| CentOS 8      | varies[3] | ?         |
| AWS Lambda    | 2.7.?     | 3.6.1     |            | 2018-05 (last check)
| Ubuntu 18.04  | 2.7.14+   | 3.6.4+    | 2028-04    | 2018-04
| Debian 9      | 2.7.13    | 3.5.3     | 2022       | 2017-06
| MacOS 10.14   | 2.7.16 [1]| -         | 2021-09    | 2018-09
| Ubuntu 16.04  | 2.7.12    | 3.5.2     | 2021-04    | 2016-04
| Debian 8      | 2.7.9     | 3.4.2     | 2020-06    | 2015-05
| CentOS 7      | 2.7.5 [1] | [2]       | 2024-06    | 2014-06
| Ubuntu 14.04  | 2.7.6     | 3.4.3     | (2019-04)  | 2014-04
| Debian 7      | 2.7.3     | 3.2.3     | (2018-05)  | 2013-05
| Ubuntu 12.04  | 2.7.3     | 3.2.3     | (2017-04)  | 2012-04 x
| CentOS 6      | 2.6.6 [1] | [2]       | 2020-11    | 2011-06 x
| Debian 6      | ?         | ?         | (2016-02)  | 2011-02 x
| Ubuntu 10.04  | 2.6.5     | 3.1.2     |            | 2010-04 x
| CentOS 5      | 2.4.3     | -         |            | 2007-04 x

Notes:

1. Python 2 is included in the base OS install.

2. CentOS and RedHat <= 7 do not include Python 3 in their standard OS
   packages. You can install from the third-party EPEL packages with:

       yum install -y epel-release
       yum install -y python34         # 3.4.5; `python3`
       yum install -y python36         # 3.6.3; `python36`; CentOS 7 only

3. No default `python`; can be selected with `alternatives --config
   python` (but not recommended). "App streams" allow parallel defaults.
   `yum install python` fails; use `python2`, `python3`, `@python27`,
   `@python36`.
   See [What, No Python in RHEL 8 Beta?][RHEL8].


Building/Compiling Alternative Versions
---------------------------------------

### libssl Versions

Python versions < 3.5 need to build against `libssl` 1.0 and cannot
use 1.1. On Debian/Ubuntu systems the dev packages cannot be installed
at the same time, so to build ≤3.4 you will need to temporarily
install the 1.0 version and reinstall the 1.1 version afterwards:

    sudo apt-get install libssl1.0-dev  # removes 1.1 dev package
    pythonz install --shared 3.4.3
    sudo apt-get install libssl-dev     # restore 1.1 dev package

### Pythonz

[Pythonz] downloads and builds source for various Python
implementations and versions, storing all work in `~/.pythonz`.

When buidling Python versions it will automatically disable features
such as gzip, TLS, and curses unless you have their dev libraries
installed; see below under "Building from Source" for a package list.

Install with:

    curl -kL https://raw.github.com/saghul/pythonz/master/pythonz-install | bash
    #   Also apt-get build dependencies as per "From Source" below.

To enable the `pythonz` command:

    [[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc

Pythonz subcommands:

    pythonz list                    # List installed versions
    pythonz list -a                 # List all known versions
    pythonz install 3.6.3
    pythonz install --shared 3.6.3  # Shared lib build; see below.
    pythonz cleanup                 # Remove stale source folders and archives
    pythonz cleanup -a              # Remove build dirs, too (inc. debug syms)
    pythonz uninstall 3.6.3

Set up virtual environments with:

    virtualenv -p $(pythonz locate 2.7.3) python2.7.3           # Python < 3.3
    /usr/local/pythonz/pythons/CPython-3.4.1/bin/pyvenv pyvenv  # Python >= 3.3

If you build a `--shared` version of Python you will need to ensure
that `LD_LIBRARY_PATH` includes a directory with `libpython3.4m.so.1.0`
or similar in it. The easiest way to handle this is to build a
virtualenv, copy the shared object into the virtualenv's lib
directory, and set `LD_LIBRARY_PATH` in the `bin/postactivate` script.

    export LD_LIBRARY_PATH=$(dirname "$(pythonz locate 3.4.3)")/../lib
    mkvirtualenv -p $(pythonz locate 3.4.3) simplex-master43`
    cp $LD_LIBRARY_PATH/libpython3.4m.so.1.0 $VIRTUAL_ENV/lib/
    #   Do we also need the tiny `libpython3.so`?
    unset LD_LIBRARY_PATH

    #   When you later use this, activate then:
    export LD_LIBRARY_PATH=$VIRTUAL_ENV/lib/

### From Source

Get the source from [GitHub] or the Python.org [downloads] area and
build it:

    sudo apt-get install build-essential dpkg-dev \
        libffi-dev zlib1g-dev libbz2-dev liblzma-dev \
        libssl-dev libgdbm-dev libncurses5-dev libreadline-dev
    #   Use libssl1.0-dev instead for Python <=3.4
    #   XXX should include libsqlite as well...
    mkdir ~/.local/python34
    ./configure --prefix=/home/cjs/.local/python34
    make -j 4
    #   Check for notices about libs it couldn't build
    make -j 8 install       # Python 2.x may need `altinstall`?


<!-------------------------------------------------------------------->
[27drop]: https://python3statement.org/
[27eol]: https://www.python.org/dev/peps/pep-0373/#update
[API and ABI versioning]: https://docs.python.org/3/c-api/apiabiversion.html#apiabiversion
[PEP 394]: https://www.python.org/dev/peps/pep-0394
[RHEL8]: https://developers.redhat.com/blog/2018/11/27/what-no-python-in-rhel-8-beta
[all versions]: https://en.wikipedia.org/wiki/CPython#Version_history
[cpython]: https://en.wikipedia.org/wiki/CPython
[downloads]: https://www.python.org/downloads/
[pythonz]: https://github.com/saghul/pythonz
[rel3.6]: https://www.python.org/dev/peps/pep-0494/
[rel3.7]: https://www.python.org/dev/peps/pep-0537/
[rel3.8]: https://www.python.org/dev/peps/pep-0569/
