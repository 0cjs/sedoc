Sharp MZ-700 IPL Monitor
========================

See [`rom`](rom.md) for details of the BIOS-type routines available in the
IPL ROM.

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

### Loading ML Programs

This small routine loads an ML program without executing it after load, the
way the `L` command does. [[smzo-bascopy]]

    CF00: CD 27 00  call $0027      ; read info record from tape
    CF03: 38 03     jr   C,$CF08    ; if any error then stop
    CF05: CD 2A 00  call $002A      ; load data from tape into storage
    CF08: DA 07 01  jp   C,$0107    ; if any error then stop with message
    CF0B: C3 AD 00  jp   $00AD      ; goback to monitor
    CF0E: C3 CB 0F  jp   $0FCB      ; execute the verify routine from monitor



<!-------------------------------------------------------------------->
[basmon]: https://archive.org/details/sharpmz700ownersmanual/page/n100/mode/1up?view=theater
[smzo-dldrom]: https://original.sharpmz.org/mz-80k/dldrom.htm
[smzo-h&t]: https://original.sharpmz.org/mz-80k/tips.htm
[smzo-newmon]: https://original.sharpmz.org/mz-80k/newmoni.htm
[smzo-bascopy]: https://original.sharpmz.org/mz-700/basiccpy.htm
