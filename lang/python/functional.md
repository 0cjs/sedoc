Functional Programming in Python
================================

GvR seems to somewhat [hate] the FP list idioms, but at least
functions are first class objects and he didn't totally wipe out the
few basic FP functions in Python 3.


Standard Library
----------------

The standard library includes category of [functional programming
modules][functional]:

* [`itertools`]: Functions creating iterators for efficient looping.
* [`functools`]: Higher-order functions and operations on callable objects.
* [`operator`]: Function versions of operators for higher-order use.

#### `functools` Highlights:

* `partial(func, *args, **keywords)`: Returns a [partial] object
  (attributes: `func`, `args`, `keywords`) called as a function:
  
      drop1A = partial(re.sub, 'A', '', count=1)
      drop1A('AbAb') == 'bAb'

* `partialmethod`: Used for method definitions in objects:

      class Foo():
          def id(x): return x
          three = partialmethod(id, 3)

* `reduce(function, iterable[, initializer])`


toolz
-----

Composable, pure and lazy tools for list processing as done in
functional languages.

See: [toolz-pypy], [toolz-docs], [tools-github]



[`functools`]: https://docs.python.org/3/library/functools.html
[`itertools`]: https://docs.python.org/3/library/itertools.html
[`operator`]: https://docs.python.org/3/library/operator.html
[functional]: https://docs.python.org/3/library/functional.html
[hate]: http://www.artima.com/weblogs/viewpost.jsp?thread=98196
[partial]: https://docs.python.org/3/library/functools.html#partial-objects
[tools-github]: https://github.com/pytoolz/toolz/
[toolz-docs]: https://toolz.readthedocs.io/
[toolz-pypy]: https://pypi.python.org/pypi/toolz
