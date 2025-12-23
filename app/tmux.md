tmux/tmate
==========

Cheat Sheet
-----------

Handy Bindings:
- `◆:` enter command line
- `◆;` move to the previously active pane.
- `◆o` select next pane in current window

Handy commands:
- `:resize-pane`:
  - `-Z` zoom current pane to fill window
  - `-y N` resize to _n_ lines high


Introduction
------------

tmate is just tmux with the inter-server connectivity added.

A tmux/tmate _server_ runs a _session,_ a collection of ptys. Each session
has one or more _windows_ (which always take up the full "screen" of your
terminal); a window may be divided into separate _panes,_ each of which is
a separate pty.

Any number of tmux/tmate client instances may connect to the same session.
When all clients have disconected, the session ends. Starting tmux/tmate
normally starts a new server/session and becomes a client of it. (XXX
confirm this last bit.)

### Configuration

Tmux reads `~/.tmux.conf`. Tmate reads only `~/.tmate.conf`; to make it
additionally read the tmux conf, add `source-file ~/.tmux.conf`.

Any configuration file line can also be given on the tmux/tmate command
line for immeidate effect, e.g. `tmate source-file extra.conf`. This works
even in remote tmate sessions.

### Prefix Char

Below , `◆`¹ indicates the prefix char. This defaults to Ctrl-B (to avoid
collisions with Gnu Screen's Ctrl-A default, probably), but can be changed
with the following config.

    set-option -g prefix C-a
    unbind-key C-b              # prefix + Ctrl-B does nothing
    bind-key C-a send-prefix    # prefix + Ctrl-A sends Ctrl-A

- ¹ Ctrl-K digraph `Db` in Vim.

A second prefix key, `prefix2` may also be set. Both prefix settings accept
all standard key definitions (see below) and also `None` to indicate unbound.

### Commands

Commands (e.g., `bind-key`) have options and arguments, like Unix commands.
They may be given in configuration files, as command-line arguments to the
`tmux`/`tmate` commands and at the tmate internal command line brought up
with `◆:`.

### Key Bindings

- `◆:` enter command line
- `◆;` move to the previously active pane.
- `◆o` select next pane in current window


Key Bindings
------------

Key specifications may be prefixed with `^` or `C-` for control modifier
and `M-` for meta (Alt) modifier. The key names are as follows. Quotes must
be quoted in their opposite: `'"'` and `"'"`.
- Printing ASCII: letters/numbers/punctuation.
- Control chars: Space, BSpace, Tab, Enter, Escape, DC (Delete).
- Function keys: F1–F12
- Arrow keys: Up, Down, Left, Right
- Editing keys:  BTab, End, Home, IC (Insert), NPage/PageDown/PgDn,
  PPage/PageUp/PgUp.

Key bindings are stored in _key tables_; the two standard ones are `prefix`
(keys typed after the prefix char `◆`) and `root` (normal key input).
Additional key prefix tables may be created and the `switch-client -T`
command used to switch to them in key bindings.

For the copy/edit/choice modes, the key bindings are stored separately in a
_mode table,_ one of:
- `vi-copy` `emacs-copy`: Copy mode; see `copy-mode` command.
- `vi-choice` `emacs-choice`: Choosing from lists (e.g. `choose-window`).
- `vi-edit` `emacs-edit`: Editing at the command prompt.

### Commands Related to Key Bindings

* `bind-key [OPTS] KEY COMMAND [ARGS]` Create/change a key binding. Options
  are:
  - `-T KEY-TABLE`: Bind in the given key table (default `prefix`). `-n` is
    an alias for `-T root`.
  - `-t MODE-TABLE`: XXX write me.

* `unbind-key [-acn] [-t MODE-TABLE] [-T KEY-TABLE] KEY`. The `-a` option
  unbinds all keys.

* `list-keys [-t MODE-TABLE] [-T KEY-TABLE]`: List key bindings in the form
  used in the config file (i.e., `bind-key` commands). Limited to the
  specific mode and/or table if given. Bound to `◆?` by default.

* XXX To document: `send-keys`, `send-prefix`.


Copy Mode
---------

XXX write me.

* `copy-mode [-Meu] [-t TARGET-PANE]`: Enter copy mode:
  - `-u`: Scroll one page up after entry.
  - `-e`: Exit copy mode when user scrolls to end of buffer. This is
    disabled if a key other than those used for scrolling is pressed (note
    that `history-bottom` is not considered a scroll key); it's intended
    for quick scrollback-and-exit with `-eu`.
  - `-M`: Begin mouse drag (only if bound to a mouse key binding).
