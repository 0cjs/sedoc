Sharp MZ-series ROM
===================

ROM contains only IPL support, a small monitor, and enough BIOS code to
support these.

All values are in hex.


Keyboard and Screen Information
-------------------------------

Control Codes (processed by output routine):

      Ctrl Dec Hex
      ─────────────────────────────────
        E  05  $05  Lowercase input mode
        F  06  $06  Uppercase input mode
        M  13  $0D  Newline
        P  16  $10  DEL rubout previous char
        Q  17  $11  ↓ cursor down
        R  18  $12  ↑ cursor up
        S  19  $13  → cursor right
        T  20  $14  ← cursor left
        U  21  $15  HOME cursor to upper left
        V  22  $16  CLR clear screen
        W  23  $17  GRAPH input mode
        X  24  $18  INST insert a space, shifting text right
        Y  25  $19  Alphanumeric input mode


Special key codes returned by `GETKY` etc.:

      Key Code Screen Code      Key Code Screen Code
      DEL  60    C7               ↓  11    C1
     INST  61    C8               ↑  12    C2
    ALPHA  62    C9               →  13    C3
    BREAK  64    CB               ←  14    C4
       CR  66    CD            HOME  15    C5
                                CLR  16    C6


ROM Memory, Variables and Subroutines
-------------------------------------

### Memory Map

    1200   free for user use
    11A3   key input buffer
    1170   variable area
    10F0   CMT header area
    10EF   start of stack (initial SP set to $10F0)
    1000   stack area
    0000   ROM; monitor code

### Variables

Variable locations (all values in hex): [[smzo-monicmd]]

    addr  len   name    descr
    11A1    2           2 MHz/n, n=divisor freq. for 74LS221 used for sound
    117D                screen top current addr (MZ-80A, ¿MZ-700)
    10F0   80   IBUFE   tape header buffer
    103C   B4   SP      180 bytes for stack
    1038    3           jp to time interrupt (038D)
    1000   38           unused

### BIOS API (Jump Table)

Standard routines (subscript is RST number) [[som 151]]:

    0000 ₀  MONIT   monitor on (reset entry point)
    0003    GETL    ♡全 get line ending in CR or shift-break; DE→input buf
                        max 80 chars, echos chars, break/CR codes included
    0006    LETNL   ♣A cursor to beginning of next line
    0009    NL
    000C    PRNTS   ♣A print space
    000F    PRNTT   print tab
    0012    PRNT    ♠♣A print ASCII char in A
    0015    MSG     ♡全 print message ♠DE→msg, end w/CR (not printed)
                        control codes 11-16 move cursor
    0018 ₃  MSGX
    001B    GETKY   ♣A get keycode in A, or $00 = no key pressed
                    $60-66 = DEL, INST, ALPHA, BREAK, CR
                    $11-16 = ↓, ↑, →, ←, HOME, CLR
    001E    BRKEY   ♣A Z=1 if shift+break being pressed, Z=0 otherwise
    0021    WRINF   write information (tape header?)
    0024    WRDAT   write data (tape data?)
    0027    RDINF
    002A    RDDAT
    002D    VERFY   verify CMT (header and?) data
    0030 ₆  MELDY   ♣A play music DE→music data (same format as BASIC)
                        end w/CR or $C8. cy=0 no break, cy=1 break intr.
    0033    TIMST   ♣A set time ACC=0(AM),1(PM), DE=time in secs
    0038            interrupt routine (jp $1038)
    003B    TIMRD   ♠A,DE read time (per TIMST)
    003E    BELL    ♣A briefly sound ~880 Hz
    0041    XTEMP   ♡全 tempo set (A=tempo, 0=slowest, 7=highest)
    0044    MSTA    ♡BCDE melody start
    0047    MSTP    ♣A melody stop

### Documented Internal Routines

These are described in the (EU) user's manual, so are presumably unlikely
to change location. [[som 151]]

    03DA  ASC     ♠A ← ASCII char for number in A low nybble
    03F9  HEX     ♠A ← number represented by ASCII value in A
    0410  HLHEX   ♣A ♠HL ← 16-bit value repres. by DE → 4 ASCII chars
                      cy 0=success, 1=fail
    041F  2HEX    ♣DE ♠A -< 8-bit vlaue repres. by DE → 2 ASCII chars
    09B3  ??KEY   ♠A blink cursor, wait for keypress, code returned in A
    0BB9  ?ADCN   ♠A ← display code from ASCII code in A
    0BCE  ?DACN   ♠A ← ASCII code from display code in A
    0DA6  ?BLNK   ♡全 wait for vertical blank period to start
    0DDC  ?DPCT   ♡全 "display control": update display as if key code in
                  A was pressed. $C0=scrolling, $C1-C4=↓↑→←, C5=HOME,
                  $C6=CLR, $C7=DEL, $C8=INST, $C9=ALPHA, $CD=CR
    0FB1  ?PONT   ♣A ♠HL ← current cursor location

### Internal Routines

    0082          monitor prompt/command loop MZ-80K
    0095          monitor prompt/command loop MZ-80A
    00AD          monitor prompt/command loop MZ-700

Hardware Modification
---------------------

### ROM Replacement

European/PAL ROMs may be different from the Japanese ones.

- MZ-80K:  The IPL/Monitor ROM is in a 2332 (4K×8). This can be replaced
  with a 2532 without modification, or a 2732 by grounding pin 18,
  connecting the track for 18 to 21, and cutting the existing pin 21 track.
  [[smzo-h&t]]
- MZ-700: uses a 2732.



<!-------------------------------------------------------------------->
[smzo-h&t]: https://original.sharpmz.org/mz-80k/tips.htm
[smzo-monicmd]: https://original.sharpmz.org/mz-700/monicmd.htm
[som 151]: https://archive.org/details/sharpmz700ownersmanual/page/n153/mode/1up?view=theater
