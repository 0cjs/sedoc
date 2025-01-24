Google Drive Sync for Linux
===========================

Many GUI file manager apps support connecting to GDrive, including:
- OS-supplied: Nautilus. KDE Plasma. KIO GDrive (KDE).
  Gnome Online Accounts.
- Open source: GoSync (PyPI), CloudCross, Celeste (uses rclone), overGrive.
- Proprietary: Insync (paid).

Command-line clients:
- [rclone]. Linux/BSD/MacOS/Windows.
  - Supports more than 70 cloud storage projects.
  - `mount` command to mount FUSE filesystem
  - ? Daemon mode to background sync?
- [google-drive-ocamlfuse]: FUSE filesystem for GDrive
  - Source distro; ppa available for Ubuntu.
- [DriveSync]. Ruby. No longer maintained?
  - Replaces Google Drive client; does ul/dl/delete/etc.
  - Run manually or as a cronjob.
- odeke-em's [drive]. Go.
  - Small program to pull/push GDrive files.
- [grive2]
  - Downloads, syncs manually, uses `.trash` folder.
  - Fork of unmaintained "grive".


rclone
------

An rclone __remote__ is a local name used to access a remote service,
called a __backend__, with specific configuration information. The remote
is specified in command line parameters with a trailing `:`.

Hints:
- Use `--dry-run` to see what it will do.
- The basic [Usage][rc-docs] page includes links to detailed instructions
  for all the various remote types.

__Local Configuration Management__

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

__Listing Files__

    ls              List the objects in the path with size and path.
    lsd             List all directories/containers/buckets in the path.
    lsf             List directories and objects in remote:path formatted for parsing.
    lsjson          List directories and objects in the path in JSON format.
    lsl             List the objects in path with modification time, size and path.
    tree            List the contents of the remote in a tree like fashion.

__File Management__

    delete          Remove the files in path.
    deletefile      Remove a single file from remote.

__File Transfer__

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

### Backend Driver Notes

__Google Drive__

By default rclone's client_id is used for API access; this is slow because
requests are rate limited for all users using it. See [Making your own
client_id][rc-mkGid] for details. This is complex, however.

Remove the third-party client authorization at
<https://myaccount.google.com/connections>.



<!-------------------------------------------------------------------->
[DriveSync]: https://github.com/MStadlmeier/drivesync
[drive]: https://github.com/odeke-em/drive
[google-drive-ocamlfuse]: https://github.com/astrada/google-drive-ocamlfuse
[rclone]: https://rclone.org/
[Grive2]: https://github.com/vitalif/grive2

<!-- rclone -->
[`bisync`]: https://rclone.org/commands/rclone_bisync/
[`config`]: https://rclone.org/commands/rclone_config/
[`mount`]: https://rclone.org/commands/rclone_mount/
[g-apicon]: https://console.developers.google.com/
[rc-confenc]: https://rclone.org/docs/#configuration-encryption
[rc-docs]: https://rclone.org/docs/
[rc-mkGid]: https://rclone.org/drive/#making-your-own-client-id
