Windows Disk, Partition and Boot Notes
======================================


Shrinking a Partition
---------------------

This is done with "Disk Manager" under the Windows right-click menu. Third
party tools can do a better job, but might not be able to deal with
Bitlocker-protected partitions.

The application logs can show any unmovable files which files are
preventing shrinking the partition. Most of the options below can be found
by typing the given search string into the Start Menu search bar.

- Disable system protection (Control Panel » Create a restore point »
  Configure...)
- Run Disk Cleanup and Disk Defragment
- `powercfg /hibernate off`
- Disable paging file and kernel memory dump, both under Advanced Settings
  - Paging file: » Performance » Settings... » Advanced tab » Virtual
    memory » Change...; then select drive, "No paging file" and "Set" button.
  - Kernel memory dump: » Startup and Recovery » Settings... » System
    Failure » Write Debugging Information. The default is "Automatic memory
    dump"; change to "(none)".
- Reboot


Booting
-------

For Windows 10 ≤ 14093:

    diskpart
    > select disk 0
    > list partition
    > select partition N        # where Windows is installed

    bcdboot c:\windows

System file checker

    sfc /scannow

Bootrec does not work for Windows 10 > 14093, but on older systems:

    bootrec /fixmbr
    bootrec /fixboot
    bootrec /rebuildbcd
