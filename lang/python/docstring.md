Docstrings
==========

A string literal occuring as the first statement in a module,
function, class or method definition is the _docstring_, and is stored
as the `__doc__` attribute of that object. (A package docstring is in
the `__init__.py` in the package's directory.)

The style guides suggest always using three double-quotes (`"""`)
around docstrings. I don't see the point of the extra ink and just use
single or triple single quotes (`'`, `'''`) as appropriate.

Docstring tools generally strip indentiation based on the minimum
indentation of all non-blank lines in the docstring after the first,
preserving remaining indentation. See [PEP 257] for the exact
algoritm.


RST (reStructuredText) Docstrings
---------------------------------

[PEP 287] describes the convention of using [reStructuredText][] ([RST
docs], [quickref]) in docstrings.

Use interpreted text (in backticks, like Markdown inline code quoting)
for identifiers such as function parameters; these will be linked in
rendered documentation.

Double backticks are used for literal code snippets (like single backticks
in markdown);; these are not interpreted in any way.

#### Differences between RST and Markdown

Special characters are escaped with backslashes when necessary, just
like Markdown. See also the [quickref].

- `*italics*`, `**bold**`.
- Inline literals use doubled backticks, not single. (Single indicates
  'interpreted text' when not followed by an underscore to be a link.)
- Indented blocks are quotes, not code. (You can also still use `> `
  at the start of a line.
- For code blocks ("literal quotes"), use `::`. This may start a line alone
  before the indented code or be the last two characters at the end of
  the previous paragraph, where it will be rendered as a single ":".
- Comment blocks use `..` starting a line alone before the indented
  comment.
- Bullets for lists are `*`, `-` or `+`.
- Enumerated lists use the number, `#` or similar before a period or
  right paren. E.g. `1.`, `#.`, etc.
- Definition lists are a term at the left margin with the body in
  two-space indended lines directly below.
- Titles may be underlined or over-and-underlined with any printing
  non-alpha character; the first one is an H1 and the rest H2.
- Images: `.. image:: /path/to/image.jpg`

[Doctest] blocks start with a block beginning `>>>` and end with a blank
line:

    >>> print('Hello, world.')
    Hello, world.

    The above is a simple Python statement.

#### Links

Links end with an `_`, quoting a phrase with backticks (`` ` ``) if
necessary. The URL can be in `<…>` after the anchor text or labeled
with the anchor text later.

    Three links: Wikipedia_, the `Linux kernel archive`_ and
    `this very repo <https://github.com/0cjs/sedoc>`_.

    .. _Wikipedia: https://www.wikipedia.org/
    .. _Linux kernel archive: https://www.kernel.org/

Named references are similar to the above, without the URLs. Titles
are implict named references.

    Documentation Document
    ======================

    In example_ below you can see that blah blah blah.

    .. _example:

    Here's the example section. From here you can also go back to
    the `Documentation Document`_.


References
----------

* [PEP 257] Docstring Conventions
* [PEP 286] reStructuredText Docstring Format



[PEP 257]: https://www.python.org/dev/peps/pep-0257/
[PEP 287]: https://www.python.org/dev/peps/pep-0287/
[RST docs]: http://docutils.sourceforge.net/rst.html
[doctest]: http://www.python.org/doc/current/lib/module-doctest.html
[quickref]: http://docutils.sourceforge.net/docs/user/rst/quickref.html
[reStructuredText]: https://en.wikipedia.org/wiki/ReStructuredText
