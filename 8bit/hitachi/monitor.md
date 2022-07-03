Hitachi Basic Master Machine Language Monitor
=============================================

Enter using `MON` or `MONITOR` at BASIC prompt.

- Enter aborts the current command, even if you've typed something.
- Space enters the current input, or keeps the default value if you've
  entered nothing.
- DEL clears and restarts input for the current value.

Many commands start their own input mode.

    E   Escape (jumps to BASIC; cold start with any current program deleted)
        (On MB-6885, use `G B000` to preserve existing BASIC program.)

    R   Register display/change
    D   Display 128 bytes of memory
    M   Modify memory (can also view byte-by-byte; seems to confirm writes)
    F   Fill memory
    T   Transfer (copy) memory

    G   Go (seems to be a trace command or something like that?)
    B   create breakpoint
    S   Step

    L   Load from tape (always loads at start addr specified in file)
    P   Punch to tape (saves start addr to end - 1)
    V   Verify tape (compares memory using start addr and len in file)

Tape loads and verifies must specify the correct filename; terminate
filename input with a space or return if the filename is less than 6
characters (the remainder of the filename will be space-filled). Blocks
from other files will be ignored (though the name will be printed for each
block). See "CMT Load and Filenames" in [README](README.md) for more
details.
