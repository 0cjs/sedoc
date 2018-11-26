Python on Windows
=================

Python has a [Windows download page][win-dl] and Windows-specific
documentation at [Using Python on Windows][py-win-using]. Be careful
to use the x86-64 version unless you are on a 32-bit machine.

The [Windows downloads][py-win-dl] of Python are native Windows apps,
not ports of the Unix version over a compatibility layer. This means
that OS-dependent things such as terminal, process and file handling
will be Windows-specific and may break in Unix emulation environments.

For example, while `getpass.getpass()` works fine from a CMD or
PowerShell window, in a MinGW terminal runnning in a [Cygwin or
MSYS](../../../win/unixy.md) environment using Unix `pty` semantics
(e.g., Git Bash), the Python process will wedge when `getpass()` is
called. (You can use [`winpty`](../../../win/unixy.md#winpty) to get
around this.)

The Cygwin installer also offers to install Python as well; I don't
know if this is the native Windows version or uses the Cygwin Unix
compatibility layer.

Other Python bundles (not supported by Python.org) include:
- [ActivePython]
- [Anaconda]
- [Canopy]
- [WinPython]

### Install Location and Settings

Unless requested otherwise, the installer will associate file
extension `.py` with `python.exe` and `.pyw` with `pythonw.exe`.

The standard install location for Python 3.4 and below is
`C:\Python34`. Python 3.5 and above offer a system-wide install
location, `C:\Program Files\Python35` (`C:\Program Files (x86)` for
32-bit versions) or a user install location under the `%APPDATA%` dir,
`C:\Users\myuser\AppData\Local\Programs\Python\Python35`.

Settings can be specified in the installer's pop-up window or via
command-line options; see [Using Python on Windows][py-win-using] for
details. It's also possible to download a "layout" to be able to later
do an install without an Internet connection.

### pythonw.exe

`python.exe` is a console application with `sys.{stdin,stdout,stderr}`
connected to the console; it will open a new console window if not run
in one. It's also synchronous: the console will wait to accept further
input or close until the interpreter exits.

`pythonw.exe` will not use/set up a console and runs asynchronously.
It is typically used to run GUI scripts or scripts that do no I/O.
(However, console I/O will work if you use redirection, e.g., `pythonw
foo.py 1>out.txt 2>err.txt`; prefix with `cmd /c` in PowerShell.)
Exceptions will cause a silent abort. In 2.x `print` will abort;
in 3.x `print()` will do nothing (but `sys.stdout.write()` will still
fail). You can work around the 2.x abort with `1>NUL 2>&1`.

For more details see [so-30313091] and [so-30310192].

### Multiple Versions and `py`

Python is designed to work with multiple versions installed at the
same time and keeps information in the registry about which versions
are installed. Without special handling the most recently installed
version will be used by default for scripts and shebangs such as
`#!/usr/bin/env python3` will be ignored.

The separate [Python Launcher for Windows][[py] application, which is
not specific to any particular version of Python, will normally be
installed with the first version of Python you install. This provides
a `py` program that selects a requested version of python or an
appropriate one based on a shebang line.

Usage (unknown parameters will be passed to the Python interpreter):

    py              # Run latest version of all installed Pythons
    py -3.4         # Run Python 3.4
    py -2           # Run latest Python 2.x
    py foo.py       # Choose version based on shebang in foo.py, e.g.,
                    #   `#!/usr/bin/env python3.4`

If a virtual environment is active, that Python will be used by
default, but the flags above can override it.

The default version to use can also be customized with a `py.ini` file
in the user's `%APPDATA%` directory; this takes priority over the same
in the launcher directory (usually `C:\Windows\`).

Set the `PYLAUNCH_DEBUG` environment variable to debug to stderr
`py`'s chocie of Python interpreter. Output goes to `stderr`.


Embedded Distribution
---------------------

Since 3.5 a ZIP file is available that when extracted gives an
(almost) fully isolated minimal Python environment. This does not
include the [Visual C++ runtime][vc++] dependency. This is typically
used by third-party applications, with Python set up by the
application's installer.



[ActivePython]: https://www.activestate.com/activepython/
[Anaconda]: https://www.anaconda.com/download/
[Canopy]: https://www.enthought.com/product/canopy/
[WinPython]: https://winpython.github.io/
[py-win-using]: https://docs.python.org/3/using/windows.html
[py]: https://docs.python.org/3/using/windows.html#launcher
[so-30310192]: https://stackoverflow.com/a/30310192/107294
[so-30313091]: https://stackoverflow.com/a/30313091/107294
[vc++]: https://www.microsoft.com/en-us/download/details.aspx?id=48145
[win-dl]: https://www.python.org/downloads/windows/
