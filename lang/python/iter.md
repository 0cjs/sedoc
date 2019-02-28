Iterators and Generators
========================

* See also [Sequences](sequence.md).

Iterator Protocol
-----------------

An _[iterator]_ implements the [iterator protocol] with a
[`__next__()`] method that returns successive items, throwing
[`StopIteration`] when no more are available. You may also use
`next(itr)` which also throws `StopIteration` unless given a second
argument giving a value to return when the iterator is exhausted.

An object is _iterable_ if it can produce an iterator via its
[`__iter__()`] method or `iter(xs)`. The following conventions apply
to particular types:

* Iterators: `__iter__()` must return self.
* [Container types]: `__iter__()` returns a fresh (unconsumed) iterator
  that iteratates over keys for mappings, values otherwise. Additional
  functions may return other types of iterators.


Generators
----------

[Generators] are functions using the [`yield`] expression in their
body; these return a _generator-iterator_, which is an object
implementing the iterator protcol (plus some further generator-related
methods of its own; see below). Thus any class can implement
`__iter__()` as a generator function.

A [generator expression] is, like a list comprehension, an expression
followed by `for` and optionally `if`:

    ( i*i for i in range(10) if i%2 )

Generator expressions differ from list comprehensions in that the latter
are not lazy; in fact you can think of a list comprehension as passing
a generator expression to the list constuctor. [so-6407222]

#### yield

When any method is called on a generator iterator (returned by a
generator function), the generator function runs up to the point of
the first `yield`. At that point all execution of the function is
suspended and all state (including exception state) is saved.

If the function was `__next()__`, the value given to `yield` is
returned.

On resumption `yield` will return a value based on what
[method][gi-methods] was called on the generator-iterator object:

* `__next()__`: `None` is returned.
* `send(x)`: _x_ is returned.
* `throw(exception)`: The given exception object is raised.
* `close()`: A `GeneratorExit` exception is raised.

[gi-methods]: https://docs.python.org/3/reference/expressions.html#generator-iterator-methods


Using Iterables
---------------

### Syntax

* `for x in I` (where `I` is an iterable)
* `x in y` operator

### Constructors

* `tuple`, `list`: Construct an empty sequence or from an iterable.
* `set`, `frozenset`: Construct an empty set or from an iterable.
* `dict`: Construct an empty dictionary or from _kwargs_, a mapping or
  an iterable of iterable key-value pairs. Iterating over a `dict`
  yields the keys.
* `open()`: Iterates over lines in file or other input source.
* ...

### Builtin Functions

(See also the [Python builtin functions][builtin] documentation.)

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

### itertools

The [`itertools`] library provides functions creating useful iterators
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
* `groupby(xs, p)`: iterator of tuples: _(p(xᵢ), [xss])_ where _xss_
  is an iterator of all sequential elements producing the same result
  from _p()_. (_p()_ defaults to the identity function.) E.g.:
  - `b = [ 1,3,5, 2,4,6, 1,7, 2,12,10, ]`
  - `def show(pair): return (pair[0], list(pair[1]))`
  - `list(map(show, groupby(b, lambda x: x%2)))`
  - ⇒ `[(1, [1, 3, 5]), (0, [2, 4, 6]), (1, [1, 7]), (0, [2, 12, 10])]`
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
[generator expression]: https://docs.python.org/3/glossary.html#term-generator-expression
[generators]: https://docs.python.org/3/glossary.html#term-generator
[iterator protocol]: https://docs.python.org/3/library/stdtypes.html#typeiter
[iterator]: https://docs.python.org/3/glossary.html#term-iterator
[matrix transposition]: https://en.wikipedia.org/wiki/Transpose
[so-6407222]: https://stackoverflow.com/a/6407222/107294
