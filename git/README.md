General Git Information
=======================

A list of object types and good diagram showing their relationships
can be found in [this SO answer][so-23303550]. (This discusses only
objects and should be supplemented with the information in
[`ref`](./ref.md).)

### [Identifier Terminology][ident-term]

* `<object>` The name (SHA1) of any type of object
* `<blob>`, `<tree>`, `<commit>`: The name of a specific type of object
* `<type>`: one of the git object types: blob, tree, commit, tag
* `<file>`: file path usu. relative to tree described by GIT_INDEX_FILE

`<commit-ish>` and `<tree-ish>` are taken by commands that eventually
want to operate on a particular \<commit> or \<tree>; tags, refs,
\<commit>s will be deferenced until reaching one.

### Specifying a Commit-ish or Tree-ish

The [`gitrevisions(1)`] manpage has full details of ways to specify
revisions, ranges of revisions and trees. Chapter [7.1 Revision
Selection][pg-revsel] in [_Pro Git_] offers a useful tutorial. A short
table summarizing some (not all) of this is in [this SO
answer][so-23303550]. These include:

Commit-ish/Tree-ish:
- SHA1 of commit (or tree).
- Output of `git describe`.
- Using `@...` for `HEAD` or `refname@...`:
  - `@{date}` where _date_ is `yesterday`, `2 days 3 minutes ago`,
    `2018-03-11 13:22:17`, etc.
  - `@{upstream}`, `@{u}`: upstream of given branch.
  - `@{push}`: local tracking ref of the remote ref to which we'd push
    if the given ref was checked out. Different from `{upstream}` when
    we're pushing to a different place whence we pull.
  - `@{n}`: _nth_ previous value of given ref (`0` = current) from reflog.
- `@{-n}` (no refname before `@`): _nth_ branch/commit checked out
  before the current one.
- `rev~`, `rev~n`: _nth_ generation ancestor, following first parents (`^1`)
- `rev^`, `rev^n`: select _nth_ direct parent (default 1) of given commit.
  Parent `0` is the commit itself rather than a parent.
  - May be repeated, e.g., `rev^^2^1`.
  - Append `{commit}`, `{tag}` or `{tree}` to select that object type.
  - Append `{}` to dereference recursively until non-tag is found.
  - Append `{/regexp}` to match commit with _regexp_ in commit message.
- `:/regexp`: Youngest commit reachable from any ref with message
  matching _regexp_.

### Commit Ranges

`a..b` gives all commits that are part of _b_ and not part of _a_.
E.g., `master..dev` gives all commits on branch _dev_ that are not on
branch _master_.

`a...b` gives all commits that are a part of either _a_ or _b_ but not
both. Probably you want to use `--graph` with multiline output when
these are separate branches.



[_Pro Git_]: https://git-scm.com/book/en/v2
[`gitrevisions(1)`]: https://www.kernel.org/pub/software/scm/git/docs/gitrevisions.html
[ident-term]: https://www.kernel.org/pub/software/scm/git/docs/#_identifier_terminology
[pg-revsel]: https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection
[so-23303550]: https://stackoverflow.com/a/23303550/107294
