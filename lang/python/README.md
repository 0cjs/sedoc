Python Summary/Quickref
=======================

* [Linux "Optional" modules, building and build dependencies](runtime/linux.md)
* [Versions](version.md)
* [Glossary](https://docs.python.org/3/glossary.html)
* [Introduction and Syntax](language.md)
  - [Expressions and Statements](expressions.md)
  - [Functions](functions.md)
  - [Types](types.md)
  - [Names, Bindings, Namespaces](name-binding.md)
  - [Character and Byte String Handling](string.md)
  - [Docstrings](docstring.md)
* Language Features
  - [Exceptions and Warnings](exceptions.md)
  - [Iterators and Generators](iter.md)
  - [Sequences](sequence.md)
  - [Modules, Packages and Importing](import.md)
* [Standard Libraries](stdlib.md)
  - [Regular Expressions](regexp.md)
  - [Date and Time](datetime.md)
  - [Iterator protcol and `itertools`](iter.md)
  - [File and Network I/O](io.md).
  - [Filesystem and Path Libraries](files.md)
  - [Pickle](pickle.md) object seralization
  - [Argument Parsing](argparse.md)
  - [Logging](logging.md)
  - [Concurrency, subprocesses](concurrency.md)
  - [Internet Protocols and Support](internet.md)
  - [Python Language Services](ast.md) (manipulating Python code)
* [Functional Programming](fp.md)
  - [Functional] modules in the standard library
  - [toolz][toolz-pypy] library ([docs][toolz-docs])
* Runtime Environments
  - [Site setup](runtime/site.md) (`sys.path` etc.)
  - [IPython REPL](runtime/ipython.md)
  - [Virtual Environments](runtime/virtualenv.md)
  - [Packaging Code](runtime/packaging.md)
  - [Microsoft Windows](runtime/win.md)
  - [Jupyter](runtime/jupyter.md) (IPython) Notebook, Hub, Lab, etc.
* Testing Libraries
  - [PythonTestingToolsTaxonomy][PTTT] offers a large list of testing tools.
  - [`unittest`](test/unittest.md)
  - [`doctest`] finds and runs tests in function docstrings.
  - [Pytest](test/pytest.md)
    ([Assertions](test/pytest-assert.md),
    [Configuration](test/pytest-config.md))
  - [tox](test/tox.md)
* Other Libraries
  - [`attrs`](lib/attrs.md) to generate class definition boilerplate
  - [PyYAML](lib/yaml.md)
  - [PyMongo](lib/pymongo.md)
  - [Twisted](lib/twisted/), an event-driven networking/concurrency framework
  - [Git Libraries](lib/git.md)
  - [SQLAlchemy](lib/sqlalchemy.md)
* [Tips and Tricks](tips.md)

When using `pip` with a system (OS-packaged) Python, ensure that the
`python-dev` or `python3-dev` (Debian) package is installed or some
packages may not build. (The typical error message will include
something about not being able to find `<Python.h>`.)


Glossary
--------

* __dunder__: Double underline, as in `__name__`.


Major Changes in New Versions
-----------------------------

See also [python-version-cheat-sheet] and offical [changelog].

- 3.3: `yield from` (PEP380)
- 3.4: `pathlib` (PEP 428)
- 3.5: Additional unpacking generalisations (PEP 448).
  Type annotations excepting variables (PEP 484).
- 3.6: f-strings (PEP 498).
  Underscores in numeric literals, e.g. 1_000 (PEP 515).
  Type annotations for variables (PEP 526).
- 3.7: Guaranteed sort order of dicts.
  Data classes (PEP 557).
  `breakpoint()` (PEP 553).
  Postponed eval of annotations (PEP 563).
- 3.8: Walrus operator `:=` (PEP 572)
- 3.9: Built-in generic types; annotate w/`list[int]`
  instead of `from typing import List` (PEP 585).
- 3.10: Structural pattern matchin (PEP 622).
  Union types as `X | Y` (PEP 604).
- 3.11: Exception groups, `except*` (PEP 654).
  Standard library `tomlib` for parsing TOML (PEP 680).



<!-------------------------------------------------------------------->
[PTTT]: https://wiki.python.org/moin/PythonTestingToolsTaxonomy
[`doctest`]: https://docs.python.org/3/library/doctest.html
[changelog]: https://docs.python.org/3/whatsnew/changelog.html
[functional]: https://docs.python.org/3/library/functional.html
[python-version-cheat-sheet]: https://github.com/jugmac00/python-version-cheat-sheet
[toolz-docs]: https://toolz.readthedocs.io/
[toolz-pypy]: https://pypi.python.org/pypi/toolz
