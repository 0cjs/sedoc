Git Tips
========

Status
------

* To show untracked files (i.e., not ignored) files in subdirectories
  that have not been added, `git status --untracked-files=all` or
  `git status -uall`.


Logging and Graph Exploration
-----------------------------

* To do a 'blame in reverse', e.g., to find out which commit deleted a
  line, use `git blame --reverse START.. PATH`. The file must exist in
  the START commit, so you may need to do a forward log to find where
  it was added.

* Find first ancestor of a <commit-ish> reachable by any other ref
  (commits that are on only "this" branch):

      git rev-parse --not --all | grep -v I | git rev-list --stdin I

  The above doesn't handle some corner cases; see this [SO answer](
  https://stackoverflow.com/a/13461275/107294) or the [post-receive-email](
  https://github.com/git/git/blob/master/contrib/hooks/post-receive-email#L292)
  script for more details.


Default Branch Renaming
-----------------------

After renamed in remote repo `r`:

    br -m master main
    fetch -p r                  # remove tracking branch for `master`
    br -u r/main main           # -u == --set-upstream
    rem set-head r -a           # query remote for its default branch

Knowing the remote's default branch (stored in `refs/remotes/<name>/HEAD`)
is not required, but gives the default branch to use if you specify only
the name of that remote (e.g., just `origin` instead of `origin/master`).


Git Interactive Rebase (`rebase -i`)
------------------------------------

Commits can be split by marking them edit and, when editing, starting
with `git reset HEAD^`. This "rewinds" the HEAD and index to the
previous commit, leaving the changes from the commit being edited in
the work tree.
* `git add -p` etc. to generate a series of new commits that will
  replace the commit originally being edited.
* `git stash` to temporarily clean the work tree to test intermediate
  commits.
* When the working copy is clean, `git rebase --continue`


Fixing/Changing Commits and Branches
------------------------------------

* `chmod -x` followed by `git add` will not change the executable bit in
  the repo index so you can commit it. To do this you need to:

      git update-index --chmod=-x PATH …

* See [Rebasing in Git](rebase.md) for tips on handling merge conflicts.

* To rewrite the author and timestamp of a commit (using the
  [filter-branch](filter-branch.md) variables if set):

      git commit --amend --reset-author

For other history changes examples (e.g., moving a subdir) see
[filter-branch](filter-branch.md).

* To change the author of each of several commits without changing the
  dates, `git rebase --interactive` and after each commit,

      git commit --amend --author cjs -C @

* To remove a file accidentally added to a commit ([so-15321456]):

      git reset --soft @^
      git reset @ path/to/file
      git commit -c ORIG_HEAD

* To create an empty orphan branch:

      git checkout --orphan BRANCHNAME
      git rm --cached -r .
      git clean -fdx

* Use `git repack -adk` to pack unreachable objects that are not yet ready
  to prune. The default packs (by `gc` or otherwise) leave these loose, and
  as individual files they can eat a lot more space than they would packed.
  (Sometimes there's a 100× difference in disk space use.)

* To identify large objects ([so-10622293]), in a few ways:

      git gc              # Get all commits into a packfile
      git verify-pack -v .git/objects/pack/pack-*.idx \
        | sed -e '/^non delta:/,$d' | sort -k 4 -n -r | head
      # Columns: SHA-1 type size pack-size pack-offset [depth base-SHA-1]

      git rev-list --objects --all \
      | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
      | sed -n 's/^blob //p' \
      | sort --numeric-sort --key=2 \
      | cut -c 1-12,41- \
      | numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest


Configuration
-------------

### Finding Locations in the Repo

`git rev-parse` options related to paths to and within repos.
`root` below is the top-level directory of the current repo.

Show information:

    --local-env-vars
    --show-toplevel     root directory of current repo
    --git-dir           path to .git/
    --git-common-dir    path to common-git, if defined, else .git/
    --show-prefix       path to CWD from root of repo
    --git-path PATH

Tests:

    --is-inside-git-dir
    --is-inside-work-tree
    --is-bare-repository

Change behaviour:

    --show-cdup         when displaying paths, show root relative to CWD
    --prefix            generate path names relative to repo root

### Checking Line End Settings

For debugging Git [attributes], the `core.eol` and `core.autocrlf`
settings, etc., the `git ls-files --eol` option is very useful.

Normally `core.autocrlf` wants to be set to `false` to avoid any
conversions whatsoever. [The possible values are][so 3206843]:
- `false`: No processing done; git leaves all CRs and LFs just
  as they are, always.
- `true`: Get uses LF in the object database, and converts to
  CR-LF on ouptut (vice versa on input) on Windows etc.
- `input`: When reading files with CR-LF, Git converts them to LF
  when writing them to the database, but does no conversion on output.

A table from another answer on that question above:

    ╔═══════════════╦══════════════╦══════════════╦══════════════╗
    ║ core.autocrlf ║     false    ║     input    ║     true     ║
    ╠═══════════════╬══════════════╬══════════════╬══════════════╣
    ║               ║ LF   => LF   ║ LF   => LF   ║ LF   => CRLF ║
    ║ git checkout  ║ CR   => CR   ║ CR   => CR   ║ CR   => CR   ║
    ║               ║ CRLF => CRLF ║ CRLF => CRLF ║ CRLF => CRLF ║
    ╠═══════════════╬══════════════╬══════════════╬══════════════╣
    ║               ║ LF   => LF   ║ LF   => LF   ║ LF   => LF   ║
    ║ git commit    ║ CR   => CR   ║ CR   => CR   ║ CR   => CR   ║
    ║               ║ CRLF => CRLF ║ CRLF => LF   ║ CRLF => LF   ║
    ╚═══════════════╩══════════════╩══════════════╩══════════════╝

[so 3206843]:https://stackoverflow.com/q/3206843/107294

### I18N Path/Filename Display

By default Git will fully quote Unicode filenames and paths, e.g.
`"\321\203\321\201..."`. Fix with `git config --global core.quotepath off`.

[so 22827239]: https://stackoverflow.com/q/22827239/107294


Connectivity and Fetch/Push
---------------------------

#### Debugging Connectivity

The various `GIT_TRACE` environment variables documented in the
[`git(1)`] manpage are very useful for debugging transfer problems.

- `GIT_TRACE_CURL`: Prints all HTTP(S) connection information and
  transferred data, including decrypted data from TLS connections.
  Obsoletes `GIT_CURL_VERBOSE`, which has a format more similar to
  curl's `--trace-ascii`.
- `GIT_TRACE_CURL_NO_DATA` (≥2.16.3) When `GIT_TRACE_CURL` is set,
  removes the data logging from the trace output.

#### Accessing github.com via SSH through HTTP Proxy

Github.com offers SSH connectivity at [`ssh.github.com` port 443]
[gh-ssh443]. If you need to go through an HTTP proxy, [corkscrew][]
(available as a Debian package) can be used to tunnel your SSH
connection as described at [so-3777141]:

    Host github.com
        HostName ssh.github.com
        Port 443
        User git
        ProxyCommand corkscrew <proxyhost> <proxyport> %h %p [~/.ssh/proxy_auth]


GitHub and Other Hosting Tips
=============================

GitHub renders HTML files only as source, which is annoying when a copy of
the file isn't hosted elsewhere. `htmlpreview.github.io` will render these
for you; simply pass the URL to the GitHub source rendering as the query
parameter, e.g.

    https://htmlpreview.github.io/?https://github.com/Arakula/f9dasm/blob/master/f9dasm.htm



<!-------------------------------------------------------------------->
[so-15321456]: https://stackoverflow.com/a/15321456/107294
[so-10622293]: https://stackoverflow.com/a/10622293/107294

[attributes]: https://www.git-scm.com/docs/gitattributes

[`git(1)`]: https://git-scm.com/docs/git
[corkscrew]: https://web.archive.org/web/20160706023057/http://agroman.net/corkscrew/
[gh-ssh443]: https://help.github.com/articles/using-ssh-over-the-https-port/
[so-3777141]: https://stackoverflow.com/a/3777141/107294
