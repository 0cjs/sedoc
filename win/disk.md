Windows Disk, Partition and Boot Notes
======================================


Shrinking a Partition
---------------------

This is done with "Disk Manager" under the Windows right-click menu. Third
party tools can do a better job, but might not be able to deal with
Bitlocker-protected partitions.

The following setup will help disable things that generate unmovable files;
this should be reversed after shrinking. Most of the options below can be
found by typing the given search string into the Start Menu search bar.

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

After doing a defrag, you can use the application logs to check for
unmovable files that prevented shrinkage: `Event Viewer » (left panel)
Windows Logs » Application » (right panel column) Source » (value) Defrag`.
Just before the successful completion event (Event ID 258) should be an
initiated event (259) that gives various information, including the last
unmovable file. (There is a filter option that might help you find Event ID
259.) 

If the file can't be deleted after uninstalling programs and whatnot, try
holding Shift while choosing Delete in the menu (permanent delete instead
of Recycle bin). Failing that Shift-Delete may work in Safe mode. (Settings
» Updates » Recovery » Advanced Startup » Restart Now and then you'll get
an option to restart in Safe Mode. You'll need the BitLocker recovery key.)


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
