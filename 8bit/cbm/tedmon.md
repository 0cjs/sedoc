TEDMON Machine-language Monitor
===============================

The [TEDMON] machine-language monitor is included in the [BASIC 3.5] ROM in
the C16, C116 and Plus/4 and the [BASIC 7.0] ROM in the C128, C128D and
C128DCR. It is entered via:
- Holding down `RUN/STOP` during power-on or reset;
- The `MONITOR` or `SYS 1024` commands in BASIC;
- Executing a BRK ($00) opcode, executed, which will print "BREAK" followed
  by a register display.

On the C128 series, the first digit of the PC in the register display is
the bank number. See below for details.

### Commands

No input prompt. Errors on input display `?`.
`s` is a start address; `e` is an end address.

    X               Exit to BASIC

    R               Register display
    M s e           Memory dump; without _e_ shows 12 lines
    D s e           Disassemble
    C s e s₂        Compare memory at _s_ and _s₂_
    H s e vals      Search (hunt) for _vals_ (string or space-separated hex)

    ;               Change registers
    > s b₀ b₁ … b₈  Deposit up to 8 bytes at s (_s_ defaults to last M addr?)
    F s e v         Fill memory with byte value _v_
    T s e s₂        Copy (transfer) memory from _s_ to _s₂_
    A s instr op    Assemble instruction; prefix hex values with $
    . s instr op    Assemble as above

    G s             Set registers and JMP _s_
    J s             JSR _s_; return to monitor on RTS (C128 only)

    L "f",dev,s     Load a file; _s_ start addr on C128 only
    S "f",dev,s,e   Save memory from _s_ to _e-1_
    V "f",dev,s     Verify file against memory; _s_ on C128 only
    @               display drive status (optional dev, C128 only)

On C128 the following number base prefixes may be used:
`$` hex, `+` decimal, `&` octal, `%` binary.

C128 banks are:

    0   RAM0
    1   RAM1
    2   RAM2
    3   RAM3
    4   INT ROM, RAM 0, I/O
    5   INT ROM, RAM 1, I/O
    6   INT ROM, RAM 2, I/O
    7   INT ROM, RAM 3, I/O
    8   EXT ROM, RAM 0, I/O
    9   EXT ROM, RAM 1, I/O
    A   EXT ROM, RAM 2, I/O
    B   EXT ROM, RAM 3, I/O
    C   KERNAL + INT (lo), RAM 0, I/O
    D   KERNAL + EXT (lo), RAM 0, I/O
    E   KERNAL + BASIC, RAM 0, CHARROM
    F   KERNAL + BASIC, RAM 0, I/O


<!-------------------------------------------------------------------->
[BASIC 3.5]: https://www.c64-wiki.com/wiki/BASIC_3.5
[BASIC 7.0]: https://www.c64-wiki.com/wiki/BASIC_7.0
[TEDMON]: https://www.c64-wiki.com/wiki/TEDMON
