Apple Macintosh
===============

Mac Classic:
- Left side front button is reset; rear button is NMI, which brings up
  [MicroBug].
- Command-Option-X-O boots ROM MacOS 6.x (if held down early enough)


MicroBug
--------

Numbers are entered in hex. All expressions have an inherent size of byte,
word (16 bits) or long (32 bits) based on the number of hex digits. `.`,
registers, etc. are 4 bytes. Bad expressions do not produce an error but
instead do random stuff.Parsing is extremely "forgiving," 

- `.`: Yields "dot address." Initially 0; set by `DM` and `SM`
- `@<expr>`: Yields value of memory at _expr._
- `RAx`: Yields contents of address register _Ax._
- `RDx`: Yields contents of data register _Dx._
- `PC`: Yields contents of program counter.
- `- <expr>`: Yields _expr_ negated.
- `<expr> + <expr>`: Sum.
- `<expr> - <expr>`: Difference.

Commands:
- `DM [addr]`: Dump memory and set `.` to _addr._ Defaults to one past last
  location dumped. Typing Enter after continues dump.
- `SM addr expr...`: Set memory, set `.` to _addr_ and display dump of
  entered data. _exprs_ may be byte, word or long. Typing Enter after
  continues dump.
- `G [addr]`: Start execution at _addr._ Defaults to where MicroBug was
  entered (i.e., resume program).
- `TD`: Display all registers ("total display").
- `Ax|Dx|PC|SR [expr]`. Display or set register.

Tips and tricks:
- Force quit current process with `SM 0 A9F4G 0`. (Places an `_ExitToShell`
  trap at 0 and continues at that trap.)
- If system hangs in debugger, try turnning off your modem.
- Use MacsBug on a second Mac (running similar code?) to be able to
  disassemble code, etc.


Floppy Drives
-------------

Hold down mouse button during power-up to auto-eject floppy.

- SuperDrive (1.44MB): Sony MFD-75W-01G
- 800K drive: Sony MP-51W, MFD-51W series. Used in the 1986 Macintosh 512K
  and Plus, and the 1987 Macintosh SE.

Suggested lubrication is Molykote EM-30L (Poly-α-olefin, Lithium soap, PTFE
etc.) for gears and metal-on-metal contacts, and SuperLube PFTE oil for
rails and some studs. Others suggest [silicone grease][] (usually PDMS
silicone oil and amorphous fumed silica thickener).

JDW mentions that Kure 5-56 (same thing as WD-40) should _not_ be used
as a lubricant.

Videos:
- New Old Computers, [How to service a Mac Plus floppy drive][noc]
- JDW, [Macintosh 800K Floppy Drive Recap & Lube][jdw-800]
- JDW, [Gear FIX & Molykote LUBE of Apple 1.44MB Floppy Drive
  [MP-F75W-02G]][jdw-1440]. Includes Ebay link for moulded eject gear and
  [Mouser cart][jdw-1440-cart] link for recap (a few caps are slightly
  different from 800K drive).
- CTMacMan, [Sony 800k & 1.4MB Floppy Drive Cleaning and Lubrication][ctmm]



<!-------------------------------------------------------------------->
[Molykote EM-30L]: https://www.ulbrich.at/chemical-technical-products/aut/TDS_MOLYKOTE_EM_30L.pdf
[ctmm]: https://www.youtube.com/watch?v=qLyzjHTukos
[jdw-1440-cart]: https://www.mouser.com/ProjectManager/ProjectDetail.aspx?AccessID=18092c06e8
[jdw-1440]: https://www.youtube.com/watch?v=ia513LCN7jY
[noc]: https://www.youtube.com/watch?v=1yH9OF92fE8
[silicone grease]: https://en.wikipedia.org/wiki/Silicone_grease
[MicroBug]: https://developer.apple.com/library/archive/technotes/tn/tn1136.html
