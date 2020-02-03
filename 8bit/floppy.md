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

The primary reference is Herb Johnson's [Tech information on floppy
disks drives and media][hjt]. Links to this are given below as
[[HJ-xxx]] references. All references to orientation of holes and
notches assuming looking at the top of the diskette with the label in
the upper left and the oval access hole at the bottom.

For standard drives there are only two types of diskette magnetic
media: what is now called "double density" (DD, 2DD and many other
acronyms) and "high density" (HD). These differ in coercivity and
thickness of the magnetic media.

Single vs. double density refers only to the encoding format: FM for
SD and MFM for DD. (M2FM was an early DD scheme replaced by MFM.)
These all use what's now called "double density" media.

Here's a summary of the drive type info from [[hj-data]]. Capacities
are approximate based on a common two-sided MFM format; for more
examples see Wikipedia [List of floppy disk formats][wp-fmtlist]. Data
frequency is given as FM/MFM kbps.

Double-density:
- __8" DD__ 77-track (1 MiB). Index hole above and to the right of the
  center hole, write protect notch on the bottom towards the right.
  360 RPM, 48 tpi, 250/500 kbps. (Typically 26×128 byte sectors.)
  Write current reduced for tracks >43. See Shugart [SA800/801
  Diskette Storage Drive OEM Manual][sa800].
- __5.25" DD 40-track__ (320/360 KiB). 35 tracks for early drives and
  C64. 300 RPM, 48-tpi, 125/250 kbps. Fujitsu called these "2D".
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
- __5.25" HD__ (1.2 MiB). 360 RPM, 96 tpi, 500 kbps. Usually also
  reads DD formats, but writes will fail to read on 40-track drives
  and maybe 80-track drives too. (HD format is 600 oersteds; not clear
  if they can reliably write 300 oersted media used by DD drives.)
- __3.25" HD__ (1.44 MiB)

There are also some EHD drives:
- 3.5" 1.6 MiB, similar to 1.44 MB but at 360 RPM instead of 300.
- 3.5" 2.88 MiB. Created by Toshiba, endorsed by IBM.
- 5.25" 2.4 MiB.

To an FDC, all these drives look basically the same as far as track
read/write at a supported kbps rate, though often certain other signal
connectors (reduce write current, etc.) and sometimes termination have
to be tweaked. See [[hj-replace]] for more details.



Flux Level
----------

### Flux Image File Formats

- `.SCP`: [SuperCard Pro][scp]. Supported by:
  - SuperCard Pro software
  - [Disk-Utilities][du] (multi-platform)
  - [HxC software][hxcsoft] (ZIP).


### Flux-level Hardware

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



<!-------------------------------------------------------------------->
[MB8877]: https://www.tim-mann.org/max80/Appendix_D_Updated.pdf
[fm7bios]: 8bit/fm7/ml.md
[iec]: 8bit/cbm/serial-bus.md
[pc8k]: 8bit/pc-8001/floppyif.md#protocol

<!-- Diskette and Drive Types -->
[hj-8HD]: http://www.retrotechnology.com/herbs_stuff/8inchHD.html
[hj-data]: http://www.retrotechnology.com/herbs_stuff/drive.html#data
[hj-replace]: http://www.retrotechnology.com/herbs_stuff/drive.html#threefive
[hjt]: http://www.retrotechnology.com/herbs_stuff/drive.html
[sa800]: https://deramp.com/downloads/floppy_drives/shugart/SA800%20OEM%20Manual.pdf
[wp-fmtlist]: https://en.wikipedia.org/wiki/List_of_floppy_disk_formats

<!-- image file formats and software -->
[du]: https://github.com/keirf/Disk-Utilities
[hxcsoft]: https://hxc2001.com/download/floppy_drive_emulator/HxCFloppyEmulator_soft.zip

<!-- flux-level readers/writers -->
[fe]: http://cowlark.com/fluxengine/
[fegh]: https://github.com/davidgiven/fluxengine
[greaseweazle]: https://github.com/keirf/Greaseweazle
[scp]: https://www.cbmstuff.com/proddetail.php?prod=SCP
[scpman]: https://www.cbmstuff.com/downloads/scp/scp_manual.pdf
[stmfake]: https://github.com/keirf/Greaseweazle/wiki/STM32-Fakes
