Vim Editor
==========

The most comprehensive manual is the built-in `:help`. But checking
[Learn Vimscript the Hard Way][hardway] first may be a better way to
get in to a particular area.

Finding help topics:
- `:help foo` or `:help :foo` for command `:foo`
- `:help 'foo'` for option set with `:set foo`

Docs:
- <https://www.vim.org/docs.php>
- [The latest help files][:help] on the web.

#### OS Packages

Debian and derivatives may come with only `vim-tiny` installed, which
leaves out so much stuff that it's hardly Vim anymore. Instead try to
make sure you have `vim-nox` (for non-X11/GUI systems) or `vim-gtk`
(which also includes the full shebang for terminal use).


Vim Configuration and Plugin Files
----------------------------------

#### Packages of Configuration/Plugins/etc.

Pre-8.0, [Pathogen] was the most popular of many bundling systems. 8.0
has built-in support for [`*packages*`] which is very similar.
(Pathogen can help transition to this with `pathogen#infect()` on
older versions of Vim.)

[`*packages*`] are in individual subdirectories with arbitrary names
(here called `$pkg`) under `~/.vim/pack/` and any other directories in
`&packpath`.

#### Finding and Running Scripts

[`*using-scripts*`] describes the following commands.

- `:scr[iptnames]`: Print all sourced script names in order first sourced.
  The number is the script ID, `<SID>`.

- `:so[urce] FILE`: Read lines of Ex commands (starting with `:`) from
  _FILE_. User supplies input to commands needing it; e.g., `:ls<CR>`
  will wait for user to hit Enter. This can be nested about 15 levels deep.

- `:so[urce]! FILE`: Read chars of Vim (normal mode) commands and input
  from _FILE_. E.g., `:ls<CR>` will consume next `<CR>` from file for
  "hit-enter" prompt. With `:{global,argdo,windo,bufdo}`, in loop or with
  following command, display will not be updated until complete.

- `:run[time][!] [WHERE] FILE …`: Search `runtimepath` for each _FILE_ and
  execute first one (with `!`, all) found. Globs expand to all matching
  files. `verbose=1` prints not-found files, `2` prints each file executed.
  _WHERE_ changes the search path to:
  - `START`: Under `start/` in `packpath`
  - `OPT`: Under `opt/` in `packpath`
  - `PACK`: Under `start/` and `opt/` in `packpath`
  - `ALL`: In `runtimepath` then under `start/` and `opt/` in `packpath`

- `:pa[ckadd][!] DIR`:
  - Search for `pack/*/opt/DIR/` in `packpath`
  - Add it to `runtimepath`, and `pack/*/opt/DIR/after/` to end.
  - Stop here if `!` specified. (Setup for later load by [`*load-plugins*`]
    or no load with `--noplugin`.)
  - Execute all `DIR/plugin/**/*.vim`.
  - If not yet `:syntax enable` or `:filetype on`, also execute
    `DIR/ftdetect/*.vim`

- `:packl[oadall][!]`: Update `runtimepath` and load all packages in
  `start/` under each entry in `packpath`. Normally done automatically
  during startup. No-op on second call unless `!` given.

Other notes on script files:

- `\` at start of line (leading whitespace ignored) indicates
  continuation of the previous line. (`:set cpoptions+=C` will turn
  this of so you can use `:append` and `:insert`. For functions, this
  must be set during definition, not execution.)
- In thise scripts, [`*cmdline-special*`] substitutions are useful.
- Generally, use only newline line terminators on all platforms. See
  `:help :source_crnl` for more detailed information.

#### Package Dirs

See [`*packages*`] and <https://shapeshed.com/vim-packages/>.


Command-line Special Chars/Words
--------------------------------

XXX fill in from [`*cmdline-special*`].


Scripting
---------

[Vim script] is terrible and massively inconsistent. Consider using
the Python plugin (see below) or [NeoVim] if you need to do anything
serious. Debian `vim-{nox,gtk}` packages include support for scripting
with Lua, Perl, Python3, Ruby and TCL.

The following needs to be filled out with a summary of [`*eval.txt*`].

#### Misc.

- Comments start with `"` (but not midline in certain commands)
- `map` commands and one or two others are special; they cannot use
  midline comments and need the command separator `|` escaped.

Encoding:
- BOM is automatically recognised.
- `:scriptencoding ENC` specifies the encoding of the following part of the
  script, to the next `:scripte`. Empty _ENC_ for no conversion. Lines that
  cannot be converted are kept unchanged. No error message or conversion
  when not supported.

#### Types and Literals

Values are coerced, ignoring trailing rubbish, to match the operator
type, e.g., `:echo '2a' + "3b"` will print `5`. Operators are specific
to types, e.g., `+` for ints but `.` for string concatenation.

Most operators can be used in `<op>=` form.

- string
  - literals are `"…"` with backslash escapes or `'…'` without.
  - Operators: `.` concatenation
- int

#### Variables

Vimscript variables are referred to as [`*internal-variables*`].
Variable names may include segments in braces `foo_{…}_bar` that will
have the expression … substituted. [`*curly-braces-names*`].

[`:let`] sets vars and [`:unlet`] destroys them. Using a
nonexistent/destroyed name will give an error.

Variable namespace is determined by prefix:
- `v:`: global, predefined by Vim
- `g:`: global
- `s:`: local to `:source`'d script
- `l:`, `a:`: In a function, local or argument
- `b:`, `w:`, `t:`: current buffer, window, tab page

#### Control Structures

Commands:
- `:finish`: Returns from a script being sourced. All pending
  `:finally`/`:endtry` sections are executed before returning.


Python Plugin
-------------

With both Python 2 and 3 support compiled in, the interpreter version
you want to use for that session must be loaded dynamically, so most
distros include support only for Python 3. Anywhere you see the `:py`
etc. command used, substitute `:py3` instead.

    :py3 import sys; print(sys.version)



<!-------------------------------------------------------------------->
[:help]: https://vimhelp.org/
[NeoVim]: https://neovim.io/
[Pathogen]: https://github.com/tpope/vim-pathogen
[Vim script]: https://en.wikipedia.org/wiki/Vim_(text_editor)#Vim_script
[`*cmdline-special*`]: https://vimhelp.org/cmdline.txt.html#cmdline-special
[`*eval.txt*`]: https://vimhelp.org/eval.txt.html
[`*internal-variables*`]: https://vimhelp.org/eval.txt.html#internal-variables
[`*load-plugins*`]: https://vimhelp.org/starting.txt.html#load-plugins
[`*packages*`]: https://vimhelp.org/repeat.txt.html#packages
[`*using-scripts*`]: https://vimhelp.org/repeat.txt.html#using-scripts
[`:let`]: https://vimhelp.org/eval.txt.html#%3Alet
[hardway]: http://learnvimscriptthehardway.stevelosh.com/
