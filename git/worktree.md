Git Worktrees
=============

[Manpage][wtman].

Essentially, on bare repo with many working copies; saves space on disk for
large repos. (Any other advantages?) There were some interesting issues
with this in the past when I used it that I don't remember now.


Worktree Subdir Approach
------------------------

Interesting approach [by Alex Russell][russ]:

    mdcd …/project
    git clone --bare …/project.git .bare
    echo >.git ./.bare
    git worktree add main       # `main` specifies directory _and_ branch
    git worktree add dev/…/…    # dunno what happens here w/all the slashes



<!-------------------------------------------------------------------->
[wtman]: https://patio.ica.coop/chat/tech-coops/pl/a64fmfjf1td8dxsw9wk1g7bmny

[russ]: https://infrequently.org/2021/07/worktrees-step-by-step/
