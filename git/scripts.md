Writing Git Scripts/Commands
============================

You can add a `git foo` command by writing a `git-foo` script and
putting it in to your path; this is typically used to make new
"porcelean" scripts that in turn rely on the plumbing commands.

To add useful functions, source [`git-sh-setup`]:

    . "$(git --exec-path)/git-sh-setup"`

[`git-sh-setup`]: https://git-scm.com/docs/git-sh-setup
