Python Versions
===============

Python's reference implementation is the [CPython] interpreter.
There are two major versions:
* 2.7 (2010): [legacy], supported until 2020 (latest [2.7.15] 2018-05-01)
* [3.6.5][] (2018-03-28): current (3.7 releasing 2018-06)

Release Histories/Schedules/New Features: [3.6], [3.7]

On almost all systems `/usr/bin/python3` is present if Python 3 is
installed. It's almost never installed as part of the base system.

On most systems `/usr/bin/python` will be Python 2 unless the sysadmin
has explicitly selected otherwise. Red Hat flavour systems include
Python 2 as part of the base system; on other systems many packages
(over a thousand non-Python ones on Debian) require it and many more
recommend it.

#### OS/Distro Version Reference

| OS/Distro     | `python`  |`python3`  | Distro Release Date
|---------------|-----------|-----------|----------------------
| AWS Lambda    | 2.7.?     | 3.6.1     | 2018-05 (last check)
| Ubuntu 18.04  | 2.7.14+   | 3.6.4+    | 2018-04
| Debian 9      | 2.7.13    | 3.5.3     | 2017-06
| Ubuntu 16.04  | 2.7.12    | 3.5.2     | 2016-04
| Debian 8      | 2.7.9     | 3.4.2     | 2015-05
| CentOS 7      | 2.7.5 [1] | [2]       | 2014-06
| Ubuntu 14.04  | 2.7.6     | 3.4.3     | 2014-04
| Debian 7      | 2.7.3     | 3.2.3     | 2013-05
| Ubuntu 12.04  | 2.7.3     | 3.2.3     | 2012-04 x
| CentOS 6      | 2.6.6 [1] | [2]       | 2011-06 x
| Debian 6      | ?         | ?         | 2011-02 x
| Ubuntu 10.04  | 2.6.5     | 3.1.2     | 2010-04 x
| CentOS 5      | 2.4.3     | -         | 2007-04 x

##### Notes

1. Python 2 is included in the base OS install.

2. CentOS and RedHat <= 7 do not include Python 3 in their standard OS
   packages. You can install from the third-party EPEL packages with:

       yum install -y epel-release
       yum install -y python34         # 3.4.5; `python3`
       yum install -y python36         # 3.6.3; `python36`; CentOS 7 only


Building Alternative Versions
-----------------------------

### libssl Versions

Python versions < 3.5 need to build against `libssl` 1.0 and cannot
use 1.1. On Debian/Ubuntu systems the dev packages cannot be installed
at the same time, so to build ≤3.4 you will need to temporarily
install the 1.0 version and reinstall the 1.1 version afterwards:

    sudo apt-get install libssl1.0-dev  # removes 1.1 dev package
    pythonz install --shared 3.4.3
    sudo apt-get install libssl-dev     # restore 1.1 dev package

### [Pythonz]

Download and install in `~/.pythonz` with:

    curl -kL https://raw.github.com/saghul/pythonz/master/pythonz-install | bash
    #   Also apt-get build dependencies as per "From Source" below.

To enable the `pythonz` command:

    [[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc

Pythonz commands:

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



[2.7.15]: https://www.python.org/downloads/release/python-2715/
[3.6.5]: https://www.python.org/downloads/release/python-365/
[3.6]: https://www.python.org/dev/peps/pep-0494/
[3.7]: https://www.python.org/dev/peps/pep-0537/
[pythonz]: https://github.com/saghul/pythonz
