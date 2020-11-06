Applications Programs
=====================


TEXT
----

(M100) Select file to edit, or `TEXT` to create new file (prompted for ≤6
char name, `.DO` added automatically).

(M100) Editing keys (prefixes are `␣`=Shift (digraph `Vs`), `^`=Ctrl):

    ^M ENTER    newline (paragraph)
    ^H BS       delete prev char
    ^I TAB      tab
    ^P          prefix literal (for entering control chars, except ^Z)

    ^S  ←   char left               ^E  ↑   char up
    ^D  →   char right              ^X  ↓   char down
    ^A ␣←   word left               ^T ␣↑   page up (top)
    ^F ␣→   word right              ^B ␣↓   page down (bottom)
    ^Q ^←   beginning of line       ^W ^↑   top of file
    ^R ^→   end of line             ^Z ^↓   end of file

    ^C          cancel SELECT/SAVE/LOAD/FIND/PRINT
    ^N F1       Find: prompted for string
    ^L SELECT   select text; cursor not included            (PC82: F3)
    ^O F5       Copy selection
    ^U F6       Cut                                         (PC82: F4)
       F2       load from device (appends to file)          (PC82: n/a)
    ^G F3       save to device (CMT filename or `LPT:`)     (PC82: n/a)
        PRINT   print screen
    ^Y ␣PRINT   print file (prompts for width)
       F8       exit

(PC82) F-key label line is always off at start; `SHIFT-F1` to turn it on.

Standard printing will print control codes as `^c`; save to `LPT:` to print
them literally. (This will not use the width feature to wrap the output.)


TELCOM
------

- `F1` Find: searches `ADRS.DO` per ADDRSS below, displaying up to second
  colon in line but removing login scripts between `<>`. Successful match
  then offers `F2` Dial, `F3` More (next matching entry), `F4` Quit (exit
  search mode).
- `F2` Call: type in nubmer to dial.
- `F4` Term: enter terminal mode with current parameters.

`F3` Stat followed by enter prints the comms parameters, otherwise you can
enter new parameters at the prompt. (M100) The parameters and their valid
characters are:

    M1-9    baud rate: M=modem, 1=75, 3=300, 5=1200, 7=4800, 8=9600, 9=19200
    678     word length: 6-8 bits
    IOEN    parity: ignore, odd, even, none
    12      stop bits
    ED      line (XON/XOFF) status: E=enable D=disable
    ,10 ,20 pulse rate (2-digit number preceeded by comma), optional

(PC82) parameters and values:

    1-9     baud rate: 1=75, 3=300, 5=1200, 7=4800, 8=9600, 9=19200
    IOEN    parity: ignore, odd, even, none
    5678    word length: 5-8 bits
    12      stop bits
    XN      XON/XOFF flow control: X=on N=off
    SN      SI/SO (ASCII shift in/out?) flow control: S=on N=off

In terminal mode (M100; PC82 has same commands but different assignments):
- `F5` Echo: turn local echo on/off.
- `F3` Up: send contents of text file. Prompt for filename and width for
  word wrapping (empty = no wrap).
- `F4` Down: log to file.
- `F6` Wait: appears when DTE has received an XOFF.
- `F8` Bye: exit terminal mode, hanging up modem if used.

### Auto-dialer Number Format

In `ADRS.DO` phone numbers should be surrounded by colons, e.g.,
`:800-555-1234:`. Appending `<>` will enter terminal mode automatically;
within the brackets you may use the following command language:

    =   Pause for two seconds
    ?c  Wait for character c
    ^c  Send control character c
    !?  Send `?`
    !=  Send `=`
    c   Send character c

### Serial Port Use from BASIC

The Owner's Manual [p.199][om 199] has an example program that dials the
modem, logs on to a service and downloads data. It `CALL`s `21200` to lift
the line and `21293,0,addr` to dial. The key parts seem to be:

    80 OPEN "MDM:7I1D" FOR INPUT AS 1
    90 OPEN "MDM:7I1D" FOR OUTPUT AS 2
    ...
    110 Z$=INPUT$(1,1)
    ...
    180 PRINT #2,Q$


SCHEDL, ADDRSS
--------------

Actually just a search programs. (There was appointment notification alarm
functionality at one point, but that was removed to make room for something
else.) Both search a text file (created with TEXT) called `NOTE.DO`
(SCHEDL) or `ADRS.DO` (ADDRSS). Each line is a record in arbitrary format.

- `F1` Find: prints each matching line (case-insensitive) to screen, giving
  `F3` More and `F4` Quit prompts for every screenful. An empty search
  string pages through file.
- `F5` Lfnd:  prints each matching line to printer.

See TELCOM above for phone number formats.



<!-------------------------------------------------------------------->
[om 199]: https://archive.org/stream/trs-80-m-100-user-guide#page/199/mode/1up
