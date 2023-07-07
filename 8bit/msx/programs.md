MSX Programs
============


Soft Reset
----------

In BASIC, where page 0 is guaranteed to to the BIOS ROM:

    DEFUSR=0:A=USR(0)

In MSX-DOS you need to do an interslot call. From NYYRIKKI in the [MSX
Resource Center Forums][mf-softreset], the following four bytes in a `.COM`
file will do the trick:

    F7      RST6        # CALLF
    80      db $80      # slotdesc 1xxx0000: secondary enabled just in case
    00 00   dw $0000    # address to call

You can build this file from MSX-BASIC with:

    OPEN "RESET.COM" FOR OUTPUT AS#1
    PRINT #1, CHR$(247);CHR$(128);STRING$(2,0);
    ' Even w/semicolon it appends $1A, but this is harmless.
    CLOSE #1

[mf-softreset]: https://www.msx.org/forum/msx-talk/general-discussion/soft-reset
