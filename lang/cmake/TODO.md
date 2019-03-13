CMake - Things Still to Document
================================

Docs in this series: [Overview](README.md)
| [Syntax](syntax.md)
| [Build Configurations](config.md)
| [Variable/Property List](varproplist.md)
| [Tips](tips.md)
| [Visual Studio](visualstudio.md)

* [`varprops.cmake`], `print_property_attributes()`, accessing values
  of cache attributes. Also CMake's property test script,
  [`Tests/Properties/CMakeLists.txt`]?

* Printing out all vars (or cache properties?): [so 9298278].

* Generator expressions stored at config stage, evaluated at build
  stage (i.e., in the Makefile?): [so 35695152], [so 28692896]. Also
  Q&D how to print evaluated generator expression.

* Properties for `DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}` apply to all
  build dirs based on that source? What if you specify `DIRECTORY
  ${CMAKE_CURRENT_BINARY_DIR}`?

* Explanation of directory/target properties vs. variables: [so 33834879]

* Great? discussion of CMake syntax and variable usage: [so 31037882].

* `file(GENERATE)` section from [izzy].

* How [IXM] does command overrides, e.g. adding a `LAYOUT` parameter
  to `project()`.



<!-------------------------------------------------------------------->
[IXM]: https://ixm.one/
[`Tests/Properties/CMakeLists.txt`]: https://github.com/Kitware/CMake/blob/master/Tests/Properties/CMakeLists.txt
[`varprops.cmake`]: https://gist.github.com/dlrdave/10977804
[izzy]: https://izzys.casa/2019/02/everything-you-never-wanted-to-know-about-cmake/
[so 28692896]: https://stackoverflow.com/questions/28692896/
[so 31037882]: https://stackoverflow.com/questions/31037882
[so 33834879]: https://stackoverflow.com/a/33834879
[so 35695152]: https://stackoverflow.com/questions/35695152/
[so 9298278]: https://stackoverflow.com/questions/9298278/
