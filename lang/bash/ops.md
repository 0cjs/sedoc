Bash Operators
==============

Upper-case bold manual page section names below can be found by
searching for them at the start of the line (`^FOO`) in the manual
page.


Conditional Expressions
-----------------------

__CONDITIONAL EXPRESSIONS__ are used by `[[`...`]]`, `[`...`]` and
`test`. Normally `[[` should be used it's safer and less quoting need
be done. However, `<` and `>` sort with the current local with `[[`,
but in ASCII order with `test`.

__CONDITIONAL EXPRESSIONS__ describes most of this, but also see
__Compound Commands__ for `=~` and some others.

#### File References

When used in conditional expressions, the following file paths are
standardized across all operating systems:
* `/dev/stdin`, `/dev/stdout`, `/dev/stderr`: File descriptors 0, 1 and 2.
* `/dev/fd/N`: File descriptor _N_.

#### Expressions

XXX fill this in
