CMake Overview
===============

Docs in this series: [Overview](README.md)
| [Syntax](syntax.md)
| [Build Configurations](config.md)
| [Variable/Property List](varproplist.md)
| [Tips](tips.md)

> _Do not meddle in the affairs of CMake,
> for it is subtle and quick to anger._

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

    cmake_minimum_required(VERSION 3.12)  # Optional but strongly recommended
    project(hello)
    add_executable(hello hello.c)

`cmake_minimum_required()` automatically sets policies as well; see
[Build Configuration](config.md) for details on this.

Documentation:
- [List of documentation items][doclist]
- [CMake reference manual][docs]
- [Wiki]
- [FAQ]
- [Blog]
- [Tutorial]
- [Running CMake]
- [_The Architecture of Open Source Applications_: CMake chapter][aosa]

Other Resources:
- [LLVM CMake Primer](http://llvm.org/docs/CMakePrimer.html):
  A decent, quick overview.
- [CMake Cookbook Code](https://github.com/dev-cafe/cmake-cookbook)
- Daniel Pfeifer, [Effective Cmake Presentation][pfeifer]. Subtitled
  "A Random Selection of Best Practices," this also gives general
  information on CMake design and syntax, especially some subtle
  things. There are some errors (e.g., bracket argument comments are
  not nested).
- [TheErk/CMake-tutorial]. Extremely verbose (e.g., explains what a build
  system is).
- [Everything You Never Wanted to Know About CMake][izzy], 2019-02-02.
  Some very good (if limited) information and cool tips from a CMake
  expert (or at least someone who spent several weeks on a serious
  CMake project). Excellent quotes include:
  - "Variables in CMake are just cursed eldritch terrors, lying in
    wait to scare the _absolute_ __piss__ out of anyone that isn’t
    expecting it."
  - From section "Events and the Nightmares Held Within": "This is, I
    should note, _extremely useful_ if you’re trying to break CMake to
    not do its normal thing of crushing your soul everytime you want
    to start a new project."


Versions and Installation
-------------------------

The [download] page has binaries and source.
The [install] page describes how to build from source.

Distributed Versions (as of 2019-02-28):
- Latest release: is 3.13.4 (next release 3.14.0-rc3).
- Visual Studio 2017: 3.12.18081601-MSVC_2.
- Ubuntu 18.04: 3.10.2-1ubuntu2
- Debian 9: 3.7

Feature introductions:
- 3.12: `FindPython` modules.


Architecture
------------

For more details, see the following pages from [the documentation][docs]:

- [cmake-buildsystem(7)]: General introduction to the design of CMake.
- [cmake-language(7)]: Files and language description.
- [cmake(1)]: Command line tool.
- [_The Architecture of Open Source Applications_: CMake chapter][aosa]

CMake creates a _buildsystem_ for _directories_ (also called
_projects_), each of which is a set of source code with the build
definition in a `CMakeLists.txt` file in the root directory of the
source. The buildsystem has _targets_ that are output files or "phony"
(always out of date and thus always built).

Settings used to configure the build are generally not stored in or
read from the process environment (though they can be accessed with
`$ENV{name}`) but instead stored to and read from a single
`CMakeCache.txt` file in the (root) build directory. (These are
divided into normal ones always shown by `ccmake`/`cmake-gui` and
_advanced_ ones, marked with [`mark_as_advanced()`], that are not
displayed unless the show advanced option is on.)

The overall process is three steps of configuration and one of
generation.
1. Read `CMakeCache.txt` from the build directory (if it exists).
2. Read `CMakeLists.txt` from the source root directory and execute
   its commands to create a configuration/build representation. This
   step may read further `CMakeLists.txt` files via the `include()`
   and `add_subdirectory()` commands.
3. Write the updated `CMakeCache.txt` file.
4. Developer repeats the above steps as many times as necessary to set
   options revealed by changing other options. (`ccmake` and
   `cmake-gui` disable generation until the developer has seen all
   options at least once).
5. Generate the Makefiles or other target build tool files.

Following this the build system can be run with `cmake --build` or
manually. The build system generated by CMake is configured to check
the CMake configuration files used to generate it and re-run CMake
configuration if any of them have changed.

Though multiple `CMakeLists.txt` files may be read, all them together
generate a global build configuration with a single set of targets and
other global state such as cache variables. (This may produce name
collisions.)

CMake has _variables_ and separate _properties_ with somewhat complex
scoping rules; see [Syntax](syntax.md) for details.

When run, CMake uses a configuration (`CACHE`-scope property settings,
also sometimes referred to as "cached variables") in
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
may use only _script commands_, which have an immediate action during
the configure stage; they may not use _project commands_ that define
build targets or actions. The allowable commands for this mode are
listed in [cmake-commands(7)].


Command Line Tool Invocation
----------------------------

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
* `--system-information`: Discovered system info and variables. Useful
  to see what variables to check for platform, path or other information.
* `-E command`: Command-line tool mode; `-E help` for a list of
  commands. This lets makefiles etc. do things like copy files and
  directories, make symlinks, generate SHA hashes, set/clear Windows
  registery entries, etc. This can also print CMake capabilities and
  start server mode.
* `-P script`: Run (process) given _script_ (in script mode, rather
  than the normal project mode).
* `--help-command-list`, `--help-variable-list`, `--help-command CMD`,
  `--help-variable VAR`: Print help on commands and variables used in
  `CMakeLists.txt`. (But output is raw reStructuredText.)

#### CTest

Running `ctest` in a build directory will run all the tests, as with
the `test` target of `cmake`. Tests are just command line programs
that have their status code and/or output checked.

#### CPack

Packages software. Generates many different package formats, including
TGZ, ZIP, DEB, RPM, NSIS (Null Soft Installer).

#### CDash

Web application for displaying test results and doing CI testing.


CMake Syntax and Semantics
--------------------------

See [Syntax](syntax.md) for descriptions of:
- Command syntax
- Variables and Properties
- Generator Expression
- Misc. Scripting Commands


Build Configuration Declarations
--------------------------------

Commands are divided into "script commands" that may be used with or
without a build configuration (the latter e.g., in `cmake -P
filename.cmake`) and "project commands" that are used only when
defining build configurations in `CMakeLists.txt` and files it
loads/includes.

See [CMake Build Configuration](config.md) for commands (of both
types) related to configuring builds.



<!-------------------------------------------------------------------->

<!-- General CMake and KitWare Docs and Links -->
[Blog]: https://blog.kitware.com/tag/cmake/
[CMake]: https://cmake.org/
[FAQ]: https://gitlab.kitware.com/cmake/community/wikis/FAQ
[Running CMake]: https://cmake.org/runningcmake/
[Wiki]: https://gitlab.kitware.com/cmake/community/wikis/home
[cmake(1)]: https://cmake.org/cmake/help/latest/manual/cmake.1.html
[cmake-buildsystem(7)]: https://cmake.org/cmake/help/latest/manual/cmake-buildsystem.7.html
[cmake-commands(7)]: https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html
[cmake-generator-expressions(7)]: https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html
[cmake-language(7)]: https://cmake.org/cmake/help/latest/manual/cmake-language.7.html
[cmake-properties(7)]: https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html
[doclist]: https://cmake.org/documentation/
[docs]: https://cmake.org/cmake/help/latest/
[download]: http://cmake.org/download/
[install]: https://cmake.org/install/
[tutorial]: https://cmake.org/cmake-tutorial/

<!-- CMake Reference Manual Items -->
[`CMakeParseArguments`]: https://cmake.org/cmake/help/v3.4/module/CMakeParseArguments.html
[`add_compile_options()`]: https://cmake.org/cmake/help/latest/command/add_compile_options.html
[`add_subdirectory()`]: https://cmake.org/cmake/help/latest/command/add_subdirectory.html
[`cmake_parse_arguemnts()`]: https://cmake.org/cmake/help/latest/command/cmake_parse_arguments.html
[`mark_as_advanced()`]: https://cmake.org/cmake/help/latest/command/mark_as_advanced.html
[`set()`]: https://cmake.org/cmake/help/latest/command/set.html
[`unset()`]: https://cmake.org/cmake/help/latest/command/unset.html

<!-- Other Links -->
[Ninja]: https://en.wikipedia.org/wiki/Ninja_(build_system)
[TheErk/CMake-tutorial]: https://github.com/TheErk/CMake-tutorial/blob/master/precompiled-PDFs/2016-09-27-CMake-tutorial.pdf
[aosa]: http://www.aosabook.org/en/cmake.html
[izzy]: https://izzys.casa/2019/02/everything-you-never-wanted-to-know-about-cmake/
[pfeifer]: https://github.com/boostcon/cppnow_presentations_2017/blob/master/05-19-2017_friday/effective_cmake__daniel_pfeifer__cppnow_05-19-2017.pdf
