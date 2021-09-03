GitHub Tips and Tricks
======================

GitHib creates "invisible" branches for pull requests. Doing a
`git fetch origin pull/###/head` will leave the `FETCH_HEAD` set
to the head of a branch for the code for that PR.
