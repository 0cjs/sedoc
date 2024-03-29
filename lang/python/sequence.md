Python Sequences Types and Interfaces
=====================================

[Sequences][sequence] support the [iterator](iter.md) protocol.


Common Sequence Operations
--------------------------

These divide into three parts. The built-in operations on multiple
sequences can take only sequences of the same base type, e.g., `list` and
`list`, but not `tuple` and `list`.
- Built-in operators: single-type, immutable
- Built-in operators: single-type, mutation
- `itertools`: generic and multi-type operations

#### Immutable Sequences

See [Language Summary](language.md) for caveats on immutable
collections.

[Operators][seqops], lowest to highest precedence:

* `x [not] in s`: Containment or subsequence test.
* `=`, `<`, etc.: Lexicographic by [comparing] corresponding elements.
* `s + t`: Concatenation. Immutable returns new obj.
  Not supported by some types, e.g., `range`.
* `s * n`, `n * s`: _s_ + _s_ ... _n_ times using shallow copies.
  _n_ < 0 is same as _n_ = 0.
* `s[i]`: 0-based index. -1 is last item in list.
* `s[i:j]`: Slice from _i_ (default 0)
   up to (but not including) _j_ (default len).
* `s[i:j:k]`: Slice with stride _k_ (_i_, _i+k_, _i+2k_, etc.).
  Negative _k_ strides backwards.
* `len(s)`
* `min(s)`, `max(s)`: smallest/largest item in _s_.
* `s.index(x, i, j)`: Index of first occurence of _x_ in _s_
   between _i_ (default 0) and _j_ (default len). (No `rindex`?)
* `s.count(x)`: Count of occurrences of _x_ in _s_.
* [`hash()`]: Immutable sequences only.
  All values must be immutable or `TypeError` is thrown.
  Hashable objects that compare equal must have same hash value.
  More at [Hashes and Equality][hashandeq].

When implementing these, [`collections.abc.Sequence`] is useful.

See also [Using Iterables](iter.md#using-iterables) for more generic
methods that operate on iterables, including `map`, `enumerate`,
`zip`, `filter`, `max`, `min`, `sum`, `sorted`, `all`, `any`.

#### Mutable Sequences

Below, _s_ is any mutable sequence, _t_ is any iterable and _x_ is an
object that can be stored in _s_.

[Operators][mutseqops]:

* `s[i] = x`: Replacement at index.
* `s[i:j] = t`: Remove slice, insert contents of iterable.
* `del s[i:j]`: Remove slice.
* `s[i:j:k] = t`: Replacement at indices. _t_ must have same length.
* `del s[i:j:k]`: Remove elements.
* `s *= n`: Update _s_ with its contents repeated _n_ times.
  _n_ <= 0 clears. _n_ is integer or implements [`__index()__`].
* `s.append(x)`: Append element _x_ to sequence.
* `s.extend(t)`, `s += t`: Append all elements of _t_.
* `s.insert(i, x)`: Insert _x_ at index _i_, shifting subsequent elements.
  (Same as `s[i:i] = [x]`.)
* `s.pop(i)`: Remove and return element at index _i_ (default -1).
* `s.remove(x)`: Remove first element == _x_ or raise `ValueError`.
* `s.clear()`, `s.copy()`: (≥3.3) Remove all elements (`del s[:]`) and
  shallow copy (`s[:]`). For compatibility with non-sequence containers.
* `s.reverse()`: In-place reversal returning `None`.
  Use `reversed(s)` to return a reversed iterator (as s[::-1], but also
  works on non-indexable collections if they support `__reversed__()`)

When implementing these, [`collections.abc.MutableSequence`] is useful.

The default values in a slice `xs[::]` are `0:-1:1`. Thus, you can use
`x[:]` to refer to the whole list:

    del xs[:]           # Clear (empty) list
    xs[:] = [1,2,3]     # Replace contents of list
    ys = xs[:]          # Shallow copy (`ys is xs` ⇒ False)

#### Itertools

[`itertools`] offers additional operations that can work on multiple
sequences of different types. These are inspired by APL, Haskell and SML.

Infinite:
- `count(start, [step])`
- `cycle(xs)`: repeat each element of _p_: `'AB'` → `'ABABAB...'`
- `repeat(x, [n])`: Repeat _el_ forever or _n_ times

Terminating on shortest input:
- `accumulate(xs, [f])`
- `chain(xs, ...)`
- `chain.from_iterable(xs, ...)`
- `compress`
- `dropwhile`
- `filterfalse`
- `groupby`
- `islice`
- `starmap`
- `takewhile`
- `tee`
- `zip_longest`

Combinatoric:
- `product`
- `permutations`
- `combinations`
- `combinations_with_replacement`


Sequence Types
--------------

The built-in [sequence] types are tuple, list, range,
[`str`](string.md) and `bytes`.

See also [Emulating container types][container-emul].

#### tuple

Construct a [`tuple`] with `tuple()` or comma (parens are optional).

    ()   ;  tuple()     # empty
    a,   ;  (a,)        # singleton
    a,b  ;  (a,b)       # pair, etc.
    tuple(iter)         # from iterable (tuple returns unchanged)

Becuase tuples are immutable, `+` is inefficient. Extend a list instead.

#### namedtuple

[`collections.namedtuple`] extends standard tuples with access via
attribute names. These are exactly as efficient as regular tuples. The
_typename_ (first) parameter is used only to set the class'
`__name__`. The classes generated with this can be used directly by
assigning them to names or it may also be convenient to use them as
superclasses.

    from collections import namedtuple as ntup
    T0 = ntup('T0', 'foo bar baz'); t0 = T0('a', 'b', 'c')

    class T1(ntup('T1', 'a b')):
        def __init__(self, *_): self.sum = self.a + self.b
        def product(self):      return self.a * self.b
        # inherited __str__, __repr__ display ntup name

Constructing ntups with a single `**dict` parameter can be convenient.

Utility methods/attrs start with `_` to avoid collisions:
- `_make(iterable)`: (Class method) Construct this namedtuple from any iterable.
- `_asdict()`: Returns [`OrderedDict`] of names→values (`dict` in Python <3.1).
- `_replace(**kwargs)`: New tuple with some values replaced.
- `_fields`: Tuple of strings listing field names.
- `_fields_defaults`: Dictionary mapping field names to default values (≥3.7)

Python ≥3.7 has a `defaults` kwarg to supply default vaules for init
params. For older versions, [set default values][so-18348004] with:

    T3 = ntup('T3', 'a b c')
    T3.__new__.__defaults__ = (12,13)   # or e.g.: (None,) * len(T3._fields)
    T3(1,2)     # ⇒ T3(1,2,13)
    T3(1)       # ⇒ T3(1,12,13)

Subclasses of named tuples may want to set `__slots__` to an empty
tuple to avoid instance dictionary creation:

    class Point(ntup('Point', 'x y')):
        __slots__ == ()
        @property
        def hypot(self):
            return (self.x ** 2 + self.y ** 2) ** 0.5

To build a new class that "extends" an old one, just add fields:

    Point3D = ntup('Point3', Point._fields + ('z',))

#### list

Construct a [`list`] with `list()` or `[]`:

    []; list()          # empty
    [a, b, c]           # elements
    [x for x in iter]   # comprehension
    list(iter)          # from iterable (list arg is shallow copied)

Additional method:
* `sort(*, key=None, reverse=False)`:
  Stable in-place sort using `<`, returning `None`.
  - Use [`sorted()`] to return a sorted copy.
  - _key_ is a function that when applied to an element gives its sort key.
  - [`functools.cmp_to_key()`] can convert a `cmp(x,y) ⇒ {-1,0,1}` function.
  - See also [Sorting How To].

#### range

A [`range`] is a constant size object with containment functions fully
implemented. Can be empty. Testing commpares as sequences: `range(0)
== range(2,1,3)`.

Construct with `range()`:

    range(n)            # 0..n
    range(m, n)         # m..n
    range(m, n, k)      # stride by k; reverse if negative

Additional attributes: `start`, `stop`, `step`.



[Sorting How To]: https://docs.python.org/3/howto/sorting.html#sortinghowto
[`OrderedDict`]: https://docs.python.org/3/library/collections.html#collections.OrderedDict
[`__index()__`]: https://docs.python.org/3/reference/datamodel.html#object.__index__
[`collections.abc.MutableSequence`]: https://docs.python.org/3/library/collections.abc.html#collections.abc.MutableSequence
[`collections.abc.Sequence`]: https://docs.python.org/3/library/collections.abc.html#collections.abc.Sequence
[`collections.namedtuple`]: https://docs.python.org/3/library/collections.html#collections.namedtuple
[`functools.cmp_to_key()`]: https://docs.python.org/3/library/functools.html#functools.cmp_to_key
[`hash()`]: https://docs.python.org/3/library/functions.html#hash
[`itertools`]: https://docs.python.org/3/library/itertools.html
[`list`]: https://docs.python.org/3/library/stdtypes.html#lists
[`range`]: https://docs.python.org/3/library/stdtypes.html#ranges
[`sorted()`]: https://docs.python.org/3/library/functions.html#sorted
[`tuple`]: https://docs.python.org/3/library/stdtypes.html#tuples
[comparing]: https://docs.python.org/3/reference/expressions.html#comparisons
[container-emul]: https://docs.python.org/3/reference/datamodel.html#emulating-container-types
[hashandeq]: https://hynek.me/articles/hashes-and-equality/
[mutseqops]: https://docs.python.org/3/library/stdtypes.html#mutable-sequence-types
[seqops]: https://docs.python.org/3/library/stdtypes.html#typesseq-common
[sequence]: https://docs.python.org/3/library/stdtypes.html#typesseq
[so-18348004]: https://stackoverflow.com/a/18348004/107294
