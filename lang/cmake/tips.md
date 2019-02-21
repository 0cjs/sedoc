CMake Tips and Tricks
=====================

Docs in this series: [Overview](README.md)
| [Syntax](syntax.md)
| [Variables](variables.md)
| [Build Configuration](config.md)
| [Variables](variables.md)
| [Tips](tips.md)

### General Tips

From [pfeifer]:

- Use commands to describe the build rather than setting variables.
- Generally set properties on targets rather than globally, e.g.,
  `target_compile_options()` instead of `add_compile_options()`.
- Don't touch `CMAKE_CXX_FLAGS`.
- Don't use `file(GLOB)`


### Deprecate Variables and Commands

    function(__deprecated_var var access)
        if(access STREQUAL "READ_ACCESS")
            message(DEPRECATION "Variable ${var} is deprecated")
        endif()
    endfunction()
    variable_watch(hello __deprecated_var)

    macro(mycmd)
        message(DEPRECATION "mycmd() is deprecated")
        _mycmd(${ARGV})
    endmacro()



<!-------------------------------------------------------------------->
[pfeifer]: https://github.com/boostcon/cppnow_presentations_2017/blob/master/05-19-2017_friday/effective_cmake__daniel_pfeifer__cppnow_05-19-2017.pdf
