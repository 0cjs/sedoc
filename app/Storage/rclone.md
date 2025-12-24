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


Google Drive Backend Driver Notes
---------------------------------

When you need to, remove the third-party client authorization at
<https://myaccount.google.com/connections>.

### Setting Up API Access Keys

By default rclone's client_id is used for API access; this is slow because
requests are rate limited for all users using it. For better speed, make
your own API key (see below). Note that the API key does not give you
access to any files and is completely independent of the authentication
tokens you use to get access to files.

Instructions are at [Making your own client_id][rc-mkGid]. This is a bit
complex; the following additional notes may help.

You'll want to set up a new project in the [Google API console][gapi-console].
Workspace users have a choice of putting it in your Workspace domain
(enabling Internal apps) or in "uncategorized." To get back to the API
console (and any other console in Google Cloud services), it's best to
click the ≡ menu, use the "View all products" button at the very bottom,
and pin the particular console you want.

When configuring the OAuth Consent Screen, if you create an "Internal"
(instead of "External") app it avoids approval and/or scary messages. It
also immediately allows use by all users in the Workspace, rather than
having to add test users.

When creating the OAuth client, keep a copy of the the client secret; it
cannot be retrieved after that client entry is created.

### Adding Remotes

Add a remote with `rclone config`, choosing `n`)ew remote then:
- name>: remote name
- Storage>: `drive`,
- client_id>:, client_secret>: OAuth client ID and secret from above.
  This is for Google API access, and will be under the `client_id` and
  `client_secret` entries in rclone.conf.
- scope>: Generally `drive` (or `1`) for full access.
- service_account_file>: Leave empty.
- "Use auto-config?"
  - `y` will immediately open up a browser window to authenticate to the
    Drive account (My Drive for an account or Shared Drive)
  - `n` will print links to authenticate later
  - Either way, this will generate the `token` entry in rclone.conf.
- "Configure this as a Shared Drive (Team Drive)?" If you type `y` it gives
  you a list of shared drives to which you have access, otherwise it uses
  your personal Drive. If a shared drive, it will set `team_drive` in
  rclone.conf.

You can then, e.g.:

    rclone lsl NAME:            # list all files (including subdirs)
    rclone copy NAME: ./name/   # clone the drive to the given subdir
    rclone copy ./name/ NAME:   # copy changed files back to Drive



<!-------------------------------------------------------------------->
[`bisync`]: https://rclone.org/commands/rclone_bisync/
[`config`]: https://rclone.org/commands/rclone_config/
[`mount`]: https://rclone.org/commands/rclone_mount/
[g-apicon]: https://console.developers.google.com/
[rc-confenc]: https://rclone.org/docs/#configuration-encryption
[rc-docs]: https://rclone.org/docs/

[gapi-console]: https://console.developers.google.com/
[rc-mkGid]: https://rclone.org/drive/#making-your-own-client-id
