Windows Keyboard Mapping Notes
==============================

See also [`hw/keyboard`](../hw/keyboard.md) for general keyboard information.

In Windows, PS/2-compatible scan codes provided by devices are converted by
the driver into virtual keys which are then passed on to programs via
Windows messages. (This virtual key conversion is not used by some games.)

Since 2000/XP you can set
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout`
(note, not plural "Layouts") to a list of mappings that change the default
conversion; this is read only on boot. [SharpKeys] provides a nice UI for
making these changes. More details in the [Scan code mapper for
keyboards][scmk] section in "Configuration of keyboard and mouse class
drivers."

[susam/uncap] is a small program that, as long as it's running in the
background, translates any arbitrary keycode to a different keycode. The
README describes a number of alternatives for remapping under Windows,
including registry changes (as [SharpKeys] helps automate) and
[AutoHotKey]. It also gives some Linux and MacOS information.



<!-------------------------------------------------------------------->
[AutoHotKey]: http://www.autohotkey.com/
[SharpKeys]: https://sharpkeys.codeplex.com/
[scmk]: https://docs.microsoft.com/en-us/windows-hardware/drivers/hid/keyboard-and-mouse-class-drivers#scan_code_mapper_for_keyboards
[susam/uncap]: https://github.com/susam/uncap
