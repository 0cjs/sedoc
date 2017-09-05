Git Commits
===========

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


[`git commit-tree`]: https://git-scm.com/docs/git-commit-tree
[`git write-tree`]:  https://git-scm.com/docs/git-write-tree
