PETSCII and Keyboards
=====================

References:
- aivosto.com: [Commodore PETSCII character sets][avivosto] (PDF)
  Includes images of all chars from all models.
- c64.org [Commodore 64 PETSCII codes][c64.org]
  Good side-by-side quick reference as HTML table.
- pagetable.com, [Why does PETSCII have upper case and lower case
  reversed?][pt-857], 2016-07-17.  
  Possibly not a correct explanation; see the comment below the post.

[PETSCII] is also known as "CBM ASCII."
- Based on ASCII 1963 (not [1967][ascii]),
  thus missing backtick (`$60`) and `{}|~` (`$7B-$7E`).
- Two sets:
  - "Graphics"/unshifted: upper case only
  - "Business"/"text"/shifted: lower case in u/c area; upper case in l/c area
  - PET: `POKE 59468,12` for graphics, `,14` for business.
  - C64: Toggle w/Shift-`C=`, or:
    - Graphics: print `CHR$(14)` or `POKE 53272,23`
    - Business: print `CHR$(142)` or `POKE 53272,21`
- Output control chars include: `{HOME}`, `{CLR}`, `{RVS ON}`, etc.;
  appear as reversed chars on screen.
- C64 set 1 input: `C=` gives graphic on left of key, shift gives
  graphic on right.

Ranges (GR=graphics/unshifted; BT=business/text/shifted):
- $00-$1F: (Non-standard) screen control/color codes.
- $20-$3F: Standard punctuation, digits.
- $40-$5F: GR: upper case; BT: lower case. `\`=`£`. `^`=`↑`, `_`=`←`
- $60-$7F: (duplicates of $C0-DF)
- $80-$9F: (Non-standard) screen control/color codes.
- $A0-$BF: symbols
- $C0-$DF: GR: symbols; BT: upper case.
- $E0-$FE: (duplicates $A0-$BF)
- $FF: duplicate of $DE

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
[ascii]: ../../ascii.md
[avivosto]: https://www.aivosto.com/articles/petscii.pdf
[c64.org]: http://sta.c64.org/cbm64pet.html
[c64w-keyboard]: https://www.c64-wiki.com/wiki/Keyboard
[c64w-restore]: https://www.c64-wiki.com/wiki/RESTORE_(Key)
[pt-857]: https://www.pagetable.com/?p=857
[rc 11191]: https://retrocomputing.stackexchange.com/a/11191/7208
