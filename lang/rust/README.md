Rust, Cargo and Rustup
======================

References:
- [_The Rust Programming Language_][RPL] refs `RPL§N.M`.
- [_The Cargo Book_][CB] refs `CB§N.M`.


Module System
-------------

A __crate__ is a tree of modules producing a library (_library crate_) or
executable (_binary crate_). This is the smallest amount of code that
`cargo` or `rustc` considers at a time; `rustc` on a single file considers
that file a crate. [[RPL§7.1]]
- Binary crates must have a single `main` function; library creates must
  not have a `main` function.
- The _crate root_ is the source file whence the rust compiler starts, is
  the root module of the crate.
- "Crate" alone typically means "library crate."

A __package__ has a `Cargo.toml` containing the [manifest][CB§3.2] and one
or more crates (0+ binary crates and 0–1 library crates). The root module
defaults to `src/main.rs` or `src/lib.rs`. [[RPL§7.1]]

`cargo new NAME` creates a directory _NAME_ with:
- `Cargo.toml` setting package.name, .version="0.1.0", .edition="2021" and
  empty dependencies section.
- .edition determines the version of the language in use for the crates
  (2015, 2018, 2021, and pre-release 2024). All crates can be linked to
  other crates of language edition.
- `src/main.rs` containing a hello world program. This is a crate with the
  same name as the package.
- Add `src/lib.rs` to add a library crate named after the package.
- Add `src/bin/*` to add further binary crates.

A __module__ XXX [[RPL§7.2]]
- `src/{main,lib}.src` is the crate root. Declare modules in it with `mod
  foo;` where the definition is inline (`mod foo { … }`), in `src/foo.rs`,
  or in `src/foo/mod.rs`. (Latter is older style; not recommended.)
- Declare submodules in any other file. E.g., in `src/foo.rs`, `mod bar`
  inline, in `src/foo/bar.rs`, or in `src/foo/bar/mod.rs`.
- Reference items in modules with a __path__ e.g. `crate::foo:bar::SomeType`.
  `use crate::foo::bar::SomeType` will let you reference as `SomeType`.
- Code in modules is private from its parents unless declared `pub`.

__Workspaces__ are covered in [RPL§14.3] and [CB§3.3].


Cargo Configuration
-------------------

[[CB§3.6]] "Configuration"

Commands:
- Common parameters (most, not all commands):
  - `--manifest-path PATH`: path to `Cargo.toml` (including filename)
- `cargo metadata`: JSON output of build configuration.
- `cargo update`: Update all dependencies in the lockfile.
- `cargot fetch`: Download dependencies
- `cargo build`:
  - `--jobs N`, `-j N`: number of parallel jobs (default # of CPUs)
  - `--keep-going`
  - `--package [SPEC]`: packages to build
  - `--exclude SPEC`: exclude packages from build

Configuration file search:
- If present, `config` read instead of `config.toml`.
- `.cargo/config.toml` in current dir and parents all the way to root.
- `$CARGO_HOME/config.toml`.
- `$CARGO_HOME` defaults to `$HOME/.cargo/` or `%USERPROFILE%/.cargo/`.
- Sensitive values in `$CARGO_HOME/credentials.toml`.
- In a workspace, config files under workspace root not read
  (when `cargo` invoked from root)
- Keys in multiple files:
  - Number/string/boolean: first found takes precedence
  - Arrays: additional values prefixed (highest precedence towards end).

Keys:
- Environment variable `$CARGO_FOO_BAR` value overrides key `foo.bar`.
  Not all keys support this.
- Command line overrides with `cargo --config net.git-fetch-with-cli=true ...`

Values:
- Paths:
  - `$CARGO_*` env vars and `--config` are relative to CWD.
  - In files, relative to parent dir of file, i.e., same dir as `.cargo/` is in.
- Executable paths: `['echo', 'foo']` or `'echo foo'`.

Useful Keys (see ref above for full list):
- `build.target-dir`: Path where all output is placed.



<!-------------------------------------------------------------------->
[CB]: https://doc.rust-lang.org/cargo/
[CB§3.2]: https://doc.rust-lang.org/cargo/reference/manifest.html
[CB§3.3]: https://doc.rust-lang.org/cargo/reference/workspaces.html
[CB§3.6]: https://doc.rust-lang.org/cargo/reference/config.html
[RPL]: https://doc.rust-lang.org/book/
[RPL§14.3]: https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html
[RPL§7.1]: https://doc.rust-lang.org/book/ch07-01-packages-and-crates.html
[RPL§7.2]: https://doc.rust-lang.org/book/ch07-02-defining-modules-to-control-scope-and-privacy.html
