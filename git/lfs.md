Git LFS
=======

Git LFS uses clean/smudge filters (see the `gitattributes(5)` manpage) to
handle committing/checking-out large files:
- The clean filter uploads the file to the LFS server and converts the name
  in the commit to a pointer file to that upload.
- The smudge filter looks up the actual file based on the pointer file and
  downloads the actual file into the working copy.

### Installation

Git LFS is not part of Git itself; install the Debian `git-lfs` package or
similar.

The `git-lfs-install` command must be run; this will set up something like
the following in the global Git config (`~/.gitconfig`):

    [filter "lfs"]
        clean = git-lfs clean -- %f
        smudge = git-lfs smudge -- %f
        process = git-lfs filter-process
        required = true

### Repo Setup

`git-lfs-track` will:
- If necessary, set up `.git/hooks/` files. (The hooks are `post-checkout`,
  `post-commit`, `post-merge`, and `pre-push`, all of which just run `git
  lfs` followed by the name of the hook. The pre-push ensures that large
  files are sent up to the LFS API; the others simply ensure that local
  large files are read-only or locked.)
- Create/update `.gitattributes` at the root of the repo with a line like
  `*.large filter=lfs diff=lfs merge=lfs -text`. Any existing files will be
  immediately converted to large file pointers, with the actual file
  contents moved under `.git/lfs/objects/`.

Note that Git LFS will store additonal local copies of all versions of all
large files you've had locally under `.git/lfs/objects/`. (The working tree
copy can't be hard linked to these because then editing the working tree copy
would change the version named with its hash.)

### Push/Pull

It appears that you can push only to remotes that support the Git LFS API.
(Pushing to a remote that does not, e.g., a filesystem path, will produce
something like `batch request: missing protocol: ""0 B | 0 B/s`,
`error: failed to push some refs to '../bare-lfs-play/'`)

### Configuration

Git LFS will read the following configuration variables from either the
Git configuration or an `.lfsconfig` file:
- `lfs.fetchinclude`
- `lfs.fetchexclude`


Custom LFS Storage
------------------

Git LFS can talk only to servers using its [API]. The client uses [server
discovery] to figure how to talk to the server, usually with information
provided by the remote. Instead you can set (in Git configuration or
`.lfsconfig`) `lfs.url` (global) or `remote.NAME.lfsurl` (for one remote)
to your own preferred server.

The [lfs-folderstore] server will allow you to place LFS files in a
directory on the local filesystem; this would typically be a directory
sync'd to a cloud storage service such as Dropbox or Google Drive.



<!-------------------------------------------------------------------->
[API]: https://github.com/git-lfs/git-lfs/tree/main/docs/api
[lfs-folderstore]: https://github.com/sinbad/lfs-folderstore
[server discovery]: https://github.com/git-lfs/git-lfs/blob/main/docs/api/server-discovery.md
