Mac Initial Wipe/Install
========================

* Boot with [`⌘R`](./startup.md) to recovery tools.
* Use Disk Utility to erase current partition under Internal/APPLE SSD.
  You must create a new partition to replace it: name it for the Mac
  and format it as "Mac OS Extended (Journaled, Encrypted)". The
  password you choose will be a disk password separate from any user
  passwords that may also be used to unlock the disk. (This can be
  removed later)
* Quit Disk Utility, start Reinstall macOS.
* Connect to a network (dialogue box after Continue will not work
  until you do this, but will not give an error indication).
* Continue standard install process. (A couple of times during this
  process you will be prompted for the disk password you set above.)
* When the setup assistant comes up, ⌘Q will let you shut down and
  run it later.
* When adding new users (via user creation or data migration—see
  below) you will be prompted for a user password at least once during
  the process, so you will need the intended user of the Mac nearby.
* The disk encryption password cannot be removed (see
  [mac/disk-encryption](./disk-encryption.md), so if you have a policy
  of no access by other than the one user of the Mac, you need to get
  the user to change the password with `diskutil coreStorage
  changeVolumePassphrase`. (You will need both the disk password you
  set earlier and the intended user to make this change.)

Further information, especially about different versions, is at [How
to reinstall macOS][reinstall-howto].

[reinstall-howto]: https://support.apple.com/en-us/HT204904


Install Error on Pre-encrypted Disk
-----------------------------------

Erasing the disk and setting up a new encrypted volume before the
install (as described above) may sometimes result in the following
error at first boot after the install:

> macOS could not be installed on your computer
>
> Storage system verify or repair failed.
> Quit the installer to restart your computer and try again.

(This is the 10.12 Sierra; the message is slightly different for
10.10 Yosemite, which has also been seen to fail in a similar way.)

This has been fixed on at least one occasion by rebooting again into
recovery mode (the reboot and ⌘R are required), using Disk Utility to
format the drive as "Mac OS Extended (Journaled)" only, installing,
and enabling FileVault after configuration.


Migration/Data Transfer
-----------------------

The migration/data transfer options after the install are:
  * From a Mac, Time Machine backup, or startup disk
  * From a Windows PC
  * Don't transfer any information now

If you transfer data you will be prompted again for the disk password
during the migration process, and you will also be prompted for the
password of the migrated user to allow him to unlock the disk.

When doing a migration from another Mac you will not be able to use
that Mac during the Migration process.

### Application Issues with Migration

**Dropbox:**
If you use the Dropbox sync client, a migration may confuse it and
cause it to delete large numbers of files when started on the new
machine. (Perhaps the migration doesn't copy over the files in the
Dropbox directory and the client then sees them as locally deleted
since the last sync.) It seems best to disable or uninstall the
Dropbox sync client before doing a migration and reconnect/re-install
it after the migration is complete.

**Office 365:**
Your permissions/license for Office 365 might not be preserved across
a migration.
