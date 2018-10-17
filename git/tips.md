Git Tips
========


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


Fixing/Changing Commits and Branches
------------------------------------

* To rewrite the author and timestamp of a commit:

      git commit --amend --reset-author

* To remove a file accidentally added to a commit ([so-15321456]):

      git reset --soft @^
      git reset @ path/to/file
      git commit -c ORIG_HEAD

* To create an empty orphan branch:

    git checkout --orphan BRANCHNAME
    git rm --cached -r .
    git clean -fdX


Configuration
-------------

### Checking Line End Settings

For debugging Git [attributes], the `core.eol` and `core.autocrlf`
settings, etc., the `git ls-files --eol` option is very useful.

Normally `core.autocrlf` wants to be set to `input` to avoid any
conversions whatsoever.


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



[`git(1)`]: https://git-scm.com/docs/git
[attributes]: https://www.git-scm.com/docs/gitattributes
[corkscrew]: https://web.archive.org/web/20160706023057/http://agroman.net/corkscrew/
[gh-ssh443]: https://help.github.com/articles/using-ssh-over-the-https-port/
[so-15321456]: https://stackoverflow.com/a/15321456/107294
[so-3777141]: https://stackoverflow.com/a/3777141/107294
