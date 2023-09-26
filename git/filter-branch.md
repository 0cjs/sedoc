Git filter-branch
=================

### Environment

    git filter-branch --env-filter 'env | grep ^GIT' @^..@

will show something like:

    GIT_DIR=/home/cjs/co/a-repo/.git
    GIT_INDEX_FILE=/home/cjs/co/a-repo/.git-rewrite/t/../index
    GIT_WORK_TREE=.
    GIT_COMMIT=8ded10f5d924e3200f4949ead5fcd3457504a65b
    GIT_AUTHOR_NAME=Curt J. Sampson
    GIT_AUTHOR_DATE=@1504599417 +0900
    GIT_AUTHOR_EMAIL=cjs@cynic.net
    GIT_COMMITTER_NAME=Curt J. Sampson
    GIT_COMMITTER_EMAIL=cjs@cynic.net
    GIT_COMMITTER_DATE=@1504599417 +0900

The setup (`git filter-branch --setup`) has less:

    GIT_INTERNAL_GETTEXT_SH_SCHEME=gnu
    GIT_DIR=/home/cjs/co/../cjs/a-repo/.git
    GIT_INDEX_FILE=/home/cjs/co/a-repo/.git-rewrite/t/../index
    GIT_WORK_TREE=.


Procedures
----------

### Rewrite Commit Metadata (Author, etc.)

To rewrite the author and timestamp of a commit (using the filter-branch
variables above if set):

      git commit --amend --reset-author

### Create New Repo from Subdirectory

Per the manpage, to rewrite the repository to look as if `foo/bar/` had
been its project root, and discard all other history:

    git filter-branch --subdirectory-filter foo/bar -- --all

If you don't want to make `foo/bar/` the new root, you'll need to use
`--tree-filter` instead. See [[so 3142419]] about that and other ideas.

### Removing All But Certain Files

Create a pathspec file (documented in `gitglossary(1)`) containing, e.g.:

    :!:.gitignore
    :!:README.md
    :!:Test
    :!:dir-I-want-to-keep/
    *

and use it with a an index filter, to avoid having to do checkouts of
files (and thus speeding things up greatly):

    git filter-branch --prune-empty --index-filter \
        'git rm --cached --ignore-unmatch --pathspec-from-file psfile'

Further cleanup may be necessary; this can be done with something like the
following to avoid having to re-merge every commit, where `f0160bd` is some
very early commit (typically the second in the new branch).

    git rebase -i --empty=drop -s recursive -X theirs f0160bd



<!-------------------------------------------------------------------->
[so 3142419]: https://stackoverflow.com/q/3142419/107294
