General Git Information
=======================

A list of object types and good diagram showing their relationships
can be found in [this SO answer][so-23303550]. (This discusses only
object and should be supplemented with the information in
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
revisions, ranges of revisions and trees. A short table summarizing
some (not all) of this is in [this SO answer][so-23303550].



[ident-term]: https://www.kernel.org/pub/software/scm/git/docs/#_identifier_terminology
[`gitrevisions(1)`]: https://www.kernel.org/pub/software/scm/git/docs/gitrevisions.html
[so-23303550]: https://stackoverflow.com/a/23303550/107294
