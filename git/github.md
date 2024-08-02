GitHub Tips and Tricks
======================

### Terminology

The _NAME_ in `https://github.com/ORG/NAME` is a "repo"; this includes not
only the Git repo itself (which may be empty of objects) but the
issues/PRs, "Projects" (tables to sort issues/PRs), Wiki, and all metadata.

__Note:__ "Project" has a different meaning from GitLab, where a "project"
is a GitHub "repo."

### Special URLs

Appending `.keys` to a GitHub user URL gives the SSH public keys
that a user has authorised for access to the account. E.g.,
<https://github.com/InnovativeInventor.keys>.

Appending `/stargazers` after the repo name shows everybody who's starred
the repo. (This is linked from "n Stars" in the About panel.)

GitHib creates "invisible" branches for pull requests. Doing a
`git fetch origin pull/###/head` will leave the `FETCH_HEAD` set
to the head of a branch for the code for that PR.

### Forked Repos

Forked repos have many restrictions:
- A fork of a private repo must remain private.
- A private fork (XXX and public?) cannot be transferred to another
  user/org.


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


GitHub Merging
--------------

- "Rebase merge" createes new commits from the branch commits even when a
  rebase isn't necessary; that changes only the committer timestamps.


Actions
-------

Workflows contain jobs, jobs run steps that execute actions. Actions can be
comprised of additional steps.



<!-------------------------------------------------------------------->
[Mathjax]: https://docs.mathjax.org/en/latest/input/tex/
[gfm]: https://github.github.com/gfm/
[gfmath]: https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/writing-mathematical-expressions
[latex]: http://en.wikibooks.org/wiki/LaTeX/Mathematics
