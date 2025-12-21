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

### Commands

Below , `◇` (digraph:Dw) indicates the prefix char.

Character Commands:
- `◇:` enter command line
- `◇;` move to the previously active pane.
- `◇o` select next pane in current window

Command-line commands:
- `:resize-pane`:
  - `-Z` zoom current pane to fill window
  - `-y N` resize to _n_ lines high
