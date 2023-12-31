Floppy Disk Generic Information
===============================

This document covers information up to the track and sector level. For
higher-level information such as filesystem layouts and communications
protocols between computers and "smart" drives, see other files in
this repo with "floppy" in the name. (This file properly belongs under
`/ee/`, but it's under `/8bit/` to make it more noticable when browsing
other floppy disk information.)

Below "FDC" refers to a floppy disk controller chip such as the
[MB8877][] (PDF data sheet). This may be built-in to the computer or
accessed remotely as in the [FM-7 floppy interface](fm7/floppy.md).

Tracks/sectors may be read/written at three levels:

- Track/head/sector: reading blocks on a formatted disk by sector
  address. This is done via software routines that use the lower
  levels below, as in [FM-7 BIOS calls][fm7bios], or via messages to a
  "smart" external controller as with the [PC-8001 interface][pc8k] or
  direct access programming the [Commodore IEC][iec]

- Raw level: reading/writing individual bytes on a track or sector
  after MFM/GCR decoding. Usually done via an FDC, and depending on
  the type of command sent to the FDC (track read or sector read) the
  program or the FDC may do the sector identification.

- Flux level: a sequence of magnetic flux transitions on the disk.
  These are always full-track reads and need to be decoded to bytes
  and then further decoded to differentiate gap, synchronization,
  identification, data and CRC bytes.


Diskette and Drive Types
------------------------

All references to orientation of holes and notches assuming looking at the
top of the diskette with the label in the upper left and the oval access
hole at the bottom.

General references:
- Herb Johnson, [Tech information on floppy disks drives and media][hjt].
  Links to this are given below as `[HJ-xxx]` references.
- André Fachat, [_Notes on Floppy Disks_][andre19], 2019-01-02.
  Magnetization and media, data encoding (FM, MFM, CBM/Apple GCR), zone
  recording.

### Media

For standard drives there are only two types of magnetic coating: what I
call "standard" and by many is now called "double density" (DD, 1D, 2D, 2DD
and many other abbreviations) and "high density" (HD). These differ in
coercivity and thickness of the magnetic media. DD / HD 5.25" is 300 / 600
Oersted and 3.5" is 660 / 720 Oe. [[Retrocomputing SE][rcse 9303]]

All recordings to standard density diskettes use the same _flux density,_
regardless of other aspects of the format. Even with just the one flux
density, different ways of recording give a very wide range of capacities,
from around 90 KB for single-sided 40-track "single-density" FM formats to
800 KB or more for double-sided 80-track MFM formats.

Single vs. double density refers only to the encoding format: FM for SD and
MFM for DD. (M2FM was an early DD scheme replaced by MFM.) Though differing
in information density, both are the same flux density, and use the same
standard density (or "double density," as it's now called) media.

So-called "quad density" (5.25" only) or "2DD" refers to 80-track drives;
again the magnetic coating is standard ("double density") media.

8" floppy sleeves have the index hole in a [slightly different
location][boginjr] on single-sided and double-sided diskettes, and so 1S
diskettes cannot be used in 2S drives. (2S drives may have two sensors, one
for SS and one for DS diskettes.)

8" floppies also require a [reduced write current][hj-tg43] after track 43
in order to avoid self-erasure due to the higher flux/distance density on
the inner tracks. Earlier drives have a `TG43` (track greater than 43)
signal input that the controller must assert; later drives did this
automatically (which is useful when interfacing with a controller designed
for 5.25" drives that does not provide this signal).

The above is entirely separate from [_write precompensation,_][wp-precomp]
which was rarely used on floppies but more often [on on RLL and ESDI
HDDs][hj-tg43]. That's a change in timing such that the readback is closer
to the original signal before the timing change, and is done solely by the
controller.

### Drive Types

Here's a summary of the drive type info from [[hj-data]], with references
for particular examples. Capacities are approximate based on a common
two-sided MFM format; for more examples see Wikipedia [List of floppy disk
formats][wp-fmtlist]. Data frequency is given as FM/MFM kbps.

Double-density:
- __8" DD__ 77-track (1 MiB). Index hole above and to the right of the
  center hole, write protect notch on the bottom towards the right.
  360 RPM, 77 tracks at 48 tpi with write current reduced for tracks >43. 
  250/500 kbps (FM/MFM, SD/DD); typically 26 sectors of 128 bytes (FM/SD)
  or 256 bytes (MFM/DD). Separate outputs defined for head data and
  separated data and clock, though only some drives include a (usually FM?)
  data separator.
  - Shugart [SA800/801 Diskette Storage Drive OEM Manual][sa800oem]
- __5.25" DD 40-track__ (320/360 KiB). 35 tracks for early drives and
  C64. 300 RPM, 48-tpi, 125/250 kbps. Fujitsu called these "2D".
  - Shugart SA400 minifloppy™ Diskette Storage Drive [Service
    Manual][sa400sm] and [OEM Manual][sa400oem] (5.25" drives)
  - Jim Sather, _Understanding the Apple II_ [Chapter 9: The Disk
    Controller][sather9]
- __5.25" DD 80-track__ (720 KiB). 300 RPM, 96 tpi, 125/250 kbps.
  40-track disks written on 80-track drives may read on 40-track
  drives, but with a lot of errors.
- __3.5" DD 40-track__ (320 KiB). 300 RPM, 67 tpi, 250/500 kbps.
  Seemingly never used on IBM-compatible PCs, but used in, e.g.,
  Fujitsu FM-77AV.
- __3.5" DD 80-track__ (640 KiB). 300 RPM, 135 tpi, 250/500 kbps.
  Can write 40-track format, but these read with a lot of errors
  on a 40-track drive.

High-density:
- __8" HD__. [_Very_ rare][hj-8HD]. Index hole above-left. 96 tpi,
  probably 154 tracks.
- __5.25" HD__ (1.2 MiB). 360 RPM, 96 tpi, 500 kbps. Usually also reads DD
  formats (at 300 RPM), but writes will fail to read on 40-track drives and
  maybe 80-track drives too. (HD format is 600 oersteds; not clear if they
  can reliably write 300 oersted media used by DD drives.)
- __3.25" HD__ (720K, 1.44 MiB, 2.88 MiB) 300 RPM.

There are also some EHD drives:
- 3.5" 1.6 MiB, similar to 1.44 MB but at 360 RPM instead of 300.
- 3.5" 2.88 MiB. Created by Toshiba, endorsed by IBM.
- 5.25" 2.4 MiB.

To an FDC, all these drives look basically the same as far as track
read/write at a supported kbps rate, though often certain other signal
connectors (reduce write current, etc.) and sometimes termination have
to be tweaked. See [[hj-replace]] for more details.

The last drive on a chain should be terminated. Normally this is done with
150 Ω resistors. However, many modern 3.5" drives (and a few 5.25" ones)
use 1000 Ω resistors on all drives, which usually works ok. If there are
issues with these 1000 Ω drives and a final drive terminated with 150 Ω,
you can try raising the value of the termination resistors in the final drive.

#### 8" Drive Information

Shugart SA800/801 drive connector pinout:

    J4 AC       1:AC  2:FG  3:AC
    J5 DC       1:+24V 2:GND  3:GND 4:-5V  5:+5V 6:GND  (adjacent GND return)
    J1 data     50-pin; see OEM manual

The SA800/801 does not have a `TG43` input; it appears to handle reduced
write current automatically. That's normally on pin 2 when present.

Daves Old Computers [Connecting drives to PC][doa-8pc] gives instructions
to build a 5.25" IBM PC controller to 8" drive adapter. The pinout is:

    PC(34p)   8"(50p)   Description
                2        TG43                 (see below)
        8      20        Index
        12     26        DS1(PC) -> DS0(8")
        16     18        Motor ON/Head Load
        18     34        Direction            (see below)
        20     36        Step
        22     38        Write Data
        24     40        Write Gate
        26     42        Track 0 detect       All Odd numbered
        28     44        Write Protect        pins are GROUND
        30     46        Read Data
        32     14        Side1 Select
        34     12        Ready

If the 8" drive requires a TG43 signal, you have the following options:
- Live without it. Reads will be fine; writes past track 43 will be unreliable.
- The PC FDC chip provides `TG43` on the `DIRECTION` line during writes.
  Depending on the board design, you may just be able to connect controller
  `DIRECTION` to drive `DIRECTION` and `TG43`.
- His ImageDisk program can generate `TG43` from the parallel port.
- You can install a toggle switch for manual control.

#### 5.25" Drive Information

Shugart SA400:
- `J2` power is a 4-pin AMP Mate-N-Lock connector P/N 350211-1. Recommended
  mating connector AMP P/N 1-480424-0 using pins AMP P/N 60619-1. Use #18 AWG.
- `J1` data is a 34-pin PCB edge card connector, numbered 1 through 34 with
  even on component side and odd on non-component side. Key slot between
  pins 4 and 6.

SA400 pinout:

    J2 DC       1:+12V 2:GND  3:GND 4:+5V   (adjacent is +V return)
                separate frame ground

    J1 data     GND  7   8  index/sector
                GND  9  10  drive select 1
                GND  11 12  drive select 2
                GND  13 14  drive select 3
                GND  15 16  motor on
                GND  17 18  direction select
                GND  19 20  step
                GND  21 22  write data
                GND  23 24  write gate
                GND  25 26  track 00
                GND  27 28  write protect
                GND  29 30  read data

Also see [[ibus-pinout]] for PC-style pinout that can be used with a twist
in the cable when both drives are jumpered as "B":

                GND  9  10  motor enable 0
                GND  11 12  drive select 1
                GND  13 14  drive select 0
                GND  15 16  motor enable 1

Later new signals ([Wikipedia][wp-fddi]:

    J1 data     GND  1   2  /REDWC density sel (0=HD 1=DD) host→drive
                         4  reserved
                         6  reserved

#### 3.5" Drive Information

The power plug on the cable, is a TE Connectivity/AMP 170204-2 or 171822-4;
the pins have a 2.50 mm pitch. (This is often called a [Berg connector][berg],
though proper Berg connectors have 2.54 mm pitch.)

FDDs often (but not always) need only +5 V.


USB UFI - Universal Floppy Interface
------------------------------------

[UFI spec].

Supported media are all double-sided: $1E DD "720KB", $93 HD "1.25MB"
and $94 HHD "1.44 MB" (all nominal formatted capacities; non-IBM-PC
formats are possible). \[§4.5.3 p.25]

#### Some Details

I/O retry is automatic; the PER (post error) bit indicates whether the
device should inform the host that an error occurred if a retry was
successful. \[§4.5.4 p.25]

You can request to set RPM (300 or 360) and raw transfer rate to media
(250, 300, 500 kbps, 1, 2, 5 mbps). Also sectors per track, data bytes
per sector, etc. \[§4.5.5 p.26] Not clear how many drives actually
support unusual options.

The READ CAPACITY ($25) command returns last logical block address and
block length in bytes. \[§4.9 p.32]. The READ FORMAT CAPACITIES ($23)
command returns the current capacity of the formatted floppy in the
drive (if present), maximum formattable capacity, and a list of
eight-byte capacity descriptors. This includes only capacities the
drive can format, not additional capacities that it can read. \[$4.10
p.33]

### Experimentation

Toshiba USB drive with HD DOS floppy inserted (write protected), sd
driver says `[sdc] Mode Sense: 00 46 94 80.` No idea what parts of the
very long mode sense data these are (need to read the driver source).

Does not read 40-track diskettes. Gives:

    [sdc] Unit Not Ready
    [sdc] Sense Key : Medium Error [current]
    [sdc] Add. Sense: Cannot read medium - unknown format
    [sdc] Read Capacity(10) failed: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE


Flux Level Images
-----------------

### Flux Image File Formats

- `.SCP`: [SuperCard Pro][scp]. Supported by:
  - SuperCard Pro software
  - [Disk-Utilities][du] (multi-platform)
  - [HxC software][hxcsoft] (ZIP).


### Flux Level Hardware

- [FluxEngine][fe] ([GitHub][fegh]), based on a Cypress PSoC5LP
  CY8CKIT-059 development board ($10-$30). Floppy disk is connected
  directly to header pins on the board; a USB interface streams flux
  data to/from the computer. Provided software translates flux data
  from/to disk image files.

- [Greaseweazle], based on STM32F103 ($1-$5) on a "blue pill"
  development board (F1 model) or custom board (F7 model).
  Reads/writes only `.SCP` files; no other software provided.
  Note that [STM fakes][stmfake] are not infrequent.

- [SuperCard Pro][scp], [manual][scpman]. ($100+). Comes with fairly
  sophisticated software (Windows only)?


Sector Level Images
-------------------

### D88/68/77/98

The "D88" format stores a sequence of raw images (sector data) with a
32-byte header prepended in front of each giving the name, write protect
flag, media type etc. The convention is to use an extension matching the
higher-level format of the data in the images:

    .d88    NEC PC-8001/PC-8801 (2D, 2DD, 2HD)
    .d68    NEC PC-6001         (2D, others?)
    .d98    NEC PC-9801         (2D, 2DD, 2HD)
    .d77    Fujitsu FM-7/FM77   (2D, 2DD)

The image formats supported are:

    Type Media  Typical Format
     $00  2D     320K  2 sides × 40 tracks × 16 sectors × 256 bytes
     $10  2DD    640K  2 sides × 80 tracks × 16 sectors × 256 bytes
     $20  2HD    ???K  2 sides ×  ? tracks ×  ? sectors ×   ? bytes
     $30¹ 1D     160K  1 sides × 40 tracks × 16 sectors × 256 bytes
     $40¹ 1DD    320K  1 sides × 80 tracks × 16 sectors × 256 bytes

       ¹ 1DDITT tool only

The sector sizes and counts per track are actually defined on a per-sector
basis: each sector has a header giving its cylinder, head, sector size as
128 × 2ⁿ, deletion indicator, status code for normal/CRC error/etc., and
actual data size. This allows for unusual formats (e.g., used by games to
increase storage capacity) and some forms of copy protection. However, some
programs reading/writing D88 files will assume a fixed format rather than
writing what the sector headers indicate.

See [`nec/D88STRUC.txt`](nec/D88STRUC.txt) for more details.
(There's also a copy in a [gist from barbeque][barbeque].)

Programs:
- [`d88dmp`]: D88 file dump tool
- [`d88split.pl`]: splits a file containing several images into files
  containing one image each.




<!-------------------------------------------------------------------->
[MB8877]: https://www.tim-mann.org/max80/Appendix_D_Updated.pdf
[MB8877]: https://archive.org/stream/Fujitsu-MB8876a-MB8877-FDC-datasheet#page/n2/mode/1up
[fm7bios]: 8bit/fm7/ml.md
[iec]: 8bit/cbm/serial-bus.md
[pc8k]: 8bit/pc-8001/floppyif.md#protocol

<!-- Diskette and Drive Types -->
[andre19]: https://extrapages.de/archives/20190102-Floppy-notes.html
[berg]: https://en.wikipedia.org/wiki/Berg_connector
[boginjr]: http://boginjr.com/it/hw/8inch-drives/
[doa-8pc]: http://dunfield.classiccmp.org/img42841/cnct.htm
[hj-8HD]: http://www.retrotechnology.com/herbs_stuff/8inchHD.html
[hj-data]: http://www.retrotechnology.com/herbs_stuff/drive.html#data
[hj-replace]: http://www.retrotechnology.com/herbs_stuff/drive.html#threefive
[hj-tg43]: https://www.retrotechnology.com/herbs_stuff/drive.html#43
[hjt]: http://www.retrotechnology.com/herbs_stuff/drive.html
[ibus-pinout]: http://www.interfacebus.com/PC_Floppy_Drive_PinOut.html
[rcse 9303]: https://retrocomputing.stackexchange.com/a/9303/7208
[sa400oem]: https://archive.org/stream/bitsavers_shugartSA478_3019449#mode/1up
[sa400sm]: https://archive.org/stream/bitsavers_shugartSA4eManualApr1979_2873568#mode/1up
[sa800oem]: https://deramp.com/downloads/floppy_drives/shugart/SA800%20OEM%20Manual.pdf
[sather9]: https://archive.org/stream/Understanding_the_Apple_II_1983_Quality_Software#page/n230/mode/1up
[wp-fddi]: https://en.wikipedia.org/wiki/Floppy_disk_drive_interface
[wp-fmtlist]: https://en.wikipedia.org/wiki/List_of_floppy_disk_formats
[wp-precomp]: https://en.wikipedia.org/wiki/Write_precompensation

<!-- USB UFI -->
[UFI spec]: https://usb.org/sites/default/files/usbmass-ufi10.pdf

<!-- image file formats and software -->
[du]: https://github.com/keirf/Disk-Utilities
[fe]: http://cowlark.com/fluxengine/
[fegh]: https://github.com/davidgiven/fluxengine
[greaseweazle]: https://github.com/keirf/Greaseweazle
[hxcsoft]: https://hxc2001.com/download/floppy_drive_emulator/HxCFloppyEmulator_soft.zip
[scp]: https://www.cbmstuff.com/proddetail.php?prod=SCP
[scpman]: https://www.cbmstuff.com/downloads/scp/scp_manual.pdf
[stmfake]: https://github.com/keirf/Greaseweazle/wiki/STM32-Fakes

<!-- sector level images -->
[`d88dmp`]: https://github.com/ORYZAPAO/d88dmp
[`d88split.pl`]: https://github.com/tomari/d88split/blob/master/d88split.pl
[barbeque]: https://gist.github.com/barbeque/33ee77a440fb9796d309bdc980bb067a
