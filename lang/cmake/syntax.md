CMake Syntax and Semantics
==========================

Docs in this series: [Overview](README.md)
| [Syntax](syntax.md)
| [Variables](variables.md)
| [Build Configuration](config.md)
| [Variables](variables.md)
| [Tips](tips.md)

Syntax
------

The detailed reference is [cmake-language(7)].

Files are a sequence of _commands_ and comments:
- Commands have the from `command_name(arg ...)` with zero or more
  arguments in the parentheses. They may be broken across multiple
  lines after the opening paren, but there may not be multiple
  commands on a line.
- Line comments start with `#` and go to end of line. `#` immediately
  followed by a _bracket argument_ (see below) allows multiline
  comments.

Commands, which are not expressions, are divided into two types:
- _Scripting commands_ change the state of the command processor, e.g.
  setting variables or changing the behaviour of other commands
-  _Project commands_ create and modify build targets.

Arguments to commands are separated by whitespace or `;`. In unquoted
arguments whitespace and `;()#"\` must be escaped with a backslash.
Arguments may be quoted with double quotes or brackets (see below).
Unquoted nested parens are passed to commands as individual unquoted
arguments.

Escape sequences, variable expansion, quoting:
- `\x`: Escape sequence.
  - _x_ is one of `;trn`: semicolon, tab, CR, NL.
  - _x_ is any other char: Remove semantic meaning and treat
    literally. (E.g., to escape a space in an argument.)
- `${varname}`: Variable ref. Replaced (before a command is called) by
  variable's value, or empty string if not set. Nested refs are
  evaluated from inside out, e.g. the variable name in `varname` can
  be evaluated with: `${${varname}}`, or `suffix` with
  `${mystuff_${suffix}}`.
- `"`...`"`: Quoted arg. Evaluates _escape sequences_ and _variable
  refs_. Lines may be continued with a backslash at end of line.
- `[[`...`]]`: Bracket argument (≥3.0) which expands neither escape
  sequences nor variable references. Zero or more `=` may be used
  between the brackets to allow bracket use in the arg, e.g.,
  `[==[`...`]==]`. Neither escape sequences nor variable references
  are expanded.

Variable names are alphanumeric, `/_.+-` and escape sequences. (`$` is
also permitted but discouraged.)

#### [`if()`]

    if(expr) ... elseif(expr) ... else() ... endif()

Executes commands `...` based on the value of _expr_. In some
expressions variables names can be passed as arguments which are
evaluated by the command itself. Thus with `set(var1 OFF)`, `set(var2
"var1")`: `if(${var2})` ⇒ false but `if(var2)` ⇒ true.

#### [`foreach()`], [`while()`]

Loops. `break()` and `continue()` available.

    foreach(varname arg1 arg2 ...)
    foreach(varname RANGE total)
    foreach(varname RANGE start stop [step])
    foreach(varname IN [LISTS [list1 [...]]]
                       [ITEMS [item1 [...]]])
    endforeach()

Records commands up to `endforeach()` and iterates their execution.
Empty `LIST` values are a zero-length item.

    while(expr)     # _expr_ same as if()
    endwhile()

#### [`function()`], [`macro()`]

    function(name param0 param1 ...)
      ...
    endfunction()

    macro(name param0 param1)
    endmacro()

    name(one two)

Define a new commands. (There are no return values; commands are not
expressions.)  Calling with fewer arguments than there are formal
parameters is an error, but extra arguments may be supplied.

Parameters to which the arguments are bound are:
- `ARGV0`, _param0_: First argument.
- `ARGV1`, _param1_: Second argument.
- `ARGV2`, `ARGV3`, ...: Subsequent arguments.
- `ARGC`: Argument count.
- `ARGV`: All arguments as `;`-separated list.
- `ARGN`: All arguments not bound to formal parameters; `;`-separated list.

There is also a [`cmake_parse_arguemnts()`] command to do more
advanced argument parsing. (Use the [`CMakeParseArguments`] module for
versions ≤3.5.)

Scoping:
- `function()` creates a new scope at call time; and variables are
  scoped to the function unless `set(... PARENT_SCOPE)` is used.
- `macro()` uses the scope of the caller. Arguments are not set as
  variables; references are substituted before executing the macro.

Note that macro substitution can cause problems with non-deferenced
variables with names overlapping in the caller, e.g.:

      macro(print_list my_list)
          foreach(var IN LISTS my_list)
              message("${var}")
          endforeach()
      endmacro()

      set(my_list a b c d)
      set(my_list_of_numbers 1 2 3 4)
      print_list(my_list_of_numbers)    # Prints a, b, c, d


Variables
---------

Variable scoping is dynamic. The search order is:
- Function scope created with `function()`.
- Directory scope created by `CMakeLists.txt` file.
- Cache scope persisted across runs in `$build/CMakeCache.txt`.
- Environment variables are in a separate scope accessed via
  `$ENV{name}` and do not use the search rules above.

Variable names are alphanumeric, `/_.+-` and escape sequences. (`$` is
also permitted but discouraged.)

Variable values are always strings. Unset variables expand to an empty
string. Some commands may parse variables as different types, including:
- Boolean:
  - False: `OFF`, `0`, empty string.
  - True: `ON`, `1`, unrecognised string.
- Lists of elements separated by `;`.

Lists of lists are handled with multiple variable names:

    set(ll a b)
    set(a 1 2 3)
    set(b 4)
    foreach(listname in LISTS ll)
        foreach(value IN LISTS ${listname})
            ...
        endforeach()
    endforeach()

See [Variables](variables.md) and [cmake-variables(7)] for lists
variables (400+) read/used by CMake, CTest and CPack.

#### [`set()`], [`unset()`]

Binds a variable name in the current scope or in `PARENT_SCOPE`,
process environment or `CACHE` if specified.

    set(name value ... [PARENT_SCOPE])
    set(ENV{name} value ...)
    set(name value ... CACHE type docstring [FORCE])
    unset(name [CACHE|PARENT_SCOPE])
    unset(ENV{name})

Types for cache values (used by GUI interface) are `BOOL`, `FILEPATH`
(file), `PATH` (directory), `STRING` (values selected from `STRINGS`
property if set) and `INTERNAL`.

Multiple values are stored as a list (a string with elements separated
by `;`). Quoted arguments containing `;` are stored as-is, flattening
lists (`set(name a "b;c")` sets _name_ to `a;b;c`).

#### [`option()`]

    option(varname "help string" [initval])

Provide `ON`/`OFF` option (stored as a cached variable) to developer
Does nothing if _varname_ already set. Provide `-Dvarname=1` or
similar on command line of initial `cmake` run to override default.


Properties
----------

- XXX properties???
- [cmake-properties(7)]
- [`set_property()`]
- Set `INCLUDE_DIRECTORIES` with [`include_directories()`], but prefer
  `target_include_directories()`.
- `set_source_file_properties()`


Misc. Scripting Commands
------------------------

- `message()`
- `math()`:
  - `math(EXPR outvar expr)`
  - Operators (C semantics): `+ - * / % | & ^ ~ << >> * / %.`
- `string()`: search/replace, regex, manipulation, comparision,
  hashing, generation


Generator Expressions
---------------------

[Generator expressions][cmake-generator-expressions(7)] of the form
`$<...>` can be set in certain properties and given to commands that
populate them, e.g., `INCLUDE_DIRECTORIES`, [`include_directories()`],
`target_include_directories()`. These are not evaluated by the command
interpreter, which considers them just strings, but instead by certain
parts of CMake code during build system generation. They allow lookup
of information, conditional evaluation, and generation of output.

Logical expressions evaluate to `0` or `1` and most take `0` or `1` as
input.
- `$<BOOL:...>`: Evaluate `...` to `0` or `1`.
- `$<NOT:?>`: `0`→`1`, `1`→`0`.
- `$<IF:?,...,...>`.
- `$<STREQUAL:a,b>`, `$<EQUAL:a,b>`: String and numeric comparison.
- `$<IN_LIST:x,xs>`.
- `$<TARGET_EXISTS:target>`.
- etc.

Informational expressions expand to a value:
- `$<CONFIG>`: Configuration name.
- `$<TARGET_FILE_NAME:target>`, `$<TARGET_FILE_DIR:target>`.
- `$<TARGET_PROPERTY:targetname,propname>`: Value of property on given target.
- `$<TARGET_PROPERTY:propname>`: Value of property on target for which
  generator expression is being evaluated.
- etc.

Output expressions generate a string. E.g., for a list of include dirs
preceeded by `-I`, if `INCLUDE_DIRECTORIES` is not empty:

    set(idirs "$<TARGET_PROPERTY:INCLUDE_DIRECTORIES>")
    $<$<BOOL:${prop}>:-I$<JOIN:${prop}, -I>>



<!-------------------------------------------------------------------->
[cmake-variables(7)]: https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html
