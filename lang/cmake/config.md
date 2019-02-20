CMake Build Configuration
=========================

Docs in this series: [Overview](README.md)
| [Syntax](syntax.md)
| [Variables](variables.md)
| [Build Configuration](config.md)
| [Tips](tips.md)

These are mostly _project commands_ used to define how a project is
built, but this also includes some _scripting commands_ that can be
used in a standalone file run with `cmake -P filename.cmake`. For a
full list of commands see [`cmake-commands(7)`].


Project Configuration
---------------------

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

#### [`add_subdirectory()`]: Add another project to this one

This integrates another project into the existing one, sharing
configuration and targets.

    add_subdirectory(sourcedir [outputdir] [EXCLUDE_FROM_ALL])

_sourcedir_ need not be a subdirectory; it can be a relative or
absolute path. `CMakeLists.txt` is read from _sourcedir_ and
processed, and all targets are added to the build. (Target name
collision is a fatal error.)

The build directory will be `$build/`_outputdir_ where _outputdir_
defaults to the same name as _sourcedir_.

#### [`include()`]: Load file or module

    include(name [OPTIONAL] [RESULT_VARIABLE <VAR>] [NO_POLICY_SCOPE])

If _name_ is a filename, code is loaded and run from it. Otherwise
it's assumed to be a module name and `name.cmake` is searched for in
the list of directories in `CMAKE_MODULE_PATH` (not set by default)
followed by CMake's standard module directory. For a list of modules
that come with CMake see [cmake-modules(7)].

Useful modules from [cmake-modules(7)] may include: `CPack`,
`FindPython3`, `CheckLibraryExists`.


Creating Top-level Targets
--------------------------

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

    add_library(libtarget [STATIC|SHARED|MODULE] [EXCLUDE_FROM_ALL] sourcefile ...)

Builds a _normal library_ from the _sourcefile_ sources. (Additional
sources may be added later with [`target_sources()`].) Arguments may
use generators.

Types of normal library are:
- `STATIC`: Archive of object files used for later linking.
- `SHARED`: (Shared) library to be dynamically linked at runtime.
- `MODULE`: Plugins loaded by programs at runtime.

The default is `STATIC` or `SHARED` depending on whether the global
flag `BUILD_SHARED_LIBS` is `ON` or `OFF` (usually set with
[`option()`] for selection by the developer). `SHARED` and `MODULE`
libraries have their `POSITION_INDEPENDENT_CODE` target property set
to `ON`. Libraries that export no symbols cannot be declared as
`SHARED` (because Windows). A `SHARED` or `STATIC` library may be
marked with the `FRAMEWORK` target property to create a MacOS
Framework.

    add_library(libtarget SHARED|STATIC|MODULE|OBJECT|UNKNOWN IMPORTED [GLOBAL])

References an imported library from outside the project.
Can also be done with `INTERFACE` signature below.

    add_library(name OBJECT src ...)

Defines an _object library_, is a list of source files whose object
files are added when a target depending on them is linked, without a
library file being created. Generator syntax may be used.

The object files are referenced with `$<TARGET_OBJECTS:objlib>` as a
source. Some build systems (e.g. Xcode) may need at least one source
file specified along with an object file list.

    add_library(name ALIAS target)

???

    add_library(name INTERFACE [IMPORTED [GLOBAL]])

Creates an _interface library_ with no actual build output. Typically
set up with `target_link_libraries()` etc. to set link interface,
options, include dirs, etc. etc. which then can be added as a group to
another target with `target_link_libraries()`. Directory scope unless
`GLOBAL` is specified.

#### [`add_custom_target()`]: Phony Target

Target has no output file and is considered always out of date
(phony). By default nothing depends on the new target; use `ALL` to
make the `all` target depend on this and [`add_dependencies()`] to
make other targets depend on this.

    add_custom_target(name [ALL] [command1 [args1...]]
                      [COMMAND command2 [args2...] ...]
                      [DEPENDS depend depend depend ... ]
                      [BYPRODUCTS [files...]]
                      [WORKING_DIRECTORY dir]
                      [COMMENT comment]
                      [VERBATIM] [USES_TERMINAL]
                      [COMMAND_EXPAND_LISTS]
                      [SOURCES src1 [src2...]])

Notes:
- Generally, use `VERBATIM` unless you have a reason not to do so.
- Shell interpreter state may not be maintained between `COMMAND`s.
- `DEPENDS` adds dependencies on files; use `add_dependencies()` to
  add dependencies on other targets.


Creating Dependency Targets
---------------------------

#### [`add_custom_command()`]: New Target Form

Add a new output file target.

    add_custom_command(OUTPUT output1 [output2 ...]
                       COMMAND command1 [ARGS] [args1...]
                       [COMMAND command2 [ARGS] [args2...] ...]
                       [MAIN_DEPENDENCY depend]
                       [DEPENDS [depends...]]
                       [BYPRODUCTS [files...]]
                       [IMPLICIT_DEPENDS lang1 dep1 [lang2 dep2 ...]]
                       [WORKING_DIRECTORY dir]
                       [COMMENT comment]
                       [DEPFILE depfile]
                       [VERBATIM] [APPEND] [USES_TERMINAL]
                       [COMMAND_EXPAND_LISTS])

There is also a form below for configuring the build of an existing target.

#### [`add_test()`], [`set_tests_properties()`]: Add `test` Target Dependency

Directs the `ctest` command to run an executable and verify the
output. `enable_testing()` must have been executed to run tests. The
`CTest` module does this and provides `CDash` support for submitting
build results.

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

#### [`install()`]: Add `install` Target Dependency

XXX

#### [`configure_file()`]: Generate File with Token Substitution

If _source_  is newer than _target_, creates file _target_ by copying
_source_, with token substitution. _source_ and _target_ default dirs
are `CMAKE_CURRENT_SOURCE_DIR` and `CMAKE_CURRENT_BINARY_DIR`,
respectively. If _target_ is a dir, the output file is the source file
name in that directory.

    configure_file(source, target
                   [COPYONLY] [ESCAPE_QUOTES] [@ONLY]
                   [NEWLINE_STYLE [UNIX|DOS|WIN32|LF|CRLF] ])
    configure_file("${PROJECT_SOURCE_DIR}/file.in" "${PROJECT_BINARY_DIR}/file")

Options:
- `COPYONLY`: Do not do token substitution.
- `ESCAPE_QUOTES`: Escape any substituted quotes with backslashes.
- `@ONLY`: Do not substitute `${token}`.
- `NEWLINE_STYLE`: `UNIX`/`LF` or `DOS`/`WIN32`/`CRLF`.

Token substitutions:
- `@token@` and `${token}`
  → value of CMake variable `token`, or empty string if undefined.
- `#cmakedefine VAR ...`
  → `#define VAR ...` or `/* #undef VAR */` if `if(VAR)` is false.
  `...` is processed as above.
- `#cmakedefine01 VAR` → `#define VAR 1` or `#define VAR 0` if false.

Normally `include_directories(${CMAKE_CURRENT_BINARY_DIR})` is added
to use generated `.h` files.


Configuring Existing Targets
----------------------------

#### [`add_dependencies()`]

Specifies that a top-level target (created with `add_executable()`,
`add_library()` or `add_custom_target()`) depends on other top-level
targets.

    add_dependencies(target [target ...])

For file-level dependencies use:
- For custom rules, `DEPENDS` in `add_custom_target()` and
  `add_custom_command()`.
- For object files, `OBJECT_DEPENDS` source file property.

#### [`target_link_libraries()`]: Libraries and link flags.

Specify libraries/flags when linking a target or its dependents. (This
should be used to express only direct dependencies; link interface
inheritance will take care of the indirect ones.) `target` may not be
an alias. If called more than once, subsequent items are appended.

    target_link_libraries(target item ...)

Each _item_ may be prefixed by:
- `general` (default): Add _item_ for all configurations.
- `optimized`: Add _item_ for all non-debug configurations.
- `debug`: Add _item_ for debug configuration only.
Each _item_ is:
- A target created by `add_executable` or `add_library` in the current
  directory,
- Full path to a library file.
- Plain library name (e.g. `foo` becomes `-lfoo` or `foo.lib`).
- Link flag (command line fragment, no extra quoting is done).
- [Generator expression][cmake-generator-expressions(7)] `$<...>`.
- `debug`/`optimized`/`general` followed by another _item_ that will be
  used only for that build configuration. `optimized` is for non-debug
  configurations; `general` is for all configurations.

With the default `(target item ...)` signature, dependencies are
transitive; all targets that depend on _target_ will also be linked
against each _item_.

The _link interface_, specified in _target's_
[`INTERFACE_LINK_LIBRARIES`][INTERFACE_LINK_LIBRARIES:tgt]  property
(generator syntax allowed), contains the transitive link dependencies:
anything linked to _target_ will be linked to those dependencies as
well. Item lists may be prefixed by any of the following to change the
nature of the link:
- `PRIVATE`: _target_ linked against _item_ but _item_ not part of
  _target's_ link interface. (Legacy form: `LINK_PRIVATE`.)
- `INTERFACE`: _target_ not linked against _item_ but _item_ is part
  of _target's_ link interface (Legacy form: `LINK_INTERFACE_LIBRARIES`.)
- `PUBLIC`: Both of the above: _target_ linked against _item_ and
  _item_ becomes part of _target's_ link interface. (Legacy form:
  `LINK_PUBLIC`.)

XXX Also need to describe linking `OBJECT` libs, cyclic dependencies,
and relocatable packages.

#### [`target_sources()`]

    target_sources(target item ...)

Adds sources to use when compiling _target_ added with
`add_executable()` or `add_library()`; _target_ must not be an alias.
Any list of _items_ may be preceeded by `PUBLIC`, `PRIVATE` or
`INTERFACE` which work as with `target_link_libraries()` above.
Generator expressions may be used.

#### [`add_custom_command()`]: Configure Existing Target Form

Adds pre-/post-commands to build for a target.

    add_custom_command(TARGET <target>
                       PRE_BUILD | PRE_LINK | POST_BUILD
                       COMMAND command1 [ARGS] [args1...]
                       [COMMAND command2 [ARGS] [args2...] ...]
                       [BYPRODUCTS [files...]]
                       [WORKING_DIRECTORY dir]
                       [COMMENT comment]
                       [VERBATIM] [USES_TERMINAL])


External Packages/Dependencies
------------------------------

#### [`add_library()`]

See `IMPORTED` signature for `add_library()` above.

#### [`find_path()`], [`find_file()`], [`find_library()`], [`find_program()`]

    find_*(var <name|NAMES name ...>
           [HINTS path1 [path2 ... ENV envar]]
           [PATHS path1 [path2 ... ENV envar]]
           ...  # Many more opts
           )

Creates a cache entry _var_ to store the result; subsequent calls are
a no-op if _var_ is already set.

`CMAKE_SYSTEM_PREFIX_PATH` is searched; this will have
`CMAKE_INSTALL_PREFIX` added to it.

#### [`find_package()`]

_Module_ mode loads `Find<PkgName>.cmake` from `CMAKE_MODULE_PATH` or
the CMake installation. (Read the file for details of variables that
influence the search.) These are used for third-party libraries that
do not provide CMake support to clients.

_Config_ mode (`CONFIG` or `NO_MODULE` option) searches for
`<PkgName>Config.cmake` or `<pkgname>Config.cmake`; the search and
configuration are both more complex.

The code run by these should use a namespace for their variables, so
after calling `find_package(Foo 2.0 REQUIRED)` you would use
`target_link_libraries(... Foo::Foo ...)`.


Misc
----

#### [`install()`]

Installs files to subdirs of `CMAKE_INSTALL_PREFIX` (default
`/usr/local` or `C:\Program Files\projectname`.) Generated Unix
Makefiles will also accept a `DESTDIR=...` option. The
`GNUInstallDirs` module provides GNU-style options for install layout.



<!-------------------------------------------------------------------->
[CMP0022]: https://cmake.org/cmake/help/latest/policy/CMP0022.html
[INTERFACE_LINK_LIBRARIES:tgt]: https://cmake.org/cmake/help/latest/prop_tgt/INTERFACE_LINK_LIBRARIES.html
[`add_custom_command()`]: https://cmake.org/cmake/help/latest/command/add_custom_command.html
[`add_custom_target()`]: https://cmake.org/cmake/help/latest/command/add_custom_target.html
[`add_dependencies()`]: https://cmake.org/cmake/help/latest/command/add_dependencies.html
[`add_executable()`]: https://cmake.org/cmake/help/latest/command/add_executable.html
[`add_library()`]: https://cmake.org/cmake/help/latest/command/add_library.html
[`add_subdirectory()`]: https://cmake.org/cmake/help/latest/command/add_subdirectory.html
[`add_test()`]: https://cmake.org/cmake/help/latest/command/add_test.html
[`cmake-commands(7)`]: https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html
[`cmake_minimum_required()`]: https://cmake.org/cmake/help/latest/command/cmake_minimum_required.html
[`cmake_policy()`]: https://cmake.org/cmake/help/latest/command/cmake_policy.html
[`configure_file()`]: https://cmake.org/cmake/help/latest/command/configure_file.html
[`find_file()`]: https://cmake.org/cmake/help/latest/command/find_file.html
[`find_library()`]: https://cmake.org/cmake/help/latest/command/find_library.html
[`find_package()`]: https://cmake.org/cmake/help/latest/command/find_package.html
[`find_path()`]: https://cmake.org/cmake/help/latest/command/find_path.html
[`find_program()`]: https://cmake.org/cmake/help/latest/command/find_program.html
[`include()`]: https://cmake.org/cmake/help/latest/command/include.html
[`install()`]: https://cmake.org/cmake/help/latest/command/install.html
[`install()`]: https://cmake.org/cmake/help/latest/command/install.html
[`option()`]: https://cmake.org/cmake/help/latest/command/option.html
[`project()`]: https://cmake.org/cmake/help/latest/command/project.html
[`set_tests_properties()`]: https://cmake.org/cmake/help/latest/command/set_tests_properties.html
[`target_link_libraries()`]: https://cmake.org/cmake/help/latest/command/target_link_libraries.html
[`target_sources()`]: https://cmake.org/cmake/help/latest/command/target_sources.html
[cmake-generator-expressions(7)]: https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html
[cmake-modules(7)]: https://cmake.org/cmake/help/latest/manual/cmake-modules.7.html
[properties on tests]: https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#test-properties
