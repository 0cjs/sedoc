Editors
=======

OS is the primary one associated with the editor; ports may be available.
Only lead author given.

Vi family (also see vile's [About _vi clones_][vile vi-clones]):
- vi (1976, Unix, Bill Joy)
- [Elvis][] (multi-OS, 1990, Steve Kirkendall)
- [vile](#vile) (multi-OS, 1991, Paul Fox, Thomas Dickey)
- [Vim][] (multi-OS, 1991, Bram Moolenaar)
- nvi (Unix, 1994, Keith Bostic)

Emacs family:
- [Emacs][] (multi-OS, 1976, David Moon and Guy L. Steele Jr.)
- [XEmacs][] (multi-OS, 1991, Lucid)

Others in modern use:
- [Sam](#sam) (Plan 9, 1987, Rob Pike)
- [Vis](#vis) (POSIX, 2014, Marc André Tanner)
- [Kakoune](#kakoune) (ncurses, 2018, Maxime Coste)

Retrocomputing:
- [`ed`][] (Unix, 1969, Ken Thompson) Still in POSIX; required by SUS.
- `ED` (CP/M, 1974, Gary Kildall)
- [`EDLIN`][] (86-DOS/MS-DOS, 1980, Tim Paterson) Still included in MS
  32-bit OSes.

Papers on editing:
- Christopher W. Fraser. 1980. ["A generalized text editor"][fraser80].
  Commun. ACM 23, 3 (March 1980), 154–158.


Detailed Summaries
------------------

### vile

[vile][] ([homepage][vile home], "Vi Like Emacs," has no connection with
Emacs: it's a stand-alone program with the "finger-feel" of vi but adding
features from Emacs that did not exist in vi or its [clones][vile
vi-clones] at the time. It was originally based on an early version of
MicroEmacs; neither MicroEmacs nor vile use a Lisp-like extension language.
though vile's textual commands have something of the feel of those of Emacs
and vile has "majormodes." (Source: [What is ᴠɪʟᴇ?][vile faq].)

    store-procedure write-msg-tst "displays test message"
        write-message "this is a test macro"
    ~endm
    bind-key write-msg-tst #h

Highlighting is done via [syntax filters][vile synfil] that read a file and
return markup for the editor to interpret for display. Filters are
typically written in lex.

### Sam

[Sam], written by Rob Pike for Plan 9. 33 commands, highly orthogonal. Two
processes: a graphical front-end (_terminal_) send text-based commands to a
backend (_host_) that handles the file. Changes can be initiated by either
process and the other will sync with it. ([Acme]'s backend uses the same
command language.)

Ed is line oriented, iterating commands (e.g., substitute) over lines of
text. Sam is similar but "selection" oriented, using (often recursive)
[_structural regular expressions_][sre] to select blocks of text over which
to iterate commands. These can be applied to filename specification as well
to handle multiple files. Essentialy, a sequence of regexp-commands builds
up a view of data that eventually results in the match(es) to be worked on;
these can be iteratively modified until the correct view is found and then
the command executed.

References:
- [Web site](http://sam.cat-v.org/)
- [The Text Editor `sam`][sam paper] original paper from _Software—Practice
  and Experience_, Vol 17, number 11, pp. 813-845, November 1987.
- [Commands cheatsheet][sam refcard] (PDF)

### Vis

([GitHub][vis].)
- Extends vi's modal editing w/support for multiple cursors/selections.
- Adds [sam](#sam)'s structural regular expression-based command language.
- Syntax highlighting with parsing expression grammars in Lua via LPeg.
- Clipboard and digraph handling provided by independent utilities.
- Will not implement tabs/multiple workspaces/advanced window management.

### Kakoune

[Kakoune][kak home] ([GitHub][kak gh]) (command `kak`, config
`~/.config/kak/kakrc`) uses vi's "keystrokes as a text editing language"
model but with much more orthogonal selection semantics. (This makes the
"syntax" of edit mode rather different from vi.) It works works on multiple
selections, each with an anchor and a cursor. A good set of "object
selection" (sentences, paragraphs, etc.) commands is available, including
user-defined object (prompting for open/close text).

It uses a client-server architecture with multiple clients allowed on a
single server. It does not support any windowing, relying on an external
window manager to handle this. Used by [nishantjr].


Editor Feature Discussion
-------------------------

### Efficiency

Since I do a _lot_ of text editing (it is probably my primary
computer-related activity after reading), having efficient commands for
movement and changing text is a big win. This includes a wide variety of
structural movement and selection commands (words of various kinds,
multiple lines, paragraphs, bracket-delimited blocks, columnar text, etc.)
and the ability to define domain-specific command (e.g., in a Markdown file
find the definition of a reference under the cursor and copy its URL to the
system clipboard).

Many editors provide only a bare minimum of the simplest such commands and
require moving far from the keyboard home row even for basic commands such
as moving the cursor left or right a single character. (I call such editors
"arrow key editors.") While easy to use, they are very inefficient for even
trivial edits, and not suitable for use as a primary editor for someone who
spends a lot of time editing.

### Availability

I frequently use systems not over which I have little control, such as
other organizations' Internet-connected hosts and other developers' desktop
systems when pair programming. Using a personal editor that's not widely
available (and often installed) on other systems requires more frequent use
of a different editor; the hit from this (particularly if I'm forced to use
an "arrow key editor") outweighs the benefits from  using an editor that
provides only moderate advantages over Vim.

Using Vim without my customizations is a definite hit to productivity, but
I have [a system][dot-home] that allows me easily to fetch my [full Vim
configuration][dot-home cjs0] and turn it on and off on the fly.

### Window Management

Like many developers, I use two window systems simultaneously, in my case
Fvwm and Vim. (Other common combinations are an X11 window
manager/Microsoft Windows/MacOS and tmux or Emacs; some developers may even
use three, such as a graphical WM, tmux _and_ Vim or Emacs.)

Having a window system at least somewhat integrated with the editor seems
necessary for efficient handling of multiple files. (This is frequent;
simultaneously editing separate program code and test code files is
exceedingly common, and almost as common is needing to edit/view multiple
program text and documentation files.) Consider, for example, the
difficulty of implementing my [`q^N`][dot-home cjs0 q^N] command (split the
current window into two, move to the new window and switch to the next file
in the list of files to be edited) in [Kakoune](#kakoune)

Having a text-based windowing system (such as Vim or tmate) is usually a
requirement for working on remote machines where the connection (SSH) is
usually text-based.



<!-------------------------------------------------------------------->
[Elvis]: https://en.wikipedia.org/wiki/Elvis_(text_editor)
[vim]: ./vim.md

[emacs]: ./emacs.md
[xemacs]: https://en.wikipedia.org/wiki/XEmacs

[`EDLIN`]: https://en.wikipedia.org/wiki/Edlin
[`ed`]: https://web.archive.org/web/20000520043710/http://swarm.cs.wustl.edu/~jxh/ed.html

[fraser80]: https://doi.org/10.1145/358826.358834

<!-- Detailed Summaries -->

[vile faq]: https://invisible-island.net/vile/vile.faq.html
[vile home]: https://invisible-island.net/vile/
[vile synfil]: https://invisible-island.net/vile/filters.html
[vile vi-clones]: https://invisible-island.net/vile/vile.faq.html#vi_clones
[vile]: https://en.wikipedia.org/wiki/Vile_(editor)

[acme]: https://en.wikipedia.org/wiki/Acme_(text_editor)
[sam paper]: http://doc.cat-v.org/plan_9/4th_edition/papers/sam/
[sam refcard]: http://sam.cat-v.org/cheatsheet/sam-refcard.pdf
[sam sre]: http://doc.cat-v.org/bell_labs/structural_regexps/
[sam]: https://en.wikipedia.org/wiki/Sam_(text_editor)

[vis]: https://github.com/martanne/vis

[kak gh] https://github.com/mawww/kakoune
[kak home]: http://kakoune.org/
[nishantjr]: https://github.com/nishantjr/dot-files/blob/master/dot/config/kak/kakrc

<!-- Editor Feature Discussion -->
[dot-home cjs0 q^N]: https://github.com/dot-home/cjs0/blob/6fbbca0d44c53264d2991d7158c9c7e4b8484fb6/dot/vim/cjs.d/main.vim#L294
[dot-home cjs0]: https://github.com/dot-home/cjs0
[dot-home]: https://github.com/dot-home
