GitLab Git Repo Notes
=====================

This document is about GitLab's use use of Git repos; for other
information about it see the [GitLab](../app/gitlab.md) document.


Tips
----

### send-pack disconnect

If you get messages failing to write your push data to GitLab like:

    Connection to gitlab.com. closed by remote host.
    send-pack: unexpected disconnect while reading sideband packet
    fatal: the remote end hung up unexpectedly

the following in your `~/.ssh/config` may fix it:

    Host gitlab.com.
        IPQoS throughput


Special Refs
------------

Gitlab adds its own special refs of the form:

    refs/keep-around/d05c9739ff409188706c1468b08658f2ec3460f8
    refs/tmp/a3ff0952a26a14dd05a384d495673458/head

These cannot be pulled from GitLab itself with `fetch
+refs/keep-around/*` or similar; you need to pull from from a copy of
the repo on disk.

The `keep-around` refs prevent Git from GC'ing things not referenced
from regular branches (`refs/heads/*`).

Sometimes objects referenced by `keep-around` refs are lost, as in
[this bug report][gh-issue-773].



[gh-issue-773]: https://gitlab.com/gitlab-com/infrastructure/issues/773
