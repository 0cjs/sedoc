Handy Git Tricks
================

* `git blame --reverse START..` to find out which commit
  after `START` deleted a line.

* Find first ancestor of a <commit-ish> reachable by any other ref
  (commits that are on only "this" branch):

      git rev-parse --not --all | grep -v I | git rev-list --stdin I

  The above doesn't handle some corner cases; see this [SO answer](
  https://stackoverflow.com/a/13461275/107294) or the [post-receive-email](
  https://github.com/git/git/blob/master/contrib/hooks/post-receive-email#L292)
  script for more details.
