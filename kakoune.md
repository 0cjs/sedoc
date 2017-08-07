Kakoune - A Better Vim-Inspired Editor
======================================

[Kakoune] is inspired by Vim but has a more orthogonal design, allows
multiple selections and uses fewer keystrokes.

[Kakoune]: https://github.com/mawww/kakoune


Compiling on Ubuntu 14.04
-------------------------

There is an (official) PPA for newer versions of GCC:

    sudo add-apt-repository ppa:ubuntu-toolchain-r/test
    sudo apt-get update && sudo apt-get dselect-upgrade
    sudo apt-get install gcc-6 g++-6

Then compile it with `CXX=g++-6 make clean all`.

From: https://github.com/mawww/kakoune/issues/978#issuecomment-267309805
