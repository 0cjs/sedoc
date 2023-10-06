GitHub Tips and Tricks
======================

### Special URLs

Appending `/stargazers` after the repo name shows everybody who's starred
the repo. (This is linked from "n Stars" in the About panel.)

GitHib creates "invisible" branches for pull requests. Doing a
`git fetch origin pull/###/head` will leave the `FETCH_HEAD` set
to the head of a branch for the code for that PR.
