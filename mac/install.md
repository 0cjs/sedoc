Mac Initial Wipe/Install
========================

* Boot with `Command-R` to recovery tools.
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
* When adding new users (via user creation or data migration—see
  below) you will be prompted for a user password at least once during
  the process, so you will need the intended user of the Mac nearby.
* The disk encryption password cannot be removed (see
  [mac/disk-encryption](./disk-encryption.md), so if you have a policy
  of no access by other than the one user of the Mac, you need to get
  the user to change the password with `diskutil coreStorage
  changeVolumePassphrase`. (You will need both the disk password you
  set earlier and the intended user to make this change.)

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


