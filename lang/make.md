Make and GNU Make
=================

Just brief notes here.

Variables
---------

From manual chapter 6, [How to Use Variables][vars].

Assignment:
- Standard vars assigned with `=` are literal at assignment time and
  recursively expanded at expansion time: `A=1`, `B=${A}` will expand `B`
  to `${A}` and then expand that to the current value of `${A}`.
- (GNU) Simply expanded vars assigned with `:=` are expanded at assignment
  time and literal at substitution time.

Reference:
- Escape stand-alone dollar sign with itself: `$$`.
- Reference vars with `$(foo)` or `${foo}`. Works in any context.
  (Single char vars can be referenced as `$A` but this is deprecated
  except for automatic vars like `$<` etc.)
- Substitution reference: `$(foo:.o=.c)` expands `${foo}` replacing
  `.o` with `.c` at the end of all words in the value, e.g., `ab.o
  cd.o` → `ab.c cd.c`. `%` in replacment substitutes what a `%`
  wildcard in source matched. Abbreviation for `$(patsubst .o,.c,${foo})`
  function.

### Functions

From manual chapter 8, [Functions for Transforming Text][funcs].

- Call  with syntax similar to variables: `$(function arguments)` or
  `${function arguments}`, with args separated by one or more spaces
  or tabs. Closing delimiter (`)`/`}`) must match opening. Prefer same
  delimiter for all in nested calls to avoid confusion.
- Function names are predefined. Use `call` to simulate user-defined
  functions.
- If more than one arg, separate with `,`.
- Commas and unmatched delimiters cannot appear literally in
  arguments; leading spaces cannot appear before first argument. Use
  var substitution to get around this, e.g., `comma := ,`; `empty :=`,
  `space := $(empty) $(empty)`.


<!-------------------------------------------------------------------->
[vars]: https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_6.html
[funcs]: https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_8.html

