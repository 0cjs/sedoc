cryptdisks, LUKS, etc.
======================

Contents:
- Volume UUIDs
- /etc/crypttab
- LUKS Commands
- Secure Erase

#### Manpages

* crypttab(5)
* cryptdisks(8)
* cryptdisks_start(8)
* cryptdisks_stop(8)

#### Other Docs

* <https://blog.tinned-software.net/automount-a-luks-encrypted-volume-on-system-start/>
* <https://unix.stackexchange.com/q/363542/10489>


Volume UUIDs
------------

It's more reliable to use volume UUIDs than block device names because
the device names can change. UUIDs are specified in most `*tab` files
with `UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` (note no quotes)
anywhere you would use a device name. Commands useful here include:
* `cryptsetup luksUUID <dev>`: prints UUID of that LUKS volume
* `blkid <dev>`: prints UUID, type and partition UUID of that device
* `blkid -U <UUID>`: prints block device of volume/partition/etc. with
  that UUID


/etc/crypttab
-------------

`/etc/crypttab` is read on boot and by `cryptdisks_start NAME`.
The four fields are:
* _target_: name (`/` not allowed) to map to in `/dev/mapper`
* _source device_: device name, UUID=partition-UUID, etc.
* _key file_: File with secret key or `none`
* _options_: Usually `luks` or `luks,noauto`.
  - `discard` may also be added, but this can later leak info about the
    ciphertext access patterns, giving filesystem info etc.

Use `cryptdisks_start TARGET` and `cryptdisks_stop TARGET` to do bring
the target on or off-line. You will be prompted for a password if
necessary.

#### Key Files

In many situations it's reasonably safe to add a key file as an
additional unlock key to a LUKS filesystem and store that on your
encrypted main disk (readable root only of course). This means that
someone who can decrypt your root disk can decrypt the additional
disk, too, but that's often a price worth paying for not having to
type two passwords at boot.

Be careful that your key material doesn't accidentally get into your
initramfs image, e.g., via setting of `KEYFILE_PATTERN` in
`/etc/cryptsetup-initramfs/conf-hook`.

To set it up, create a new keyfile with random data and then configure
it as a keyfile for the encrypted partition

    dd if=/dev/urandom of=/etc/crypt.my-thing.key bs=4K count=1
    chmod 0500 /etc/crypt.my-thing.key
    cryptsetup luksAddKey /dev/sdx1 /etc/crypt.my-thing.key
    #       Add to /etc/crypttab:
    # my-thing UUID=... /etc/crypt.my-thing.key luks
    #       Add to /etc/fstab (FS UUID, not luks UUID!)
    # UUID=...  /u ext4  nosuid  0 2

#### Management Commands

DEV is a device name; NAME is the name assigned with `open`, or from
`/etc/crypttab` when using `cryptdisks_*`.

    #   Wrappers around around `cryptsetup` that use /etc/crypttab.
    cryptdisks_start [NAME]
    cryptdisks_stop [NAME]

    cryptsetup status NAME
    cryptsetup luksDump DEV
    cryptsetup open DEV NAME
    cryptsetup close NAME

Once a crypt partition is opened, `lsblk -f` or `blkid` on
`/dev/mapper/…_crypt` can be handy to figure out the FS, etc.

#### Debugging

If `cryptdisks_start` gives you an error along the following lines,
you've most likely left out or mispelled the `luks` option in the
_options_ field.

    the precheck for '/dev/disk/by-uuid/...' failed
    /dev/disk/by-uuid/.... contains a filesystem type crypto_LUKS.


LUKS Commands
-------------

Common options:
* `--batch-mode`/`-q`  
  Suppress all confirmations
* `--keyfile`/`-d`  
  Read passphrase from file. `-` is stdin, which ends at EOF (newline
  is part of the key).
* `--keyfile-offset`, `--keyfile-size`/`-l`,
  `--new-keyfile-offset`, `--new-keyfile-size`  
  Bytes to skip and read from authentication and new setting keyfiles
* `--key-slot <0-7>`  

Commands (arguments to `cryptsetup`):
* `luksDump <device>`
* `luksFormat <device> [<keyfile>]`
* `luksAddKey <device> [<new-keyfile>]`
* `luksRemoveKey <device> [<old-keyfile>]`
* `luksChangeKey <device> [<new-keyfile>]`
* `luksKillSlot <device> <slot 0-7>`  
  Without `-q` will prompt for a remaining passphrase first.
* `luksErase <device>`  
   Wipes LUKS header making device permanently inaccessible.


Secure Erase
------------

References:
- tinyapps.org/docs, [ATA Secure Erase (SE) and hdparm][ta-se]
- thomas-krenn.com, [Perform an SSD Secure Erase][tk-se]

`hdparm -I /dev/sdX` gives information on the current security settings.

Lenovo T510 BIOS, and probably many others will set the SSD to 'frozen'
mode. Suspend (sleep mode) the system and bring it back, or hot-swap the
drive, in order to unfreeze it. (`hdparm -I` will say `not frozen` in the
'Security:' section near the end of its output.)

You must set a password to use secure erase if `hdparm -I` says security is
'not enabled': 

    hdparm --user-master u --security-set-pass p /dev/sdX

Erase with:

    hdparm --user-master u --security-erase p /dev/sdx

[ta-se]: https://tinyapps.org/docs/wipe_drives_hdparm.html
[tk-se]: https://www.thomas-krenn.com/en/wiki/Perform_a_SSD_Secure_Erase
