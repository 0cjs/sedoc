Packaging Python Code
=====================

* Wheel is a newer format than egg.
* Distutils is part of standard library, but functionality is very basic.
* Setuptools recommended over Distutils.

Environment and Dependency Managers
-----------------------------------

* Pip w/manual `requirements.txt`: Dependency versions must be managed
  manually. Locks or ranges, not both.
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



[Hatch]: https://github.com/ofek/hatch
[Pipenv]: https://docs.pipenv.org/
[Poetry]: https://github.com/sdispater/poetry
[packaging]: https://packaging.python.org/
[pip-tools]: https://github.com/jazzband/pip-tools
[setupscript]: https://docs.python.org/2/distutils/setupscript.html
[so-26661475]: https://stackoverflow.com/a/26661475/107294
[so-6344076]: https://stackoverflow.com/q/6344076/107294
