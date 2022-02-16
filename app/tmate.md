tmate
=====

Configuration
-------------

### Configuration Files

- `@SYSCONFDIR@/tmux.conf`: Loaded before the user configuration file by
  tmux and, according to the manual page, tmate. Not present on Debian 11.
- `~/.tmux.conf`: Loaded by tmux on startup.
- `~/.tmate.conf`: Loaded by tmate on startup. The manual page claims that
  tmate falls back to `~/.tmux.conf` if this isn't present, but that does
  not seem to be true.

To share settings between the two, put common settings in `~/.tmux.conf`
and add a `source-file ~/.tmux.conf` command to the start of
`~/.tmate.conf`.

The `-f FILE` option will start tmate with an alternative file; this skips
the system configuration file (unconfirmed) and the user configuration
file.

### Configuration Options

Tmate has three different types of configuration options:
- _Server_ options which do not apply to any particular window or session.
  There is only one set of these. This includes things like the
  `default-terminal`, `escape-time` and the tmate server.
- _Session_ options which apply to __???__. The global set provides the
  defaults; these can be overridden by the (often empty) list of local
  options.
- _Window_ options apply to individual windows within a session and also
  have a global set with optional overrides from a local set.

XXX `tmate set-option ...` works from the command line for curren thing
XXX global vs. session vs. window options
XXX `-g`/`-s` make no diff; option names are disjointed and `-s` will
  set a global option if you give it a global option name
XXX `show-options` shows nothing without `-g` or `-s` (or other opt?)
XXX `escape-time` global option in milliseconds
https://downloads.haskell.org/~ghc/9.2.1-rc1/docs/html/users_guide/phases.html?highlight=main#ghc-flag--main-is%20%E2%9F%A8thing%E2%9F%A9

_Global options_ do not apply to a 

Server

- `set`/`set-option` sets a session option by default.
  - `-s` sets a server option
  - `-g` sets a global session or window option.
  - `-w` sets a window option (same as `set-window-option`).
  - `-u` unsets an option.

It sets a session option by
default, a window option 

Options to it are:
- `-w`: equivalant to the `set-window-option` command.


`~/tmate.conf`:

    # tmux display things in 256 colors
    set -g default-terminal "tmux-256color-italic"

    set-option -ga terminal-overrides ",xterm-256color-italic:Tc"

Tmate uses the xterm title as the initial status bar title.

### Delay on Esc



<!-------------------------------------------------------------------->
[delay]: https://www.reddit.com/r/vim/comments/40257u/delay_on_esc_with_tmux_and_vim/
