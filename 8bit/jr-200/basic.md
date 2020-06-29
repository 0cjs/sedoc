National/Panasonic JR-200 BASIC
===============================

Written by Matsushita System Engineering (not an MS BASIC). It has a
"screen editor" similar to Commodore's.

- Maximum line length is 80 chars. Keywords must be space-separated.
- Integers and 9-digit floating point numbers are available. Integers
  prefixed with `$` are hexadecimal.
- Variable names are 2-chars only; more gives syntax error.
- CMT save filenames may include any combination of underscore, numbers and
  mixed-case letters. Other chars will cause a syntax error.

Many keywords and functions are on the keytops (entered with the CTRL key).

Screen:
- `LOCATE x,y`: Set cursor position (0-31, 0-23).
- `HPOS(n)`, `VPOS(n)`: Current cursor location; _n_ is ignored.
- `COLOR f,b,m`: Set foreground, background colors for text/plotting. _m_
  is display mode: 0=normal, 1=user-defined chars, 2=toggle inverse,
  3=alter background for all screen following cursor. All args are
  optional. Colors: 0=black 1=blue 2=red 3=magenta 4=green 5=cyan 6=yellow
  7=white.
- `POKE $CA00,n`: Set border color.
- `PLOT x,y`: Set pixel of 64×48 low-res graphics mode.

Sound:
- `BEEP n`: Turn off/on (_n_=0/1) 880 Hz tone.
- `SOUND p,l`: _p_ Hz tone, approx _l_×25 milliseconds long.
- `PLAY`, `TEMPO`: For up to 3-part sound, foreground or background.

I/O:
- `STICK(n)`: Read keyboard (_n_ = 0) and joystick (_n_ = 1, 2) ports.
  - Joystick bits go low for: 0=up 1=down 2=left 3=right 4=button
  - Keyboard returns code (more or less ASCII) as long as key is pressed.
    shift/英数/GRAPH/カナ still have modifier effect.
- `LPRINT`, `LLIST`
- `HCOPY`: Screen dump to printer. (Not clear what it does with graphics.)

Save/load:
- `SAVE "name"`. Save BASIC program to tape. _name_ must not be empty
  string. Five seconds silence before data starts.
- `VERIFY "name"`: Verify save matches in-memory program. _name_ optional.
- `LOAD "name"` Load BASIC program from tape. _name_ optional.
- `MSAVE "name",start,end`: Save memory, from _start_ though _end_
  inclusive.
- `MLOAD "name",start`: Load memory, save address used if _start_ not
  provided.

Programming:
- `RUN n`: (Re-)run program, optionally at a given line number. Given a
  filename will also load/run from tape.
- `USR(addr)`: Run ML program, e.g., `mload:a=usr($1000)`.
- `VARPTR(v)`: Gives address of variable _v_. (Do not use quotes.)
- `MON`: Enter machine-language monitor. See [rom](rom.md).

Unknown:
- `PICK`


Sources
-------

- [_Creative Computing_ review][ccreview], May 1983. The [original
  scan][ccreview-orig] has the photos and code, but the 2nd and 3rd pages
  are swapped.



<!-------------------------------------------------------------------->
[ccreview]: https://www.atarimagazines.com/creative/v9n5/16_Panasonic_JR200.php
[ccreview-orig]: https://archive.org/stream/creativecomputing-1983-05./Creative_Computing_v09_n05_1983_05#page/n19/mode/1up
