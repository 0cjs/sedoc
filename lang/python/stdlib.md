The [Python Standard Library][stdlib]
=====================================

[Built-in Functions][builtin]
-----------------------------

There are several dozen built-in functions (not including data type
constructors), many of which operate on many or all types. The most
useful are:

#### Data type constructors
  * `bool(x)` etc.; see [types](types.md).

#### Functions
  * `callable(o)`: appears to be callable as `o(...)`
  * `eval(exp, globals=None, locals=None)`
  * `exec(obj[, globals[, locals]])`: execute a string or code object

#### Numeric
  * `abs(x)`, `round(x[,ndgits])`
  * `int(x[,base])`: converts number or string
  * `bin(n)`, `hex(n)`, `oct(n)`: return string, e.g., `0b1101`
  * `divmod(a,b)`: same as `(a//b, a%b)`
  * `pow(x,y[,z])`: same as `x**y`; more efficient than `x**y % z`

#### String
  * `repr(o)`: printable representation of _o_; sometimes `eval()`able
    (classes may define `_repr__()`)
  * `ascii(o)`: printable representation of _o_ with non-ASCII chars escaped
  * `chr(i)`: string of Unicode code point _i_
  * `ord(s)`: int of Unicode code point `s[0]`; `len(s)` must be 1
  * `format(val,spec)`: See [format]

#### Composite Types
  * `len(seq)`: works for many non-iterables, too
  * `reversed(seq)`
  * `slice(stop)`, `slice(start,stop[,step])`

#### Iterable
  * `enumerate(['a','b'])` returns `[(1,'a'), (2,'[b')]`
  * `zip(*iterables)`
  * `filter(P, iterable)`: P = `None` is identity (removes all false values)
  * `map(f, iterable)`
  * `sorted(iterable, *, key=None, reverse=False)`
  * `min(...)`, `max(...)`, `sum(...)`
  * `all(els)`, `any(els)` if all/any elements are true.

#### [Iterators]
  * `next(iter[,default])`: calls `__next__()`,
    returns _default_ if `StopIteration` thrown

#### Objects
  * `id(o)`: unique identity constant for object (not interpreter) lifetime
    (memory address in CPython)
  * `hash(o)`: int hash value
  * `dir(o)`: names (attributes) in _o_, or local scope if no arg
  * `vars(o)`: `__dict__` of _o_, or without arg, `locals()`
  * `isinstance(o,cls)`, `issubclass(o,cls)`: _cls_ may be tuple to
    check if instance of any in it
  * `type(o)`: return type object, usually `o.__class__`
  * `getattr(o,k)`, `setattr(o,k,v)`, `delattr(o,k)`: attributes
  * [`property(fget=None,fset=None,fdel=None,doc=None)`][property]
  * [`super([type[,obj-or-type]])`][super]: proxy that delegates method calls

#### I/O
  * `print(*objs,sep='',end='\n',file=sys.stdout,flush=False)`:
    _file_ must have a `write(str)` method
  * [`open()`]

#### Other
  * `help([o])`: e.g., `help(dict)` to get a quickref
  * `input([prompt])`: prints prompt, reads and returns stripped line
  * `globals()`, `locals()`: symbol table dictionaries
  * `__import__(name,globals=None,locals=None,fromlist=(),level=0)`


Other Builtins
--------------

* Constants
* Types
* [Exceptions] and their [hierarchy]


[Standard Library][stdlib]
--------------------------

* Regular Expressions in [`re` package](regexp.md)
* The [functional programming modules][fpmods] include:
  * [`operator`]: standard operators  (`+`, `=`, etc.) as functions
    (see the [opmap])
  * [`functools`]: higher order functions and operations on callable objects



[Exceptions]: https://docs.python.org/3/library/exceptions.html
[Iterators]: https://docs.python.org/3/library/stdtypes.html#iterator-types
[`open()`]: https://docs.python.org/3/library/functions.html#open
[`operator`]: https://docs.python.org/3/library/operator.html
[bufprot]: https://docs.python.org/3/c-api/buffer.html#bufferobjects
[builtin]: https://docs.python.org/3/library/functions.html
[format]: https://docs.python.org/3/library/string.html#formatspec
[fpmods]: https://docs.python.org/3/library/functional.html
[hierarchy]: https://docs.python.org/3/library/exceptions.html#exception-hierarchy
[opmap]: https://docs.python.org/3/library/operator.html#mapping-operators-to-functions
[property]: https://docs.python.org/3/library/functions.html#property
[stdlib]: https://docs.python.org/3/library/index.html
[super]: https://docs.python.org/3/library/functions.html#super
