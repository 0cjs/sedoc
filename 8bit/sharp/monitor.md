Sharp MZ-700 IPL Monitor
========================

See [`rom`](rom.md) for details of the BIOS-type routines available in the
IPL ROM.

Probably applies to all of the MZ-80K series. There is also a slightly
different [monitor in the BASIC interpreter][basmon].

ROMs for various monitor, charset, and FD interface [downloadable
here][smzo-dldrom]. The standard MZ-80K ROM is SP-1002. The [new monitor
ROM][smzo-newmon] is also available here.


Machine/Software-Specific Monitors
----------------------------------

All numbers are entered and displayed in hex. Generally, `RREAK` will
pause output and `Shift-BREAK` will abort and return to the prompt.

#### MZ-80K SP-1002 (JP and EU version?)

    LOAD[fname] Load file (with given name, if supplied) from CMT
    GOTO$hhhh   Jump to address hhhh
    SG          Enable keypress beep (Sound Generate)
    SS          Disable keypress beep (Sound Stop)
    FD          Floppy disk boot: if $F000 = $00, jumps to $F000

#### MZ-700 1Z-009A (JP)

Same as 1Z-013A below except without `D` command?

#### MZ-700 1Z-013A (EU)

Commands (from [[som 149]], monitor listing). `ss` etc must be a full
four-digit hex value. In the CSCP emulator, `Break` is backspace.

    L[fname]    Load named file from tape, or next file.
    Ssseexx     Save memory starting at <ss> through <ee> with execution
                address <xx>. Prompts for filename. Shift-Break to exit.
    V           Compares save with <S> above to memory.

    Dssee       Dump memory from <ss> through <ee>  (EU version only)
    Maaaa       Modify memory starting at <aaaa>. Location and old value
                displayed; Enter or new value. Shift-Break to exit.
    Jaaaa       Jump to address <aaaa>

    #           Switch all memory to DRAM and jump to $0000.
                Same as holding Ctrl while resetting.
    F           Floppy boot, if present.

    Pchars      Print <chars> on printer. Control codes include:
                &T=test pattern  &S=80 chars/line  &L=40 chars/line
                &G=graphic mode  &C=change pen color
    B           Toggle beep on keypress

Notes:
- `F` checks to see if $F000 contains $00; if it does it jumps to $F000.
  (This is a magic number for an expansion ROM at $F000; when unmapped
  that area always returns $7F.)

The monitor prompt/parse routine starts at $00AD; to return it from
a program you've entered, `C3 AD 00` (jp $00AD). A `C9` (ret) will reset.

#### MZ-700 S-BASIC 1Z-007B (JP)

#### MZ-700 S-BASIC 1Z-013B (EU)

From EU _Uuser's Manual_ [[som 99]]. Prompt is `*`.
Invoke with `MON` at the BASIC prompt.

- `:addr=nn nn …`: Deposit to _addr_ sequential bytes _nn …_. Use `;c` to
  generate a character code.
- `P`: Switches output for `D` and `F` to printer, or back to display.
- `Dsaddr [eaddr]`: Dump memory from _saddr_ to _eaddr_ (default $80) in
  hex and "ASCII" (actually Sharp character coding) form.
- `M[addr]`: Memory set. Displays value at memory location _addr_; enter a
  new value or type CR to keep the current value. Exit with `Shift-BREAK`.
- `Fsaddr eaddr data …`: Search for string _data …_ in memory; found
  address and values are dumped to screen.
- `Gaddr`: Call subroutine at _addr_. Stack set to $FFEE.
- `Tsaddr eaddr taddr`: Copy _saddr_ through (including?) _eaddr_ to target
  address _taddr_.
- `Ssaddr eaddr xaddr : fname`: Save data to tape.
- `L[addr][:fname]`: Load data from tape.
- `V[fname]`: Verify data on tape, comparing with memory.
- `R`: Return to program that called the monitor program.


Usage and Tips
--------------

XXX These need to be checked to confirm to which versions of the monitor
they apply.

### Tips

After a reset: [[smzo-h&t]]

    G$1200   BASIC restart (program lost)
    G$1260   BASIC warm start (program retained)
    G$1050   SAVE an ML program
    G$1060   VERIFY a ML program
    G$2000   Typical entry point of ML program

### Loading ML Programs

This small routine loads an ML program without executing it after load, the
way the `L` command does. [[smzo-bascopy]]

    CF00: CD 27 00  call $0027      ; read info record from tape
    CF03: 38 03     jr   C,$CF08    ; if any error then stop
    CF05: CD 2A 00  call $002A      ; load data from tape into storage
    CF08: DA 07 01  jp   C,$0107    ; if any error then stop with message
    CF0B: C3 AD 00  jp   $00AD      ; goback to monitor
    CF0E: C3 CB 0F  jp   $0FCB      ; execute the verify routine from monitor

### Command Table

The command loop is at $00AD; after checking the standard commands
(`JLFB#PMSVD`) there are four NOPs at $00ED before continuing to parse the
line, presumably so if the monitor is copied to RAM this can call a
subroutine to check for further commands. (This is only for 1Z-013A ROM,
the 1Z-009A ROM loops back immediately after the `V` command.)



<!-------------------------------------------------------------------->
[basmon]: https://archive.org/details/sharpmz700ownersmanual/page/n100/mode/1up?view=theater
[smzo-bascopy]: https://original.sharpmz.org/mz-700/basiccpy.htm
[smzo-dldrom]: https://original.sharpmz.org/mz-80k/dldrom.htm
[smzo-h&t]: https://original.sharpmz.org/mz-80k/tips.htm
[smzo-newmon]: https://original.sharpmz.org/mz-80k/newmoni.htm
[som 149]: https://archive.org/details/sharpmz700ownersmanual/page/n148/mode/1up?view=theater
[som 99]: https://archive.org/details/sharpmz700ownersmanual/page/n100/mode/1up?view=theater
