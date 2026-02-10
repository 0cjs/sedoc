Bash Compatibility
==================

Techniques for writing code that works not just on Bash 5/Gnu userland
("Linux") but also Bash 3/BSD (MacOS) and Zsh/BSD (MacOS).

### Version Number Comparison

    #   True if version number $1 ≥ $2. Handles 2.10 > 2.9.
    #   `sort -V` is in Gnu coreutils, BSD, and MacOS ≥ 10.3.
    ver_ge() {
        [ "$2" = "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" ]
    }
