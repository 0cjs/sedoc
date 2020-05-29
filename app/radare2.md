Radare2
=======

A good inspection tool for binary files, disk images, etc. (Kind of a
super `od` or `xxd`.) Has an excellent visual mode. Disassembly good
for fragments of code, but not for full reverse-engineering of a ROM
image.

- [Website]
- [GitHub repo `radare/radare2`][repo]
- [Radare2 Book][book-html] (HTML edition)
- [Reference Card][book-ref]


Installation
------------

Clone the repo and run `sys/user.sh --install-path ~/opt/radare2`.
To add it to your environment:

    export LD_LIBRARY_PATH=~/opt/radare2/lib/
    prepath ~/opt/radare2/bin

`r2` Prints a fortune on startup, prefixed by `--`.


Commands
--------

General:
- Numbers default to decimal; prefix `0x` for hex.
- `?` in command/subcommand letter position for help. `pd?`, `~?`.
  - Somtimes two question marks for more detailed help, `e asm.arch=??`.
  - Grep (`~PAT`) can be useful for searching help output.
- Format: `[.][times][cmd][~grep][@[@iter]addr!size][|>pipe] ;`.
  - `times`: Numeric repeat count
  - `~PAT`: grep output; can select cols of binary data, etc.
  - `@` gives temporary offset; original offset restored after.

Setup commands:
- `e`: settings. `e asm.` to display all `asm.*` vars.
  `e.asm.arch=m680x` to set 6800 disassembly.
- `i`: info about file
- `om`: map offsets. `om`, `om=` to list.
  `omb. 0xNNNN` to relocate current map.

Examination commands:
- `p`: examine (print) data. `px` hexdump, `pd` disassembly.
- `s`: seek to location. (Use `@` above for one-off offset.)
  - `s-`, `s+` to go "undo" to previous pos, redo to next pos.
  - `s++`, `s--`: blocksize seek
  - Various searching functions available.
- `V`: visual mode.

Other commands:
- `d` debugger.

### Visual Mode

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


Configuration Files
-------------------

- `r2 -H` to list config env vars and their current path values.
- Global configs: `~/.config/radare2/radare2rc`,
  `~/.config/radare2/radare2rc.d/`
- Target file config: filename with `.r2` appended.



<!-------------------------------------------------------------------->
[book-html]: https://radare.gitbooks.io/radare2book/
[book-ref]: https://radare.gitbooks.io/radare2book/refcard/intro.html
[repo]: https://github.com/radareorg/radare2
[website]: http://www.radare.org/
