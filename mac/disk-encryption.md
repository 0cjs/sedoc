MacOS Disk Encryption
=====================

Encryption is part of CoreStorage, arranged as follows and as
displayed by `diskutil coreStorage list` or `diskutil cs list`:

  * a Logical Volume Group (LVG)
    * has Physical Volumes (PV), must be a GPT partition
    * exports Logical Volume Families (LVF), currenly only 1 per LVG
      * containing Logical Voumes (LV), currently only 1 per LVF

The LVF specifies the properties for disk encryption, but it's not
clear from the `diskutil(8)` manpage what exactly is encrypted; it
seems to be the LV, whose volume ID is what you give to tools that
change encryption, so we'll use that here.

An LV optionally has a Disk Password independent of any user; this
will be present if the LV was set up via `disktuil` or the graphical
`Disk Utility` (such as before doing a fresh MacOS install). `diskutil
coreStorage changeVolumePassword` will change this if it exists, but
it's not clear how to add one if it doesn't exist (maybe the
`-recoverykeychain` option?) or remove one if FDE credentials (see
below) are in use.

After install, encryption can be set up and/or user passphrases ("OS"
and "Personal Recovery" FDE Credentials) added using the Control Panel
/ Security / File Vault pane or `fdesetup`. This will not add a Disk
Password if the volume was unencrypted to start.


