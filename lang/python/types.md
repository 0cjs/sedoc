Python Types
============


Base
----

All below are from the `builtins` module but are referenced with just
the name (`str(33)`, not `builtins.str(33)`). All type names are also
constructors, e.g., `bool(x)`, `bytes([x[, encoding[, errors]]])`,
etc.

Abbreviations below: [I] = immutable, "inst." = instantiated.
(See [Python.md] for more details of literal instantiation.)

### Atomic

* `bool` [I]: inst. with `True`, `False`, `bool(expr)`

* `float` [I]
* `complex` [I]: inst. with `(x+yj)`

* `str` [I]: strings inst. with `'`, `"`, etc.
* `bytes` [I]: bytes inst. with `b'...'` (also see [Buffer Protocol][bufprot])
* `bytearray`: mutable `bytes`

### Composite

* `object`: base for all classes (no `__dict__` so can't add attrs)
* `range` [I]: sequence inst. with `range(start, stop[, step])`
* `tuple` [I]: tuples inst. with `x, y, ...` (often in parens).
* `list`: list/array inst. with `[x, y, ...]`.
* `dict`: dictionary inst. with `{ 1: x, 'a': y, ...}`
* `set`: inst. with `{0, 'a', ()}` or `set()` for empty set
* `frozenset`: [I] immutable version of `set`
* [`collections` module][collections]

### Collections

* Sequences: `str`, `tuple`, `list`. Indexed 0 - len-1.
* Mappings: `dict`. key→value sets; keys must be immutable (they're hashed).
* Sets: `set`, `frozenset`
* [`memoryview`]: direct buffer access

See [stdlib](stdlib.md) for functions that operate on these and many
other types.


Classes
-------

[Classes] are objects that create instances of new types; each
instance has its own namespace. "Methods" are functions in the
namespace that take `self` as the first argument.

All data in an object's namespace ("attributes") are public.
Convention dicates that names starting with an `_` are for internal
use only. Names starting with `__` (and with no more than one trailing
`_`) are internally mangled to `_classname_name` to avoid subclasses
overriding them. Note that `exec()`/`eval()` don't consider their
invoking class to be the current class.

Empty class definitions are useful as structs:

    class Point: pass
    p = Point(); p.x = 17; p.y = -33


(XXX add more here, and cover `@staticmethod` and `@classmethod`.)



[bufprot]: https://docs.python.org/3/c-api/buffer.html#bufferobjects
[Classes]: https://docs.python.org/3.6/tutorial/classes.html
[`memoryview`]: https://docs.python.org/3/library/stdtypes.html#typememoryview
[collections]: https://docs.python.org/3/library/collections.html#module-collections
