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
