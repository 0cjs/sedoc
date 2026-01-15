rclone
======

Rclone does command-line copy to/from and file operations on cloud file
storage services. (It supports `rsync` functionality as well, via `rclone
sync`.) It has several dozen __backend__ drivers for services, including
Google Drive, Dropbox, Amazon S3-compliant services, etc.

An rclone __remote__ is a local name used to access a remote service with
specific configuration information, including the backend, authentication
information, etc. The remote is specified in command line parameters with a
trailing `:`.

Hints:
- Use `--dry-run` to see what it will do.
- The basic [Usage][rc-docs] page includes links to detailed instructions
  for all the various remote types.

### Local Configuration Management

Remote information, _including sensitive access tokens_, is stored in the
config file, default `~/.config/rclone/rclone.conf`.
- This is in an undocumented "INI"-style format. It does allow comment
  lines starting with `#`, but does not allow end-of-line comments.
- The config file may be encrypted with a [configuration
  password][rc-confenc] which must be supplied to decrypt the config file.

Configuration-related commands:

- [`help backends`]: List names of drivers for remotes (drive, dropbox, etc.)
  `help backend NAME` will give backend-specific command line options and
  configuration properties for backend _name_.

- [`listrermotes`]: List of configured remotes.
  Add `--long` to show backend for each.

- [`config`]: With no arguments, starts an interactive configuration session.
  There are many subcommands; use `-h`.
  - `config create NAME BACKEND`

- [`authorize BACKEND`]: Does auth process for a backend and prints the
  `{"access_token":...}` information. This does not associate the token
  with a specific remote; to do that you need to add it as `token =
  {"access_token":...}` to the appropriate config file section.

### Listing Files

The `Ṙ` symbol indicates that the listing will be recursive. For
non-recursive, enable recursion with `-R`; for recursive, disable it
with `--max-depth 1`.

    lsd             List all directories/containers/buckets at path
    tree          Ṙ List the contents under path in a tree like fashion.

    lsf             List directories and objects at path (parsable)
    lsjson          List directories and objects at path in JSON format
    ls            Ṙ List the objects under path with size and path
    lsl           Ṙ List the objects under path with mod time, size and path

Convenient commands:

    #   List all files/dirs at top level in date order, with sizes.
    rclone lsf --format tsp REMOTE: | sort | column -t -s ';'

### File Management

    delete          Remove the files in path.
    deletefile      Remove a single file from remote.

### File Transfer

    copy            Copy files from source to dest, skipping identical files.
    copyto          Copy files from source to dest, skipping identical files.
    copyurl         Copy url content to dest.

- [`bisync`] is in beta. It maintains previously known path listings for
  both sides, checks for changes between the two (Newer/Older/New/Deleted)
  and propagates changes from each side to the other. It uses modification
  times if they exist on both sides, otherwise can use checksum and/or
  size (see `--compare` flag).

- [`mount`] mounts a FUSE filesystem for the remote, running in the
  foreground unless given the `--daemon` option.


Backend Driver Information
--------------------------

- [rclone Google Drive Backend Driver][gd]



<!-------------------------------------------------------------------->
[`bisync`]: https://rclone.org/commands/rclone_bisync/
[`config`]: https://rclone.org/commands/rclone_config/
[`mount`]: https://rclone.org/commands/rclone_mount/
[g-apicon]: https://console.developers.google.com/
[rc-confenc]: https://rclone.org/docs/#configuration-encryption
[rc-docs]: https://rclone.org/docs/

[gd]: ./google-drive.md#rclone-google-drive-backend-driver
