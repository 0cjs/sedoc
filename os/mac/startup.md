Mac Startup Options
===================

See also [macOS Sierra: Ways to start up your Mac][Startup].

Keys to hold down during startup (OS X Yosemite):

* `Shift`: safe mode (released when progress indicator shows),
           avoid auto-login, during login avoid opening login items etc.
* `C`: Boot CD/DVD
* `N`: Boot NetBoot disk image
* `T`: Target disk mode
* `D`: Diagnostics/Hardware Test (also see [diag-howto])
* `⌥D`: Internet diagnostics
* `⌘R`: Recovery tools
* `⌥⌘R` (pre-10.12.4), `Shift⌥⌘R` (10.12.4+): Upgrade to latest compatible
  macOS (Always use to wipe El Capitan or earlier to protect Apple ID.)
* `Shift⌥⌘R` (10.12.4+): Reinstall original MacOS that came with this Mac
* `⌥⌘PR`: Reset parameter RAM
* `⌘V`: Verbose mode
* `⌘S`: Single-user mode (not with Filevault disk?)

#### Shutdown

* Hold power button for 6 seconds to force restart.
* `^⌘Power`: Force restart

Wait for laptops to shut down before closing display or it may sleep
instead.


### Diagnostics

Once the diagnostics (`D` or `⌥D` boot) have completed, your serial
number will be displayed and the following options are available:

* `℅R`: Run diagnostics again
* `R`: Restart Mac
* `S`: Shutdown Mac (works with any modifier key)
* `℅G`: "Get Started"; more information including service/support options
  (But doesn't actually work on a MacBook Air 2013.)


[Startup]: https://support.apple.com/kb/PH25625
[diag-howto]: https://support.apple.com/en-us/HT202731
