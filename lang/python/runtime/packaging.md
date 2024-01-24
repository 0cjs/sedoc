Packaging Python Code
=====================

* Wheel is a newer format than egg.
* Distutils is part of standard library, but functionality is very basic.
* Setuptools recommended over Distutils.

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

[`requirements.txt` format][pip-rq-fmt]:

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
[PyInstaller]: https://pypi.org/project/PyInstaller/
[docker-compose]: https://github.com/docker/compose
[pyinst-adv]: https://pyinstaller.readthedocs.io/en/stable/advanced-topics.html
[pyinst-docs]: https://pyinstaller.readthedocs.io/en/stable/
[pyinst-man]: https://pyinstaller.readthedocs.io/en/stable/man/pyinstaller.html
[pyinst-rti]: https://pyinstaller.readthedocs.io/en/stable/runtime-information.html

[Hatch]: https://github.com/ofek/hatch
[Pipenv]: https://docs.pipenv.org/
[Poetry]: https://github.com/sdispater/poetry
[pip-e]: https://pip.pypa.io/en/latest/topics/vcs-support/#editable-vcs-installs
[pip-rq-fmt]: https://pip.pypa.io/en/stable/reference/requirements-file-format/
[pip-tools]: https://github.com/jazzband/pip-tools

[packaging]: https://packaging.python.org/
[setupscript]: https://docs.python.org/2/distutils/setupscript.html
[so-26661475]: https://stackoverflow.com/a/26661475/107294
[so-6344076]: https://stackoverflow.com/q/6344076/107294
