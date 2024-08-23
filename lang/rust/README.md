Rust, Cargo and Rustup
======================


Cargo Configuration
-------------------

- _The Cargo Book,_ [Configuration][cb-config].

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
[cb-config]: https://doc.rust-lang.org/cargo/reference/config.html
