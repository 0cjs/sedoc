Radare2
=======

A good inspection tool for binary files, disk images, etc. (Kind of a
super `od` or `xxd`.) Has an excellent visual mode. Disassembly good
for fragments of code, but not for full reverse-engineering of a ROM
image.

- [Website]
- [GitHub repo `radare/radare2`][repo]
- [Radare2 Book][book-html] (HTML edition)
- [Reference Card (`doc/intro.md`)][doc-ref]
- [Reference Card from Book][book-ref] (substantially different)
- [Misc. docs on specific topics (`doc/`)][doc]


Installation
------------

Clone the repo and run `sys/user.sh --install-path ~/opt/radare2`.
To add it to your environment:

    export LD_LIBRARY_PATH=~/opt/radare2/lib/
    prepath ~/opt/radare2/bin

`r2` Prints a fortune on startup, prefixed by `--`.


Command Line Commands
---------------------

Used in "interactive" command-line mode and for scripting.
(In scripting `;` separates commands.)

Numeric Entry:
- Numbers default to decimal; prefix `0x` for hex.
- Prepending `..` to a number (or label?) will take the remainder
  as a replacement for the right-hand segment of that length of
  some current value, e.g., `s ..c000` to seek to `0x0012c000`
  if the current position is `0x0012xxxx`, and `omb. ` Does not
  work with `@` modifier.

General:
- Help often given by `?` in various places:
  - Command line in command/subcommand letter position: `?`,`pd?`, `~?`.
  - Various positions for setting config vars with `e`; see `e?`.
  - Grep (`~PAT`) can be useful for searching help output.
    Good for settings: `e scr. ~vi`
- Format: `[.][times][cmd][~grep][@[@iter]addr!size][|>pipe] ;`.
  - `times`: Numeric repeat count
  - `~PAT`: grep output; can select cols of binary data, etc.
  - `@` gives temporary offset; original offset restored after.

Setup commands:
- `e`: settings. `e asm.` to display all `asm.*` vars.
  `Ve` to enter visual mode config editor.
  `e.asm.arch=m680x` to set 6800 disassembly.
- `i`: info about file
- `om`: map offsets. `om`, `om=` to list.
  `omb. 0xNNNN` to relocate current map.
- `b`: get/set block size

Arithmetic:
- `??`: show value of last operation (`$?` variable)
- `?v `: (note space) show value of any expression (`?v?` for help).
  `?v 30` converts to hex 0x1e,
  `?vi 0xAA` converts to decimal 170,
  `?v $b` shows blocksize.
- Expressions also usable elsewhere, e.g. with `s`eek.
  Some relative, `s+$b` to seek forward one page.
- `?`: evaluators; `???` for help (because `??` is last value eval'd)

Movement Commands:
- `s`: seek to location. (Use `@` above for one-off offset.)
  - `s-`, `s+` to go "undo" to previous pos, redo to next pos.
  - `s++`, `s--`: blocksize seek
  - Various searching functions available.

Examination commands:
- `p`: examine (print) data.
  - `px` hexdump (`xc` also, which adds comments for flags)
  - `pd` disassembly; -N for # instrs backwards
  - `pi` instructions; usu. use `pd`, but `piu` to `RTS` is useful
- Flag-related examination:
  - `fx` hexdump from flag location
- `V`: enter visual mode (see below)

Some examination options:
- `asm.describe`: Describe what each instruction does.

Searching:
- `izz`: search for strings in the whole binary (search results with `~`)
  - `e bin.str.purge=?` for info on purging strings; `iz-` appends to it

#### Flags

Flags are basically labels, but may include other information
such as a length and comment.

A flag may be in the no-name flagspace or a named flagspace; one can
select a particular flagspace (except no-name) to show only those
flags, or all flagspaces (`*`). There is a stack for saving/restoring
previous current flagspaces. `fs?` for flagspace operations.

Disassembled branches will not show the flag name of a target, but
disassembled `JSR`s will have a comment above giving it.

Flags label areas of code/data:
- `f` list flags; `afl` list functions (flags in `function` namespace)
- `f name 12 @offset`: define flag _name_; optionally len _12_ at _offset_
- `fC name comment`: add _comment_ to flag; can print in disassembly
- `af+ $$ COUT`: add function manually

#### Comments and Area Definitions

`C` command.

E.g., `Cd 12 @ 0xFFFA` to define 6502 vectors as data.


Visual Mode Commands
--------------------

- `v` to enter. (Starts in panel mode; `!` to switch.)
- `q`/`Q` to quit tab/all tabs
- `?` for help. (`q` to back up in help)

#### Non-panel Mode Commands

Change current display (non-panel mode):
- `p`,`P`: rotate print modes
- `Tab`: next configuration of current print mode
- `\`: split/unsplit horizontally
- `m□`,`'□`: set/goto mark for key □

#### Panel Mode Commands

- `!`: enable/disable panels. (Default start is with panels enabled.)
- `Tab`: move to next panel.
- `X`: delete panel.
- `:`: enter command-line mode; empty line exits

Change current panel display:
- `"`: choose panel display from a list (hexdump, etc.)
- `D`: disassembly
- `e`: change title and command
- `|`,`-`: Vertical/horizontal display split

Current panel movement:
- `hkjl`,`HJKL`: 1 char/page in that direction
- `^F`,`^B`: forward/back a block
- `u`,`U`: undo/redo seek
- `g`,`G`: go (seek) given offset/end of file
- `^`,`$`: seek to beginning/end of curent map

Misc:
- `;`: Add comment


$ Variables
-----------

`?$?` lists meanings. `?v $$` prints a value. `$?` lists all values.

Useful vars are:

    $?  last operation value (show w/ `??` command)
    $$  current offset (use w/ e.g. `$$+4`)
    $b  block size (set with `b`)
    $M  map address
    $MM map size


Tips and Tricks
---------------



Configuration Files
-------------------

- `r2 -H` to list config env vars and their current path values.
- Global configs: `~/.config/radare2/radare2rc`,
  `~/.config/radare2/radare2rc.d/`
- Target file config: filename with `.r2` appended.



<!-------------------------------------------------------------------->
[book-html]: https://radare.gitbooks.io/radare2book/
[book-ref]: https://radare.gitbooks.io/radare2book/refcard/intro.html
[doc-ref]: https://github.com/radareorg/radare2/blob/master/doc/intro.md
[doc]: https://github.com/radareorg/radare2/tree/master/doc
[repo]: https://github.com/radareorg/radare2
[website]: http://www.radare.org/
