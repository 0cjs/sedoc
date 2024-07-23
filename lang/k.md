K Semantic Framework
====================


Installation
------------

[Source] build has a lot of requirements. May be best to build in a
container. Old versions had a llvm `.gitmodules` path bug, now fixed.

    ./install-build-deps                    # from branch/PR at the moment
    git submodule update --init --recursive`

To use:

    prepath k-distribution/target/release/k/bin


Tutorial
--------

[K Tutorial]

### [§1.2] Basics of Functional K

- Set of K files compiled together is a _K definition._




<!-------------------------------------------------------------------->
[source]: https://github.com/runtimeverification/k.git
[K Tutorial]: https://kframework.org/k-distribution/k-tutorial/
[§1.2]: https://kframework.org/k-distribution/k-tutorial/1_basic/02_basics/
