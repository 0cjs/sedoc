Windows 10 Tips and Tricks
==========================

### Lock Icon

Create a shortcut to `rundll32.exe user32.dll,LockWorkStation`.
This can also be run from the command line.

### Change Screen → Lock Timeout

Control Panel » Screen Saver, "Wait" setting.

### Change Screen Timeout After Lock

(I don't really care about this _lock screen_; it was a wrong turn when
trying to figure out how to change the _screen lock_ timeout.)

Use Regedit to change under the key below the `Attributes` value from `1`
to `2`. Then under Control Panel » Power Options » Change plan settings »
Change advanced power settings » +Display you will find a new option,
"Console lock display off timeout" which defaults to 2 minutes. ([How-To
Geek][htg 267893])

  HKEYLOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings
      \7516b95f-f776-4464-8c53-06167f40cc99\8EC4B3A5-6868-48c2-BE75-4F3044BE88A7

That said, though the setting appears for me on Windows 10, it doesn't seem
to be taking effect.

### RTC (Hardware) Clock in UTC

For more recent versions of Windows 10, run [`rtc-utc.reg`](rtc-utc.reg) or
use `regedit` to manually set the `DWORD` key. The time zone and DST
settings will no longer affect the hardware clock. Earlier versions of
Windows 10 and 64-bit Windows 7 have a bug that needs a `QWORD` instead; in
modern builds only `DWORD` works. [[Arch Wiki][rtc-utc]]



<!-------------------------------------------------------------------->
[htg 267893]: https://www.howtogeek.com/267893/how-to-change-the-windows-10-lock-screen-timeout/
[rtc-utc]: https://wiki.archlinux.org/title/System_time#UTC_in_Microsoft_Windows
