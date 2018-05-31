Iterators and Generators
========================

* See also [Sequences](sequence.md).

[Iterator Protocol]
-------------------

An _[iterator]_ has a [`__next__()`] method that returns successive
items, throwing [`StopIteration`] when no more are available. You may
also use `next(itr)`.

An object is _iterable_ if it can produce an iterator via its
[`__iter__()`] method or `iter(xs)`. The following conventions apply
to particular types:

* Iterators: `__iter__()` must return self.
* [Container types]: `__iter__()` returns a fresh (unconsumed) iterator
  that iteratates over keys for mappings, values otherwise. Additional
  functions may return other types of iterators.

The following  are some things that consume iterables:
* `for x in I` (where `I` is an iterable)
* `x in y` operator
* Constructors: `list`, `tuple`, `set`, `dict`, `frozenset`, ...
* Reducers: `sum`, `min`, ...

Types iterate over:
* `dict`: keys in dictionary
* `open()`: lines in file/input source

### [Builtin] functions operating on iterables:

(For data constructors, see above.)

Mappings:
* `map(f, xs, ys, ...)`: `[f(x₀,y₀,...), f(x₁,y₁,...), ...]`;
  length is shortest input sequence
* `enumerate(xs, start=0)`: sequence of tuples `[(0,x₀), (1,x₁), ...]`
* `zip(xs, ys, ...)`: sequence of tuples: `[(x₀,y₀,...), (x₁,y₁,...), ...]`.
  Unzip ([matrix transposition]) with `ys, zs = zip(*xs)`

Selection:
* `filter(p, xs)`: all _xᵢ_ where _p(xᵢ)_; all if _p_ is `None`
* `max(xs)`, `min(xs)`: maximum/minimum _xᵢ_

Folds:
* `sum(xs, start=0)`: like `accumulate(xs)`. See also `math.fsum()`,
  `itertools.chain()`. To concatenate a string, use `''.join(s)`.

Misc:
* `sorted(xs, key=None, reverse=False)`:
  _key(xᵢ)_ returns the sort key for _xᵢ_.
  `None` specifies the identity function.
* `all(xs)`, `any(xs)`: bool, all or any `bool`(_xᵢ_) == True

### [`itertools`]

The `itertools` library provides functions creating useful iterators
(à la APL, Haskell, SML). The [`operator`] module functions
(`operator.mul`, etc.) are often used with these. The lists below also
include a few similar [builtin] functions.

To simply see a list of the results (if not infinite), wrap the
iterator in `list(...)`.

Infinite:
* `count(start=0, step=1)`: infinite counting
* `cycle(itr)`: infinite repeated iteration over _itr_
* `repeat(elem, n=?)`: repeat _elem_, _n_ times or forever if not specified

Terminating on shortest sequence:
* `accumulate(itr, f=operator.add)`: (≥3.3) sequence of accumulated
  results: `[i₀, i₀+i₁, i₀+i₁+i₂, ...]`.
* `chain(itr0, itr1, ...)`: concatenation of iterables.
* `chain.from_iterable([itr0, itr1, ...])`: concatenation of iterables
  given in the single iterable argument.
* `compress(xs, ps)`: all _xᵢ_ where _pᵢ_
* `takewhile(p, xs)`, `dropwhile(p, xs)`
* `filterfalse(p, xs)`: all _xᵢ_ where not _p(xᵢ)_

Combinatoric:
* XXX write me


[`StopIteration`]: https://docs.python.org/3/library/exceptions.html#StopIteration
[`__iter__()`]: https://docs.python.org/3/reference/datamodel.html#object.__iter__
[`__next__()`]: https://docs.python.org/3/library/stdtypes.html#iterator.__next__
[`itertools`]: https://docs.python.org/3/library/itertools.html
[`operator`]: https://docs.python.org/3/library/operator.html#module-operator
[builtin]: https://docs.python.org/3/library/functions.html
[container types]: https://docs.python.org/3/reference/datamodel.html#emulating-container-types
[iterator protocol]: https://docs.python.org/3/library/stdtypes.html#typeiter
[iterator]: https://docs.python.org/3/glossary.html#term-iterator
[matrix transposition]: https://en.wikipedia.org/wiki/Transpose
