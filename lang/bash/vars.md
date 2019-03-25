Bash Word and Variable Expansion
================================

Upper-case bold manual page section names below can be found by
searching for them at the start of the line (`^FOO`) in the manual
page.


Word Expansion
--------------

__EXPANSION__ is done in the following order. I

1. Brace expansion: `a{1,2}b` → `a1b a2b`
2. From left to right:
  - Tilde expansion: `~` → `$HOME`
  - Parameter and variable expansion: see below
  - Arithmetic expansion:
  - Command substitution:
  - Process substitution:
3. Word splitting
4. Pathname Expansion

The only cases in which a single word can expand to multiple
words are brace expansion, word splitting, pathname expansion,
`${@}`, and `${name[@]}`.

#### Brace Expansion

- Comma-separated strings which may be nested:
  `_{abc,123,x{y,Y}z,}_` → `_abc_ _123_ _xyz_ _xYz_ __`
- `{n..m}`: _n_ to _m_ (incrementing upward or downward) for single
  characters or integers ordered via the default C locale:
  `{c..f}` → `c d e f`.
- Prefix integers with `0` to give them all the same width:
  `{08..10}` → `08 09 10`.
- `{n..m..incr}`: As above for only every _incr_ value (_incr_ takes
  sign from direction implied by _n_ and _m_:
  `{150..-051..50}` → `0150 0100 0050 0000 -050`.

Brace expansions must contain unquoted opening and closing braces and
at least one comma or valid sequence expansion; invalid brace
expansions are left unchanged. Quote braces with backslash. `${` is
also never considered an opening brace.

Use the `+B` option to `bash` or `set` to disable brace expansion for
`sh` compatibility.

#### Tilde Expansion

A valid login name prefixed with `~` expands to the home directory for
that user. If the login name expands to an empty string, `$HOME` or
the home dir for the current user is substituted.

Other expansions:
* `~+`: `$PWD` (the current working directory)
* `~-`: `$OLDPWD` if set (the previous working directory).
* `~n`: where _n_ is an integer, that entry from the `pushd`/`dirs` stack

Tilde expansion is done after a `:` or the first `=` to allow
expansion in assignments to other vars such as `PATH`.

#### Parameter Expansion

See separate section below.

#### Arithmetic expansion:

`$((expr))` evaluates _expr_ and substitutes the result. (`$[expr]` is
an obsolete form of this that will be removed.) _expr_ is treated as
if it were in double quotes, with parameter and variable expansion,
command substitution and quote removal, but double quotes in _expr_
are not special. See __ARITHMETIC EVALUATION__ for evaluation details.

Invalid expressions print an error message the command is not evaluated.

#### Command substitution:

`$(command)` or `` `command` ``. _command_ is run in a subshell and
its stdout is substituted with trailing newlines deleted. Nesting
allowed. The second form has irregular backslash processing; see the
manpage for details.

`stdout` must close before `$(command)` can finish evaluating so if
_command_ starts background processes these must not be connected to
`stdout`. ([so 1080695].) Typically fix with `>/dev/null` or `1>&2`.

Word splitting and pathname expansion are performed on the results
unless the expansion is double-quoted, e.g., `echo "${echo \*}"`
prints `*` but `echo ${echo \*}` expands to the filenames in the
current dir.

`$(cat filename)` may be replaced with the faster `$(< filename)`.

#### Process substitution:

XXX

#### Word splitting

XXX

#### Pathname Expansion

XXX. Includes glob pattern matching.


Parameter Expansion
-------------------

Canonically `${expr}` to expand _expr_ (nesting not allowed); for
simple variable names (single digits in the case of numeric names)
`$name` can be used.

Below, _word_ is subject to tilde, parameter, command and arithemtic
expansion. Prefix the operator with a colon (e.g., `${FOO:-avalue}`)
to consider set but null (empty string) to be unset.

- `${param-word}`: Use _word_ if _param_ unset.
- `${param=word}`: Assign _word_ to _param_ if _param_ unset.
- `${param?word}`: Display _param_ and _word_ as error if _param_ unset.
  (Error message for empty _word_ is "parameter null or not set".)
- `${param+word}`: Alternate value: _word_ if _param_ set, otherwise null.
- `${param:offset}`,`${param:offset:len}`: Substring expansion.
  - Chars starting at _offset_ from start (positive) or end
    (negative). (Use leading space `${x: -3}` for negative _offset_.)
    Negative _len_ specifies distance from end of string.
    _offset_ and _len_ are evaluated as arithemtic expansions.
  - For _param_ `@` or `${array[@]}`, _len_ array items from _offset_.
  - Associative arrays produce undefined results.
- `${!expr}`: Indirect expansion; expand _expr_ and then expand
  variable with that name. (XXX different for namerefs.)
- `${!prefix*}`: Variable names matching _prefix_.
  Use `@` and double quotes `"${!prefix@}"` to expand as list of words.
- `${!name[@]}`, `${!name[*]}`: List of array keys.
  - When _name_ not array, `0` if name is set, otherwise null.
- `${#param}`: Length of string, or number of elements in array
  for `${#@}`, `${#param[@]}`.
- `${param#word}`, `${param##word}`, `${param%word}`, `${param%%word}`:
  Remove shortest/longest matching prefix/suffix glob pattern.
  Applied to each element in array for `${param[@]#word}` expansions.
- `${param/pattern/string}`: Substitute _string_ for glob _pattern_.
  - Applied to each element in array for `${@/...}` and
    `${param[@]/...}` expansions.
  - Prefix _pattern_ with `/` to replace all occurrences, `#`, `%` to
    anchor match at beginning/end.
- `${param^pattern}`, `${param^^pattern}`,
  `${param,pattern}`, `${param,,pattern}`:
  First char (`^`) or all chars (`^^`) matching _pattern_ (default `?`)
  have case converted from lower to upper or upper to lower (`,`, `,,`).
- `${param@op}`: Parameter transformation. _op_ is:
  - `Q`: Quoted string that can be reused as input.
  - `E`: Expand backslash escapes like `$'...'`.
  - `P`: Expand as per __PROMPTING__.
  - `A`: Generate `declare`/assignment that will re-create _param_.
  - `a`: Flag values for parameters attributes.


Variables Set by Bash
---------------------

Variables set automatically by Bash, particularly when a script or
function is called. See __PARAMETERS__ for full details.

Positional parameters:
* `$0`: Name of script
  - If file of commands, path used to invoke file
  - If `bash -c`, first arg after string to be executed
  - Othewrise filename used to invoke bash (e.g., `/bin/bash`
    or `-bash` for a login shell)
* `$1`, `$2`, ..., `$10`, `$11`, ....: Positional parameters
* `$#`: Number of positional parameters (in decimal)
* `$*`, `$@`: All positional params, with various quoting (see manpage)

Other:
* `$$`: PID of shell (parent when used in subprocess `(`...`)`
* `$!`: PID of job most recently placed into background (inc. `bg`)
* `$?`: Exit status of most recently executed foreground pipeline
* `$-`: Current set of option flags (via `set`, `-i` or shell itself)
* `$_`: Kinda most recent command executed, but very confusing



<!-------------------------------------------------------------------->
[so 1080695]: https://superuser.com/q/1080695/26274
