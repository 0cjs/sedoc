Python Sequences Types and Interfaces
=====================================

[Sequences][sequence] support the [iterator](iter.md) protocol.


Common Sequence Operations
--------------------------

#### [Immutable Sequences][seqops]

Lowest to highest precedence:

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

When implementing these, [`collections.abc.Sequence`] is useful.

#### [Mutable Sequences][mutseqops]

Below, _s_ is any mutable sequence, _t_ is any iterable and _x_ is an
object that can be stored in _s_.

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


Sequence Types
--------------

The built-in [sequence] types are tuple, list, range,
[`str`](string.md) and `bytes`.

#### [`tuple`]

Construct with `tuple()` or comma (parens are optional).

    ()   ;  tuple()     # empty
    a,   ;  (a,)        # singleton
    a,b  ;  (a,b)       # pair, etc.
    tuple(iter)         # from iterable (tuple returns unchanged)

[`collections.namedtuple`] extends standard tuples with access via
attribute names.

Becuase tuples are immutable, `+` is inefficient. Extend a list instead.

#### [`list`]

Construct with `list()` or `[]`:

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

#### [`range`]

Constant size; containment functions fully implemented. Can be empty.
Testing commpares as sequences: `range(0) == range(2,1,3)`.

Construct with `range()`:

    range(n)            # 0..n
    range(m, n)         # m..n
    range(m, n, k)      # stride by k; reverse if negative

Additional attributes: `start`, `stop`, `step`.



[Sorting How To]: https://docs.python.org/3/howto/sorting.html#sortinghowto
[`__index()__`]: https://docs.python.org/3/reference/datamodel.html#object.__index__
[`collections.abc.MutableSequence`]: https://docs.python.org/3/library/collections.abc.html#collections.abc.MutableSequence
[`collections.abc.Sequence`]: https://docs.python.org/3/library/collections.abc.html#collections.abc.Sequence
[`collections.namedtuple`]: https://docs.python.org/3/library/collections.html#collections.namedtuple
[`functools.cmp_to_key()`]: https://docs.python.org/3/library/functools.html#functools.cmp_to_key
[`hash()`]: https://docs.python.org/3/library/functions.html#hash
[`list`]: https://docs.python.org/3/library/stdtypes.html#lists
[`range`]: https://docs.python.org/3/library/stdtypes.html#ranges
[`sorted()`]: https://docs.python.org/3/library/functions.html#sorted
[`tuple`]: https://docs.python.org/3/library/stdtypes.html#tuples
[comparing]: https://docs.python.org/3/reference/expressions.html#comparisons
[mutseqops]: https://docs.python.org/3/library/stdtypes.html#mutable-sequence-types
[seqops]: https://docs.python.org/3/library/stdtypes.html#typesseq-common
[sequence]: https://docs.python.org/3/library/stdtypes.html#typesseq
