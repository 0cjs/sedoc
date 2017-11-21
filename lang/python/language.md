Python Summary/Quickref
=======================

Python's reference implementation is the [CPython] interpreter.
There are two major versions:
* 2.7 (2010): [legacy], supported until 2020 (latest 2.7.13 2016-12)
* 3.6.3 (2017-10): current (3.7 releasing 2018-06)

A good REPL is available via [ipython](./ipython.md).

Python variables are untyped; their values are typed. All variables
are references to objects or builtin types. [Functions](functions.md)
define variables in the same namespace and these reference function
objects.

There is limited implicit conversation, mainly between numeric types
and any type to boolean.


Syntax
-------

Line-oriented, with blocks delimited by indentation ([lex]).
Statements that introduce blocks (`def`, `if`, `else`, etc.) end with
a `:` (`if p: x`) and must have a body; use `pass` as the body if it
should do or return nothing (see example in [types](types.md)).

If `return` is not used in a function it always returns `None`.
`lambda: expr` however returns `expr` and may not use `return`.

See [types.md] for more information on the types below.


### Literals

Numbers: the usual: `0`, `-1`, `3.4`, `3.5e-8`.

String (`str`) Literals:

    'foo'           # C-style backslash sequences interpolated
    '''foo'''       # newlines are literal
    r'foo'          # no `\x` interpolation; useful for regexes

    'a' "b"         # adjacent literals are concatenated
    len('a'  # 1    # Good for commenting parts of strings.
        'b') # 2    # len('ab') => 2

Tuples, Lists, Dictionaries, Sets:

    1, 2                    # tuple
    (1, 2)                  # tuple
    ()                      # empty tuple

    [0, 'a', (), []]        # list
    list({4,2,3})           # list: [2,3,4] (from set; see below)

    { 1:'one', 'two':2 }    # dict
    {}                      # empty dict

    { 0, 'a', (), [] }      # set
    set()                   # empty set
    frozenset(['a',2,'a'])  # frozen set: frozenset({2, 'a'})


Objects
-------

`dir()` returns a list of names in local scope; `dir(obj)` returns the
list of `obj`'s attributes.


Further Reading
---------------

* Wikipedia, [Python syntax and semantics][wp].
* [The Python Language Reference][pyref].



[wp]: https://en.wikipedia.org/wiki/Python_syntax_and_semantics
[pyref]: https://docs.python.org/3/reference/

[CPython]: https://en.wikipedia.org/wiki/CPython
[legacy]: https://wiki.python.org/moin/Python2orPython3
[lex]: https://docs.python.org/3/reference/lexical_analysis.html
[lambda]: https://docs.python.org/3/reference/expressions.html#lambda
