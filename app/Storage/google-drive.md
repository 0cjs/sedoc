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

The best option of the above seems to be rclone; see [rclone](./rclone.md)
for a summary and more details.


<!-------------------------------------------------------------------->
[DriveSync]: https://github.com/MStadlmeier/drivesync
[drive]: https://github.com/odeke-em/drive
[google-drive-ocamlfuse]: https://github.com/astrada/google-drive-ocamlfuse
[rclone]: https://rclone.org/
[Grive2]: https://github.com/vitalif/grive2
