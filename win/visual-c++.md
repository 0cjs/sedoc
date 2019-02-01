Visual C++ / Visual Studio
==========================

### Solution/Project Configuration

The ["native" build configuration][vs-sol-proj] in [Visual Studio] is a
_solution_ (defined in `.sln` and `.suo` files) which includes
references to one or more _projects_ and various other settings. A
_project_ (defined in a `.vcxproj`, `.csproj`, or `.vbproj` file)
generates a single output (e.g., `.exe` or `.dll`) and contains
source/data files, configuration information and references to
dependent projects in the same solution and other dependencies.

The "New Project" menu item in VS also creates a new solution if one
is not already open.

A project has one or more _configurations_ (same as MSBuild
configurations?) with different settings for building the project; the
default configurations are `Debug` and `Release`. (There may also be
different [platforms] for each configuration.) Solutions also may have
configurations and platforms; these map to a set of
project/configuration/platform tuples.

VS uses [MSBuild], an [open source][msb-github] tool written in
C#, to load and build projects; the `.*proj` file contains the MSBuild
XML code. MSBuild can also run standalone or via an API to do the same
builds that VS would do, and can run on Linux and MacOS via [.NET
Core] or [manual install][.NET Core MSBuild].

An [MSBuild] project file contains:
- _Properties_: key-value pairs used for configuration.
- _Items_: Build system inputs, typically files. grouped into _item types_.
- _Tasks_: Executable code to perform build operations.
- _Targets_: Group tasks together and expose sections of the project
  file as entry points to the build process.

Also see tutorial [_Walkthrough: Creating an MSBuild project file from
scratch_][msb-project-scratch].

### "Open Folder" Configuration

VS 2017 and later can also work without a solution or project via
__File » Open » Folder__ (≥VS 2017); this is referred to as "'Open
Folder' Development" ([_Develop code in Visual Studio without projects
or solutions_][open-folder]).

VS may detect and know how to run the build used by the folder.
* [C++ code][blog-open-folder] is detected browsable automatically,
  without a solution or project . A `CppProperties.json` can be added
  to the root folder for configurations, include paths, etc., and
  build tasks (below) can also be added. This is an alternative to the
  "Create Project from Existing Code" wizard.
* [CMake] is also detected automatically and the VS will read it for
  build information and use CMake to do the build.

Otherwise you can add _build tasks_ to tell VS how to build. These are
stored in files `tasks.vs.json` (build commands, compiler switches,
arbitrary tasks), `launch.vs.json` (command line arguments for
launching/debugging) and `VSWorkspaceSettings.json` (generic settings
for the above, such as environment variables). For more see
[_Customize build and debug tasks for "Open Folder"
development_][of-customize].



<!-- Documentation -->
[.NET Core SDK]: https://github.com/dotnet/core-sdk
[.NET Core]: https://dotnet.microsoft.com/learn/dotnet/hello-world-tutorial
[.NET core MSBuild]: https://github.com/Microsoft/msbuild/blob/master/documentation/wiki/Building-Testing-and-Debugging-on-.Net-Core-MSBuild.md
[CMake]: https://blogs.msdn.microsoft.com/vcblog/2016/10/05/cmake-support-in-visual-studio/
[MSBuild]: https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild?view=vs-2017
[Visual Studio]: https://en.wikipedia.org/wiki/Microsoft_Visual_Studio
[msb-github]: https://github.com/Microsoft/msbuild
[msb-project-scratch]: https://docs.microsoft.com/en-us/visualstudio/msbuild/walkthrough-creating-an-msbuild-project-file-from-scratch?view=vs-2017
[of-customize]: https://docs.microsoft.com/en-us/visualstudio/ide/customize-build-and-debug-tasks-in-visual-studio?view=vs-2017
[open-folder]: https://docs.microsoft.com/en-us/visualstudio/ide/develop-code-in-visual-studio-without-projects-or-solutions?view=vs-2017
[platforms]: https://docs.microsoft.com/en-us/visualstudio/ide/understanding-build-platforms?view=vs-2017
[vs-sol-proj]: https://docs.microsoft.com/en-us/visualstudio/ide/solutions-and-projects-in-visual-studio?view=vs-2017

<!-- Blog Posts -->
[blog-open-folder]: https://blogs.msdn.microsoft.com/vcblog/2016/10/05/bring-your-c-codebase-to-visual-studio-with-open-folder/

