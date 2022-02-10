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


<!-------------------------------------------------------------------->
[jpkb]: https://web.archive.org/web/*/http://www.euc.jp/i18n/jpkbd.en.html
[JIS X 6002:1980]: https://webstore.ansi.org/Standards/JIS/JIS60021980
