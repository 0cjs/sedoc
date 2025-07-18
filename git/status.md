Git: Status of Working Copy/Index
=================================

Programatically Getting the Status
----------------------------------

    # Prints `__ path` where `__` is index/working copy status of each path
    git status --porcelain

    #   Various checks for changes to tracked and untracked in the working copy:
    git diff-index --quiet HEAD --          # Tracked files changed (staged or not)
    git diff-index --quiet --cached HEAD -- # Staged changes
    git diff-files --quiet                  # Unstaged (but tracked) changes

Information about programatically getting the status of the working
copy and index is available in StackOverflow post [Checking for a
dirty index or untracked files with Git][so-2657935] (note that second
answer is higher voted than accepted answer) and blog post [Adding Git
Status Information to your Terminal Prompt][0xfe].

Also see [`ref.md`](./ref.md) for information on getting ref names
useful to programs (`rev-parse`, `show-ref`, etc.).


git ls-files
------------

`git ls-files` is another approach to doing this.

To get a list of all the non-ignored files in a working copy (unchanged,
staged, modified and new that are not ignored):

    git ls-files -c -o --exclude-standard


git check-ignore
----------------

To find what is causing any particular file(s) to be ignored:

    git check-ignore -v filename [...]

Exits with `1` if any file in the list is not ignored.



<!-------------------------------------------------------------------->
[0xfe]: http://0xfe.blogspot.jp/2010/04/adding-git-status-information-to-your.html
[so-2657935]: https://stackoverflow.com/q/2657935/107294
