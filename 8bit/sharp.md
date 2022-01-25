Sharp 8-bit Computers
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

### [MZ-80K Series]

All from the Electronic Parts division until the Information Systems division
takes over and releases the MZ-1200.

Specs:
- CPU: 2 MHz Z-80
- 48 KB max. RAM. 4K ROM w/loaders and low-level I/O routines.
- Video: 40×25 text (8×8 cells; 2×2 block graphics avail.).
  1 KB VRAM, 2 KB character ROM.
- Built-in 9" monitor and CMT.
- All keyboards are "square" (PET-style) layout unless otherwise mentioned.

Models:
- MZ-80K (1978-12, ¥198,000) 20K RAM. Semi-kit (keyboard needed assembly) to
  avoid friction with w/another division (all later models are fully
  assembled). Display will snow during access conflict.
- MZ-80C (1979, ¥268,000) 48K RAM. Typewriter keyboard. No longer kit.
- MZ-80K2 (1980, ¥198,000) 32K RAM.
- MZ-80KE (1981, ¥148,000) Cost-reduced MZ-80K2.
- MZ-80A (1982) 24K RAM. Typewriter keyboard. ROM can be bank-switched out.
  Cycle-stealing CRTC (no snow) and hardware scroll (via moving frame buffer
  start address).
- MZ-1200 (1982?, ¥148,000) Basically an MZ-80A. Taken over by Information
  Systems Division.

### [MZ-80B Series]

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

To-do XXX:
- MZ-3500 (1982) Dual processor Z-80. CP/M; might not be MZ-80-compatible.
- MZ-2500 (1985) "SuperMZ" series: MZ-2511, MZ-2520, MZ-2521, MZ-2531

Later machines (MZ-100, MZ-5500 and up) used 8086-series processors, some with
also a Z-80 and some backward compatibility.



<!-------------------------------------------------------------------->
[MZ-40K]: https://ja.wikipedia.org/wiki/MZ-40K
[MZ-80B Series]: https://ja.wikipedia.org/wiki/MZ-80#MZ-80B
[MZ-80K Series]: https://ja.wikipedia.org/wiki/MZ-80#MZ-80K系機種
[SB-B-80TE]: http://retropc.net/ohishi/museum/80te.htm
[SB-B-80T]: http://retropc.net/ohishi/museum/80t.htm
[nib]: http://retropc.net/ohishi/museum/index.htm
[rpc-mz40k]: http://retropc.net/ohishi/museum/mz40k.htm
