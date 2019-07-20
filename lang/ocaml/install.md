Installing OCaml
================


Installation for various systems is described on the [Install OCaml] page
of the official documentation:
- [Try OCaml] offers a web REPL and brief tutorial.
- [opam][] ([GitHub][opam-gh]) handles compiler/toolchain and package
  installation. See below.
- Debian offers `ocaml` and `ocaml-nox` (without X11 support) packages.
  You'd probably end up installing the `opam` package as well anyway.


opam
----

[opam][] ([GitHub][opam-gh], [install instructions][opam-inst]), the OCaml
package manager, handles compiler, toolchain and package installation.

It's a single standalone binary. Configuration is read from `/etc/opamrc`
and `~/.opamrc`, and it places all files it manages under a single
directory, `~/.opam/` by default.

### Installation

There is a standard [bootstrap shell script][opam-boot] that installs the
`opam` command into `/usr/local/bin` by default. It also has a dependency
on the `bwrap` command. opam must must be explicitly initialized before it
can be used.

    sudo apt-get install bubblewrap
    #   Ensure any/all of Git, Mercurial, Darcs are installed as well.
    sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
    opam init
    eval $(opam env)

- Prompts for install location. Default is `/usr/local/bin`, but using
  `/home/{user}/.local/bin` is a better idea. (opam itself installs
  everything into the user's home dir.)
- Requires `openssl` to do an SHA512 integrity check; skips check if
  not present.
- Offers some command line options related to switching between 1.x
  and 2.x that can be appended to the command line above; add `--help`
  or see the source for details.

`opam init` by default does an interactive install, prompting you for
important information.
- Not sure what this means: "A hook can be added to opam's init scripts to
  ensure that the shell remains in sync with the opam environment when they
  are loaded."

`opam env` (a shortcut for `opam config env`) prints out a set of
environment variable settings (updated `PATH` and `MANPATH`, along with
some OCaml-specific variables) to allow use of the environment. Usually
`eval $(opam env)` would be run in one's shell profile. Options:
- `--revert`: Undo settings made by `opam env`. (Unset env vars are reset
  to empty strings.)
- `--inplace-path`: Replace OPAM path in `$PATH` in-place rather than
  moving it to the front, maintaining any existing shadowing of
  opam-installed commands.
- `-v`: Add colon-prefixed comments explaining each env var.



<!-------------------------------------------------------------------->
[Install OCaml]: https://ocaml.org/docs/install.html
[Try OCaml]: https://try.ocamlpro.com/
[opam-inst]: https://opam.ocaml.org/doc/Install.html
[opam]: https://opam.ocaml.org/
[opam-boot]: https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh
[opam-gh]: https://github.com/ocaml/opam
