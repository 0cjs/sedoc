Mac and OS X/macOS
==================

[OS Releases]
-------------

"OS X" up to 10.11; "macOS" from 10.12.

Date    | Ver   | Codename      | Notes
--------|-------|---------------|--------------------------------
2017-?? | 10.13 | High Sierra   | APFS replaces HFS Plus
2016-09 | 10.12 | Sierra        |
2015-09 | 10.11 | El Capitan    |
2014-06 | 10.10 | Yosmite       |
2013-06 | 10.9  | Mavericks     |
2012-02 | 10.8  | Mountain Lion |
2010-10 | 10.7  | Lion          | FileVault becomes whole-disk encryption
2008-06 | 10.6  | Snow Leopard  |
2006-06 | 10.5  | Leopard       |


System Information
------------------

* `system_profiler SPHardwareDataType` will show model information,
  CPU/mem, serial number, etc.


[Startup]
---------

Keys to hold down during startup (OS X Yosemite):

* `Shift`: safe mode (released when progress indicator shows),
           avoid auto-login, during login avoid opening login items etc.
* `C`: Boot CD/DVD
* `N`: Boot NetBoot disk image
* `T`: Target disk mode
* `D`: Diagnostics/Hardware Test
* `Command-R`: Recovery tools
* `Option-Command-P-R`: Reset parameter RAM
* `Command-V`: Verbose mode
* `Command-S`: Single-user mode (not with Filevault disk?)

#### Shutdown

* Hold power button for 6 seconds to force restart.
* `Control-Command-Power`: Force restart

Wait for laptops to shut down before closing display or it may sleep
instead.


Misc.
-----

* [User and Guest User info](https://support.apple.com/kb/PH25796)



[Startup]: https://support.apple.com/kb/PH25625
[OS Releases]: https://en.wikipedia.org/wiki/MacOS#Release_history
