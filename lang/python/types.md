Python Types
============


Base
----

All below are from the `builtins` module but are referenced with just
the name (`str(33)`, not `builtins.str(33)`).

Abbreviations below: [I] = immutable, "inst." = instantiated.
(See [Python.md] for more details of literal instantiation.)

* `str` [I]: strings inst. with `'`, `"`, etc.
* `tuple` [I]: tuples inst. with `x, y, ...` (often in parens).
* `list`: list/array inst. with `[x, y, ...]`.
* `dict`: dictionary inst. with `{ 1: x, 'a': y, ...}` 
* `set`: inst. with `{0, 'a', ()}` or `set()` for empty set
* `frozenset`: [I] immutable version of `set`


Collection
----------

* Sequences: `str`, `tuple`, `list`. Indexed 0 - len-1.
* Mappings: `dict`. key→value sets; keys must be immutable (they're hashed).
* Sets: `set`, `frozenset`
