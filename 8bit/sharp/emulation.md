Sharp MZ-series Emulation
=========================


### CSCP mz80k

The hardware keyboard matrix can be found on the [SharpMZ.org
website][80k-matrix]. In the [takeda-cscp-emulators] source, the emulator's
mapping can be found in `src/vm/mz80k/keyboard.cpp` (the second matrix
there exactly matches the hardware matrix above). The special keys are as
follows; `vkey` is the Windows [Virtual-Key Code].

    row,col  key          vkey      vkey-name
    ─────────────────────────────────────────────────────────────────────
      4, 5   ?,£          0xBA      VK_OEM_1  (`;:` key on US keyboards)
      6, 5   KANA,SMLCAP  0x15      VK_KANA   (IME Kana mode)
    ─────────────────────────────────────────────────────────────────────
      8, 0   LSHIFT       0xA0;00¹  VK_LSHIFT (Left Shift Key)
      8, 1   INST/DEL     0x2E      VK_DELETE (Delete Key)
      8, 3   RIGHT/LEFT   0x27      VK_RIGHT  (Right Arrow Key)
      8, 4   CR           0x0D      VK_RETURN (Enter Key)
      8, 5   RSHIFT       0xA1;10¹  VK_RSHIFT (Right Shift Key)
    ─────────────────────────────────────────────────────────────────────
      9, 0   CLR/HOME     0x24      VK_HOME   (Home Key)
      9, 2   UP/DOWN      0x28      VK_DOWN   (Down Arrow Key)
      9, 3   BREAK        0x13      VK_PAUSE  (Pause Key)
    ─────────────────────────────────────────────────────────────────────
    ¹ Second value is when not using DirectInput. 0x00 = not mapped.

The `keycode_conv` (`win32/osd_input.cpp`) array defaults to values 0x00
through 0xFF; this can be changed by creating a 256-byte `keycode.cfg` file
with the new mappings.



<!-------------------------------------------------------------------->
[80k-matrix]: https://sharpmz.org/original/mz-80k/kbdmatrix.htm
[Virtual-Key Code]: https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
[takeda-cscp-emulators]: https://github.com/mc68-net/takeda-cscp-emulators
