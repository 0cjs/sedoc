git-bug: Distributed Issue Tracker
==================================

[git-bug] is a standalone, distributed, offline-first issue tracker that
stores issues/comments/etc. as objects in a git repository (_not files!_)
and provides push/pull facilities.

#### Installation

`git-bug` is a single stand-alone binary; `git bug` will find it in your
path. Typically, download from the [releases][git-bug-releases] page, e.g.:

    curl -OL https://github.com/git-bug/git-bug/releases/download/v0.10.1/git-bug_linux_amd64
    chmod +x git-bug_linux_amd64
    mv git-bug_linux_amd64 ~/.local/bin/git-bug
    git bug version


Tutorial
--------

All commands given are assumed to be prefixed with `git bug` where it's
left out .

* You must first create a new identity (separate from your Git author
  information, host login, SSH ID, etc.): `user new`. This gives an
  interactive dialogue for name, email and avatar URL and produces a
  256-bit hash that is your ID. `user list` will list 7-char hash prefix
  and name; `user show 1a2b3c4` shows the same thing; it's not clear how to
  show details.

* For convenience, `gbb() { git bug bug "$@"; }`.

* Create a new bug with `gbb new`; this opens up an editor where
  you enter the title and body as first para and rest, just like a Git
  commit message. After writing, it will come back with something like
  `5b530d2 created`.

* Listing the bugs with `gbb` will show a summary line for your
  bug; other ways of seeing information:

      gbb title 5b530d2
      gbb status 5b530d2        # 'open'
      gbb label 5b530d2         # no labels yet
      gbb show 5b530d2          # summary of all above and all comments
      gbb comment 5b530d2       # comments only w/no summary; prettier format

  The IDs showed by `gbb comment` are the [_combined_ IDs][combid] created
  by interleaving the bug ID and the comment ID; see also below.

* You can `gbb select 5b530d2` so that you can do all the above
  commands without having to specify the bug ID. `gbb deselect`
  undoes this.

* Comments on bugs.

      gbb comment new 5b530d2   # bring up editor for comment
      gbb comment 5b530d2       # shows comment w/new comment ID 5fb3563
      gbb comment edit 5fb3563  # replaces comment
      #   BUG: old comment not shown in editor when editing a comment above.
      gbb comment 5b530d2       # comment ID did not change

  Note that the comment ID after edit remains the same: the [combined
  ID][combid] of the bug (5b53…) and the original comment ID f365… (that
  the edit targets with its `"target":"f365…"` field) interleaving each
  char as a₀b₀a₁b₁a₂b₂… to get 5fb356….

TODO:
* Filter and sort: Use queries like git bug ls "status:open sort:edit" to filter and sort bugs.
* Search: Find bugs by text content within your repository.
* Push/pull to/from remote.
* Test/document TUI.
* Test/document web UI.
* Document bridge workflow (interface to other bug tracking systems).


Notes on Internals
------------------

The data structures below, _identity_ and _bug,_ use various parts of the
[dag-entity] data structure.

The _[identity]_ is a semi-arbitrary SHA-256 that is stored as a ref
`identities/…SHA-256…`, pointing to a commit. You can dig down into it:

    $ cat .git/refs/identities/581f47…
    63ef39b4cb3099201f5770044bcebfb8fb06cc79
    $ git cat-file -p 63ef39b4cb3099201f5770044bcebfb8fb06cc79
    … [etc. through commit, tree, blob etc. to:]
    $ git cat-file -p 88cf530ae4088c77903b2c1c983e82615298f021; echo
    {"version":2,"times":{},"unix_time":1783063856,"name":"Nishant Rodrigues","email":"nishantjr@gmail.com","nonce":"O2KTGm8PUje/s/fjzM/Iv2KvBf0="}

Similarly, each _[bug]_ is also given a ref of `bugs/…SHA-256…` and you can
dig down in a similar way:

    $ git log --stat --patch bugs/5b530d294bdae31dafa74b2a384c66a32025dafe501ed341adb55eb4548831eb
    commit 6a0d7ca3178a3a0905e5eac6e611378832c01cbd
    Author:  <>
    Date:   Fri Jul 3 07:43:46 2026 +0000
    ---
     create-clock-2 | 0
     edit-clock-2   | 0
     ops            | 1 +
     version-4      | 0
     4 files changed, 1 insertion(+)

    diff --git a/create-clock-2 b/create-clock-2
    new file mode 100644
    index 0000000..e69de29
    diff --git a/edit-clock-2 b/edit-clock-2
    new file mode 100644
    index 0000000..e69de29
    diff --git a/ops b/ops
    new file mode 100644
    index 0000000..65c6c09
    --- /dev/null
    +++ b/ops
    @@ -0,0 +1 @@
    +{"author":{"id":"581f47ddcb89f45d011ba3d7e313739aa23d656ab910472eaca3fc8dccf39818"},"ops":[{"type":1,"timestamp":1783064626,"nonce":"g0MFGZaLkV2f9p1vjE0USQxjpZk=","title":"I am confused","message":"I am a very confused person and need help. If you can explain to my who I\nam and why I have a nonce, that would be great.\n\nI'm also adding more paragraphs just because I like to talk a lot.","files":null}]}
    \ No newline at end of file
    diff --git a/version-4 b/version-4
    new file mode 100644
    index 0000000..e69de29
    njr@tarnyq-notes$

The clocks and version are empty file objects; `ops` contains all the
user-visible material:

    $ git cat-file -p  65c6c09234412dbf0c649f97ccca2ad8f0db2d2f | jq
    { "author": {
          "id": "581f47ddcb89f45d011ba3d7e313739aa23d656ab910472eaca3fc8dccf39818"
      },
       "ops": [   { "type": 1,
                    "timestamp": 1783064626,
                    "nonce": "g0MFGZaLkV2f9p1vjE0USQxjpZk=",
                    "title": "I am confused",
                    "message": "I am a very confused person and need help. If you can explain to my who I\nam and why I have a nonce, that would be great.\n\nI'm also adding more paragraphs just because I like to talk a lot.",
                    "files": null
                  }
       ] }



<!-------------------------------------------------------------------->
[bug]: https://github.com/git-bug/git-bug/blob/trunk/doc/spec/bug.md
[dag-entity]: https://github.com/git-bug/git-bug/blob/trunk/doc/spec/dag-entity.md
[git-bug-releases]: https://github.com/git-bug/git-bug/releases/
[git-bug]: https://github.com/git-bug/git-bug
[identity]: https://github.com/git-bug/git-bug/blob/trunk/doc/spec/identity.md
[combid]: https://github.com/git-bug/git-bug/blob/trunk/doc/spec/README.md#combined-ids
