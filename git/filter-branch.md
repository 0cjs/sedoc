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

