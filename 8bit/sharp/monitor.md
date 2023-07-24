Sharp MZ-700 IPL Monitor
========================

Probably applies to all of the MZ-80K series. There is also a slightly
different [monitor in the BASIC interpreter][basmon].

ROMs for various monitor, charset, and FD interface [downloadable
here][smzo-dldrom]. The standard MZ-80K ROM is SP-1002. The [new monitor
ROM][smzo-newmon] is also available here.

Versions:
- `1Z-009A`: JP MZ-700
- `1Z-013A`: EU MZ-700

### Tips

After a reset: [[smzo-h&t]]

    G$1200   BASIC restart (program lost)
    G$1260   BASIC warm start (program retained)
    G$1050   SAVE an ML program
    G$1060   VERIFY a ML program
    G$2000   Typical entry point of ML program

### Usage

All numbers are entered and displayed in hex.

### Technical Details

Memory map:

    $1200   free for user use
    $11A3   key input buffer
    $1170   variable area
    $10F0   CMT header area
    $10EF   start of stack (initial SP set to $10F0)
    $1000   stack area
    $0000   ROM; monitor code

Variable locations (all values in hex): [[smzo-monicmd]]

    addr  len   name    descr
    10F0   80   IBUFE   tape header buffer
    103C   B4   SP      180 bytes for stack
    1038    3           jp to time interrupt (038D)
    1000   38           unused

Standard routines (subscript is RST number) [[som 151]]:

    0000 ₀  MONIT       monitor on (reset entry point)
    0003    GETL        get line (end w/CR)
    0006    LETNL       ♣A cursor to beginning of next line
    0009    NL
    000C    PRNTS       ♣A print space
    000F    PRNTT       print tab
    0012    PRNT        print 1 character
    0015    MSG         ♡全 print message ♠DE→msg, end w/CR (not printed)
                            control codes 11-16 move cursor
    0018 ₃  MSGX
    001B    GETKY       get key
    001E    BRKEY       get break
    0021    WRINF       write information (tape header?)
    0024    WRDAT       write data (tape data?)
    0027    RDINF
    002A    RDDAT
    002D    VERFY       verify CMT (header and?) data
    0030 ₆  MELDY       ♣A play music DE→music data (same format as BASIC)
                            end w/CR or $C8. CF=0 no break, CF=1 break intr.
    0033    TIMST       set time
    0038                interrupt routine (jp $1038)
    003B    TIMRD       read time
    003E    BELL        ♣A briefly sound ~880 Hz
    0041    XTEMP       ♡全 tempo set (A=tempo, 0=slowest, 7=highest)
    0044    MSTA        melody start
    0047    MSTP        melody stop

### Loading ML Programs

This small routine loads an ML program without executing it after load, the
way the `L` command does. [[smzo-bascopy]]

    CF00: CD 27 00  call $0027      ; read info record from tape
    CF03: 38 03     jr   C,$CF08    ; if any error then stop
    CF05: CD 2A 00  call $002A      ; load data from tape into storage
    CF08: DA 07 01  jp   C,$0107    ; if any error then stop with message
    CF0B: C3 AD 00  jp   $00AD      ; goback to monitor
    CF0E: C3 CB 0F  jp   $0FCB      ; execute the verify routine from monitor

### ROM Replacement

European/PAL ROMs may be different from the Japanese ones.

- MZ-80K:  The IPL/Monitor ROM is in a 2332 (4K×8). This can be replaced
  with a 2532 without modification, or a 2732 by grounding pin 18,
  connecting the track for 18 to 21, and cutting the existing pin 21 track.
  [[smzo-h&t]]
- MZ-700: uses a 2732.



<!-------------------------------------------------------------------->
[basmon]: https://archive.org/details/sharpmz700ownersmanual/page/n100/mode/1up?view=theater
[smzo-dldrom]: https://original.sharpmz.org/mz-80k/dldrom.htm
[smzo-h&t]: https://original.sharpmz.org/mz-80k/tips.htm
[smzo-monicmd]: https://original.sharpmz.org/mz-700/monicmd.htm
[smzo-newmon]: https://original.sharpmz.org/mz-80k/newmoni.htm
[smzo-bascopy]: https://original.sharpmz.org/mz-700/basiccpy.htm
[som 151]: https://archive.org/details/sharpmz700ownersmanual/page/n153/mode/1up?view=theater
