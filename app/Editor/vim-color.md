Vim Colors and Syntax Highlighting
==================================

`:set background=light` / `:set bg=dark`) informs Vim what terminal
background colour should be assumed (it does not change it).
- If `g:colors_name` is set, the colorscheme will be reloaded.
- Syntax not reloaded; use `syntax on` if necessary
- `:set background&` (to default) makes Vim guess
  (reliable in Gvim, requested via `t_RB` otherwise)


Colorschemes
------------

`g:colors_name` is a global variable containing the current colorscheme
  name; if not set the coloscheme is "default". Colorschemes are expected
  to set this in their `colors/myscheme.vim` init file (`let colors_name =
  "myscheme"`).

`:colorscheme` (`:colo`) is essentially just `:echo g:colors_name`,
printing `default` if `g;colors_name` is not set.

`:colorscheme {name}`  searches the runtime path/plugins for `colors/{name}.vim`
and runs it. It's not special beyond the following (in particular note it
does not set/use `g:colors_name`):
- _{name}_ `default` goes back to Vim default (from $VIMRUNTIME?)
- Does not work recursively (use `:runtime` instead)
- `|ColorSchemePre|` autocommand triggered before loading
- `|ColorScheme|` autocommand triggered after loading


### Examples and Further Information

The [solarized] colorscheme seems to be a good example of how to write a
colorscheme. The calling sequence it uses is

    syntax enable
    set background=light
    colorscheme solarized

Handy hints from the source code:

    " Useful commands for testing colorschemes:
    :source $VIMRUNTIME/syntax/hitest.vim
    :help highlight-groups
    :help cterm-colors
    :help group-name

    " Useful links for developing colorschemes:
    http://www.vim.org/scripts/script.php?script_id=2937
    http://vimcasts.org/episodes/creating-colorschemes-for-vim/
    http://www.frexx.de/xterm-256-notes/"


Syntax Highlighting
-------------------

If `g:colors_name` is not set, loading a new file seems to use the default
highlighting rather than what's set in `.vimrc`. I dealt with this by just
extracting all my `highlight` commands to `colors/cjs.vim`, adding `let
g:colors_name = 'cjs'` to it, and loading it from my vimrc.



<!-------------------------------------------------------------------->

<!-- Colorschemes -->
[solarized]: http://ethanschoonover.com/solarized
