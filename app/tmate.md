Tmate
=====

`~/tmate.conf`:

    # tmux display things in 256 colors
    set -g default-terminal "tmux-256color-italic"

    set-option -ga terminal-overrides ",xterm-256color-italic:Tc"

Tmate uses the xterm title as the initial status bar title.
