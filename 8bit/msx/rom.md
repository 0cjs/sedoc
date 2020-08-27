MSX ROM
=======

Usage Notes
-----------

### Startup

- Use STOP to pause/restart output, Ctrl-STOP to break.
- Holding down `Shift` during the post-reset initialization sequence will
  avoid loading DOS, generally leaving with you with about 5384 more bytes
  of memory available to BASIC (around 28K instead of 23K).
- Holding down `Ctrl` will enable only one drive and leave you with about
  1558 bytes of free memory available to BASIC (around 25K instead of 23K).

### BASIC

Handy screen-editor keys:
- `^B`/`^F`: cursor back/forward one word
- `^N` move to EOL
- `^E`: erase to EOL
- `^U` erase current line
- `^R` enter/exit insert mode (cursor movement also exits)

See msx.org wiki [MSX Characters and Control Codes][codes] for a full list
of the control codes, which seem to work the same on input as output where
that makes sense.



<!-------------------------------------------------------------------->
[codes]: https://www.msx.org/wiki/MSX_Characters_and_Control_Codes
