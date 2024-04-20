CP/M Notes
==========

References;
- [_CP/M 2.2 Operating System Manual_][htm] (HTML), 3rd ed., 1983-09.
- [_CP/M 2.0 Interface Guide_][ig], Digital Research, 1979. (PDF)

### Compressor and Archiver File Extensions

Where the extension is a pattern `.?X?`, this indicates an individual file
compresion format where the middle letter of the extension is changed to
indicate the compressed version, e.g., `FOO.TXT` → `FOO.TQT` for Squeeze.

- `.LBR`: Library; no compression.
  - Extract: `NULU` `DELBR`
  - Create: `NULU` or `LAR`

- `.?Q?`: Squeeze.
  - Extract:`UNSQUEEZE` (name varies)
  - Create:`SQUEEZE` (name varies)

- `.?Z?`: Crunch.
  - Extract: `UNCR`, `UNCRUNCH` (various revisions)
  - Create: `CR`, `CRUNCH` (various revisions).

- `.?Y?`: LZH-Crunch.
  - Extract: `UNCRLZH20`
  - Create: `CRLZH20`

- `.ARC`: Cross-platform archiver (DOS, Unix, etc.; CP/M uses `.ARK` extension).

- `.ZIP`: Cross-platform archiver.
  - Extract: `UNZIP` (various versions; older ZIP files only)
  - Create: not available under CP/M.

- `.LZH`
  - Extract: `LHARC` (no LH5 decompression)
  - Create: `LHARD` (no LH5 compression)

- `.ARJ`
  - Extract: `UNARJ` (older versions of the format only).

- `.PMA`: CP/M only; best compression under CP/M.
  - `PMAUTOAE.COM` is a self-extracting file with the tools. Extractor can
    also extract LH5 LZH archives. Creator can create self-extracting
    archives.

BDOS and BIOS
-------------

References:
- CP/M Manual [§5 CP/M 2 System Interface][htm5]
- CP/M Manual [§6 CP/M Alteration][htm6]

### System Paramter Area

(§6.9) Memory from $0000 through $00FF.

    $00  3  Warm Start entry (jp $4A03+b)
    $03  1  IOBYTE (Intel standard)
    $04  1  Low nybble: default drive (0=A, 1=B, …, 15=P)
            High nybble: current user area
    $05  3  BDOS entry ($06-07 is lowest address used by CP/M without CCP)
    $08 28  Unused RST entries 1-5
    $30  8  Reserved (RST entry 6)
    $38  3  DDT/SID entry when debugger running, otherwise unused (RST 7)
    $3B  5  Reserved (not currently used)
    $40 16  CBIOS scratch (but not used by CP/M 2.2)
    $50 12  Reserved (not currently used)
    $5C 16  FCB 1 init'd by CCP when running a transient program
    $6C 16  FCB 2 init'd by CCP
    $7D  3  Optional default random record position
    $80 128 Default disk buffer; command line args from CCP

Per §5.2 (well into it), when the CCP loads a transient program it attempts
to parse up to two file specifications on the command line. If present,
FCBs 1 and 2 above are initialised with the disk number and filename. If
filenames are not found, the FCB filenames are cleared to spaces and all
other fields to 0.

The $80 location is initialised with command line arguments, or the "tail"
of the command line after the program name and following space. (Or does it
skip all spaces?) $80 is the char count, and $81 onward are a copy of the
remainder of the command line, translated to upper case. (Note that this
will be overwritten by the first disk call unless the buffer address is
changed from the default.)

### BDOS Calls

(§5.2, §5.6) BDOS calls are made by loading C with the function code, DE
with the parameter, and calling $0005.

    00 $00 System Reset
    01 $01 Console Input        A ← char
    02 $02 Console Output       E → console
    03 $03 Reader Input         A ← char
    04 $04 Punch Output         E → punch
    05 $05 List Output          E → punch
    06 $06 Direct Console I/O   E → console, or E=$FF A ← console
    07 $07 Get I/O Byte         A ← IOBYTE
    08 $08 Set I/O Byte         E → IOBYTE
    09 $09 Print String         DE=addr → chars to console until '$'
    10 $0A Read Console Buffer  DE=addr ← line read from console
                                a[0]=buflen, a[1]←count read, a[2..]←chars
                                term on buffer full or CR/LF
    11 $0B Get Console Status   A←status: $FF=char ready, $00=not
    12 $0C Return Version Number
    13 $0D Reset Disk System
    14 $0E Select Disk          E=disk (0=A, 1=B, ..., 15=P)
    15 $0F Open File            DE=FCB to fill, A←dir code or $FF=not found
    16 $10 Close File           DE=FCB, A←0/1/2/3=closed, $FF=not found
    17 $11 Search for First
    18 $12 Search for Next
    19 $13 Delete File
    20 $14 Read Sequential
    21 $15 Write Sequential     DE=FCB, A←$00 success, non-zero error
    22 $16 Make File            DE=FCB, A←0/1/2/3 file opened, $FF=no dir space
                                caller must make file doesn't exist!
    ...
    37     Reset Drive
    40     Write Random with Zero Fill

### File Control Blocks (FCBs)

(§5.2)

    $00 dr  Drive Code: 0=default 1=A 2=B … $10=P
    $01 f1  Filename, ASCII, upper case,
    $08 f8    high bit clear.
    $09 t1  Filetype     | b7 Read Only 0=no 1=yes
    $0A t2    ASCII      | b7 SYS file (no dir list) 0=no 1=yes
    $0B t3    upper case |
    $0C ex  Current extent number
    $0D s1  Reserved for internal system use
    $0E s2  Reserved for internal system use
    $0F rc  Record count for extent `ex` ($00-$7F)
    $10 d0  CP/M System
    $1F dn    Use
    $20 cr  Current (sequential) record; user sets to $00
    $21 r0  Random record number LSB
    $22 r1  Random record number MSB
    $23 r2  Random record number overflow byte


<!-------------------------------------------------------------------->
[htm]: http://www.gaby.de/cpm/manuals/archive/cpm22htm/
[htm5]: http://www.gaby.de/cpm/manuals/archive/cpm22htm/ch5.htm
[htm6]: http://www.gaby.de/cpm/manuals/archive/cpm22htm/ch6.htm
[ig]: https://bitsavers.org/pdf/digitalResearch/cpm/2.0/CPM_2_0_Interface_Guide_1979.pdf
