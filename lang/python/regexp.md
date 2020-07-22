[`re`] - Regular expression operations
--------------------------------------

This works on Unicode `str` and byte (`bytes`) strings, but they can't
be mixed: the search string, pattern and replacement must all be the
same type.

Regexp strings use `\` for special regex meanings, so generally use
raw string notation for them to avoid the Python `\` interpretations:
`r'\n'` for a string containing `\` followed by `n`. Feel free to
concatentate search strings as necessary (also see [tokenizer]):

    prog = re.compile(
        'a'   # first part
        'b'   # second part
        )

[Matching Functions]
--------------------

    p = re.compile('b')             # compile pattern for reuse (or use cached)
    p.search('abc')                 # same as: re.search('b', 'abc')
    filter(prog.search, ['abc'])    # useful with higher-order functions

    re.search('b', 'abc')           # first match anywhere in string
    re.match('b', 'bc')             # == `search('^b', 'bc')`
                                    #    when not in multiline mode
    re.fullmatch('b', 'b')          # == `search('^b$', 'b')`

    re.split(r'\.', '1.2.3.4', maxsplit=2)      # ⇒ ['1', '2', '3.4']

    re.split('(\W+)', 'Words: words; words.', maxsplit=0, flags=0)
        # ⇒ ['Words', ': ', 'words', '; ', 'words', '.', '']

    re.findall('0.', '0ab0cd0ef')   # ⇒ ['0a', '0c', '0e']
    re.finditer('0.', '0ab0cd0ef')  # ⇒ (iterator)

    re.sub('0.', '_', '0ab0cd0ef', count=2)     # ⇒ '_b_d0ef'
    re.subn('0.', '_', '0ab0cd0ef', count=0)    # ⇒ ('_b_d_f', 3)

    # Pattern objects from `re.compile()` have functions above,
    # as `re.search('abc', pos=2, endpos=3)`, and:
    p.pattern; p.flags
    p.groups                        # count of `()` groups in pattern
    p.groupindex                    # map of symbolic `(?P<id>)` group names

    # Misc stuff
    re.escape('.*')                 # ⇒ '\\.\\*'
    re.purge()                      # Clear compiled regexp cache

Flags can be passed as the last argument or `flags` to the functions:

    re.compile('b', re.ASCII | re.I)

* A, ASCII: `\w` etc. match ASCII instead of Unicode. Inline: `(?a)`.
* DEBUG: Print debug info when compiling
* I, IGNORECASE: Case-insenstive; Unicode-casing unless `A` given.
  Inline: `(?i)`.
* L, LOCALE: (`bytes`-only) `\{wWbB}` case-insensitive depending on
  locale; very unreliable. Inline: `(?L)`.
* M, MULTILINE: `^` matches beginning of line as well as string,
  `$` similar. Inline: `(?m)`.
* S, DOTALL: `.` matches newlines. Inline `(?s)`.
* X, VERBOSE: Ignore unescaped, non-charclass whitespace; allow comments
  with `#`, e.g.:
      re.compile(r'\d+\.\d*')
      re.compile(r'''\d+    # integral part
                     \.     # decimal point
                     \d*    # fraction      ''', re.X)

Exception
---------

Raised on failure to compile or other error.

    e = re.error(msg, pattern=None, pos=None)

    e.msg                       # Unformatted error message
    e.pattern
    e.pos; e.lineno; e.colno    # Index where compile failed (may be None)

[Match Objects]
---------------

These always have value `True` in boolean expressions.
`search()` etc. return `None` on no match.

    m = re.search('_(.*)_(.*)_', '_a_bc_')
    m.span()                    # ⇒ (0, 6)      # == (m.start(), m.end())
    m.expand(r'-\1-\2-')        # ⇒ '-a-bc-'
    m.group(1)                  # ⇒ 'a'
    m.span(1)                   # ⇒ (1, 2)      # == (m.start(1), m.end(1))
    m.group(0, 2)               # ⇒ ('_a_bc_', 'bc')
    m.groups()                  # ⇒ ('a', 'bc')
    m.lastindex                 # ⇒ 2           # last matched group

    m = re.search(r'(?P<first>\w+) (?P<last>\w+)', 'Taro Tanaka')
    m.group('last', 'first')    # ⇒ ('Tanaka', 'Taro')
    m.groupdict()               # ⇒ {'first': 'Taro', 'last': 'Tanaka'}
                                #   (Named groups only)
    m.expand('Mr. \g<last>')    # ⇒ 'Mr. Tanaka'        # also \g<2> and \2

    m = re.search('(..)+', 'abcdef')    # Only last match available
    m.group(1)                          # ⇒ 'ef'

    # Copied from input
    m.re                        # regexp
    m.string                    # passed to search/match
    m.pos; m.endpos

[Regular Expression Syntax] Summary
-----------------------------------

    Expr            Matches
    ------------------------------------------------------------------
    .               Any char
    ^               Start of string; start of line in `MULTILINE`
    $               End of string; end of line in `MULTILINE`
    * + ?           0 or more, 1 or more, 0 or 1 of prev expr
    *? +? ??        Non-greedy versions of above
    {m}             Exactly _m_ of prev expr
    {m,n}           From _m_ to _n_ of prev expr
    {m,n}?          Non-greedy version of above
    \               Escapes special chars (`*` etc.); starts special sequence
    []              Standard ranges; `\\` escapes special chars in ranges
    a|b             Match a or b

    (?...)          Extension (doesn't create new group)
    (?aiLmsux)      Set flags (see above); must be first in regex string
    (?ismx-ismx:...) Enables/disables flags for ???

    (...)           Captured grouping
    (?:...)         Non-captured grouping
    (?P<name>...)   Grouping captured with name _name_ as well as number
    \3              Matches (previous) 3rd group match
    (?P=name)       Matches whatever matched by previous group _name_

    (?=...)         Lookahead; matches but doesn't consume; e.g.
                    r'Isaac (?=Asimov)' matches Isaac only if followed by Asimov
    (?!...)         Negative lookahead; match only if ... doesn't appear next
    (?<=...)        Lookbehind: re.search('(?<=-)\w+', 'ham-egg') ⇒ 'egg'
    (?<!...)        Negative lookbehind

    (?(id/name)yes-pattern|no-pattern)
                    Tries yes-pattern if id/name exists, otherwise (optional)
                    no-pattern, e.g., '(<)?.*(?(1)>)' kinda matches paired <>.

    (?#...)         Comment

    \A \Z           Start/end of string
    \b \B           Empty string at/not at beginning or end of word
                    (boundary between \w and \W or vice versa)
    \d \D           Digit/not digit
    \s \S           Whitespace/not whitespace
    \w \W           word char/not word char

    \abfnrtuUvx\    Standard string backslash-char substitution



[Match Objects]: https://docs.python.org/3/library/re.html#match-objects
[Matching Functions]: https://docs.python.org/3/library/re.html#module-contents
[Regular Expression Syntax]: https://docs.python.org/3/library/re.html#regular-expression-syntax
[`re`]: https://docs.python.org/3/library/re.html
[tokenizer]: https://docs.python.org/3/library/re.html#writing-a-tokenizer
