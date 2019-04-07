Haddock: Documentation Generated from Source
============================================

[Haddock][] ([docs]) generates documentation from Haskell source code,
producing HTML, LaTeX or Hoogle index output. It's used to generate
most of the documentation on [Hackage].

Stack can build docs with `stack build --haddock` or `stack haddock`.

### Selection

Documentation is generated for everything export by a module, even if
imported from another module and re-exported. The export order
determines the order in the documentation, regardless of order in
source files.

### Markup

- Rendered documentation starts only after `|` or `^` in comment.
- Blank lines separate paragraphs.
- The following special chars must be prefixed by a backslash `\` to
  be literal: `` \/`'"<@$ ``. Also `>` and `>>>` at beginning of line
  and `*-` at beginning of paragraph.
- SGML-style character refs: `&#` followed by a decimal number and
  `&#h` followed by a hexadecimal number, both closed with a
  semicolon. E.g., lower-case lambda is any of `&#x3BB;`, `&#x3bb;`
  `&#955;`.
- Code blocks: stand-alone `@` on either side of text or a paragraph
  (internal markup interpreted, e.g., `@x / y / z@` gives "x _y_ z")
  or prefix each line with `>` (completely literal).
- REPL: Prefix line with `>>>` and put results on subsequent
  non-indented lines below. Use `<BLANKLINE>` for empty result lines.
- Properties: prefix line with `prop>`: `-- prop> a + b = b + a`.
- Linked identifiers:
  - Surround local or qualified identifiers with single quotes:
    `'foo'' will be type 'T' or 'M.T'`. Quotes not surrounding valid
    identifiers are interpreted literally. (For compatibility, `` `T'
    `` is also accepted.
  - Surround module names with double quotes, `module "Foo"`.
- Emphasis `/.../`, bold `__...__`, and monospace `@...@` all allow
  other markup inside them (including linked identifiers); escape a
  closing char with backslash.
- Lists: a new paragraph with lines prefixed by `*`, `(1)`, `2.`, etc.
  List items not of the same time must be started with a new
  paragraph. Wrap lines under the bullet; use 4 spaces for new
  indentation level.
- Definition lists: `[@foo@]: Description of @foo@.`
- Links/embedded (URLs may be relative):
  - URLs: `<http://...>`
  - Inline links: `[link text](http://...)`
  - Images: `![description](http://...)`
- Math/LaTeX: `\[ frac{1}{2\pi i} \]`. (Displayed via [MathJax] in HTML.)

XXX document grid tables, anchors, headings, metadata:
<https://haskell-haddock.readthedocs.io/en/latest/markup.html#grid-tables>.

### Declarations

Start a comment before a declaration with `|` or after a declaration
with `^` to annotate that declaration;

    -- | Double an Integer.
    -- This can be slow, but will not overflow.
    double :: Integer   -- ^The number to be doubled
           -> Integer   -- ^The result
    double i = 2*i

    data Item a
      Empty         -- ^Item containing nothing.
      Item
        { type :: String        -- ^Used by next processor
        , contents :: String    -- ^Data to process
        }

Module documentation has specific fields:

    {-|
    Module      : W
    Description : Short description
    Copyright   : (c) Some Guy, 2013
                      Someone Else, 2014
    License     : GPL-3
    Maintainer  : sample@email.com
    Stability   : experimental
    Portability : POSIX

    Here is a longer description of this module, containing some
    commentary with @some markup@.
    -}

### Documentation Structure

XXX continue documenting this from
<https://haskell-haddock.readthedocs.io/en/latest/markup.html#controlling-the-documentation-structure>



<!-------------------------------------------------------------------->
[Hackage]: https://hackage.haskell.org/
[Haddock]: https://www.haskell.org/haddock/
[MathJax]: https://www.mathjax.org/
[docs]: https://haskell-haddock.readthedocs.io/en/latest/
