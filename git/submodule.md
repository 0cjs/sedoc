Git Submodules
==============

Submodules are specific commits of a _submodule_ repository associated
with a commit in another repository, the _superproject_. This is done
with a "gitlink" entry in the commit's tree referencing a commit in
the submodule repo; when verifying whether the submodule checkout is
correct Git does not care about the source of the submodule repo.

However, usually the tree referencing a submodule will also include a
`.gitmodules` file at the root giving a logical name and default
source URL for the submodule repo. URLs starting with `./` or `../`
are relative; see below.

The history of the submodule repo remains completely independent of
the repo using the submodule, though Git provides help maintaining the
state of a checked-out submodule.

Submodules appear in `git status` as a single name at the "mount
point" of the submodule. Any modifications to the working copy in the
submodule will show the submodule mount point as modified in the
superproject's status. If the working copy is clean, you can `git add`
the submodule to stage a new gitlink entry to that new commit; if the
working copy is dirty you will not be able to stage until the changes
in the submodule are commited there.

### Relative Source URLs

The source URL may be made relative by starting it with `./` or `../`
in which case it's relative to the URL of the superproject's "default
remote."

The default remote appears to be found by derferencing `HEAD` and, if
that's a ref and has a tracking ref, using the URL of the remote of
that tracking ref. If that remote does not exist, it tries to look up
the URL for the remote `origin`. If that doesn't exist, it doesn't
fail but instead interprets the relative path relative to the
filesystem location of the parent repo.

This last case can occur e.g. when you're init'ing the subrepo of a
subrepo. the upper subrepo has HEAD pointing to a commit (so no
tracking ref) because it's set based it's parent repo's commit. If
your git config is not the default `core.defaultRemoteName = origin`,
it won't find a remote URL.

If it gets to this relative fileystem path point, the filesystem path
is unlikely to be a Git repo and so won't be a valid source and the
clone will fail. However, `git submodule update` does not recognise
this, retries (failing again), and then leaves the submodule init'd to
that bad remote. Any further attempt to use any of this will fail
until you `deinit` that submodule and init it again to a valid URL.

### Configuration Storage Details

- The commit to which a submodule should be set is stored in a commit
  in the main repo; configuration files contain only information about
  where to get a copy of the repo.
- Submodule bare repositories are under `.git/modules/`; the working
  copy under `foo/bar/` will have a `.git` file containing the line:
  `gitdir: ../../.git/modules/foo/bar`. If present, this is used and
  config files are ignored.
- The `[submodule "foo/bar"]` section in `.git/config` is used when
  `.git/modules/foo/bar` is not present; the `url =` line will determine
  whence Git will try to fetch the module's repo.
- A fresh clone of the main repo will not have submodules sections in
  `.git commit`; in this case you must use `update --init` to copy the
  default sections from `.gitmodules` to `.git/config`.


Checking Out Submodules
-----------------------

Submodules are not cloned by default when a repo is cloned and checked
out; the `git clone --recursive` or `--recurse-submodule` options will
clone and check out submodules as well. Since most people don't do
this by default, it's best to have the test script check that
necessary submodules are present and either ask the user to
`git submodule update --init` or do that itself.

    warn() { echo 1>&2 "WARNNG:" "$@"; }

    #   From: https://github.com/0cjs/sedoc, git/submodule.md
    check_submodules() {
        count=$(git submodule status --recursive | sed -n -e '/^[^ ]/p' | wc -l)
        [ $count -eq 0 ] || {
            warn "$count Git submodules are not up to date"
            warn 'Run `git submodule update --init`?'
        }
    }


Creating/Updating Submodules
----------------------------

`git submodule add <repo> [<path>]` will stage a gitlink entry and
additions to a `.gitmodules` file to be commited.

Checking out a different commit in the submodule will mark it as
modified in the superproject; this modification can be added and
commited. Uncommited modifications to the submodule working copy will
be noted as the superproject's submodule entry being modified, but
they will be ignored on commit (i.e., only the commit ID of the
submodule's HEAD is committed).


Showing Submodule Information
-----------------------------

`git show REF:PATH` cannot show submodule commit IDs.
Instead you need to use `git ls-tree REF PATH`.
