Installing OCaml
================

[Try OCaml] offers a web REPL and brief tutorial.

Installation for various systems is described on the [Install OCaml] page
of the official documentation:
- [opam][] ([GitHub][opam-gh]), the OCaml package manager, handles
  compiler/toolchain and package installation. [OPAM install
  instructions][opam-inst].
- Debian offers `ocaml` and `ocaml-nox` (without X11 support) packages.

### OPAM OCaml Installation

There is a standard [bootstrap shell script][opam-boot] that installs the
`opam` command into `/usr/local/bin` by default:

    sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)

- Prompts for install location. Default is `/usr/local/bin`, but using
  `/home/{user}/.local/bin` is a better idea. (opam itself installs
  everything into the user's home dir.)
- Requires `openssl` to do an SHA512 integrity check; skips check if
  not present.
- Offers some command line options related to switching between 1.x
  and 2.x that can be appended to the command line above; add `--help`
  or see the source for details.



<!-------------------------------------------------------------------->
[Install OCaml]: https://ocaml.org/docs/install.html
[Try OCaml]: https://try.ocamlpro.com/
[opam-inst]: https://opam.ocaml.org/doc/Install.html
[opam]: https://opam.ocaml.org/
[opam-boot]: https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh
[opam-gh]: https://github.com/ocaml/opam
