Sord M68 (Z80/68000)
====================

### DIP Switches

- 4: Boot: up=HD, down=floppy.


### Video

- DIN-5 B/W: 1=GND 2=CVBS 4=+5V
- DIN-8 270° RGB: (hsync/vsync inverted compared to VGA)
  - 1=red
  - 2=blue
  - 3=GND
  - 4=green
  - 5=csync
  - 6=DCLK
  - 7=hsync 21.5 kHz
  - 8=vsync 50 Hz

### Keyboard

DIN-8 268°.
- 1: Clock M68 → keyboard (4 MHz shifted slightly from CPU clock)
- 2: GND
- 3: Data out M68 → keyboard
- 4: /Select M68 -> KB
  - Seems to go low when M68 is reading from Keyboard 3.85us
- 5: /reg M68 -> KB
  - has signal indicating which of the 15 reads we are doing. Could be bidir
- 6: GND
- 7: GND
- 8: +5V

### References

- tunozemichanの日記, [Connecting SORD M68 to a VGA monitor][tu-vga]
- [VCFed thread].



<!-------------------------------------------------------------------->
[Retrobug]: https://www.retrobug.org/system/view/sord_m68
[VCFed thread]: https://forum.vcfed.org/index.php?threads/sord-m68-without-keyboard.1250154/
[tu-vga]: https://tunozemichan.hatenablog.com/entry/2021/11/29/193100
