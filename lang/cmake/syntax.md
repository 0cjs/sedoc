CMake Syntax and Semantics
==========================

Docs in this series: [Overview](README.md)
| [Syntax](syntax.md)
| [Build Configuration](config.md)
| [Variable/Property List](varproplist.md)
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
arguments whitespace and `;()#"\` (and `>`?) must be escaped with a
backslash. Arguments may be quoted with double quotes or brackets (see
below). Unquoted nested parens are passed to commands as individual
unquoted arguments.

Escape sequences, variable expansion, quoting:
- `\x`: Escape sequence.
  - _x_ is one of `;trn`: semicolon, tab, CR, NL.
  - _x_ is any other char: Remove semantic meaning and treat
    literally. (E.g., to escape a space in an argument.)
- `${varname}`: Variable expansion, replaced (before a command is called) by
  variable's value, or empty string if not set. See below.
- `"`...`"`: Quoted arg. Evaluates _escape sequences_ and _variable
  refs_. Lines may be continued with a backslash at end of line.
- `[[`...`]]`: Bracket argument (≥3.0) which expands neither escape
  sequences nor variable references. Zero or more `=` may be used
  between the brackets to allow bracket use in the arg, e.g.,
  `[==[`...`]==]`. Neither escape sequences nor variable references
  are expanded.


Variables and Properties
------------------------

CMake has dynamically scoped _variables_ or _normal variables_
recursively expanded at time of reference (i.e., before commands are
called). Additionally there are _properties_ which are attached to
specific objects (a `GLOBAL` object, a named `CACHE` object,
"directories", build targets, etc.; `GLOBAL`/`CACHE`/etc. are often
called _scopes_) and are normally set and read with special
commands.

Cache entry `VALUE` property values are sometimes referred to as
_cache variables_ because, unlike other properties, variable expansion
of a never-set or `unset()` variable can result in substitution of a
those values.

Variable and property names are alphanumeric, `/_.+-` and escape
sequences. (`$` is also permitted but discouraged.)

Expansion forms are:
- `${name}`: Standard variable/cache-property expansion; see below.
- `$CACHE{name}`: Expands to a cache entry `VALUE` property.
- `$ENV{name}`: Expands to the value of a process environment variable.

Unset variables expand to an empty string.

Recursive expansion of nested variable references is done
inside-to-out: `${outer_${inner}_variable}`. E.g. the variable name in
`varname` can be evaluated with: `${${varname}}`, or `suffix` with
`${mystuff_${suffix}}`.

When CMake policy [CMP0054] is set to `OLD`, the `if()` command does
"automatic evaluation" on unquoted/unbracketed arguments: variable
names are expanded to variable values (but not cache property values)
by the command after it's been called, even if these names are
themselves the result of variable expansion with `${name}` at the call
site.

### Variables

Variables are set and unset with [`set()`] and [`unset()`]; the latter
is a "whiteout" that terminates a scope search, potentially exposing a
cache property. The `PARENT_SCOPE` parameter changes values in a
parent scope.

Scope is dynamic; new scopes are introduced by [`function()`] and
[`add_subdirectory()`]. For the latter, though referred to as
"directory" scope, the actual hierarchy location of the source and
target directories is irrelevant; only the `add_subdirectory()` call
tree is used.

New scopes are not introduced by [`macro()`] and [`include()`].

The search order for variable expansion is as follows. Any variable
"whited out" with `unset()` terminates the function/directory scope
search and moves on to the cache search.
- Deepest to highest function scopes in the function call stack.
- Deepest to highest "directory" scopes in the `add_subdirectory()`
  call stack.
- Cache properties persisted across runs in `$build/CMakeCache.txt`.

See [Variables](variables.md) and [cmake-variables(7)] for lists
variables (400+) read/used by CMake, CTest and CPack.

### Properties

Properties are separate variable-like namespaces attached to objects
with separate scoping rules and inheritance based on the object
relationships.

The exception to this is cache properties; variable expansion will
look up cache properties for unset variable names and `set()` and
`unset()` have an option to change a cache property instead of a
variable.

Properties on various objects are used extensively by CMake to
configure the build. For a list of properties used by cmake, see
[cmake-properties(7)].

The object types are called "scopes" and are:
- `GLOBAL`: A single unique object.
- `DIRECTORY`: Seems not to be the same as `add_subdirectory()`
  "directory" variable scope.
- `TARGET`: A build target.
- `SOURCE`: A source file.
- `INSTALL`: An installed file.
- `TEST`: A CTest test.
- `CACHE`: A named cache entry; see property list below.

#### Property Inheritance

Inheritance of values can be specified for specific properties with
the `INHERITED` option to `define_property()`. This causes
`get_property()` and `get_*_property()` functions to search as follows
when a property is not set.
- `TARGET`, `SOURCE` and `TEST` properties inherit from their  in
  their corresponding `DIRECTORY` scope.
- `DIRECTORY` scopes in turn inherit from parent `DIRECTORY` scopes.

`set_property()` and similar never use inheritance; this can introduce
unexpected behaviour when using the `APPEND` or `APPEND_STRING`
option, making it appear to overwrite a inherited value.

It's generally suggested that properties be set using target-scoped
commands (where they will be propagated/exported to dependents) rather
than directory-scoped where possible. E.g., prefer
[`target_include_directories()`] to set the [target-scoped
`INCLUDE_DIRECTORIES`][INCLUDE_DIRECTORIES:tgt] property over
[`include_directories()`] to set the [directory-scoped
`INCLUDE_DIRECTORIES`][INCLUDE_DIRECTORIES:dir].

#### Cache Entry Properties

Cache entries are named objects in the `CACHE` scope and have a [fixed
set of properties][cache-prop]. Most of the properties on `CACHE`
objects should be set with specialized functions such as
[`define_property()`].

- `VALUE`: The value of the "cache variable." Setting this directly
  sets the value without any checks.
- `TYPE`: Helps configuration setting tools. One of:
  - `STRING`, `BOOL`, `PATH` to a directory, `FILEPATH` to a file.
  - `INTERNAL`: Never show property in configuration tools, and
    `FORCE` is always implied when `set()` is used to set cache
    variable.
  - `STATIC`: Managed by CMake; never change.
  - `UNINITIALIZED`: Type not yet specified.
- `STRINGS`: List enumerating valid string values to allow interactive
  configuration tools to display a selection list.
- `ADVANCED`: If true, property setting is hidden by default in
  interactive CMake build setup tools. Set with `mark_as_advanced()`.
- `HELPSTRING`: Help text to be shown by configuration tools.
- `MODIFIED`: Internal management property; do not set or get. (Tracks
  interactive user modification of properties.)

#### Using Cache Entries Instead of Variables

Sometimes one wants a subproject to be able to make values available
to the whole CMake build; `set()` can't be reliably used for this
because it can't set values beyond the parent.

From [so 34290292] it appears that it's acceptable to set an
`INTERNAL` cache property (`INTERNAL` implying `FORCE` to override any
cached values, making this more like a regular transient variable) and
rely on standard variable expansion for unset variables falling back
to that cached value.

### Value Types

Variable values are always strings. Unset variables expand to an empty
string. Some commands may parse variables as different types, including:
- Boolean:
  - False: `OFF`, `0`, empty string.
  - True: `ON`, `1`, unrecognised string.
- Lists of elements separated by `;`.
- `DATA{myfile.dat}` by the `ExternalData` module.

Lists of lists are handled with multiple variable names:

    set(ll a b)
    set(a 1 2 3)
    set(b 4)
    foreach(listname in LISTS ll)
        foreach(value IN LISTS ${listname})
            ...
        endforeach()
    endforeach()

[IXM] offers an example of how to do internal expansion of references
like `HUB{catchorg/catch2@v2.6.0}`. It's also implemented dictionaries
as properties on `INTERFACE IMPORTED` libraries (prepending
`INTERFACE_` to any keys and using `$<TARGET_PROPERTY>` to access
values). See [izzy] for more details, and ideas on how to deal with
seralization of values to files.


Generator Expressions
---------------------

[Generator expressions][cmake-generator-expressions(7)] of the form
`$<...>` can be set in certain properties and given to commands that
populate them, e.g., `INCLUDE_DIRECTORIES`, [`include_directories()`],
[`target_include_directories()`]. These are not evaluated by the
command interpreter, which considers them just strings, but instead by
certain parts of CMake code during build system generation. They allow
lookup of information, conditional evaluation, and generation of
output.

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


Command Reference
-----------------

See [cmake-commands(7)] for a complete list of scripting commands.

### Debugging

#### [`variable_watch()`]

    variable_watch(varname [command])

When variable _varname_ changes, print a message. If _command_ is specified,
that CMake command will be executed with the following arguments:

    command(varname access value current_list_file stack)

Watching for `CMAKE_CURRENT_LIST_DIR` being set to `""` indicates that
the configuration step is finished, allowing for post-configuratin
commands. See [izzy] and [IXM] for more details.

### Variable and Property Setting

#### [`set()`], [`unset()`]

`set()` binds a "normal" variable name in the current scope or in
`PARENT_SCOPE`, process environment or `CACHE` if specified.

`unset()` whites out a variable, causing it to terminate variable
scope searches at that location, possibly exposing a cache property.
To avoid exposing cache properties, use `set(varname "")`.

    set(name value ... [PARENT_SCOPE])
    set(ENV{name} value ...)
    set(name value ... CACHE type docstring [FORCE])
    unset(name [CACHE|PARENT_SCOPE])
    unset(ENV{name})

Types for cache values (described in detail above) are: `STRING`
(values selected from `STRINGS` property if set), `BOOL`, `PATH`,
`FILEPATH`, `INTERNAL` and `UNINITIALIZED`.

Multiple values are stored as a list (a string with elements separated
by `;`). Quoted arguments containing `;` are stored as-is, flattening
lists (`set(name a "b;c")` sets _name_ to `a;b;c`).

#### [`option()`]

    option(varname "help string" [initval])

Provide `ON`/`OFF` option (stored as a cached variable) to developer
Does nothing if _varname_ already set. Provide `-Dvarname=1` or
similar on command line of initial `cmake` run to override default.

#### [`set_property()`], [`get_property()`], etc.

> Reminder: when setting/getting cache property values, set _entry_ to
> the property name and use `PROPERTY VALUE`. See above for other
> properties on cache entries.

    set_property(
        < GLOBAL
        | DIRECTORY [dir ...]
        | TARGET    [target₁ ...]
        | SOURCE    [src₁ ...]
        | INSTALL   [file₁ ...]
        | TEST      [test₁ ...]
        | CACHE     [entry₁ ...]
        > [APPEND] [APPEND_STRING] PROPERTY name [value₁ ...])

There are also standard functions for setting multiple properties on a
single scope: `set_directory_properties()`,
`set_source_file_properties()` `set_target_properties()` and
`set_tests_properties()`; see [Build Configuration](config.md).

There is no inheritance behaviour when setting properties; `APPEND`
and `APPEND_STRING` will thus not consider inherited values when
working out the contents to append to.

    get_property(varname,
        < GLOBAL
        | DIRECTORY [dir]
        | TARGET    target
        | SOURCE    src
        | INSTALL   file
        | TEST      test
        | CACHE     entry
        | VARIABLE
        > PROPERTY propname [SET|DEFINED|BRIEF_DOCS|FULL_DOCS])

[`get_property()`] retrieves property or variable information (using
inheritance if defined), including whether or not it's defined,
whether it's set, and its documentation. Also see
`get_directory_property()`, `get_source_file_property()`,
`get_target_property()`, and `get_test_property()`.

See [cmake-properties(7)] for a list of all standard properties.

#### [`define_property()`], [`mark_as_advanced()`]

Define and document custom properties.

### Control Flow

All of these are executed when generating the build system prior to
the build being started. This allows you to, e.g., programatically add
new targets, but there are also gotchas such as you can't check
properties of files that will be produced by the build.

`if()`, `elseif()`, `else()`, `while()` and `foreach(IN LISTS)` all
may (for some expressions) take variable names that they evaluate
internally. This means you need to take care not to accidentally use
expansion that can break things:

    set(var1 "OFF")
    set(var2 "var1")
    if(${var2}") ...    # ⇒ false; var1 == OFF
    if(var2) ...        # ⇒ true;  var2 != OFF

In particular, be careful about checking result variables:

    find_package(Python3)
    if(NOT Python3_FOUND)   # `if(NOT ${Python3_FOUND})` WILL NOT WORK
        message(FATAL_ERROR "Python3 not found")
    endif()

#### [`return()`]

Immediately aborts command processing and returns from the current:
- Function defined by `function()`.
- File being processed by `include()` or `find_package()`.
- `CMakeLists.txt` being processed via `add_subdirectory()`.

Macros are expanded in place and so `return()` cannot be used in them.

#### [`if()`]

    if(expr) ... elseif(expr) ... else() ... endif()

Executes commands `...` based on the value of _expr_.

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

### Command Definition

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


Misc. Scripting Commands
------------------------

See [cmake-commands(7)] for a complete list of scripting commands.

- [`message()`]
- [`math()`]:
  - `math(EXPR outvar expr)`
  - Operators (C semantics): `+ - * / % | & ^ ~ << >> * / %.`
- [`string()`]: search/replace, regex, manipulation, comparision,
  hashing, generation
- [`list()`]: List operations.
- [`file()`]: Filesystem and file read/write/etc. operations.
- [`get_filename_component()`]: Get a specific component of a filename/path.
- [`get_filename_component()`]: https://cmake.org/cmake/help/latest/command/get_filename_component.html



<!-------------------------------------------------------------------->
[cache-prop]: https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#properties-on-cache-entries
[cmake-generator-expressions(7)]: https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html
[cmake-language(7)]: https://cmake.org/cmake/help/latest/manual/cmake-language.7.html
[cmake-properties(7)]: https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html
[cmake-variables(7)]: https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html

[CMP0054]: https://cmake.org/cmake/help/latest/policy/CMP0054.html

[INCLUDE_DIRECTORIES:dir]: https://cmake.org/cmake/help/latest/prop_dir/INCLUDE_DIRECTORIES.html
[INCLUDE_DIRECTORIES:tgt]: https://cmake.org/cmake/help/latest/prop_tgt/INCLUDE_DIRECTORIES.html
[`define_property()`]: https://cmake.org/cmake/help/latest/command/define_property.html
[`file()`]: https://cmake.org/cmake/help/latest/command/file.html
[`foreach()`]: https://cmake.org/cmake/help/latest/command/foreach.html
[`function()`]: https://cmake.org/cmake/help/latest/command/function.html
[`get_property()`]: https://cmake.org/cmake/help/latest/command/get_property.html
[`if()`]: https://cmake.org/cmake/help/latest/command/if.html
[`include()`]: https://cmake.org/cmake/help/latest/command/include.html
[`include_directories()`]: https://cmake.org/cmake/help/latest/command/include_directories.html
[`list()`]: https://cmake.org/cmake/help/latest/command/list.html
[`macro()`]: https://cmake.org/cmake/help/latest/command/macro.html
[`mark_as_advanced()`]: https://cmake.org/cmake/help/latest/command/mark_as_advanced.html
[`math()`]: https://cmake.org/cmake/help/latest/command/math.html
[`message()`]: https://cmake.org/cmake/help/latest/command/message.html
[`option()`]: https://cmake.org/cmake/help/latest/command/option.html
[`return()`]: https://cmake.org/cmake/help/latest/command/return.html
[`set()`]: https://cmake.org/cmake/help/latest/command/set.html
[`set_property()`]: https://cmake.org/cmake/help/latest/command/set_property.html
[`string()`]: https://cmake.org/cmake/help/latest/command/string.html
[`target_include_directories()`]: https://cmake.org/cmake/help/latest/command/target_include_directories.html
[`unset()`]: https://cmake.org/cmake/help/latest/command/unset.html
[`variable_watch()`]: https://cmake.org/cmake/help/latest/command/variable_watch.html
[`while()`]: https://cmake.org/cmake/help/latest/command/while.html

[IXM]: https://ixm.one/
[izzy]: https://izzys.casa/2019/02/everything-you-never-wanted-to-know-about-cmake/
[so 34290292]: https://stackoverflow.com/questions/34290292/
