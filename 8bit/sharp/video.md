Sharp MZ Video
==============

### MZ-700

40 chars × 50 lines of character VRAM at $D000-$D7FF (must be banked in,
see [`addr-decoding`](addr-decoding.md)); not clear how to set start line
of 40×25 screen.

Matching color VRAM at $D800-$DFFF, encoded as:

    b7      ATB: selects one of two banks in character ROM
    b654    GRB foreground
    b3      unused
    b210    GRB background



<!-------------------------------------------------------------------->
[ssm]: https://archive.org/details/sharpmz700servicemanual/page/n7/mode/1up?view=theater
