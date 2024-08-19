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

### Shell

The `SHELL` variable specifies the shell for the recipe lines, defaulting
to `/bin/sh`. On Unix it's never read from the environment (that's the
user's choice, not the makefile's), but the user's `SHELL` is exported to
the shell that make starts.

`.SHELLFLAGS` defaults to `-c` or `-ec` in POSIX mode.


Variables
---------

Ref [6. How to Use Variables][§6].

The four _flavors_ of variable assignment are :
- [Recursively expanded][§6.2.1] `N = v` or `define`.
  Expanded at substitution time.
- [Simply expanded][§6.2.2] (POSIX/GNU) `N ::= v`, (GNU) `N := v`
  Expanded at definition time.
  (Note: BSD `:=` is different from GNU `:=`.)
- [Immediately expanded][§6.2.3] (GNU) `N :::= v`
  Expanded at definition _and_ substitution time.
- [Conditional][§6.2.4]: `FOO ?= bar`.
  Assigned only if undefined (not if defined but empty!).

Additional assignment forms:
- `!=` (GNU) Runs RHS as a shell command and does immediate assignment.
- `+=` [§6.6] Adds additional text to a var. Prepends a space to the text
  if var has a value already. Check docs for details of behaviour with
  different assignment/expansion flavors.

Leading whitespace is stripped during substitution; this can be protected
as follows. Note that if you do _not_ want trailing whitespace, avoid EOL
comments!

    nullstring := 
    space := ${nullstring} # EOL at `#`; `space` is exactly one space
    dir := /foo/bar  # ${dir} is `/foo/bar  ` here!

#### Referencing Variables

- Escape stand-alone dollar sign with itself: `$$`.
- Reference vars with `$(foo)` or `${foo}`. Works in any context.
  (Single char vars can be referenced as `$A` but this is deprecated
  except for automatic vars like `$<` etc.)
- Substitution reference: `$(foo:.o=.c)` expands `${foo}` replacing
  `.o` with `.c` at the end of all words in the value, e.g., `ab.o
  cd.o` → `ab.c cd.c`. `%` in replacment substitutes what a `%`
  wildcard in source matched. Abbreviation for `$(patsubst .o,.c,${foo})`
  function.

#### Environment Variables

- All variables in the environment are read and makefile variables of the
  same names are set to the same values. Explicitly set makefile variables
  override environment variables of the same name unless `make -e` is used.
- `export VARNAME …` / `export VARNAME = …` (also `:=` and `+=`) will
  export makefile vars into the recipe environments. `unexport` will will
  prevent a makefile variable from being exported.
- `export` alone will export to the recipe environments all makefile
  variables that are not explicitly `unexport`ed. `unexport` undoes this
  (restoring the default behaviour).
- Older versions of Gnu make without `export` did the same functionality by
  default. For backward compatibility with this behaviour, define special
  target `.EXPORT_ALL_VARIABLES`, which is ignored by old versions where
  `export` would produce an error.
- Exporting a variable requires expansion; if the expansion has side
  effects you will see them every time a command is invoked.
- Related special variables:
  - `SHELL` is not exported; the calling environment's value is passed on.
    This can be overridden with `export`.
  - `MAKEFLAGS` is always exported; can be overridden with `unexport`.
  - `MAKEFILES` is exported if you set it to anything.
  - `MAKELEVEL`, see below.

#### Pre-defined and Special Variables

- [6.14 Other Special Variables][§6.14] (Many, not all.)
- `MAKELEVEL`: 0 at top level; incremented with every sub-make. [§5.7.2]
- A few other places.
- Also see ["Automatic Variables"](#automatic-variables) below for
  variables automatically defined in recipies (`$<` etc.).


Functions
---------

Ref [8. Functions for Transforming Text][§8].

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

String functions (complete list):
- `$(subst from,to,text)`: substitution of constant values only.
- `$(patsubst pattern,replacement,text)`, `$(var:pattern=replacement)`: For
  each whitespace-separated word word in _text,_ replace any characters
  matching _pattern_ with _replacement._ The second form returns a modified
  version of the text in a the given variable. The only pattern is `%`,
  matching anything; `%` in _replacement_ substitutes the matched text.
- `$(strip string)`: Remove all leading/trailing whitespace from _string_
  and also collapse any internal whitespace sequences to a single space.
  One use is to prevent problems as `if neq "$(strip $(needs_made))" ""`.
- `$(findstring find,in)`
- `$(filter pattern…,text)`: Return all words in _text_ that match any of the _pattern_ words.
- `$(filter-out pattern…,text)`: Return all words in _text_ that do not match any of the _pattern_ words.
- `$(sort list)`
- `$(word n,txt)`: Return the _n_ th word of _text;_ 1-based index.
- `$(wordlist s,e,text)`
- `$(words text)`: Return the number of words in _text._
- `$(firstword names…)`
- `$(lastword names…)`

Filename functions (complete list); these map on each item in _names…_:
- `$(dir names…)`: "Directory part," which is everything through (and
  including) the last slash in the string. If no slash present, `./`.
- `$(notdir names…)`: "Filename part"; removes all through last slash.
  (String ending in `/` becomes empty string.)
- `$(suffix names…)`
- `$(basename names…)`
- `$(addsuffix suffix,names…)`
- `$(addprefix prefix,names…)`
- `$(join list1,list2)`: concatenates two lists word by word pairwise.
- `$(wildcard pattern)`: space-separated list of names of existing files
  matching shell glob _pattern._
- `$(realpath names…)`: cannonical path for each _name_ (no `.`/`..` or
  repeated `/` and symlinks resolved). Each _name_ must exist.
- `$(abspath names…)`: cannonical path for each _name_ (no `.`/`..` or
  repeated `/`). Symlinks not resolved; each _name_ need not exist.

Conditional functions (complete list):
- `$(if cond,then-part[,else-part])`
- `$(or cond1[,cond2…])`
- `$(and cond1[,cond2…])`
- `$(intcmp lhs,rhs[,lt-part[,eq-part[,gt-part])`: integer conmparison.

Other functions:
- `$(let ...)`
- `$(foreach ...)`
- `$(file ...)`: read/write a file.
- `$(call ...)`: creates new parameterized functions.
- `$(value var)`
- `$(eval ...)`
- `$(origin var)`: indicate how variable named _var_ was defined.
- `$(flavor var)`: indicate flavor of variable named _var_ (`undefined`,
  `recursive`, `simple`).
- `$(error text…)`
- `$(warning text…)`
- `$(info text…)`
- `$(guile text)`: Pass _text_ to GNU Guile langauge, if compiled in.
  (`.FEATURES` contains "guile" if available.)

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

### Automatic Variables

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
[imp-builtin]: https://www.gnu.org/software/make/manual/make.html#Catalogue-of-Rules
[imp-cancel]: https://www.gnu.org/software/make/manual/make.html#Canceling-Rules
[imp-chain]: https://www.gnu.org/software/make/manual/make.html#Chained-Rules
[implicit]: http://www.gnu.org/software/make/manual/make.html#Implicit-Rules
[pattern rule]: https://www.gnu.org/software/make/manual/make.html#Pattern-Rules
[spectarg]: https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
[§5.7.2]: https://www.gnu.org/software/make/manual/html_node/Variables_002fRecursion.html
[§6.14]: https://www.gnu.org/software/make/manual/html_node/Special-Variables.html
[§6.2.1]: https://www.gnu.org/software/make/manual/html_node/Recursive-Assignment.html
[§6.2.2]: https://www.gnu.org/software/make/manual/html_node/Simple-Assignment.html
[§6.2.3]: https://www.gnu.org/software/make/manual/html_node/Immediate-Assignment.html
[§6.2.4]: https://www.gnu.org/software/make/manual/html_node/Conditional-Assignment.html
[§6.6]: https://www.gnu.org/software/make/manual/html_node/Appending.html
[§6]: https://www.gnu.org/software/make/manual/html_node/Using-Variables.html
[§8]: https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_8.html
