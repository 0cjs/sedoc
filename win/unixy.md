Unix-like Programs and Environments on Windows
==============================================

Native Windows programs are compiled with MS or MinGW compilers. The
Cygwin and MSYS compilers compile Unix-y programs that depend on a DLL
providing a POSIX interface and various other things.

For further information on differences between Cygwin and MSYS-related
systems, see:

* [How does MSYS2 differ from Cygwin][msys2-diff]
* [SO: What is the difference between Cygwin and MinGW?][so-771756]


Cygwin
------

[Cygwin] \([WP][Cygwin-wp]) is compatibility layer that runs on
Windows and tries to provide as complete as possible a Unix (and
POSIX) environment for building and running Unix programs. These
programs are not native Windows applications in many ways:
- Kernel: programs see Cygwin PIDs, different from Windows PIDs.
- Kernel: `fork()` is emulated for Windows.
- Filesystems: `/proc` and similar will be available.
- File Paths: forward slashes are used, and using native Wind32 paths
  can circumvent security mechanisms.
- Files: symlinks are faked in a number of different ways.
- Limited access to Windows APIs.

[Highlights of Cygwin Functionality][cyg-hi] discusses what
system-level things are emulated and [Using Cygwin][cyg-use] details
some of the user-facing changes, especially with filesystem paths.

The Cygwin setup program includes a package manager and lets you
install a huge number of packages, including an X11 server and
clients.

Applications built for Cygwin rely on `cygwin1.dll`; this is GPL and
has all the usual issues that go along with that.


MinGW and MSYS
--------------

[MinGW], Minimalist GNU for Windows, is an open-source development
environment using GNU tools to create native Windows applications.
(Unlike Cygwin, no extra DLL is required to run these.) While POSIX
APIs that are easily to emulate in Windows are provided, it does not
provide anywhere near full POSIX compatibility. It's not designed to
provide an easy way to port POSIX apps; it's better seen as an
alternative to Visual C++, especially when using cross-platform
libraries such as [Qt].

The MinGW-w64 fork is the current version; original MinGW stopped
development in 2013.

### MSYS

[MSYS] is a Cygwin derivative implementing a POSIX-y [FHS] \(Unix
Filesystem Hierarchy Standard) filesystem namespace and POSIX
compatibility layer, and includes a set of Unix tools (`bash`, `grep`,
`make`, etc.) built with MinGW and designed to support building of
Windows programs using traditional Unix tools. It is often installed
alongside MinGW. (It may include its own version of a C compiler for
compiling MSYS, as opposed to MinGW, programs?)

Also see [so-41318586] for more information on this.

mingwPORTs are Bash scripts that help deal with patching Unix packages
and building them with MinGW and MSYS.

#### MSYS2

MSYS2 is an independent rewrite of MSYS, aiming for better
interoperability with Windows software.

The MSYS2 POSIX compatability DLL is is `msys-2.0.dll`.

### Path Conversion

MSYS does automatic Unix to Windows path conversion when calling native
executables, turning things like `/foo` into `C:\msys64\foo` or similar.
MinGW [Posix path conversion][mingw pathconv] gives the details, but
roughly:
- Relative paths are not converted.
- Absolute paths starting with a drive letter `/c/foo/bar` are converted
  to `C:\foo\bar`.
- Absolute paths without a drive letter are prefixed by the MSYS
  installation directory: `/foo` → `C:\MSYS64\foo`.
- Prefix an absolute path with two slashes to suppress conversion:
  `//foo` → `//foo`.

This can be suppressed by setting values in the program's environment. Set
[`MSYS_NO_PATHCONV`] to suppress all conversion, or use
`MSYS2_ENV_CONV_EXCL` and `MSYS2_ARG_CONV_EXCL` to [exclude specific
environment variables and command line parameters][MSYS2_vars]:

    $ # XXX not clear why Python 10 is printing forward slashes below.
    $ export E=/foo

    $ py -c 'import os, sys; print(os.getenv("E"), sys.argv[1])' /bar
    C:/Program Files/Git/foo C:/Program Files/Git/bar

    $ MSYS_NO_PATHCONV=1 py -c …
    /foo /bar

    $ MSYS2_ENV_CONV_EXCL='E' MSYS2_ARG_CONV_EXCL='*' py -c …
    /foo /bar

The [`cygpath`] command can do explicit conversions. Also see its use in
the "Tips and Tricks" section below.


Platform Checks
---------------

MSYS2 sets/uses environment variable `MSYSTEM` to one of `MSYS2`,
`MINGW32`, `MINGW64` to allow use of native build mode.

On Windows 10 with Git for Windows installed:
* `uname` returns `MINGW64_NT-10.0`
* `MSYSTEM=MINGW64`
* `MINGW_PREFIX=/mingw64`


Terminals
---------

See [Terminals, Terminal Emulators and SSH for Windows](term-ssh.md).


Toolsets
--------

### Git for Windows

[Git for Windows](../git/win.md) is a MinGW-based build of Git that
includes various other utilities (mintty, winpty, Bash, `grep`, etc.)
as well.

### Python for Windows

The [Windows downloads][py-win-dl] of Python are native Windows apps.
For further information see [Python for Windows
](../lang/python/runtime/win.md).


Tips and Tricks
---------------

* Use `cygpath` to convert between MinGW Bash paths and Windows paths.
* The MinGW programs can be run from CMD/PowerShell even if not in path
  by finding the full path to them: `cygpath -w /mingw64/bin`.



<!-------------------------------------------------------------------->
[msys2-diff]: https://github.com/msys2/msys2/wiki/How-does-MSYS2-differ-from-Cygwin
[so-771756]: https://stackoverflow.com/q/771756/107294

[Cyg-hi]: https://www.cygwin.com/cygwin-ug-net/highlights.html
[Cyg-use]: https://www.cygwin.com/cygwin-ug-net/using.html#
[Cygwin-wp]: https://en.wikipedia.org/wiki/Cygwin
[Cygwin]: http://cygwin.com/

[FHS]: http://www.pathname.com/fhs/
[MSYS2]: https://github.com/msys2/msys2/wiki/
[MSYS2_vars]: https://www.msys2.org/docs/filesystem-paths/
[MSYS]: http://www.mingw.org/wiki/MSYS
[MinGW]: https://en.wikipedia.org/wiki/MinGW
[Qt]: https://en.wikipedia.org/wiki/Qt_(software)
[`MSYS_NO_PATHCONV`]: https://stackoverflow.com/a/48348531/107294
[`cygpath`]: https://cygwin.com/cygwin-ug-net/cygpath.html
[mingw pathconv]: https://web.archive.org/web/20201112005258/http://www.mingw.org/wiki/Posix_path_conversion
[so-41318586]: https://stackoverflow.com/a/41318586/107294

[py-win-dl]: https://www.python.org/downloads/windows/
