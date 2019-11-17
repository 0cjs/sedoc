PC-6001/8001 Disk Interfaces
============================


According to the [PC-8800シリーズ][wj-pc8800], the PC-8001/8801 series used
(in Japan only) an "intelligent" external disk unit (the PC-8031,
presumably) with its own Z-80 controlling the disks; the FDD port used an
[i8255]-compatible PIO chip for communications with the peripheral.

The mkII series have a "controller" built in, but the original PC-8001 did
not. It seems that the PC-8033 interface was just an 8255 chip, however,
and one can build it oneself fairly easily: [PC-8033を自作する][8033self].

#### Projects

- [PC-8001をゲームマシン化(SDメモリ版2017/6)][8001game-sd] adds an 8255 to a
  PC-8001 via the expansion bus. This was used by the homebrew PC-8033
  project above, but this project seems to put the chip at I/O ports
  $FC-$FF, and below we have evidence that they're supposed to be at
  $D0-$D3. Perhaps the other guy changed the decoding? Anyway, this one is
  connected to an SD card and a custom ROM is put on the motherboard to
  present a menu and load games from the SD card. (Also see his [game rom
  schematic][8001game-rom].)


- The [SD6031] is an FDD Emulator for the PC-6001mkII that can work with
  the PC-8001mkII (though the pinout looks to be different. See the README
  in the [firmware source](sd6031/) is here for more details.

- There also seems to be a separate and quite different (and larger)
  "SD6031" project on [sbeach.seesaa.net][sb-sd3601]. This one appears to
  connect directly to the expansion bus on a PC-6001 (and perhaps 8001) and
  can't be used on the mkII etc. models without removing the i8255 (on
  perhaps by wiring it into the FDD emulator). They also have the SD6031WIF
  a FlashAir version. Either or both of these may also offer an HDD mode
  and RAM expansion.


Connections and Pinouts
-----------------------

The computer side is likely an Intel [i8255] PIO compatible chip which has
three 8-bit ports, or similar. It's a 40-pin DIP; [here are images][er-146]
of Intel P8255A-5, Toshiba TMP8255AP-5 and NEC μPD8255AC-5, along with
comments on programming it.

[sb-access] shows two 8255s (in the computer and the drive unit) cross-wired:

    Computer         FDD Unit      Notes
     Port A      <--  Port B
     Port B      -->  Port A
     Port C 7-4  -->  Port C 3-0   ATN, DAC, RFD, DAV
     Port C 3-0  <--  Port C 7-4   (ATN), DAC, RFD, DAV

[This page][PC8001-PIC] offers a PIC-based board used to hook up the drive
directly to a Windows machine (for converting old floppies) and includes
diagrams of the PC-8033/PC-8031 connection (like the above) and protocol
diagrams.

PC-6001 PCB edge connector pinout (from the [SD6031 spec page][SD6031-spec]):

      1-8   PB0-PB7     out     data out
        9   n/c         -
    10-18   GND         -       signal ground
    19-26   PA0-7       in      data in
    27-30   PC4-7       out     ATN, DAC, RFD, DAV
    31-34   PC0-3       in      ATN, DAC, RFD, DAV
       35   RESET       out     reset
       36   GND         -       signal ground

[PC-8001mkII and later pinout][er-268]:

      1-8   PB0-PB7             (to PA0-7 on FDD side)
     9-18   GND
    19-26   PA0-PA7             (to PB0-7 on FDD side)
    27-30   PC4-7               (to PC0-3 on FDD side)
    31-34   PC0-3               (to PC4-7 on FDD side)
       35   /RESET
       36   GND

[PC-8012 I/O Unit][er-268] or PC-8033 FDD interface for PC-8001:



IO Ports
--------

For the PC-6000 series, from [sb-access]:

    $B1     bit2=1, external FDD can be accessed (66/66SR only)
    $D0     8255 port A
    $D1     8255 port B
    $D2     8255 port C
    $D3     8255 control

It also mentions something about $F7 needing to be set along with $B1. Both
of these apply only to the 66/66SR; not to any of the 6000 series.


Protocol
--------

References:
- sbeach.seesaa.net [How to access an external FDD][sb-access]
- [SD6031 spec page][SD6031-spec] ([local copy](sd6031/spec.html)).
- sbeach.seesaa.net SD6031 Firmware Command List [part 1][sb-sd6031-cmd1]
  and [part 2][sb-sd6031-cmd2].
- [PC8001-PIC][] (protocol and command diagrams at bottom of page)

The protocol is driven by the PC.

Command sequence (send data is same except without ATN up/down):

    -->  ATN=1
    <--  wait for RFD=1 or time out
    -->  ATN=0
    -->  set data lines, DAV=1
    <--  wait for DAC=1
    -->  DAV=0
    <--  wait for DAC=0

Receive data:

    <-- RFD = 1
    --> wait for DAV=1 or time out
    --> RFD=0, read data, DAC=1
    <-- wait for DAV=0
    --> DAC=0


Boot
----

The comments to [sb-access] discuss booting, with stuff relating to whether
`SYS`, `RXR`, `IPL` is at location $F900-$F902; the last calls $C003.


<!-------------------------------------------------------------------->
[8001game-rom]: http://w01.tp1.jp/~a571632211/pc8001/pc8001rw.png
[8001game-sd]: http://w01.tp1.jp/~a571632211/pc8001/index.html
[8033self]: https://blog.goo.ne.jp/tk-80/e/fd42e45f6f2e993327d567582c0df1d0
[PC8001-PIC]: http://www8.plala.or.jp/ita-sys/K02C_PC8001-PIC.html
[SD6031-spec]: http://tulip-house.ddo.jp/DIGITAL/SD6031V1/spec.html
[SD6031]: http://tulip-house.ddo.jp/DIGITAL/SD6031V1/
[er-146]: https://electrelic.com/electrelic/node/146
[er-268]: https://electrelic.com/electrelic/node/268
[er-330]: https://electrelic.com/electrelic/node/330
[i8255]: https://en.wikipedia.org/wiki/Intel_8255
[sb-access]: http://sbeach.seesaa.net/article/387861573.html
[sb-sd3601]: http://sbeach.seesaa.net/category/22105341-1.html
[sb-sd6031-cmd1]: http://sbeach.seesaa.net/article/468174889.html
[sb-sd6031-cmd2]: http://sbeach.seesaa.net/article/468174896.html
[wj-pc8800]: https://ja.wikipedia.org/wiki/PC-8800シリーズ
