CMake
=====

See also [CMake Build Configurations](cmake-config.md).

[CMake] is a multi-platform build tool that reads a `CMakeLists.txt`
file, reads/generates a build configuration, and generates
platform-native buildsystem files (e.g., for GNU Make, [Ninja] or
MSBuild) and workspaces to build the project. `CMakeLists.txt` is
stored at the root of the source directory, but the build is usually
done in a separate, empty build directory (referred to as `$build/`
below).

CMake reads C, C++ and Fortran files and automatically computes
dependency information for them. However, when using IDE build systems
it offloads this task to the IDE.

Execute CMake with `cd $build && cmake dir`, where _dir_ is a relative
or absolute path to the directory containing `CMakeLists.txt` or the
path to an existing build directory created by CMake. This will
generate the makefiles; you then need to run `cmake --build .` or your
native build tool (e.g., `make`).

There are also GUIs available: `ccmake` for curses and `cmake-gui` for
a graphical interface. These display `CMakeCache.txt` configuration
variables (as set with the `-C`/`-D` option to `cmake`) for you to set
before generating the buildsystem files. (`cmake -i` for interactive
configuration is no longer supported.)

The simplest build description is:

    cmake_minimum_required(VERSION 3.1)     # Optional but recommended
    project(hello)
    add_executable(hello hello.c)

(We use 3.1 instead of 3.0 to default to new variable names instead of
the deprecated old ones, [CMP0053].)

Documentation:
- [List of documentation items][doclist]
- [CMake reference manual][docs]
- [Wiki]
- [FAQ]
- [Blog]
- [Tutorial]
- [Running CMake]
- [_The Architecture of Open Source Applications_: CMake chapter][aosa]


Architecture
------------

For more details, see the following pages from [the documentation][docs]:

- [cmake-buildsystem(7)]: General introduction to the design of CMake.
- [cmake-language(7)]: Files and language description.
- [cmake(1)]: Command line tool.
- [_The Architecture of Open Source Applications_: CMake chapter][aosa]

CMake creates a _buildsystem_ for _projects_, each defined by a
`CMakeLists.txt` file in the _directory_ of the project. The
buildsystem has _targets_ that are output files or "phony" (always out
of date and thus always built).

Variables used to configure the build are generally not stored in or
read from the process environment (though they can be accessed with
`$ENV{name}`) but instead stored to and read from a single
`CMakeCache.txt` file in the (root) build directory.

The overall process is three steps of configuration and one of generation:
1. Read `CMakeCache.txt` from the build directory (if it exists).
2. Read `CMakeLists.txt` from the source root directory and execute
   its commands to create a configuration/build representation. This
   step may read further `CMakeLists.txt` files via the `include()`
   and `add_subdirectory()` commands.
3. Write the updated `CMakeCache.txt` file.
4. Generate the Makefiles or other target build tool files.

Though multiple `CMakeLists.txt` files may be read, all them together
generate a global build configuration with a single set of targets and
other global state such as cache variables. (This may produce name
collisions.) CMake code read with [`include()`] is executed in the
scope of the caller. [`add_subdirectory()`] adds a new build
subdirectory under the top-level build directory and creates a new
directory scope for the processing of the new `CMakeLists.txt`; the
new source directory need not be a subdirectory of the calling source
dir.

Directory scoping appears to be based on the build directory tree;
commands that use directory scoping "apply to directories below the
project directory" in which they're executed, so presumably to
projects below the project directory. However, it's generally
suggested that properties be set using target-scoped commands (where
they will be propagated/exported to dependents) rather than
directory-scoped where possible. E.g., prefer
[`target_include_directories()`] to set the [target-scoped
`INCLUDE_DIRECTORIES`][INCLUDE_DIRECTORIES:tgt] property over
[`include_directories()`] to set the [directory-scoped
`INCLUDE_DIRECTORIES`][INCLUDE_DIRECTORIES:dir].


XXX properties

When run, CMake uses a configuration (property settings) in
`$build/CMakeCache.txt`, generating it if necessary. Existing
configuration entries will not be changed or removed, but new ones may
be added. Changing a configuration entry may cause additions; re-run
`cmake` until the configuration no longer changes. Entries can be
specified on first run with the `-C`/`-D` options to `cmake` or in the
GUI tools; entries can be edited by editing the file or using a GUI
tool. `cmake -U glob` will remove entries matching _glob_.

Built targets (executables, libraries, etc.) will be placed in
`$build/`. Intermediate files for each target are placed in
`$build/CMakeFiles/$target.dir`.

#### Scripts

CMake can also directly run script files, without configuring and
producing a buildsystem, with `cmake -P scriptname.cmake`. These files
may not use "project commands" that define build targets or actions.
The allowable commands for this mode are listed in [cmake-commands(7)].


Command Invocation
------------------

#### cmake

Generate the configuration and buildsystem files.

    cmake sourcedir             # From build directory
    cmake builddir              # After cmake has been run once

CMake can also invoke the native build system with `cmake --build buildir
[opts] -- [native-opts]`; _builddir_ must already have been created with
`cmake sourcedir`.

Setting envvar `VERBOSE=1` makes the build output more verbose (at least
when using the Makefile generator).

Other useful options/modes:
* `-E command`: Command-line tool mode; `-E help` for a list of commands.
  This lets makefiles etc. do things like copy files and directories, make
  symlinks, generate SHA hashes, set/clear Windows registery entries, etc.
  This can also print CMake capabilities and start server mode.

#### CTest

Running `ctest` in a build directory will run all the tests, as with
the `test` target of `cmake`. Run `ctest` in the
build dir.

#### CPack

Packages software.

#### CDash

Web application for displaying test results and doing CI testing.


Syntax
------

The detailed reference is [cmake-language(7)].

Files are a sequence of _commands_ and comments:
- Commands have the from `command_name(arg ...)` with zero or more
  arguments in the parentheses. Arguments to commands are separated by
  whitespace or `;`. In unquoted arguments whitespace and `;()#"\`
  must be escaped with a backslash. Arguments may be quoted with
  double quotes or brackets (see below). Unquoted nested parens are
  passed to commands as individual unquoted arguments. Commands may be
  broken across multiple lines after the opening paren, but there may
  not be multiple commands on a line.
- Line comments start with `#` and go to end of line. `#` immediately
  followed by a _bracket argument_ (see below) allows multiline
  comments.

Escape sequences, variable expansion, quoting:
- `\x`: Escape sequence.
  - _x_ is one of `;trn`: semicolon, tab, CR, NL.
  - _x_ is any other char: Remove semantic meaning and treat
    literally. (E.g., to escape a space in an argument.)
- `${varname}`: Variable ref. Replaced by variable's value, or empty
  string if not set. Nested is evaluated from inside out, e.g. the
  variable name in `varname` can be evaluated with: `${${varname}}`,
  or `suffix` with `${mystuff_${suffix}}`.
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

In some expressions variables names can be passed as arguments which
are evaluated by the command itself. Thus with `set(var1 OFF)`,
`set(var2 "var1")`: `if(${var2})` ⇒ false but `if(var2)` ⇒ true.

#### [`foreach()`], [`while()`]

Loops. `break()` and `continue()` available.

    foreach(varname arg1 arg2 ...)
    foreach(varname RANGE total)
    foreach(varname RANGE start stop [step])
    foreach(varname IN [LISTS [list1 [...]]]
                       [ITEMS [item1 [...]]])

Records commands up to `endforeach()` and iterates their execution.
Empty `LIST` values are a zero-length item.

    while(expr)     # _expr_ same as if()
    endwhile()

### [`macro()`], [`function()`]

Define new commands.


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

Variable values are always strings though some commands may parse them
as different types, including:
- Boolean `0`/`1`.
- Lists of elements separated by `;`

[cmake-variables(7)] lists variables read/used by CMake, CTest and CPack.

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


Properties
----------

- XXX properties???
- [cmake-properties(7)]
- [`set_property()`]
- Set `INCLUDE_DIRECTORIES` with [`include_directories()`], but prefer
  `target_include_directories()`.


Generator Expressions
---------------------

[Generator expressions][cmake-generator-expressions(7)] of the form
`$<...>` can be used in certain properties and commands that populate
them (e.g., `INCLUDE_DIRECTORIES`, [`include_directories()`],
`target_include_directories()`) to be evaluated during build system
generation. They allow lookup of information, conditional evaluation,
and generation of output.

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


Build Configuration Declarations
--------------------------------

Commands are divided into "script commands" that may be used with or
without a build configuration (the latter e.g., in `cmake -P
filename.cmake`) and "project commands" that are used only when
defining build configurations in `CMakeLists.txt` and files it
loads/includes.

See [CMake Build Configuration](cmake-config.md) for commands (of both
types) related to configuring builds.



<!-------------------------------------------------------------------->
[Blog]: https://blog.kitware.com/tag/cmake/
[CMP0053]: https://cmake.org/cmake/help/latest/policy/CMP0053.html
[CMake]: https://cmake.org/
[FAQ]: https://gitlab.kitware.com/cmake/community/wikis/FAQ
[INCLUDE_DIRECTORIES:dir]: https://cmake.org/cmake/help/latest/prop_dir/INCLUDE_DIRECTORIES.html
[INCLUDE_DIRECTORIES:tgt]: https://cmake.org/cmake/help/latest/prop_tgt/INCLUDE_DIRECTORIES.html
[Ninja]: https://en.wikipedia.org/wiki/Ninja_(build_system)
[Running CMake]: https://cmake.org/runningcmake/
[Wiki]: https://gitlab.kitware.com/cmake/community/wikis/home
[`add_compile_options()`]: https://cmake.org/cmake/help/latest/command/add_compile_options.html
[`add_subdirectory()`]: https://cmake.org/cmake/help/latest/command/add_subdirectory.html
[`foreach()`]: https://cmake.org/cmake/help/latest/command/foreach.html
[`function()`]: https://cmake.org/cmake/help/latest/command/function.html
[`if()`]: https://cmake.org/cmake/help/latest/command/if.html
[`include()`]: https://cmake.org/cmake/help/latest/command/include.html
[`include_directories()`]: https://cmake.org/cmake/help/latest/command/include_directories.html
[`macro()`]: https://cmake.org/cmake/help/latest/command/macro.html
[`set()`]: https://cmake.org/cmake/help/latest/command/set.html
[`target_include_directories()`]: https://cmake.org/cmake/help/latest/command/target_include_directories.html
[`unset()`]: https://cmake.org/cmake/help/latest/command/unset.html
[`while()`]: https://cmake.org/cmake/help/latest/command/while.html
[aosa]: http://www.aosabook.org/en/cmake.html
[cmake(1)]: https://cmake.org/cmake/help/latest/manual/cmake.1.html
[cmake-buildsystem(7)]: https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html
[cmake-commands(7)]: https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html
[cmake-generator-expressions(7)]: https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html
[cmake-language(7)]: https://cmake.org/cmake/help/latest/manual/cmake-language.7.html
[cmake-properties(7)]: https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html
[cmake-variables(7)]: https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html
[doclist]: https://cmake.org/documentation/
[docs]: https://cmake.org/cmake/help/latest/
[tutorial]: https://cmake.org/cmake-tutorial/
