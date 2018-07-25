Handy Git Tricks
================


Logging and Graph Exploration
-----------------------------

* To do a 'blame in reverse', e.g., to find out which commit deleted a
  line, use `git blame --reverse START.. PATH`. The file must exist in
  the START commit, so you may need to do a forward log to find where
  it was added.

* Find first ancestor of a <commit-ish> reachable by any other ref
  (commits that are on only "this" branch):

      git rev-parse --not --all | grep -v I | git rev-list --stdin I

  The above doesn't handle some corner cases; see this [SO answer](
  https://stackoverflow.com/a/13461275/107294) or the [post-receive-email](
  https://github.com/git/git/blob/master/contrib/hooks/post-receive-email#L292)
  script for more details.


Fixing Commits
--------------

* To rewrite the author and timestamp of a commit:

      git commit --amend --reset-author

* To remove a file accidentally added to a commit:

      git reset --soft @^
      git reset @ path/to/file
      git commit -c ORIG_HEAD

  From <https://stackoverflow.com/a/15321456/107294>.


Checking Line End Settings
--------------------------

For debugging Git [attributes], the `core.eol` and `core.autocrlf`
settings, etc., the `git ls-files --eol` option is very useful.

Normally `core.autocrlf` wants to be set to `input` to avoid any
conversions whatsoever.



[attributes]: https://www.git-scm.com/docs/gitattributes


