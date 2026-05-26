mise
====

_[mise]_ (mise.jdx.dev), also known as _mise en place,_ is a tool to
install and use "tools" (languages and other development tools, including
all programs that come with them) such as Python, Node, Go, Terraform, jq,
etc. etc. It can ensure that a specific language/tool version is available
(either downloading a precompiled binary or building it if necessary or
desired), give you its location, and change the current environment to use
these tools and other env vars by default (if you're into that sort of
thing) when you `cd` into a dir.

Install the command-line tool with `curl https://mise.run | sh`, which will
place it into `~/.local/bin/`. (Or use one of [many other packaging
systems][inst].) This does not add any of the "activation" support (such as
changing environment on `cd`); that's done with `eval "$(mise activate
bash)"` [or similar][install-shells].¹ (Also see [IDE Integration].)

`mise doctor` will try to diagnose common problems, including the "problem"
that your `cd` command doesn't change your environment vars.

`mise implode` will remove it; add `--config` to remove config dir too.
`mise implode -n --config` (or `--dry-run`) will tell you what dirs it
uses.

-----
¹ But don't do that unless you like using random programs depending on what
your CWD is. Instead, make your build scripts use their own dir's config,
not the CWD's config. `../myproject/Test` should not work differently from
`cd ../myproject && ./Test`.

### Directories

These are per [uninstalling].

    $MISE_DATA_DIR      $XDG_DATA_HOME/mise     ~/.local/share/mise
    $MISE_STATE_DIR     $XDG_STATE_HOME/mise    ~/.local/state/mise
    $MISE_CONFIG_DIR    $XDG_CONFIG_HOME/mise   ~/.config/mise
    $MISE_CACHE_DIR     $XDG_CACHE_HOME/mise    ~/.cache/mise
                        (MacOS)                 ~/Library/Caches/mise

### Tool Notes

Some tools offer far fewer versions than the "native" version management
tool; e.g. `ghc` offers only 8.2.2, 8.10.4 and 8.10.7. (Better to use
[`ghcup`] for that.)

- `python`: Python itself includes `pip` as of time of release.
  3.14.2 gives pip 25.3; 3.14.5 gives pip 26.1.1.



Basic Usage
-----------

This does not cover "activation"; just use of the stand-alone `mise`
command without affecting your environment. `python@3.14` is the example
target; which subversion is picked depends on the command.

Configuration (most subcommands except `unset` can be left out):
- `mise settings ls`: List settings; add `-a` to include defaulted values.
- `mise settings get X.Y`: Show an individual setting.
- `mise settings set X.Y=VAL`: E.g., `set python.compile=true`.
- `mise settings unset X.Y`: Restore default value.
- __Warning:__ `mise set` is a different command to set env vars
  (e.g., `mise set NODE_ENV=production`).

Discovery:
- `mise ls`: List all tools/versions installed.
- `mise ls python`: List all versions of `python` tool installed.
- `mise ls-remote python`: List all versions that mise knows about.

Installation. You may give a list of targets; it will do them in parallel.
* `mise install`:
  - `mise install python@3.14.0`: Install specific patch release.
  - `mise install python@3.14`: Install latest 3.14.x patch release,
    regardless of any other versions installed.
  - `mise install python@latest`: Install latest version of all released
    versions of the tool. (Does not include pre-releases, betas, etc.)
  - The `--dry-run-code` option returns 1 if it would install, 0 if the
    requested version is already installed.
* `mise upgrade`: Upgrades to "free" part of version number. E.g., `mise
  upgrade` will not upgrade Python 3.14.0 to 3.14.5, but upgrading
  `python@3.14` will. On upgrade, the older version is removed.
* `mise uninstall`: Not the same as `mise rm`, which is `mise unuse`!
  - `mise uninstall python@3.14.5`: Remove exact version.
  - `mise uninstall --all python@3.14`: Remove all matching versions.

Execution:
- `mise where python@3.14`: Show path to directory holding latest patch
  release. (`bin/`, `include/`, `lib/`, `share/` etc. under this.)
- `mise exec python@3.14 -- python --version`: Execute given command from
  that tool using latest patch version installed, downloading and
  installing it if necessary if no matching version is installed.


Tool Download/Building
----------------------

mise generally tries to find a binary, but will build from source if it
can't find one, or if explicitly requested with e.g. `python.compile=1`.



<!-------------------------------------------------------------------->
[IDE Integration]: https://mise.en.dev/ide-integration.html
[install-shells]: https://mise.en.dev/installing-mise.html#shells
[install]: https://mise.en.dev/installing-mise.html
[mise]: https://mise.jdx.dev/
[uninstalling]: https://mise.en.dev/installing-mise.html#uninstalling

[`ghcup`]: https://github.com/haskell/ghcup-hs
