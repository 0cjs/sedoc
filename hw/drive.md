Mass Storage (Drive) and Partitioning Information
=================================================


Linux Tools
-----------

Much of this info from [cks-190331] and its comments.

- `hdparm`: SATA/IDE device information, parameters and commands.
  `-i` gets kernel info for given device; `-I` does direct info request.
- `wipefs`: Clear partition sigantures from a block device.
- `fstrim`: Send SSD TRIM command for unused blocks in mounted filesystem.
- `blkdiscard`: Send SSD TRIM for arbitrary range of block device.

#### Secure Erase

From a comment by [David Magda] on [cks-190331]:

The [ATA secure erase] meets NIST's definition of "purge" in Special
Publication 800-88 Rev. 1. The "enhanced" command below supposedly
destroys data in sectors that have been remapped.

    hdparm -I /dev/sdX      # Ensure "not frozen."
    #   Set temporary password.
    hdparm --user-master u --security-set-pass MyPW /dev/sdX
    #   One of the following two wipe commands:
    hdparm --user-master u --security-erase-enhanced MyPW /dev/X
    hdparm --user-master u --security-erase MyPW /dev/X



<!-------------------------------------------------------------------->
[ATA secure erase]: https://ata.wiki.kernel.org/index.php/ATA_Secure_Erase
[David Magda]: http://www.magda.ca/
[cks-190331]: https://utcc.utoronto.ca/~cks/space/blog/linux/ErasingSSDsWithBlkdiscard?showcomments
