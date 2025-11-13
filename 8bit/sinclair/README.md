Sinclair Computers: ZX80/ZX81/Spectrum/etc.
===========================================

ZX80/ZX81 Video
---------------

Screen is 24×32 cells of 8×8 pixel characters, with only upper case letters
supported. Character codes (see Sinclair manual, Appendix A) are:

    Normal                  Inverse
    ───────────────────────────────────────────────────────
    $00     space           $80     "cursor" (black box?)
    $01-$0A 4×4 graphics    $81-$8A 4×4 graphics
    $0B-$1B punctuation     $8B-$9B punctuation
    $1C-$25 numbers 0-9     $9C-$A5 numbers 0-9
    $26-$63 letters A-Z     $A6-$BF letters A-Z
    $76     newline/HLT

The _display file_ is always 24 variable-length lines: $76 followed by 0-32
character codes. The final line is followed by one more $76. Character
codes other than those listed above are illegal and may cause a system
crash.
