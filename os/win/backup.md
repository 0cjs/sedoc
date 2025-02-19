Windows Backup, File Sync and Disk Cloning Solutions
====================================================

Also see Gizmo's reviews of [cloning][review-clone],
[file-based backup][review-filebu] and [sync][review-sync] software.

### Windows Backup

- Built in to Windows 10 (access from control panel).
- Files/directories on backup volume, named for host:
  - `MediaId.bin`
  - `HOSTNAME`: dir with backup sets
  - `WindowsImageBackup/hostname`
- Horribly slow (24h or more to back up 1 TB)
- Failed after maybe completing 2 TB drive backup with error code
  [0x807800c5][su-508924].
- Errors out when doing system image backup [because only one can exist][hp]?
  Try moving `WindowsImageBackup\host-name` to a .bak name.

### SyncToy

- [Wikipedia page][wp-synctoy], [download][synctoy]
- Run as Admin when syncing system files
- Not fast, but seems to work very well
- Preserves NTFS file permissions, etc.

### AOMEI Backupper Standard

- [Website][aomei-standard], standard version is free
- Does cloning, image backup, file backup
- Very fast at doing image backups of drives/partitions
  (but verify-after-backup seems slow)
- Can it extract individual files from an image backup?



[aomei-standard]: https://www.aomeitech.com/ab/standard.html
[hp]: https://h30434.www3.hp.com/t5/Notebooks-Archive-Read-Only/Windows-10-System-image-backup-error/td-p/5408613
[review-clone]: https://www.techsupportalert.com/best-free-drive-cloning-software.htm
[review-filebu]: https://www.techsupportalert.com/best-free-hard-drive-backup-program.htm
[review-sync]: https://www.techsupportalert.com/best-free-folder-synchronization-utility.htm
[su-508924]: https://superuser.com/q/508932/26274
[synctoy]: http://microsoft.com/download/en/details.aspx?id=15155
[wp-synctoy]: https://en.wikipedia.org/wiki/SyncToy
