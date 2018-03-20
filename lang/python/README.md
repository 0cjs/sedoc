Python Summary/Quickref
=======================

* [Versions](version.md)
* [Introduction and Syntax](language.md)
  * [Expressions and Statements](expressions.md)
  * [Functions](functions.md)
  * [Types](types.md)
  * [Names, Bindings, Namespaces](name-binding.md)
* Language Features
  * [Modules, Packages and Importing](import.md)
* [Standard Libraries](stdlib.md)
  * [Regular Expressions](regexp.md)
  * [Pickle](pickle.md) object seralization
  * [Argument Parsing](argparse.md)
  * [Concurrency](concurrency.md) (including processes)
  * [Python Language Services](ast.md) (manipulating Python code)
* [Functional Programming](functional.md)
  * [Functional] modules in the standard library
  * [toolz][toolz-pypy] library ([docs][toolz-docs])
* Runtime Environments
  * [IPython REPL](runtime/ipython.md)
  * [Virtual Environments](runtime/virtualenv.md)
* Testing Libraries
  * [PythonTestingToolsTaxonomy][PTTT] offers a large list of testing tools.
  * [`unittest`](test/unittest.md)
  * [`doctest`] finds and runs tests in function docstrings.
  * [Pytest](test/pytest.md)
  * [tox](test/tox.md)
* [Tips and Tricks](tricks.md)

When using `pip` with a system (OS-packaged) Python, ensure that the
`python-dev` or `python3-dev` (Debian) package is installed or some
packages may not build. (The typical error message will include
something about not being able to find `<Python.h>`.)



[PTTT]: https://wiki.python.org/moin/PythonTestingToolsTaxonomy
[`doctest`]: https://docs.python.org/3/library/doctest.html
[functional]: https://docs.python.org/3/library/functional.html
[toolz-docs]: https://toolz.readthedocs.io/
[toolz-pypy]: https://pypi.python.org/pypi/toolz
