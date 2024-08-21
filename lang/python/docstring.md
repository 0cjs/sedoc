Docstrings
==========

References:
- [PEP 257] Docstring Conventions
- [PEP 287] reStructuredText Docstring Format


Overview
--------

A string literal occurring as the first statement in a module,
function/method or class definition is the _docstring_, and is stored as
the `__doc__` attribute of that object. (A package docstring is in the
`__init__.py` in the package's directory.) Most documentation generators
support inheritance: a method without a docstring will inherit the
docstring of the superclass's method, if present.

Python itself cannot attach docstrings to variables, but many tools (such
as Sphinx and [pdoc][pdoc-vars]) will examine the AST and take any string
immediately following an assignment statement as a docstring for that
variable. (This is (rejected) [PEP 224] style.) For more, see below.

The style guides, including [PEP 257] _Docstring Conventions,_ suggest
always using three double-quotes (`"""`) around docstrings. I don't see the
point of the extra ink and just use single or triple single quotes (`'`,
`'''`) as appropriate.

Docstring tools generally strip indentation based on the minimum
indentation of all non-blank lines in the docstring after the first,
preserving remaining indentation. See [PEP 257] for the exact algorithm.

#### Variable/Attribute Docstrings

The original proposal for "docstring after assignment" is [PEP 224][]
(2000-08-23, Python 2.0), with the same syntax as common systems currently
use, but having the compiler attach it to the enclosing object as an
attribute named `__doc_VARNAME__`. This was rejected by Guido because he
really didn't like the syntax. Yet most documentation generators today seem
to use this anyway, though via examination of the AST as it's not in the
compiler.

An alternative syntax, supported by [pdoc3][pdoc3-vars], is to take
documentation from `#:` comments, e.g.

    class C:
        #: Documentation comment for class_variable
        #: spanning over three lines.
        class_variable = 2  #: Assignment line is included.

        def __init__(self):
            #: Instance variable's doc-comment
            self.variable = 3
            """But note, PEP 224 docstrings take precedence."""


RST (reStructuredText) Docstrings
---------------------------------

[PEP 287] describes the convention of using [reStructuredText][wp-rst]
([RST docs], [quickref]) in docstrings. The [Restructured Text][sp-rst]
section of the Sphinx documentation is also useful, particularly since it's
the usual program that reads and renders docstrings to HTML documentation.

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
  two-space indented lines directly below.
- Titles may be underlined or over-and-underlined with any printing
  non-alpha character; the first one is an H1 and the rest H2.
- Images: `.. image:: /path/to/image.jpg`

[Doctest] blocks start with a block beginning `>>>` and end with a blank
line:

    >>> print('Hello, world.')
    Hello, world.

    The above is a simple Python statement.

#### Interpreted Text Roles

RST provides [interpreted text roles][rst-roles] of the form
`` :role:`text` `` to give special markup to the backquoted text.
Systems using RST may extend this, e.g., [Sphinx roles][sp-roles]
and [sphinx-issues]. Useful roles include the following.

[Standard RST][rst-roles]:
- `:literal:`: Same as double-backticks.
- `:code:`: Same as double-backticks; used for role customisation (see docs).
- `:strong:`: Same as double-asterisks: `**foo**`.
- `:superscript:`, `:sup:`: Superscript
- `:title-reference:`, `:title:`, `:t:`: Book title (rendered w/HTML `<cite>`).
- `:math:`: LaTeX math syntax (do not add `($ $)` math delimiters).
- `:pep-reference:`, `:pep:`: Reference Python Enhancement Proposal; give just
  the number in backticks.
- `:rfc-reference:`, `:rfc:`: Reference IETF Request for Comments; give just
  the number in backticks.

[Sphinx roles][sp-roles]:
- `:samp:`: Literal text with "variable" parts in braces, e.g., `1+{x}`.
- `:command:`: OS-level command, e.g., `rm`.
- `:file:`: Name of file/directory, with braced variable parts as `:samp:`.
  `python3.{x}`.
- `:program:`: Name of an executable program; omit `.exe` for Windows.
- `:kbd:`: Keystrokes.
- `:guilabel:`: Label from an interactive UI.
- `:manpage:`: Reference to manual page, including section number in parens.

[Sphinx-issues roles][sphinx-issues] (used with GitHub etc.):
- `:issue:`, `:pr:`: These take an issue/PR number or comma-separated list
  of them.
- `:commit:`: Takes a commit ID. (Not sure if partial IDs will work.)
- `:user:`: Takes a GitHub (or other, if configured) user name and links to
  the user profile; do not use a leading `@`. Can also take an arbitrary
  string, e.g., `Curt J. Sampson <cjs@cynic.net>`.
- `:cve:`: Takes a CVE ID (e.g. `CVE-2018-17175`) for <https://cve.mitre.org>.
- `:cve:`: Takes a CWE ID (e.g. `CWE-787`); links to <https://cwe.mitre.org>.
- `:role:`: Takes `Custom title <target>`; links to _target._

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



<!-------------------------------------------------------------------->
[PEP 224]: https://peps.python.org/pep-0224/
[PEP 257]: https://www.python.org/dev/peps/pep-0257/
[PEP 287]: https://peps.python.org/pep-0287/
[PEP 287]: https://www.python.org/dev/peps/pep-0287/
[RST docs]: http://docutils.sourceforge.net/rst.html
[doctest]: http://www.python.org/doc/current/lib/module-doctest.html
[pdoc-vars]: https://pdoc.dev/docs/pdoc.html#document-variables
[pdoc3-vars]: https://pdoc3.github.io/pdoc/doc/pdoc/#docstrings-for-variables
[quickref]: http://docutils.sourceforge.net/docs/user/rst/quickref.html
[rst-roles]: https://docutils.sourceforge.io/docs/ref/rst/roles.html
[sp-roles]: https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html
[sp-rst]: https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html
[sphinx-issues]: https://github.com/sloria/sphinx-issues#usage-inside-the-documentation
[wp-rst]: https://en.wikipedia.org/wiki/ReStructuredText
