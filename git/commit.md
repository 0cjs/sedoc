Git Commits
===========

For some tips on fixing/rewriting commits, see [Handy Git
Tricks](tricks.md).


Plumbing
--------

The plumbing command to create a git commit is [`git commit-tree`]:

    git commit-tree <tree> [(-p <parent>)...] \
        [-S[<keyid>]] [(-m <message>)...] [(-F <file>)...]

Multiple `-m` arguments specify an ordered list of paragraphs in the
commit message. Stdin is used if `-mF` are not given or they result
in an empty message. (Use `</dev/null`) to get an empty message.)

Author and committer name/date information is taken in order from
`$GIT_{AUTHOR,COMMITTER}_{NAME,EMAIL,DATE}`, `user.{name,email}` and
`$EMAIL`. `<`, `>` and `\n` are stripped. Dates are formatted as
`@<unix-timestamp> <tzoffset>`, ISO-8601 or similar.

Show a raw commit with `git cat-file -p REF`.

[`git write-tree`] creates a tree from an index. The index must be in
a fully merged state.


Stash Commits
-------------

`git stash` stores its data as commits marked with the `refs/stash` ref;
multiple stashes are found through the reflog of `refs/stash`, e.g.:

    $ stash list
    stash@{0}: WIP on master: d569aec two
    stash@{1}: On master: stash2

The stash consists of several commits [2-3 of which are
new][stash-desc]:

1. _head_: The current `HEAD` commit when you stashed (pre-existing).
3. _untracked_: Optional; an orphan (parentless) commit containing a
   tree of all untracked files at the time of the stash. This is
   created only with the `-u` (untracked files) or `-a` (all files,
   untracked and ignored) options.
2. _index_: the staged commits (in the index) at the time of stash,
   with parents _head_ and, if present,  _untracked_.
3. _wc_: The working copy's tracked but unstaged files at the time you
   stashed, with parents _head_ and _index_.

[Diagram][stash-graph]:

           .----W----.
          /    /    /
    -----H----I    U

See also [more details on the stash algorithms][stash-algo].



[`git commit-tree`]: https://git-scm.com/docs/git-commit-tree
[`git write-tree`]:  https://git-scm.com/docs/git-write-tree
[stash-algo]: https://stackoverflow.com/a/20589663/107294
[stash-desc]: https://stackoverflow.com/a/41441118/107294
[stash-graph]: https://softwareengineering.stackexchange.com/a/326080/221703
