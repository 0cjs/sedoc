Keyboard Information
====================

### Japanese Keyboards

The [standard Japanese PC keyboard][jpkb] is the IBM 5576-A01 PC/AT 106/109
key keyboard, which is an implementation of (or close to) [JIS X
6002:1980]: Keyboard Layout for Information Processing Using The JIS 7 Bit
Coded Character Set].

The positional scan codes are the same as the US 101-key keyboard, that is,
`半角/全角` to the left of `1` produces the same code as the `` `/~ `` key
in that position on a US keyboard. There are also some additional keys
using codes "Keyboard International 1" through "5" in the standards. `X11`
below refers to the X11 keycodes.

    X11     US      JP                      Notes
    ────────────────────────────────────────────────────────────────────────
      9     ` ~     半角 全角
     34     [ {     @ `
     35     ] }     [ {
     51     \ |     ] }
    ────────────────────────────────────────────────────────────────────────
    132             ¥ |                     KI3  left of backspace key
     97             \ _                     KI1  between /? and right shift
    131             無変換                  KI5  left of space bar
    129             変換                    KI4  right of space bar
    208             ひらがな カタカナ       KI2
    ────────────────────────────────────────────────────────────────────────


Linux Keyboard Handling
-----------------------

Pressing or releasing a key on a keyboard generates a _scan code._ Some
keys (e.g., `PrtSc`) may produce an "escaped" scan code of `0xE0 nn`; this
is specified to `setkeycodes(8)` as a single 16-bit hex number `E0nn`.

The scan code (regular or extended) is read by the Linux kernel keyboard
driver and converted to a _keycode_ between 1-255 (1-127 in ≤2.4 kernels)
plus a press or release indication.
- See `/usr/include/linux/input-event-codes.h` for the standard keycode
  names (`KEY_*`). Keycodes 195-199 and 249-254 are unassigned; 255 is
  reserved for "sepcial needs of AT keyboard driver."
- The conversion table can be dumped with `getkeycodes(8)` and changed with
  `setkeycodes SCANCODE KEYCODE ...`. (This might not work with USB
  keyboards, at least as of Linux 3.14.)
- The kernel will log "Unknown key pressed" messages when it receives scan
  codes with no translation in the table.
- Note that the text console utility `showkey -s` does not actually show
  scan codes; it remaps the kernel keycode (that you would see with
  `showkey -k`) back to a scan code using the translation table.
- `udev` can also be used to change the mapping on a per-keyboard basis,
  identifying keyboards using hardware ID glob patterns.
- Further information:
  - Arch Wiki page [Map scancodes to keycodes] has more and explains how to
    add a systemd service to change keycodes at boot.
  - Unix & Linux SE question [How to get all my keys to send
    keycodes][ulse0656] shows a keyboard with `evtest` input event codes
    above 254 and how to get the scan codes to translate them into
    keycodes.

There is apparently an `atkbd.softraw=0` boot option that can ask the
kernel to return actual scan codes.

The Arch Wiki page [Keyboard input] provides information on the higher
levels of keyboard handling for text consoles and X11.

#### Text Consoles

On a text console the keycode, in combination with modifier keys, is mapped
to an _action_ via a `keymaps(5)` keyboard layout table. A keyboard layout
table may also have compose definitions to generate characters from a
two-key sequence and string definitions to generate multiple characters
from a single keypress. (This is usually used for ANSI function key
bindings.) A single mapping table is used for all virtual consoles.

Actions are assigned a number and symbolic name; these can be found in the
`dumpkeys -l` output. Actions include:
- Producing a character. Prefixing it with `+` makes it affected by
  `CapsLock` state in the same way as it is by `Shift`. (Shift+CapsLock
  gives unshifted state; this may be prevented by not putting the `+` in
  front of the shifted version.)
- Producing a string. Strings are assigned arbitrary names (not sure what
  happens on collision with action name), but `F` followed by a decimal
  number will never be used by the kernel.
  - XXX This may be wrong; `F1` etc. also appear to be action names...
- Switching to a different keymap, done by modifier keys.
- Switching to a different virtual console via `Console_1` through
  `Console_63`, `Incr_Console` `Decr_Console` and `Last_Console`.
- Do nothing. Possibly called `VoidSymbol`.

_Modifier actions_ switch between the 256 _keymaps_ (sometimes called
_columns_), giving up to 256 different actions for each key. The regular
modifiers below switch keymaps when pressed (the current keymap number is
the sum of the modifier values) and switch back when released; there are
also versions ending in `_Lock` which do nothing when released and switch
back when pressed a second time. Note that for release to work the modifier
action must be bound also into the _new_ kemyap to which the modifier
switched. The modifier actions are as follows (these are case-insensitive
in `loadkeys`):

     1 Shift     16 ShiftL  256 CapsShift
     2 AltGr     32 ShiftR
     4 Control   64 CtrlL
     8 Alt      128 CtrlR

The following programs show status. These must be run as root if the user
is not currently on a console.
- `kbd_mode`: Show or set keyboard mode. RAW=scancode; MEDIUMRAW=keycode;
  XLATE=ASCII; UNICODE=UTF-8. Normally used only via remote login to
  recover a keyboard that's in the wrong mode.
- `showkey -k`  will show keycodes generated by key presses and releases.
- `showkey -s` will translate these back to scancodes using the
  getkeycodes(8) table (it does not show the actual scancodes received).
- `dumpkeys(1)` will dump the keyboard translation tables.
  - `dumpkeys`: Show keycode, string and compose definitions.
  - `dumpkeys -i`: Short info on keyboard driver characteristics.
  - `dumpkeys -l`: Long info with recognized action symbols and modifiers.

`loadkeys(1)` loads or modifies a keymap.  It detects whether the console
is in Unicode or ASCII mode and converts appropriately. The manual page
contains only some information on the format; further information is in
`keymaps(5)` and the various `dumpkeys(1)` commands above also give further
information and examples. Roughly:
- `MOD … keycode N = ACT` specifies the action for a single column
  determined by the modifiers in a list before the keycode, e.g., `shift
  control keycode 3 = nul` to make Ctrl-2 produce an ASCII NUL. Specify
  `plain` to use this format to define only the column 0 entry of a key,
  leaving all other definitions alone.
- `keycode N = ACT` with only one action sets the same action for all 256
  columns, except for ASCII letters `[A-Za-z]` where it sets uppper case,
  control keys, etc.
- `keycode N = ACT …` with more than one action sets keycode _n_ to perform
  action _act_; additional actions are for the keycode with modifiers. Add
  the modifier numbers above to get the index of the action in the list.
  Any trailing entries of the 256 that are left off are set to `VoidSymbol`
- `keymaps 0-2,4-5,8,12` or similar specifies that following `keycode N`
  lines will specify only the indicated columns.
- `string SNAME = "STR"` to assign string _str_ to action _sname._

`ACT` above is normally a symbolic name. Numbers may also be given in
decimal, octal (`0###`), hex (`0x##`) or "Unicode" (`U+####`) format; the
assignments to actions may vary by kernel version.

The actions such as `Meta_asciitilde` actions all seem simply to prefix the
given character with an Esc, giving `^[~` for the above (and `^[^[` for
Meta_Escape).

`loadkeys -d` is supposed to restore the kernal's default keymap, but
always gives `loadkeys: Unable to find file: defkeymap.map`. On Debian,
`loadkeys /etc/console-setup/cached_UTF-8_del.kmap.gz` seems to restore the
bootup keymap; you may need a `-C /dev/tty1` or similar option if you're
doing this remotely to fix a broken console.

The `console-common` package gives the `install-keymap(8)` command which
expands keymaps (adding the ability to do includes, etc.) and installs the
given one as the boot-time keymap. Its `console-data` dependency installs
many keymaps into `/usr/share/keymaps/`.

References:
- Arch Wiki page [Linux console/Keyboard Configuration][arch-lckc]

Other Notes:
- Debian maps keycode 58 (keytop: CapsLock) to `CtrlL_Lock`. According to
  [susam/uncap], this is a working around for ancient Debian bug [514464]
  and kernel bug [7746].

#### X11

X11 uses 16-bit _keysyms._
For more see [`x11/keyboard`](../x11/keyboard.md).



<!-------------------------------------------------------------------->
[jpkb]: https://web.archive.org/web/*/http://www.euc.jp/i18n/jpkbd.en.html
[JIS X 6002:1980]: https://webstore.ansi.org/Standards/JIS/JIS60021980

[514464]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=514464
[7746]: https://bugzilla.kernel.org/show_bug.cgi?id=7746
[arch-lckc]: https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration
[keyboard input]: <https://wiki.archlinux.org/title/Keyboard_input
[map scancodes to keycodes]: https://wiki.archlinux.org/title/Map_scancodes_to_keycodes
[susam/uncap]: https://github.com/susam/uncap
[ulse0656]: https://unix.stackexchange.com/q/130656/10489
