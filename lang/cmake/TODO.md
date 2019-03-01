CMake - Things Still to Document
================================

* In `README`, "Settings used to configure build": note access with
  `$CACHE{name}`, property access, and maybe variable fallback to
  cache lookup?

* `get_property(cmcc CACHE CMAKE_C_COMPILER PROPERTY VALUE)`

* `get_property(var VARIABLE PROPERTY ...)`

* [`varprops.cmake`], `print_property_attributes()`, accessing values
  of cache attributes. Also CMake's property test script,
  [`Tests/Properties/CMakeLists.txt`]?

* Printing out all vars (or cache properties?): [so 9298278].

* Generator expressions stored at config stage, evaluated at build
  stage (i.e., in the Makefile?): [so 35695152], [so 28692896]. Also
  Q&D how to print evaluated generator expression.

* Some stuff on cache variables vs. global properties: [so 34290292].

* Great? discussion of CMake syntax and variable usage: [so 31037882].

* [Everything You Never Wanted to Know About CMake][everything],
  2019-02-02.
  - "Variables in CMake are just cursed eldritch terrors, lying in
    wait to scare the _absolute_ __piss__ out of anyone that isn’t
    expecting it."
  - Also from section "Events and the Nightmares Held Within": "This
    is, I should note, _extremely useful_ if you’re trying to break
    CMake to not do its normal thing of crushing your soul everytime
    you want to start a new project."





<!-------------------------------------------------------------------->
[`Tests/Properties/CMakeLists.txt`]: https://github.com/Kitware/CMake/blob/master/Tests/Properties/CMakeLists.txt
[`varprops.cmake`]: https://gist.github.com/dlrdave/10977804
[everything]: https://izzys.casa/2019/02/everything-you-never-wanted-to-know-about-cmake/
[so 28692896]: https://stackoverflow.com/questions/28692896/
[so 31037882]: https://stackoverflow.com/questions/31037882
[so 34290292]: https://stackoverflow.com/questions/34290292/
[so 35695152]: https://stackoverflow.com/questions/35695152/
[so 9298278]: https://stackoverflow.com/questions/9298278/
