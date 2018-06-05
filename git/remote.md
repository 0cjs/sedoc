Git Remotes, Fetching and Pushing
=================================

`git remote` provides the commands for manipulating local
configuration of remotes. It also offers some ability to fetch commits
from a remote (`git remote update`) but this has at this point seems
to have been [entirely superseded][so-17512004] by `git fetch` since
it gained the `--{all,multiple,prune}` options.

`git remote show` may contact the remote for just branch information
(without updating local tracking branches); this is probably better
done with `git ls-remote` when needed programatically.



[so-17512004]: https://stackoverflow.com/a/17512004/107294
