Bash Shell
==========


Old Versions
------------

MacOS still ships Bash 3 (users usually use `zsh` instead). To build
a copy of Bash 3 for testing:

    sudo apt install build-essential bison
    git clone -oupstream https://github.com/bminor/bash.git
    git checkout -b v3.2.48 f1be666c
    rm -f y.tab.*
    ./configure
    make -j32
    cp bash ~/.local/bin/bash3
