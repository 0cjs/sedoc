PETSCII and Keyboards
=====================

[PETSCII] is also known as "CBM ASCII."
- Based on ASCII 1963 (not [1967][ascii]),
  thus missing backtick (`$60`) and `{}|~` (`$7B-$7E`).
- Two sets, 1 (unshifted) UC only and 2 (shifted) including LC. C64
  toggle w/Shift-`C=` or `POKE 59468,12` unshift, `,14` shift.
- Output control chars include: `{HOME}`, `{CLR}`, `{RVS ON}`, etc.;
  appear as reversed chars on screen.
- C64 set 1 input: `C=` gives graphic on left of key, shift gives
  graphic on right.

Ranges:
- $00-$1F: Standard control chars.
- $20-$3F: Standard punctuation, digits.
- $40-$5F: 1:UC, 2:LC. `\`=`£`. `^`=`↑`, `_`=`←`
- $60-$7F: 1:symbols, 2:UC.
- $80-$9F: control?
- $A0-$BF: symbols

C64 chargen ROM codes are different (e.g., `@ABC` = $00 $01 $02 $03).

![C64 fonts](https://upload.wikimedia.org/wikipedia/commons/d/d8/Fonts-C64.png)


Keyboards
---------

- [Keyboard][c64w-keyboard] on the C64 Wiki for an outline of the scan
  matrix and usage in assembler and BASIC.
- [RCSE answer][rc 11191] to "Reading both keyboard and joystick with
  non-KERNAL code on C64" for details of keyboard/joystick scanning,
  including schematics.
- `RESTORE` key hooked to NMI; see C64 Wiki
  [RESTORE (Key)][c64w-restore]. Normally hooked to ML routine that
  resets back to BASIC if `RUN/STOP`+`RESTORE` is pressed.

![C64 keyboard](https://www.c64-wiki.com/images/4/42/Tastatur_foto1.jpg)



<!-------------------------------------------------------------------->
[PETSCII]: https://en.wikipedia.org/wiki/PETSCII
[ascii]: ../../ascii.txt
[c64w-keyboard]: https://www.c64-wiki.com/wiki/Keyboard
[c64w-restore]: https://www.c64-wiki.com/wiki/RESTORE_(Key)
[rc 11191]: https://retrocomputing.stackexchange.com/a/11191/7208
