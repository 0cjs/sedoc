[GitLab] Notes
==============

Basically a slightly less featureful GitHub, with usual open and
enterprise editions, oursourced or self-hosted.


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


Links
-----

(These are visible only in the Markdown source.)

[GitLab]: https://en.wikipedia.org/wiki/GitLab
[gh-issue-773]: https://gitlab.com/gitlab-com/infrastructure/issues/773
