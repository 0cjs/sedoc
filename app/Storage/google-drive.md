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

Hints:
- Use `--dry-run` to see what it will do.
- Configuration in `~/.config/rclone/rclone.conf`. May use a [configuration
  password][rc-confenc] which must be supplied to decrypt the config file.
- The basic [Usage][rc-docs] page includes links to detailed instructions
  for all the various remote types.

__config__

[`config`] starts an interactive configuration session.

__bisync__

[`bisync`] is in beta. It maintains previously known path listings for both
sides, checks for changes between the two (Newer/Older/New/Deleted) and
propagates changes from each side to the other.

Uses modification times, if they exist on both sides, otherwise
can use checksum and/or size; see `--compare` flag.

__mount__

[`mount`] mounts a FUSE filesystem for the remote, running in the
foreground unless given the `--daemon` option.

### Remote Configs

__Google Drive__

By default rclone's client_id is used for API access; this is slow because
requests are rate limited for all users using it. See [Making your own
client_id][rc-mkGid] for details. This is complex, however.

Remove the client authorization at <https://myaccount.google.com/connections>.



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
