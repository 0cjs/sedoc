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

#### Automated Conflict Handling

The standard merge strategy is `recursive`, which will normally stop
for manual resolution when there's a conflict. This can be overridden
with `-Xours` or `-Xtheirs`, automatically taking content from the
specified side in the case of a conflict. During rebases as described
above, remember that `ours` is _upstream_, onto which you're rebasing,
and `theirs` is the dev branch, `ORIG_HEAD`. (This is the opposite of
the meaning during `git merge`.)

The recursive merge strategy also offers `-Xignore-space-change` etc.

#### Manual Conflict Handling

The following vim mapping will let you easily find conflict markers
in a buffer:

    noremap qv/ /^\(<<<<<<< .*\\|\|\|\|\|\|\|\| .*\\|=======\\|>>>>>>> .*\)$<CR>

When in a conflicted state you may also use:

    git checkout --ours   .     # Take all changes from upstream
    git checkout --theirs .     # Take all changes from _devbranch

These must have a path specified, otherwise you will get an error
`--ours/--theirs' cannot be used with switching branches`. (For more
details, see the message from Jeff King in [git checkout --theirs
fails][co-theirs-fails].


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


Git Interactive Rebase (`rebase -i`)
------------------------------------

### Splitting Commits

Commits can be split by marking them edit and, when editing, starting
with `git reset HEAD^`. This "rewinds" the HEAD and index to the
previous commit, leaving the changes from the commit being edited in
the work tree.
* `git add -p` etc. to generate a series of new commits that will
  replace the commit originally being edited.
* `git stash` to temporarily clean the work tree to test intermediate
  commits.
* When the working copy is clean, `git rebase --continue`

### Moving Code Forward to a Later Commit

To fix the earlier commit from which you want to remove code:
- `git rebase -i` selecting the commit from which to remove code and, if
  it's not the last commit on the branch, the commit to which the code
  should be added.
- `logb -1` and record the current commit ID.
- `git reset @^` to reset to the parent commit and leave the to-edit
  commit's changes in the work tree.
- `git add -p` etc. to stage the changes for the new version of the commit.
- `git commit -C` to generate a new commit w/the author/timestamp/message
  of the to-edit commit.
- `git commit` to generate a new commit with the material to be moved into
  the next commit.
- `git rebase --continue` to finish for the moment

Then to do the move forward:
- Interactive rebase: swap the order of the move-forward commit and the
  commit to receive the changes, and fixup the new second one.
- `stash save` after commiting the "remove code" commit and `stash apply`
  on the next commit.


<!-------------------------------------------------------------------->
[`git-rebase(1)`]: https://git-scm.com/docs/git-rebase
[co-theirs-fails]: http://git.661346.n2.nabble.com/git-checkout-theirs-fails-td7650612.html
[recovering]: https://git-scm.com/docs/git-rebase#_recovering_from_upstream_rebase
