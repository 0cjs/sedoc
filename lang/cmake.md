CMake
=====

[CMake] is a multi-platform build tool that reads a `CMakeLists.txt` file
and generates platform-native makefiles (or similar) and workspaces to
build the project. `CMakeLists.txt` is stored at the root of the source
directory, but the build is usually done in a separate, empty build
directory (referred to as `$build/` below).

Execute CMake with `cd $build && cmake dir`, where _dir_ is a relative or
absolute path to the directory containing `CMakeLists.txt` or the path to
an existing build directory created by CMake. This will generate the
makefiles; you then need to run `cmake --build`, `make` or your other build
tool.

There are also GUIs available: `ccmake` for curses and `cmake-gui` for a
graphical interface. These display `CMakeCache.txt` configuration variables
(as set with the `-C`/`-D` option to `cmake`) for you to set before
generating the buildsystem files. (`cmake -i` for interactive configuration
is no longer supported.)

The simplest build description is:

    cmake_minimum_required(VERSION 3.1)     # Optional but recommended
    project(hello)
    add_executable(hello, hello.c)

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

Architecture
------------

For full details, see the following pages from [the documentation][docs]:

- [cmake-buildsystem(7)]: General introduction to the design of CMake.
- [cmake-language(7)]: Files and language description.
- [cmake(1)]: Command line tool.

When run, CMake uses a configuration in `$build/CMakeCache.txt`, generating
it if necessary. Existing configuration entries will not be changed or
removed, but new ones may be added. Changing a configuration entry may
cause additions; re-run `cmake` until the configuration no longer changes.
Entries can be specified on first run with the `-C`/`-D` options to `cmake`
or in the GUI tools; entries can be edited by editing the file or using a
GUI tool. `cmake -U glob` will remove entries matching _glob_.

Targets (executables, libraries, etc.) will be placed in `$build/`.
Intermediate files for each target are placed in
`$build/CMakeFiles/$target.dir`.


Command Invocation
------------------

    cmake sourcedir             # From build directory
    cmake builddir              # After cmake has been run once

CMake can also invoke the native build system with `cmake --build buildir
[opts] -- [native-opts]`; _builddir_ must already have been created with
`cmake sourcedir`.


Syntax
------

The detailed reference is [cmake-language(7)].

- Variable names are alphanumeric, `/_.+-` and escape sequences.
  (`$` is also permitted but discouraged.)

Quoting, comments, substitution:
- Unquoted args are sequences of chars. Whitespace and `()#"\` must be
  escaped with a backslash.
- `\x`: Escape sequence.
  - _x_ is one of `;trn`: semicolon, tab, CR, NL.
  - _x_ is any other char: Remove semantic meaning and treat literally.
    (E.g., to escape a space in an argument.)
- `"`...`"`: Quoted arg. Evaluates _escape sequences_ and _variable refs_.
- `[[`...`]]`: Bracket argument. Zero or more `=` may be used between the
  brackets to allow bracket use in the arg, e.g., `[==[`...`]==]`.
- `#`: Comment to end of line, or of immediately following _bracket arg_.
- `${varname}`: Variable ref. Replaced by variable's value, or empty string
  if not set. Nested is evaluated from inside out, e.g. the variable name
  in `varname` can be evaluated with: `${${varname}}`, or `suffix` with
  `${mystuff_${suffix}}`.

XXX Generator expressions ([cmake-generator-expressions(7)])`$<...>`.


Declarations
------------

### General

#### [`cmake_minimum_required()`]: Minimum version and policy settings.

    cmake_minimum_required(VERSION min[...max] [FATAL_ERROR])

- _min_ and _max_ are specified as `major.minor[.patch[.tweak]]`.
- `...max` is ≥3.12 only.
- `FATAL_ERROR` is ignored by ≥2.6 and should be used to make ≤2.4
  fail with an error instead of warning.
- Invokes [`cmake_policy()`].

#### [`project()`]: Set project information.

    project(<PROJECT-NAME> [LANGUAGES] [<language-name>...])
    project(<PROJECT-NAME>
            [VERSION <major>[.<minor>[.<patch>[.<tweak>]]]]
            [DESCRIPTION <project-description-string>]
            [HOMEPAGE_URL <url-string>]
            [LANGUAGES <language-name>...])

Sets the following variables. All also have a version with `PROJECT`
replaced by the project name.
- `PROJECT_SOURCE_DIR`, `PROJECT_BINARY_DIR`
- `PROJECT_VERSION`, `PROJECT_VERSION_MAJOR`,`PROJECT_VERSION_MINOR`
  `PROJECT_VERSION_PATCH`, `PROJECT_VERSION_TWEAK` (unspecified versions
  are set to empty string)
- `PROJECT_DESCRIPTION` (expected to be just a few words)
- `PROJECT_HOMEPAGE_URL`

Languages default to `C` and `CXX` (C++) if not given. Language name
`NONE` or empty specifies no language setup. If `ASM` is used, it should
be listed last.

The last step of the `project()` command will load
`CMAKE_PROJECT_<PROJECT-NAME>_INCLUDE`, if defined.

`project()` cannot be specified via `include()`. If not called in the
top-level `CMakeLists.txt`, an implicit call to `project()` will be
generated.

`cmake_minimum_required()` must be called before `project()`.

### Targets

#### [`add_executable()`]: Define an executable target.

      add_executable(target [WIN32] [MACOSX__BUNDLE] [EXCLUDE_FROM_ALL] sourcefile ...)
      add_executable(target IMPORTED [GLOBAL])
      add_executable(target ALIAS alias)

`IMPORTED` references an executable file from outside from outside the
project. No build rules for it are generated.

_alias_ can be used to refer to _target_ in subsequent commands. _alias_
may not be installed or exported, and will not appear as a target in the
generated makefiles.

#### [`add_library()`]: Define library target.

    add_library(libtarget sourcefile ...)     # Static lib

#### [`target_link_libraries()`]: Libraries and link flags.

Specify libraries/flags when linking a target or its dependents. `target`
may not be an alias.

    target_link_libraries(target item ...)

Each _item_ may be prefixed by:
- `general` (default): Add _item_ for all configurations.
- `optimized`: Add _item_ for all non-debug configurations.
- `debug`: Add _item_ for debug configuration only.
Items are:
- A target created by `add_executable` or `add_library` in the current
  directory,
- Full path to a library file.
- Plain library name (e.g. `foo` becomes `-lfoo` or `foo.lib`).
- Link flag (command line fragment, no extra quoting is done).
- [Generator expression][cmake-generator-expressions(7)] `$<...>`.
- `debug`/`optimized`/`general` followed by another _item_ that will be
  used only for that build configuration. `optimized` is for non-debug
  configurations; `general` is for all configurations.

#### [`install()`]

XXX

#### [`add_test()`], [`set_tests_properties()`]

Directs the `ctest` command to run an executable and verify the output.

    add_test(NAME name COMMAND command [arg...]
             [CONFIGURATIONS config...]
             [WORKING_DIRECTORY dir])
    set_tests_properties(name ...  PROPERTIES propname value)
    set_tests_properties(test1 test8  PROPERTIES WILL_FAIL TRUE)

[Properties on tests] include:
- `WILL_FAIL`: Set to `TRUE` to expect non-zero exit code.
- `SKIP_RETURN_CODE`: Exit value to mark test as skipped instead of pass/fail.
- `PASS_REGULAR_EXPRESSION`: Fails unless output matches at least one regexp.
- `FAIL_REGULAR_EXPRESSION`: Fails if output matches any of the regexps.
- `TIMEOUT`: Number of seconds after which the test will be killed.
  Takes precedence over `CTEST_TEST_TIMEOUT`.
- `FIXTURES_REQUIRED` etc. to add setup/cleanup to sets of tests.
- Many more; see [properties on tests].

Properties such as `PASS_REGULAR_EXPRESSION` may have multiple values
specified, separated with a semicolon.

Suggested macro:

    macro(do_test arg result)
      add_test(Test${arg} exec_target ${arg})
      set_tests_properties(Test${arg} PROPERTIES PASS_REGULAR_EXPRESSION ${result})
    endmacro(do_test)
    do_test(25 "25 is 5")
    do_test(-25 "-25 is 0")

### File generation

#### [`configure_file()`]: Generate file with token substitution.

Creates file _target_, replacing `@token@` in _source_ with value of CMake
variable `token`.

    configure_file(source, target)
    configure_file("${PROJECT_SOURCE_DIR}/file.in" "${PROJECT_BINARY_DIR}/file")



<!-------------------------------------------------------------------->
[Blog]: https://blog.kitware.com/tag/cmake/
[CMP0053]: https://cmake.org/cmake/help/latest/policy/CMP0053.html
[CMake]: https://cmake.org/
[FAQ]: https://gitlab.kitware.com/cmake/community/wikis/FAQ
[Running CMake]: https://cmake.org/runningcmake/
[Wiki]: https://gitlab.kitware.com/cmake/community/wikis/home
[`add_executable()`]: https://cmake.org/cmake/help/latest/command/add_executable.html
[`add_library()`]: https://cmake.org/cmake/help/latest/command/add_library.html
[`add_test()`]: https://cmake.org/cmake/help/latest/command/add_test.html
[`cmake_minimum_required()`]: https://cmake.org/cmake/help/latest/command/cmake_minimum_required.html
[`cmake_policy()`]: https://cmake.org/cmake/help/latest/command/cmake_policy.html
[`configure_file()`]: https://cmake.org/cmake/help/latest/command/configure_file.html
[`install()`]: https://cmake.org/cmake/help/latest/command/install.html
[`project()`]: https://cmake.org/cmake/help/latest/command/project.html
[`set_tests_properties()`]: https://cmake.org/cmake/help/latest/command/set_tests_properties.html
[`target_link_libraries()`]: https://cmake.org/cmake/help/latest/command/target_link_libraries.html
[cmake(1)]: https://cmake.org/cmake/help/latest/manual/cmake.1.html
[cmake-buildsystem(7)]: https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html
[cmake-generator-expressions(7)]: https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html
[cmake-language(7)]: https://cmake.org/cmake/help/latest/manual/cmake-language.7.html
[doclist]: https://cmake.org/documentation/
[docs]: https://cmake.org/cmake/help/latest/
[properties on tests]: https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#test-properties
[tutorial]: https://cmake.org/cmake-tutorial/
