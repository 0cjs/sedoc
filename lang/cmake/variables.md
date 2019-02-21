CMake Variables
===============

Docs in this series: [Overview](README.md)
| [Syntax](syntax.md)
| [Variables](variables.md)
| [Build Configuration](config.md)
| [Tips](tips.md)

This is a categorized selection of some commonly used variables from
the full list of over 400 in [cmake-variables(7)].

#### Directories

- `CMAKE_SOURCE_DIR`: Full path to top level of source tree.
- `CMAKE_BINARY_DIR`: Full path to top level of build tree.
- `CMAKE_CURRENT_SOURCE_DIR`: Directory containing current
  `CMakeLists.txt`. Set when `add_subdir()` is called.
- `CMAKE_CURRENT_BINARY_DIR`: Build dir for current `CMakeLists.txt`.
  Set when `add_subdir()` is called.

The above variables are set to the current working directory when
cmake is invoked as `cmake -P scriptname`.

- `PROJECT_SOURCE_DIR`: When `project()` is called, set to current
  source dir.
- `PROJECT_BINARY_DIR`: When `project()` is called, set to current
  binary dir.

#### Verbosity

- `CMAKE_RULE_MESSAGES`: Cache setting initializes `RULE_MESSAGES`
  property. (Not passed to subprojects?) Default `ON` gives progress
  message (`[33%] Building C object...`) for each build rule; `OFF`
  reports only as targets complete. Currently ignored by non-Makefile
  generators.
- `CMAKE_VERBOSE_MAKEFILE`: Show Makefile command lines. Initialized
  to `FALSE` by `project()` command.

Verbosity can also be specified when calling `make`:
- Make or env var `VERBOSE=1`: Non-verbose makefiles become verbose.
- `--no-print-directory`: Do not print entering/leaving directory
  messages.

For `ninja`, pass `-v` for verbose.



<!-------------------------------------------------------------------->
[cmake-variables(7)]: https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html
