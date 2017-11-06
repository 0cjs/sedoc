Git Tags
========

All tags are [refs](./ref.md); lightweight reference a commit and
annotated reference a `tag` object.

#### Lightweight Tags

* Created when `-[asumF]` options not used
* Just refs under `refs/tags/<tagname>` (like branches under `refs/heads`)
* Packed into `.git/packed-refs` as usual
* Designed for private or temporary object labels; some commands
  ignore them by default (see manpage).

#### Annotated Tags

* `refs/tags/<tagname>` points to a tag object

#### Fetching/Pushing

* Tags are fetched by default when:
  * No tag with that name already exists (i.e., no overwrite)
  * The tag is on a commit brought over due to a tracking branch
    (i.e., `git fetch REMOTE some/branch` will not bring over tags)
* Use `pull --tags` to force tag fetching/overwriting-of-local

* Not pushed by default; use `push --follow-tags` or similar.
* To force-with-lease you need to provide the old tag value (since there's
  no "tracking tag"): `push --force-with-lease=tags/T:b06ff15 origin T`


Git Commands
------------

`git log TAG` where `TAG` is an annotated tag object or SHA1 of such
will show the commit referenced by that tag rather than the tag
itself. To see the tag itself, use `git cat-file -p TAG`.

`git for-each-ref refs/tags` will print a nice list of tag and
commit objects.


Sample Objects
--------------

These were dumped with `git cat-file -p`.

Commit:

    tree 74f59bf0294463f734bb0795279c5fe414f4c5ee
    parent 9566e96560d814d08ddff7458f75decf7f1ffae1
    author Curt J. Sampson <cjs@cynic.net> 1504178797 +0900
    committer Curt J. Sampson <cjs@cynic.net> 1504178797 +0900

    two

Annotated tag:

    object b06ff1589e0f6fc49406a70d12361caaea915fac
    type commit
    tag a1
    tagger Curt J. Sampson <cjs@cynic.net> 1504244791 +0900

    Annotated tag at first commit

    Not sure how much stuff should be in here or how useful it is to have
    stuff separated from the commits. Reviwers could, e.g., put notes in
    these, but why would they be here and not in the commit message itself?

Signed tag:

    object b06ff1589e0f6fc49406a70d12361caaea915fac
    type commit
    tag a1s
    tagger Curt J. Sampson <cjs@cynic.net> 1504245194 +0900

    Annotated tag at first commit

    Not sure how much stuff should be in here or how useful it is to have
    stuff separated from the commits. Reviwers could, e.g., put notes in
    these, but why would they be here and not in the commit message itself?
    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v2.0.22 (GNU/Linux)

    iQEcBAABAgAGBQJZqPXUAAoJEKgqOkIlgIs6pzkIAJirve22urqexqBizLLeitC8
    exWi8dDPtatmdOdR3/rdxCnqR7OgJ67qUO9/gqf5AsYaK/gNqGAbkfDyAJeDefZG
    V4zuuOrv1gooddzUXSDkiZzL2Po4kcfqTBJtfQzXVtS+8gnc2Vu7BwclfPqs32Q9
    j3E+4eBzR6ZBYnLqj8TpveYBMri4t5LC+YAXyvfCg00SWlgR6SiPP9BcRCGO7b7c
    8j5FqVfGcBdh+vSYIrHZobVi1KFw7Oj5qOHiTGYAagO0Uk1dUrqxwkOV1JkBHSZY
    PABaQ69OHtADNxcrlymQZkE2fGaBU0yfIhgbVjz3CSO2fqQi63QUv3Nz5lfXOvo=
    =ZmfE
    -----END PGP SIGNATURE-----

