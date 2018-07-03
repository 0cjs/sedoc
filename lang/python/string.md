Python String Handling
======================

* See also [Sequences](sequence.md).

Python strings are [`str`] objects which are immutable sequences of
Unicode code points. There's no separate char type; `s[0]` produces a
string of length 1.

Constructors:

* `str(obj='')`
* `str(obj=b'', encoding='utf-8', errors='strict')`

Literals are single or double-quoted which work the same way except
for allowing double or single quotes in the string. Strings may also
be "triple-quoted" using a sequence of three single or double quotes
(`'''` or `"""`); these may span multiple lines. Adjacent string
literals are concatenated into a single string.

String literals may be prefixed with characters to change their
interpretation. The prefix is case-insensitive. Whitespace is not
allowed between the prefix and the opening quote.

- `b`: Produce a `bytes` instead of a `str`. Only ASCII chars and
  backslash escape sequencs allowed.
- `r`: Raw string or bytes; backslashes are interpreted literally.
  (Not usable with `u`.)
- `u`: Unicode literal. Does nothing in Python ≥3.3; in Python 2,
  where `str` is the equivalant of `bytes`, reads string literal as
  Unicode instead.
- `f`: (≥3.6) [Formatted string literal][f-strings]. Cannot be
  combined with `b` or `u`.

See [String and Bytes literals] for more.

### Methods

[Common Sequence Operations](sequence.md):
* `t [not] in s`: Subsequence test, e.g., `'bar' in 'foobarbaz'` is True
* `s + t`: Concatenation returning new object. For better efficiency,
  use `''.join(s, t, ...)` or write to [`io.StringIO`].

Character Class Predicates (all chars must match and len ≥ 1):
* `isprintable()`: Includes space but not other whitespace;
   true if empty as well
* `isspace()`: Whitespace
* `isalnum()`: Is alpha, decimal, digit or numeric
* `isalpha()`: Unicode 'Letter' (not Unicode 'Alphabetic')
* `isdecimal()`: Chars form numbers in base 10
* `isnumeric()`: Includes e.g., fractions
* `isdigit()`: Includes non-decimal, e.g., superscripts, Kharosthi numbers
* `istitle()`: Cased chars after nonchars upper, all else lower
* `isupper()`, `islower()`: Must include a cased character
* `isidentifier()`: According to Python language def; also see
  `keyword.iskeyword()`

String Predicates (all take optional _start_ and _end_ indexes):
* _s₁_ `in` _s₂_
* `startswith(s)`, `endswith(s)`
* `count(s)`: Count of non-overlapping _s_

Indexing (all take optional _start_ and _end_ indexes):
* `find(s)`, `rfind(s)`: Returns lowest/highest index of _s_
* `index()`, `rindex()`: As _find_ but raise `ValueError` when not found

Modification:
* `lstrip(cs)`, `rstrip(cs)`, `strip(cs)`: Remove leading/trailing/both
  chars of set made from string _cs_, default whitespace
* `replace(old, new[, count])`: Replace substring _old_
* `encode(encoding='utf-8', errors='strict')`: Return `bytes` object
  (strict raises `UnicodeError`)

Case modification:
* `upper()`, `lower()`
* `swapcase()`: Not necessarily reversable
* `capitalize()`: First char capitalized; rest lowered
* `title()`: All chars after non-chars uppered; can produce weird results
* `casefold()`: (≥3.3) More aggressive "lower casing" as per Unicode 3.13.

Padding:
* `expandtabs(tabsize=8)`: Column 0 at start of string
* `center(width, fillchar=' ')`
* `ljust(width, fillchar=' ')`
* `rjust(width, fillchar=' ')`
* `zfill(width)`: Pad with `0` between sign and digits; sign included in width

Splitting:
* `partition(sep)`, `rpartition(sep)`:  
   Return a 3-tuple of `(pre, sep, post)` or `(str, '', '')` if _sep_ not found
* `split(sep=None, max=-1)`, `rsplit()`:
  - _sep_=None separates with runs of consecutive whitespace;
    leading/trailing whitespace is removed
  - Consecutive non-None _sep_s delimit empty strings
  - Returns unlimited if -1, or no more than _max_+1 elements
* `splitlines(keepends=False)`: Splits on `\r`, `\n`, `\r\n`,
   `\v`, `\f`, `\x1c`, `\x1d`, `\x1e` (file/group/record separator),
   `\x85` (next line C1), `\u2028` (line sep), `\u2029` (para sep)


Other:
* `join(iterable)`: Concatenation of _iterable_
  separated by string providing this method.
* `maketrans(x, y=None, z=None)`: Make translation table
  - 1 arg: dict mapping ints of Unicode code points or chars to
    Unicode code points, chars, strings or None
  - 2 args: strings of equal length
  - 3 args: as 2, but 3rd arg is chars to delete
* `translate(table)`: Chars translated through `maketrans` table

### Formatting

* `f'...'`, `F'...'`: (≥3.6) Formatted string literals or [f-strings]
* `format(*args, **kwargs)`: See [format string syntax]
* `format_map(mapping)`: _mapping_ is used directly and not copied to a dict
  (useful for dict subclasses)
* _s_ `%` _values_: Not recommended. See [printf] for more info.


Related
-------

* [`io.StringIO`]



[String and Bytes literals]: https://docs.python.org/3/reference/lexical_analysis.html#strings
[`io.StringIO`]: https://docs.python.org/3/library/io.html#io.StringIO
[`str`]: https://docs.python.org/3/library/stdtypes.html#text-sequence-type-str
[f-strings]: https://docs.python.org/3/reference/lexical_analysis.html#f-strings
[format string syntax]: https://docs.python.org/3/library/string.html#formatstrings
[printf]: https://docs.python.org/3/library/stdtypes.html#printf-style-string-formatting
