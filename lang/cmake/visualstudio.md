Using CMake with Visual Studio
==============================

Docs in this series: [Overview](README.md)
| [Syntax](syntax.md)
| [Build Configuration](config.md)
| [Variable/Property List](varproplist.md)
| [Tips](tips.md)
| [Visual Studio](visualstudio.md)

Visual Studio 2017 introduced support for using CMake instead of its
native solution/projects system, while mostly maintaining the standard
VS workflow. (It uses the CMake server to get information about the
source files, targets, etc.) VS 2015 can also use CMake-generated
MSBuild project file IntelliSense, browsing and compilation; these are
never used by VS 2017.

Currently VS 2017 ships with CMake 3.12 and Ninja 1.8.2. (You may need
to update your VS install to get these versions). VS selects the Ninja
generator by by default (it supports others), though CMake from the
command line will use the "VS Studio 15 2017" generator.

VS supports development and remote running/debugging of Linux
executables; see [Configure a Linux CMake project][vs-linux]. It can
install [MS's pre-built Linux CMake binaries][ms-cmakebin] under
`.vs/cmake` if necessary.

Using "File / Open / Folder..." (or run `devenv.exe FOLDERNAME`) on a
folder with a `CMakeLists.txt` will create a new _workspace_ in VS
representing the collection of files in that folder. If it doesn't
already exist VS will create a `CMakeSettings.json` file with
configuration for how CMake is run. See [devblog] for some details on
this.

VS will create its own build directory for a CMake project under
`C:\Users\USERNAME\CMakeBuilds\`; the name is a UUID. The name can be
discovered from menu "CMake / Cache / Open Cache Folder". If the folder
is removed VS will no longer be able to build; use the "Generate" option
in that menu to regenerate the folder.


Tips
----

- [`source_group()`] can be used to set up file tabs in Visual Studio
  and change the locations of files in the Solution Explorer
  hierarchy. (By default, VS seems to set up a reasonable grouping by
  project.)


Documentation
-------------

Microsoft:
- [CMake Support in Visual Studio][devblog], Microsoft C++ Team Blog,
  2016-10-05. (Updated 2017-10-05 for VS 2017 15.4.)
- [CMake projects in Visual Studio][vs-cmake].
- [Customize CMake build settings in Visual Studio][vs-settings].
- [Using the MSVC toolset from the command line][vc-cmdline]

Other:
- [CMake and Visual Studio][cogwave], _Cognitive Waves_ blog post.  
  Includes a mapping of MSBuild concepts to CMake concepts and
  commands, e.g. "solution"→"project", "project"→"target".



To-do
-----

* <https://stackoverflow.com/questions/28987900/>


<!-------------------------------------------------------------------->
[devblog]: https://devblogs.microsoft.com/cppblog/cmake-support-in-visual-studio/
[ms-cmakebin]: https://github.com/Microsoft/CMake/releases
[vc-cmdline]: https://docs.microsoft.com/en-us/cpp/build/building-on-the-command-line?
[vs-cmake]: https://docs.microsoft.com/en-us/cpp/build/cmake-projects-in-visual-studio
[vs-linux]: https://docs.microsoft.com/en-us/cpp/linux/cmake-linux-project
[vs-settings]: https://docs.microsoft.com/en-us/cpp/ide/customize-cmake-settings

[cogwave]: https://cognitivewaves.wordpress.com/cmake-and-visual-studio/

[`source_group()`]: https://cmake.org/cmake/help/v3.14/command/source_group.html
