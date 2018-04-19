MinGW
=====

Some sort of  [MinGW] (Minimalist GNU for Windows) is included with
Git for Windows; I don't know which MinGW project this is. It seems to
be `x86_64-w64-mingw32`.


Tips and Tricks
---------------

* Use `cygpath` to convert between MinGW Bash paths and Windows paths.
* The MinGW programs can be run from CMD/PowerShell even if not in path
  by finding the full path to them: `cygpath -w /mingw64/bin`.



[MinGW]: https://en.wikipedia.org/wiki/MinGW
