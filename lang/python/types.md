Python Types
============


Base
----

All below are from the `builtins` module but are referenced with just
the name (`str(33)`, not `builtins.str(33)`). All type names are also
constructors, e.g., `bool(x)`, `bytes([x[, encoding[, errors]]])`,
etc.

Abbreviations below: [I] = immutable, "inst." = instantiated. See
[Language Summary](language.md) for caveats on immutable collections
and [Python.md] for more details of literal instantiation.

### Atomic

Boolean:
* `bool` [I]: inst. with `True`, `False`, `bool(expr)`

Floating point:
* `float` [I]
* `complex` [I]: inst. with `(x+yj)`

Strings and Bytes:
* `str` [I]: strings inst. with `'`, `"`, etc.
* `bytes` [I]: bytes inst. with `b'...'` (also see [Buffer Protocol][bufprot])
* `bytearray`: mutable `bytes`

### Composite

* `object`: base for all classes (no `__dict__` so can't add attrs)
* [`range`] [I]: [sequence] inst. with `range(start, stop[, step])`
* [`tuple`] [I]: tuple inst. with `x, y, ...` (often in parens).
* [`list`]: list/array inst. with `[x, y, ...]`.
* [`dict`]: dictionary inst. with `{ 1: x, 'a': y, ...}`
* [`set`]: inst. with `{0, 'a', ()}` or `set()` for empty set
* `frozenset`: [I] immutable version of `set`
* [`collections` module][collections]

### Collection Interfaces

* [Sequences][sequence]: `str`, `tuple`, `list`. Indexed 0 - len-1.
* Mappings: [`dict`]. key→value sets; keys must be immutable (they're hashed).
* Sets: `set`, `frozenset`
* [`memoryview`]: direct buffer access

See [stdlib](stdlib.md) for functions that operate on these and many
other types.


Common Attributes
-----------------

Many objects have some standard [special attributes] added by the
implementation and not shown by `dir()`:
- `__dict__`: Mapping that stores an objects writable attributes.
- `__class__`: Class of an instance.
- `__bases__`: Tuple of base (inherited) classes of a class object.
- `__subclasses__()`: Class object's subclasses; weak refs.
- `__name__`: Name of class function, method, descriptor, generator.
- `__qualname__`: (≥3.3) Above name prefixed with module name.
- `__mro__`: Tuple of classes used during method resolution.
- `mro()`: Overridden by metclass to customize method resolution.


Classes
-------

[Classes] are objects that create instances of new types; each
instance has its own namespace. "Methods" are functions in the
namespace that take `self` as the first argument.

For details on the internals of attribute and method access, and how
to modify such access, see _[descriptors](functions.md#Descriptors)_.

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


Type Annotations
----------------

Function definition annotations per [PEP 3107] function definition
annotations ([BNF][funcdef]) are available from at least Python 3.4
(perhaps 3.0). These are return annotations `-> expr` and parameter
annotations `identifier: expr`. (Lambdas cannot be annotated.) These
are syntax only (accessible via the `__annotations__` attribute).

Using the [typing] library (3.5 or later) you can annotate as:

    def greeting(name: str = 'nobody') -> str:
        return 'Hello ' + name

    greeting()      # no error
    greeting('joe') # no error
    greeting(7)     # TypeError: Can't convert 'int' object to str implicitly

(This example works in 3.4.3, with no `import typing`. I don't know
why or how.)

Further documentation:
* The [typing] library (3.5)
* [PEP 3107]: Function Annotations (3.0; syntax but no semantics)
* [PEP 483]:  The Theory of Type Hints
* [PEP 484]:  Type Hints (3.5)
* [PEP 526]:  Syntax for Variable Annotations (3.6)



<!-------------------------------------------------------------------->
[Classes]: https://docs.python.org/3.6/tutorial/classes.html
[PEP 3107]: https://www.python.org/dev/peps/pep-3107/
[PEP 483]: https://www.python.org/dev/peps/pep-0483/
[PEP 484]: https://www.python.org/dev/peps/pep-0484/
[PEP 526]: https://www.python.org/dev/peps/pep-0526/
[`dict`]: https://docs.python.org/3/library/stdtypes.html#mapping-types-dict
[`list`]: https://docs.python.org/3/library/stdtypes.html#lists
[`memoryview`]: https://docs.python.org/3/library/stdtypes.html#typememoryview
[`range`]: https://docs.python.org/3/library/stdtypes.html#ranges
[`set`]: https://docs.python.org/3/library/stdtypes.html#set-types-set-frozenset
[`tuple`]: https://docs.python.org/3/library/stdtypes.html#tuples
[bufprot]: https://docs.python.org/3/c-api/buffer.html#bufferobjects
[collections]: https://docs.python.org/3/library/collections.html#module-collections
[funcdef]: https://docs.python.org/3/reference/compound_stmts.html#function-definitions
[sequence]: https://docs.python.org/3/library/stdtypes.html#sequence-types-list-tuple-range
[special attributes]: https://docs.python.org/3/library/stdtypes.html#special-attributes
[typing]: https://docs.python.org/3/library/typing.html
