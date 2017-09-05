Rebasing in Git
===============


Regular vs. "Onto" Rebasing
---------------------------

`git rebase BASE` takes _all_ commits from `HEAD` (back to the initial
commit) that do not exist on the `BASE` branch and re-applies them
following `BASE`. (`BASE` defaults to the upstream defined by
`branch.<name>.{remote,merge}`.)

The `--onto NEWBASE` option applies the commits to follow `NEWBASE`
instad of `BASE`, in which case `BASE` is only used to determine the
commits that will be applied, as above.

In the typical case of a force-pushed dev branch, rebasing the old
version on to the new will re-introduce commits that were removed. If
you don't have any new commits you've added all you need to do is
reset your head to the tracking head (with `git reset --hard
@{upstream}`), throwing away everything on your local branch. To
maintain your additional commits, transplant your commits _from_ that
point from their parent commit to a new parent commit:

    #                 new-base   old-base
    git rebase --onto origin/foo origin/foo@{1}

For more details, see [`git-rebase(1)`] manpage section ["Recovering
from Upstream Rebase"].



[`git-rebase(1)`]: https://git-scm.com/docs/git-rebase
[recovering]: https://git-scm.com/docs/git-rebase#_recovering_from_upstream_rebase
