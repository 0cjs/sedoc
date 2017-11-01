Python Summary/Quickref
=======================

Python variables are untyped; their values are typed. All variables
are references to objects. Functions define variables in the same
namespace referencing function objects.

There is limited implicit conversation, mainly between numeric types
and any type to boolean.


Syntax
-------

Line-oriented, with blocks delimited by indentation ([lex]).
Statements that introduce blocks (`def`, `if`, `else`, etc.)
end with a `:` (`if p: x`).

If `return` is not used in a function it always returns `None`.

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

Functions:

    def f(x): return x + 1  # 'return' required
    g = f
    h = lambda x: x + 1     # no 'return'!


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

[lex]: https://docs.python.org/3/reference/lexical_analysis.html
[lambda]: https://docs.python.org/3/reference/expressions.html#lambda
