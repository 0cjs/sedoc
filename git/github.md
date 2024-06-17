GitHub Tips and Tricks
======================

### Special URLs

Appending `/stargazers` after the repo name shows everybody who's starred
the repo. (This is linked from "n Stars" in the About panel.)

GitHib creates "invisible" branches for pull requests. Doing a
`git fetch origin pull/###/head` will leave the `FETCH_HEAD` set
to the head of a branch for the code for that PR.


GitHub Markdown Rendering
-------------------------

The GitHub web site renders `.md` files in repos, issues, pull requests,
discussions and wikis using [GitHub-flavoured Markdown][gfm]. Additionally,
[math markup][gfmath] is allowed; this is [LaTeX-formatted math][latex]
rendered using [Mathjax]. Note that GitHub has particular configuration of
Mathjax (e.g., with `$` enabled for math mode?), and you need to know this
as well as Mathjax generalities.

Delimiters are:
- Inline: `$` … `$` (not default; enabled on GitHub? Escape `$` as `\$` in ….)
- Escape above with `<span>$</span>` (only in lines with a math expression?)
- Inline: `` $` `` … `` `$ ``
- Display (block): `$$` …lines… `$$`
- Display (block): ` ```math` `\n` …lines…  `\n` ` ``` `



<!-------------------------------------------------------------------->
[Mathjax]: https://docs.mathjax.org/en/latest/input/tex/
[gfm]: https://github.github.com/gfm/
[gfmath]: https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/writing-mathematical-expressions
[latex]: http://en.wikibooks.org/wiki/LaTeX/Mathematics
