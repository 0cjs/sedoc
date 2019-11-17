PC-6001 mkII 用 FDD エミュレータ - SD6031 -
===========================================

This is the firmware for [SD6031], an emulator for the external
PC-6031 floppy disk drive unit. This is hooked up to a PC-6001 via a
PC-6011A expansion unit, or directly to a PC-6001mkII or PC-6001mkIISR.
(It has been tested only with the PC-6001mkII.) It does not work with
the PC-6600 series.

It is also said to work with the PC-8001mkII but requires a separate
power 5-9V power supply, and doesn't support some of the extra
PC-8001mkII commands. This is supported by the Wikipedia
[PC-6000シリーズ][wj-pc6000] page, which says that the the
PC-8000/8800 series drives can be connected to the PC-6001mkIISR.

### Usage

The PC-6001mkII must have the switch set to 1D mode. The SD card must
be formatted as FAT16. The emulator mounts the first `*.P31` image
file it finds as drive one, and `*.P32` through `*.P34` as drives 2-4.
(`files 1`, `files 2` etc. on the PC will show the disk directories.)
`.D88` files can be converted using `d88_p31` and `p31_d88` utilities,
though the links to them from that page are broken.

Disk images for utilities (to format disks, etc.) are available from
the [SD6031] page in [`UTILITY.ZIP`].

### Technical Details

The emulator is based on an Amtel ATMEGA164P AVR running at 20 MHz,
and seems to have very little hardware otherwise. (SD card reader, a
switch for 1D vs. 2D mode, LEDs for drive 1/drive 2 access, and caps.)
It's not clear if schematics are available, but Nishida Radio [sells
units][shop] for ¥9800.

Further technical details about the `.P31` file format, communications
protocol and pinouts are given on the [spec page][SD6031-spec] ([local
copy](spec.html)).

The computer side is likely an Intel [i8255] PIO compatible chip which
has three 8-bit ports, or similar. See the § "Floppy Disk" in the
[README above][fd] for references.

PC-6001 PCB edge connector pinout (from the spec page):

      1-8   PB0-PB7     out     data out
        9   n/c         -
    10-18   GND         -       signal ground
    19-26   PA0-7       in      data in
    27-30   PC4-7       out     ATN, DAC, RFD, DAV
    31-34   PC0-3       in      ATN, DAC, RFD, DAV
       35   RESET       out     reset
       36   GND         -       signal ground



<!-------------------------------------------------------------------->
[SD6031-spec]: http://tulip-house.ddo.jp/DIGITAL/SD6031V1/spec.html
[SD6031]: http://tulip-house.ddo.jp/DIGITAL/SD6031V1/
[`UTILITY.ZIP`]: http://tulip-house.ddo.jp/DIGITAL/SD6031V1/UTILITY.ZIP
[shop]: http://tulip-house.ddo.jp/DIGITAL/

[fd]: ../README.md#floppy-disk
[i8255]: https://en.wikipedia.org/wiki/Intel_8255
[wj-pc6000]: https://ja.wikipedia.org/wiki/PC-6000シリーズ
