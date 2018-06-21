Git: Status of Working Copy/Index
=================================

Programatically Getting the Status
----------------------------------

    # Prints `__ path` where `__` is index/working copy status of each path
    git status --porcelain

    # Check for changes staged to index (ignoreg unstaged working copy changes)
    git diff-index --quiet --cached HEAD --

Information about programatically getting the status of the working
copy and index is available in StackOverflow post [Checking for a
dirty index or untracked files with Git][so-2657935] (note that second
answer is higher voted than accepted answer) and blog post [Adding Git
Status Information to your Terminal Prompt][0xfe].



[0xfe]: http://0xfe.blogspot.jp/2010/04/adding-git-status-information-to-your.html
[so-2657935]: https://stackoverflow.com/q/2657935/107294
