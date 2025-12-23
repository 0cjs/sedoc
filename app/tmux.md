tmux/tmate
==========

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

### Commands

Character Commands:
- `◆:` enter command line
- `◆;` move to the previously active pane.
- `◆o` select next pane in current window

Command-line commands:
- `:resize-pane`:
  - `-Z` zoom current pane to fill window
  - `-y N` resize to _n_ lines high
