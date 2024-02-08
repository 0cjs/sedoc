Packaging Python Code
=====================

* Wheel is a newer format than egg.
* Distutils is part of standard library, but functionality is very basic.
* Setuptools recommended over Distutils.

Terminology
-----------

The following are from the [glossary] of the Pythong Packaging User Guide
at packaging.python.org and the terms from the [pkg-resources][pkgr] page
of the setuptools documentation.

- __[Project]:__ A library, app, etc. intended to be packaged into a
  _distribution package._ Typcially available as a Git repo, other VCS
  checkout, or (for a single version) a _source archive._ Contains  a
  project _specification file._
- __[Source Archive]:__ Contains raw source code for a _release,_ from
  which you create _source distributions_ and _built distributions._
- __Specification File:__ Build information for a _project._ Usually one of:
  - `pyproject.toml`: [PEP 518], used by many tools including setuptools.
  - `setup.py` and/or `setup.cfg`: distutils; legacy support in setuptools.

Distribution formats:
- __[Release]:__ A snapshot of a _project_ with a version identifier. May
  be published as multiple _distribution packages_ (e.g., source, Windows
  installer).
- __[Distribution Package]:__ (Often just "package" or "distribution", but
  both terms are used in other ways as well.) A versioned archive file
  built from a _project_ and downloaded by end-users. Note that this is
  different from an _import package,_ as used by the Python module system. 
- __[Source Distribution]__ or __sdist:__ [[sdist-spec]] An _unbuilt
  distribution_ in a file named `{pkgname}-{version}.tar.gz`, containing a
  `{pkgname}-{version}/` directory which in turn has a `pyproject.toml`, a
  `PKG-INFO` with metadata, and the source files. See also [PEP 643],
  [PEP 625], [PEP 721]. Pip can build/install these.
- __[Built Distribution]:__ Files and metadata that need only be copied to
  the install location. E.g, _wheel,_ _egg._
- __[Binary Distribution]:__ A _built distribution_ that contains compiled
  extensions.
- __[Importable Distribution][pkgr]:__ A file or directory that can be
  placed directly on `sys.path`.
- __[Wheel]:__ _Built distribution_ format that replaces _Egg._ Has a
  [standard spec][wheel-spec] later approved as [PEP 427]. Supported by Pip.
- __[Egg]:__ Older _built distribution_ format introduced by setuptools.
  [Quick guide][egg-quick]. [Internal structure][egg-int].

### Version Specifiers

Per the _Python Packaging User Guide_ [Version specifiers][ppug-ver]:

    [N!]N(.N)*[{a|b|rc}N][.postN][.devN]

All numbers _N_ are ordered numerically with no regard for leading zeros,
i.e., `10` succeeds `9`.

All the following are optional except for the release segment:
- `N!` Epoch segment. default _0!_, used when changing versioning scheme.
  Rarely used.
- `N(.N)*` Release segment. Required. E.g., _2.1_, _2.12.3_.
- `{a|b|rc}N` Pre-release segment. Appended to the _next_ release version
  number, e.g., _2.3a7_ → _2.3b1_ → _2.3rc4_ → _2.3_ for alpha, beta,
  release candidate and final release. `c` may be accepted as meaning `rc`.
- `.postN` Post-release segment. Used for small fixes that do not affect
  the distributed software (e.g., correcting release notes).
- `.devN` Development release segment.

A _final release_ version specifier may consist of only an optional epoch
segment followed by a release segment.

#### Dependency Specifiers

[PEP 508]-compliant [dependency specifiers][ppug-depver] have additional
syntax to specify version ranges and other depencency options.

### Package Metadata Fields

- `requires-python`: [PEP 508] version string for Python version range.
  E.g., `>=3.6` for a Python with [f-strings][PEP 498].


Libraries and Packaging Tools
-----------------------------

Build frontends:
- [Pip]: Can build and install from a project or source archive, as well as
  a release.
- [build]: Standard simple build frontend.
- [Hatch]: ([GitHub][hatch-gh]) CLI tool to manage dependencies and
  environment isolation. Includes build backend hatchling.

Build backends (may include a frontend, too):
- [setuptools]: Enhanced distutils.  Includes `easy_install`.
- hatchling: see Hatch above.

Libraries:
- [distlib]: Library to aid third-party packaging tools, succeeds `packaging`.
- [packaging]; Packaging library. Used by Pip and setuptools.
- [distutils]: Original packaging system. Deprecated 3.10, removed 3.12.
  Use setuptools instead.
- [`importlib.metadata`]: Python standard library module for getting
  information about installed packages.

More at packaging.python.org [Key Projects] page.


PyInstaller
-----------

[PyInstaller][] (`pip install pyinstaller`; [manual][PyInst-docs]) can
package a script and all its dependencies (including the Python interpreter
binary!) in a single folder or single executable file that can be run on
systems without a Python interpreter installed. However, the build must be
done on the target platform; there are no cross-build facilities.

Notes:
- The app creates a new console window by default; this can be overridden.
- Only .pyc files are included. Options are available for further
  obfuscation, or use cython.
- Arbitrary data can be appended to the end of an ELF or .EXE file; the
  system loader ignores this. PyInstaller appends a CArchive format
  archive; `pyi-archive_viewer` can view the archive.
- See [Run-time Information][pyinst-rti] for use of `__file__`,
  `sys.executable`, `sys.argv[0]`, and notes on finding data files.
- See [Advanced Topics][pyinst-adv] for a description of the the
  application startup process ("bootloader"), the CArchive format,
  executable inspection program `pyi-bindepend`, and using `PYTHONHASHSEED`
  to create bit-for-bit reproducable builds.

`pyinstaller myscript.py` ([manpage][pyinst-man]) will analyze all `import`
statements, but may miss more clever ways of importing code. You can give
additional dependencies (files and import paths) on the command line or
edit the `myscript.spec` created by the first PyInstaller run. (These may
include data files as well.) A "hook" system is also available to specify
"hidden" imports; hooks are included for many popular libraries.

One-file mode changes distribution only; when run it builds a temporary
folder and extracts files to it before running as it would in one-folder
mode. Implications:
- Make sure the bundled app works in one-folder mode before building it in
  one-file mode.
- The temporary folder will be left behind on program crash.
- No-exec `/tmp` will break things; `--runtime-tmpdir` may help with this.
- Do not give admin privs to a one-file app; the extraction has race
  conditions. `seteuid()` may also be problematic.

Programs that use PyInstaller include [docker-compose].


Environment and Dependency Managers
-----------------------------------

* [Pip](./pip.md) w/manual `requirements.txt`: Dependency versions must be
  managed manually. Locks or ranges, not both.
* [pip-tools]
* [Pipenv] Wrapper around `pip` and virtual environments. Uses
  `Pipfile` and `Pipfile.lock` for dependency specs. Recommended for
  applications but not libraries due to strict pinning in
  `Pipfile.lock`.
* [Poetry] has better and more reliable dependency determination than
  Pipenv. Designed for both apps and libraries.
* [Hatch] simplifies/wraps process of creating/managing/testing libs
  and apps (more features than Poetry in this area). No dependency
  graph calculation?

### Pip

The Pip [`requirements.txt` format][pip-rq-fmt] follows [PEP 508]:

    pkgname                     # ordinary package names
    pkgname == 1.0              # specific version: does not match higher
    pkgname == 2.*              # highest 2.x.y version
    pkgname <= 7                # version ranges
    pkgname >= 5.1.2

    ./downloads/foo-1.2.3.whl
    pkgname @ git+https://github.com/…/pkgname.git
    #   Append `@REF` to use a particular ref, e.g., `@refs/pull/123/head`
    requests [security] @ https://github.com/psf/requests/archive/refs/heads/main.zip ; python_version >= "3.11"
    #   Note above is a .zip file downloaded from GitHub releases, not the repo.

    -r other-requirements.txt
    -c constraints.txt

Using the `--editable`/`-e` option of Pip will do an [editable VCS
install][pip-e]. The default clone location is `VENV/src/PKGNAME/`
(when using a virtualenv) or `CWD/src/PKGNAME/` (when not). This can
be modified with the `--src` option.

The optional dependencies brought in with e.g. `pip install .[foo,bar]` can
be specified (among other ways) as `optional-dependencies.NAME` entries in
the `[project]` section of `pyproject.toml` files, e.g.:

    [project]
    optional-dependencies.foo = [ 'abc', 'def', ]

    [project.optional-dependencies]
    bar = [ 'ghi', 'jkl', ]


To-read
-------

* <http://andrewsforge.com/article/python-new-package-landscape>
* <https://hynek.me/articles/sharing-your-labor-of-love-pypi-quick-and-dirty/>
* <https://blog.ionelmc.ro/2014/05/25/python-packaging/>
* [SO notes on types of packages and tools][so-26661475], a broad
  overview including installers (pip, easy_install) etc.
* [Differences between distribute, distutils, setuptools and
  distutils2][so-6344076] includes a useful summary of tools
* [Python Packaging User Guide][packaging]
* [Writing the setup script][setupscript] for Python 2 Distutils



<!-------------------------------------------------------------------->
[PEP 427]: https://peps.python.org/pep-0427/
[PEP 498]: https://peps.python.org/pep-0498/
[PEP 518]: https://peps.python.org/pep-0518/
[PEP 625]: https://peps.python.org/pep-0625/
[PEP 643]: https://peps.python.org/pep-0643/
[PEP 721]: https://peps.python.org/pep-0721/
[built distribution]: https://packaging.python.org/en/latest/glossary/#term-Built-Distribution
[distribution package]: https://packaging.python.org/en/latest/glossary/#term-Distribution-Package
[egg-int]: https://setuptools.pypa.io/en/latest/deprecated/python_eggs.html
[egg-quick]: http://peak.telecommunity.com/DevCenter/PythonEggs
[glossary]: https://packaging.python.org/en/latest/glossary/
[pkgr]: https://setuptools.pypa.io/en/latest/pkg_resources.html
[project]: https://packaging.python.org/en/latest/glossary/#term-Project
[release]: https://packaging.python.org/en/latest/glossary/#term-Release
[sdist-spec]: https://packaging.python.org/en/latest/specifications/source-distribution-format/
[source distribution]: https://packaging.python.org/en/latest/glossary/#term-Source-Distribution
[wheel-spec]: https://packaging.python.org/en/latest/specifications/binary-distribution-format/
[wheel]: https://packaging.python.org/en/latest/glossary/#term-Wheel

[ppug-depver]: https://packaging.python.org/en/latest/specifications/dependency-specifiers/
[ppug-ver]: https://packaging.python.org/en/latest/specifications/version-specifiers/

[`importlib.metadata`]: https://docs.python.org/3.11/library/importlib.metadata.html
[build]: https://build.pypa.io/en/stable/
[distlib]: https://distlib.readthedocs.io/en/latest/
[distutils]: https://packaging.python.org/en/latest/key_projects/#distutils
[hatch-gh]: https://github.com/ofek/hatch
[hatch]: https://hatch.pypa.io/latest/
[key proejcts]: https://packaging.python.org/en/latest/key_projects/#setuptools
[packaging]: https://packaging.pypa.io/en/latest/
[setuptools]: https://setuptools.readthedocs.io/en/latest/

[PyInstaller]: https://pypi.org/project/PyInstaller/
[docker-compose]: https://github.com/docker/compose
[pyinst-adv]: https://pyinstaller.readthedocs.io/en/stable/advanced-topics.html
[pyinst-docs]: https://pyinstaller.readthedocs.io/en/stable/
[pyinst-man]: https://pyinstaller.readthedocs.io/en/stable/man/pyinstaller.html
[pyinst-rti]: https://pyinstaller.readthedocs.io/en/stable/runtime-information.html

[PEP 508]: https://peps.python.org/pep-0508/
[Pipenv]: https://docs.pipenv.org/
[Poetry]: https://github.com/sdispater/poetry
[pip-e]: https://pip.pypa.io/en/latest/topics/vcs-support/#editable-vcs-installs
[pip-rq-fmt]: https://pip.pypa.io/en/stable/reference/requirements-file-format/
[pip-tools]: https://github.com/jazzband/pip-tools

[packaging]: https://packaging.python.org/
[setupscript]: https://docs.python.org/2/distutils/setupscript.html
[so-26661475]: https://stackoverflow.com/a/26661475/107294
[so-6344076]: https://stackoverflow.com/q/6344076/107294
