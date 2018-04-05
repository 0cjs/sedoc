Iterators and Generators
========================

[Iterator Protocol]
-------------------

An _[iterator]_ (said to be 'iterable')  has a [`__next__()`] method
that returns successive items, throwing [`StopIteration`] when no more
are available. Calling [`__iter__()`] on an object is expected to
produce an iterator. The following conventions apply to particular
types:

* Iterators: `__iter__()` must return self.
* [Container types]: `__iter__()` returns a fresh (unconsumed) iterator
  that iteratates over keys for mappings, values otherwise. Additional
  functions may return other types of iterators.

Built-in functions `iter(S)` and `next(I)` are mostly equivalant to
calling `__iter__()` and `__next__()` on `S` and `I`, respectively.

The following  are some things that consume iterables:
* `for x in ITR`
* `x in y` operator
* Constructors: `list`, `tuple`, `set`, `dict`, ...
* Reducers: `sum`, `min`, ...

Types iterate over:
* `dict`: keys in dictionary
* `open()`: lines in file/input source

### [`itertools`]

The `itertools` library provides functions creating useful iterators
(à la APL, Haskell, SML). The [`operator`] module functions
(`operator.mul`, etc.) are often used with these.

Infinite:
* `count(start=0, step=1)`: infinite counting
* `cycle(itr)`: infinite repeated iteration over _itr_
* `repeat(elem, n=?)`: repeat _elem_, _n_ times or forever if not specified

Terminating on shortest sequence:
* XXX write me

Combinatoric:
* XXX write me


[`StopIteration`]: https://docs.python.org/3/library/exceptions.html#StopIteration
[`__iter__()`]: https://docs.python.org/3/reference/datamodel.html#object.__iter__
[`__next__()`]: https://docs.python.org/3/library/stdtypes.html#iterator.__next__
[container types]: https://docs.python.org/3/reference/datamodel.html#emulating-container-types
[iterator protocol]: https://docs.python.org/3/library/stdtypes.html#typeiter
[iterator]: https://docs.python.org/3/glossary.html#term-iterator
[`itertools`]: https://docs.python.org/3/library/itertools.html
[`operator`]: https://docs.python.org/3/library/operator.html#module-operator
