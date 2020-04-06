Make and GNU Make
=================

Resources:
- [POSIX make][posix] manpage
- [BSD make][bsd] manpage
- [_GNU Make_][gnu] manual
- [A Tutorial on Portable Makefiles][nullprog]


Misc
----

### Wildcards

(§4, "Using Wildcard Characters in File Names.") Where a filename or
space-separated list of filenames is expected, Bourne shell glob
patterns `*`, `?`, `[…]` and `~` for home directories may be used;
these are escaped with `\`.

Expansion happens automatically by make in targets and prerequisites
and is done by the shell in commands. Variables store the wildcard
which expands when it's used in an expansion location. Elsewhere use
the `wildcard` function (later in §4).


Variables
---------

From manual chapter 6, [How to Use Variables][vars].

Assignment:
- Standard vars assigned with `=` are literal at assignment time and
  recursively expanded at expansion time: `A=1`, `B=${A}` will expand
  `B` to `${A}` and then expand that to the current value of `${A}`.
- (GNU) Simply expanded vars assigned with `:=` are expanded at
  assignment time and literal at substitution time.
- (GNU) `!=` Runs RHS as a shell command and does immediate asignment.

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

Commonly-used functions:
- `$(shell …)`: Execute a shell command, taking stdout as value and
  setting `.SHELLSTATUS` var to exit code. Inefficient with `=`
  because of delayed evaluation, but `!=` does immediate evaluation.


Rules
-----

From manual chapter 10, [Using Implicit Rules][implicit].

The [Catalogue of Built-In Rules][imp-builtin] includes:
* `a.o` ← `a.c`: `$(CC) $(CPPFLAGS) $(CFLAGS) -c`
* `a.o` ← `a.{cc,cpp,C}`: `$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c`.
  (`.cc` suffix is preferrred.)
* `a` ← `a.o ...`: `$(CC) $(LDFLAGS) a.o ... $(LOADLIBES) $(LDLIBS)`

Implicit rules may be [cancelled][imp-cancel] by redefining them with
an empty recipe.


### Defining Pattern Rules

Implicit rules are defined by writing a _[pattern rule]_. These rules
have a `%` in the target that matches one or more characters, called
the _stem_, and `%` when used in the prerequisites will match the same
stem. If multiple pattern rules match, the one with the shortest stem
is used.

Unlike regular rules, the recipe will be run only once even if there
are multiple targets and all targets will be marked as updated once
the recipe has run.

When targets are built via a [chain of implicit rules][imp-chain]
(e.g., `%.bin: %.o` and `%.o: %.c`) the "intermediate" files will be
deleted automatically by make. Adding an empty `.SECONDARY` target
will preserve all of these. (Preserving specific ones seems tricky.)

#### Automatic Variables

Within the recipe, the following _automatic variables_ may be used.
When the variable expands to multiple filenames, they are
space-separated.

    $@  Filename of the target that caused the rule to be run.
        If the target is an archive member, this is the name of the archive file.
    $%  The target member name, when the target is an archive file.
    $<  The name of the first prerequisite.
    $?  The names of all prerequisites newer than the target.
    $^  The names of all prerequesites.
    $+  As $^, but prerequisites listed more than once are duplicated
        in the order they were listed in the makefile.
    $|  The names of all order-only prerequesites.
    $*  The stem with which the implicit rule matched. E.g., if
        a.%.b matched foo/a.bar.b, the stem is foo/bar. Use to
        construct related filenames.

There are further variables in the docs for various parts of the
filenames and paths.


Special Targets
---------------

Make has various [special built-in target][spectarg]; making an actual
target the dependency of one of these changes the build behaviour.
Commonly used ones include the following.

__[`.PHONY`]__. All dependencies of this are targets unconditionally
rebuilt when found in the build graph, regardless of existence or
state of the file named for that target. Used for the default target
(usu. `all`), subdirectories, etc.

__[`.SECONDARY`][imp-chain]__.



<!-------------------------------------------------------------------->
[bsd]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html
[gnu]: https://www.gnu.org/software/make/manual/make.html
[nullprog]: https://nullprogram.com/blog/2017/08/20/
[posix]: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html

[`.PHONY`]: https://www.gnu.org/software/make/manual/html_node/Phony-Targets.html
[funcs]: https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_8.html
[imp-builtin]: https://www.gnu.org/software/make/manual/make.html#Catalogue-of-Rules
[imp-cancel]: https://www.gnu.org/software/make/manual/make.html#Canceling-Rules
[imp-chain]: https://www.gnu.org/software/make/manual/make.html#Chained-Rules
[implicit]: http://www.gnu.org/software/make/manual/make.html#Implicit-Rules
[pattern rule]: https://www.gnu.org/software/make/manual/make.html#Pattern-Rules
[spectarg]: https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
[vars]: https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_6.html
