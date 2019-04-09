Vim Editor
==========

The most comprehensive manual is the built-in `:help`. But checking
[Learn Vimscript the Hard Way][hardway] first may be a better way to
get in to a particular area.

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

XXX

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
[`*eval.txt*`]: https://vimhelp.org/eval.txt.html
[`*internal-variables*`]: https://vimhelp.org/eval.txt.html#internal-variables
[`*packages*`]: https://vimhelp.org/repeat.txt.html#packages
[`:let`]: https://vimhelp.org/eval.txt.html#%3Alet
[hardway]: http://learnvimscriptthehardway.stevelosh.com/
