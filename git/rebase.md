Rebasing in Git
===============

Basic Rebasing
--------------

The following two commands are equivalant:

    git rebase upstream devbranch
    git rebase --onto upstream $(git merge-base upsteam devbranch) devbranch

`git rebase upstream` takes all commits from `HEAD` that do not exist
on the `upstream` branch and re-applies them following `upstream`.
(`upstream` defaults to the upstream defined by
`branch.<name>.{remote,merge}`.)

`git rebase --onto upstream forkpoint` option applies the commits onto
`upstream` as above, but takes only commits `forkpoint..HEAD`. See
below for examples/situations for using this.

The procedure this command follows is:
1. Checkout `devbranch`.
2. Set `ORIG_HEAD` to `HEAD`.
2. Reset the current branch to _upstream_.
3. For each commit `forkpoint..ORIG_HEAD` apply it to `HEAD` à la `cherry-pick`.
4. Skip any commits that would produce no textual changes on `HEAD`
   (i.e., the changes are already included in _upstream_).
5. Stop on merge failures for manual fixes.

The standard merge strategy is `recursive`, which will normally stop
for manual resolution when there's a conflict. This can be overridden
with `-Xours` or `-Xtheirs`, automatically taking content from the
specified side in the case of a conflict. During rebases as described
above, remember that `ours` is _upstream_, onto which you're rebasing,
and `theirs` is the dev branch, `ORIG_HEAD`. (This is the opposite of
the meaning during `git merge`.)

#### Handling Conflicts

When you're in a conflicted state, you can also use `git checkout
--ours .` (take all changes from _upstream_) or `git checkout --theirs
.` (take all changes from _devbranch_). Note that these must have a
path specified, otherwise you will get an error `--ours/--theirs'
cannot be used with switching branches`. (For more details, see the
message from Jeff King in [git checkout --theirs
fails][co-theirs-fails].

The recursive merge strategy also offers `-Xignore-space-change` etc.


Using --onto
------------

Take the last few commits on a branch onto the upstream:

    git rebase --onto origin/master @~5     # Take last five commits

Especially useful when someone else has force-pushed your dev branch
but you also have new commits and so can't just `git reset --hard
@{upstream}`. This avoids redoing conflict resolution and
reintroducing commits that were removed:

    git rebase --onto @{u} @~2              # Keep my last two commits

Remove commits in the middle of a branch:

    git rebase --onto dev~5 dev~3 dev       # Remove dev~4 and dev~3

Also see [`git-rebase(1)`] manpage section ["Recovering from Upstream
Rebase"][recovering].



[`git-rebase(1)`]: https://git-scm.com/docs/git-rebase
[co-theirs-fails]: http://git.661346.n2.nabble.com/git-checkout-theirs-fails-td7650612.html
[recovering]: https://git-scm.com/docs/git-rebase#_recovering_from_upstream_rebase
