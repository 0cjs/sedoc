Pickle Object Serialization
===========================

[Pickle] is preferred to the more primitive [marshal] which exists
mainly to support `.pyc` files. Pickle is portable across Python
versions and stores objects only once, preserving sharing and handling
recursion.

Unpickling will happily run malicious code; don't unpickle untrusted
or unverified data.

Related packages:
* [shelve]: Pickle to and unpickle from DBM files.
* [pickletools]: Developer stuff, including a protocol disassembler.

You can use these modules to print/dissassemble pickle data files:

    $ python3 -m pickle z.pickle            # print objects
    $ python3 -m pickletools -a z.pickle    # disassembly, annotated


Usage
-----

[`dump()`] and [`load()`] write to/read from a file handle; `dumps()`
and `loads()` do the same with [`bytes`] objects.

    from pickle import *

    b = dumps(obj, protocol=None, fix_imports=True)
    obj = loads(b, fix_imports=True, encoding='ASCII', errors='strict')

    with open('file', 'wb') as f: f.dump(obj, f)
    with open('file', 'rb') as f: obj = f.load(f)

    # `f` must have a `write(bytes)` method, e.g., `io.BytesIO`
    p = Pickler(f, protocol=None, fix_imports=True)
    p.dump(o0); p.dump(o1)

    u = Unpickler(f, fix_imports=True, encoding='ASCII', errors='strict')
    o0 = u.load(); o1 = u.load()

### Exceptions

Pickle module:
* `PickleError`: base class inheriting `Exception`
* `PicklingError`: object is unpicklable (may have been partially written)
* `UnpicklingError`

Other modules:
* `RecursionError`: Data structure is too recursive
* `EOFError`: Ran out of input
* `AttributeError`, `ImportError`, `IndexError`
* Maybe more

### Picklable Types

* `None`, `True`, `False`
* integers, floating point numbers, complex numbers
* strings, bytes, bytearrays
* tuples, lists, sets, and dictionaries containing only picklable objects
* functions defined at the top level of a module (using def, not lambda)
* built-in functions defined at the top level of a module
* classes that are defined at the top level of a module
* instances of such classes whose `__dict__` or the result of calling
  `__getstate__()` is picklable

Functions and classes are pickled by reference to the fully qualified
name (i.e., including the full module name, regardless of local name).
Thus these must be loadable from the same source code on the system
where objects are being unpickled. Lambdas cannot be pickled because
they all share the name `<lambda>`. Current class code and attributes
are not pickled with the object so if they've been changed dynamically
they'll be (re-)set to the value used in the defining code. (This might
have added changes or bugfixes.)

If you plan to have long-lived objects that will see many versions of
a class, it may be worthwhile to put a version number in the objects
so that suitable conversions can be made by the class's [`__setstate__()`]
method.

You can change how instances are pickled/unpickled; see [Pickling
Class Instances][pci]. You can also create/use references to
persistent objects outside the data stream (`persistent_id()` and
`persistent_load()` methods). You can override how globals are found
with `find_class()` (this can help with security).


Formats
-------

Pickle uses one of five binary formats; compress if necessary.
The formats are:
* 0: human-readable, very early compatibility
* 1: old binary format, also very early compatibility
* 2: ≥2.3, more efficient with current class structure
* 3: ≥3.0, default, explicit support for `bytes`
* 4: ≥3.4 (PEP 3154) supports very large objects, more kinds

Protocol arguments take:
* Any integer above
* `HIGHEST_PROTOCOL`, any negative number
* `DEFAULT_PROTOCOL` (≥3.0), `None`



[`__setstate__()`]: https://docs.python.org/3/library/pickle.html#object.__setstate__
[`bytes`]: https://docs.python.org/3/library/stdtypes.html#bytes
[`dump()`]: https://docs.python.org/3/library/pickle.html#pickle.dump
[`load()`]: https://docs.python.org/3/library/pickle.html#pickle.load
[marshal]: https://docs.python.org/3/library/marshal.html
[pci]: https://docs.python.org/3/library/pickle.html#pickling-class-instances
[pickle]: https://docs.python.org/3/library/pickle.html
[pickletools]: https://docs.python.org/3/library/pickletools.html
[shelve]: https://docs.python.org/3/library/shelve.html
