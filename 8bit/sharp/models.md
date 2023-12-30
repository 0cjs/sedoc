Sharp Computer Models
=====================

The [Nibbles lab シャープ博物館 (Sharp Museum)][nib] has pages for many of
these computers and newer ones, and lots of (small) photos.

### Single-board Computers and Trainers

[MZ-40K][] (1978, ¥24,800 kit). 4-bit Fujitsu MB8843 microcontroller, keypad,
4-digit 7-segment LED display, speaker. Not programmable as it had no monitor
in the microcontroller mask ROM, just some demo programs. More a toy or
soldering exercise than a real computer.
- ROM: 1024×8 bits mask ROM in microcontroller
- RAM: 64×4 bits in CPU; 2× MB8101 256×4 bits
- Produced by Electronic Parts Division.
- Tons of good photos and info on [Nibbles lab][rpc-mz40k].
- Built-in programs: clock, timer, sensor, organ, tone playback, telephone
  charge calculation, games (random number generator based on keypress).

[SB-B-80T][] (197?, ¥85,000) Z-80 trainer/development board.
- Keyboard separate from main board: hex keypad and 8 digits of 7-segment LED
- 2× Z80PIO (one used for keyboard/display)
- Kansas City tape
- Two ROM sockets w/switch between them. One loaded with monitor ROM.
- GT (LH-8H04) option adds additional boards for more RAM/ROM, typewriter
  keyboard, video display, printer I/F, etc. (similar to NEC TK-80 BASIC
  Station)

[SM-B-80TE][] (19??, ¥39,800) Z-80 trainer/development board; much-revised
SM-B-80T
- Keyboard/display moved on to main board and permanently attached to Z80PIO.
- CPU: Z-80 (LH-0080) 2.4576MHz (4.9152MHz crystal)
- ROM: 2× 2716 / 2732 sockets for 4KB/8KB total; supplied w/2K 2716
- RAM: 2K static RAM; expandable to 4K (monitor uses $700-$7FF)
- Z-80PIO (LH-0081) for LED/kbd/CMT; socket for 2nd PIO
- Tape I/F is now FSK, 1200 bps.

### [MZ-80K "Hobby" Series][80k-series]

All from the Electronic Parts division until the Information Systems division
takes over and releases the MZ-1200.

Specs:
- CPU: 2 MHz Z-80
- 48 KB max. RAM. 4K ROM w/loaders and low-level I/O routines.
- Video: 40×25 text (8×8 cells; 2×2 block graphics avail.).
  1 KB VRAM, 2 KB character ROM.
- Built-in 9" monitor and CMT.
- All keyboards are "square" (PET-style) layout unless otherwise mentioned.
- CMT: 1200 bps.

Built-in monochrome display:
- MZ-80K (1978-12, ¥198,000) 20K RAM. Semi-kit (keyboard needed assembly) to
  avoid friction with w/another division (all later models are fully
  assembled). Display will snow during access conflict.
- MZ-80C (1979, ¥268,000) 48K RAM. Typewriter keyboard. No longer kit.
- MZ-80K2 (1980, ¥198,000) 32K RAM.
- MZ-80K2E (1981, ¥148,000) Cost-reduced MZ-80K2.
- MZ-80A (1982) 24K RAM. Typewriter keyboard. ROM can be bank-switched out.
  Cycle-stealing CRTC (no snow) and hardware scroll (via moving frame buffer
  start address).
- MZ-1200 (1982?, ¥148,000) Basically an MZ-80A. Taken over by Information
  Systems Division.

External colour display:
- MZ-700 (1982-11) 3.58 Mhz. 64K + 4K VRAM.
  - Almost perfectly compatible with MZ-80K. Came with S-BASIC and Hu-BASIC.
  - MZ-711 (¥79,000): Base model; no CMT or plotter.
  - MZ-721 (¥89,000): MZ-1T01 CMT (MZ-721).
  - MZ-731 (¥128,000): CMT and  MZ-1P01 color plotter printer.
  - External printer MZ-80P5(K) available. PCB printer switch must be set
    to external position (left), not `INT` (right). Printer connector port
    covered with metal panel on MZ-731.
  - Back panel:
    - Upper: RF (RCA), CH2-CH1 (SW), B/W-COLOR (SW), CVBS (RCA), RGB (DIN-8)
    - Lower: CMT READ, WRITE (2×3.5mm mono)
      - JOYSTICK (2 5-pin headers (JST?) behind panel)
      - I/O-BUS: 2×25 edge connector, key between 11/13, behind panel
      - PRINTER: 2×13 edge connector, key between 5/7, behind panel, neg.logic
      - VOLUME (pot), RESET (btn).
    - Right: Power (IEC C8), FG (terminal), POWER (sw).
  - Dimenstions: 440 × 305 × 86/102 (printer), 3.6/4.0/4.6 kg
- MZ-1500 (1984, JP only) 320×200 graphics; TI SN76489 sound; 2.8" QuickDisk.
- MZ-800 (1985) First w/640×200 graphics TI SN6489 sound; 2.8" QuickDisk.

Peripherals:
- MZ-IU06 Extension Unit: external card cage expansion for MZ-700.
- MZ-1E05 Floppy Disk Interface: controller for MZ-1F02.
- MZ-1F02: Floppy disk drive (1-2, appears to be 5.25").

### [MZ-80B "Business" Series][80b-series]

ROM has IPL only, no low-level I/O routines. (IPL copied from ROM to RAM.)

Specs:
- CPU: 4 MHz Z-80
- 64K RAM (32K in some overseas models). 2KB ROM (IPL only).
- Video: 40×25 and 80×25 (8×8 cells).
  - MZ-8BG board: 320×200 monochrome (overlaid over text screen).
  - MZ-8BGK board: 320×200 2-plane (overlaid over text screen and MZ-8BG?).
- Built-in 9" monitor and CMT
Typewriter keyboard.

Models:
- MZ-80B (1981, ¥278,000) 64 KB.
- MZ-80B2 (1982, ¥278,000) 64 KB. Graphics VRAM standard?
- MZ-2000 (1982): optional color monitor, BASIC-level compatible with MZ-80B.
- MZ-2200 (1983): only one in series w/o monitor or CMT (but still very deep).
  No built-in CMT; special CMT connector. Expansion card unit bolts on back
  to make it even deeper.

To-do XXX:
- MZ-3500 (1982) Dual processor Z-80. CP/M; might not be MZ-80-compatible.
- MZ-2500 (1985) "SuperMZ" series: MZ-2511, MZ-2520, MZ-2521, MZ-2531
  - MZ-2521: desktop case
    - CMT and 2 3.5" FDDs; 2× RS-232 (DB-25F, DE-9F)
    - front switch for MZ-2500, MZ-200 and MZ-80B modes
    - Coor and B/W DIN-8, each with analog/digtal switch


Later machines (MZ-100, MZ-5500 and up) used 8086-series processors, some with
also a Z-80 and some backward compatibility.



<!-------------------------------------------------------------------->
[MZ-40K]: https://ja.wikipedia.org/wiki/MZ-40K
[80b-series]: https://ja.wikipedia.org/wiki/MZ-80#MZ-80B
[80k-series]: https://ja.wikipedia.org/wiki/MZ-80#MZ-80K系機種
[SB-B-80TE]: http://retropc.net/ohishi/museum/80te.htm
[SB-B-80T]: http://retropc.net/ohishi/museum/80t.htm
[nib]: http://retropc.net/ohishi/museum/index.htm
[rpc-mz40k]: http://retropc.net/ohishi/museum/mz40k.htm
