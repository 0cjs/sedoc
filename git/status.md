Git: Status of Working Copy/Index
=================================

Programatically Getting the Status
----------------------------------

    # Prints `__ path` where `__` is index/working copy status of each path
    git status --porcelain     

    # Check for changes staged to index (ignoreg unstaged working copy changes)
    git diff-index --quiet --cached HEAD --

Information about programatically getting the status of the working
copy and index is available in StackOverflow post
and blog post [

### References:

* [Checking for a dirty index or untracked files with Git](https://stackoverflow.com/q/2657935/107294) (second answer is higher voted than accepted answer)
* [Adding Git Status Information to your Terminal Prompt](http://0xfe.blogspot.jp/2010/04/adding-git-status-information-to-your.html)


Getting Branch/Upstream Names
-----------------------------

    git rev-parse --symbolic-full-name --short @

Use current branch (`HEAD`, `@`), upstream (`@{u}`, `@{upstream}`) or
whatever you like as the branch name.

When this branch isn't tracking another, a query for upstream will
fail with exit code 128 and: `fatal: HEAD does not point to a branch`
on stderr, which can be redirected to `/dev/null`.
