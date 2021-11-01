NEC PC-nnn Series
=================

- 1979: [PC-8001](8001.md): Business/games.
- 1981: [PC-6001](6001.md): Lower-end gaming; includes cartridge port.
- 1981: [PC-8801](8801.md): Moving more towards business. Separate keyboard
  on all models; integrated FDDs in models after the first.
- 1982: [PC-9801](9801.md): 16-bit, business
- 1983: mkII released for all 8-bit series
- 1985: 8-bit  mkII SRs released: end of PC-80 and focus on games for PC-88.


Machine-language Monitor
------------------------

Enter from Basic with `MON` command. Prompt is `*`. `ESC` pauses output.

- `Dx,y`: Display bytes at addrs _x_ (def. 0) to _y_ (def. x+$10).
- `Sx`: Display byte at _x_ and prompt for new value;
  continue with next addr until no value entered.
- `G x`: Goto addr _x_.
- `W x, y`: Write tape block from _x_ to _y_.
- `L`: Load tape block.
- `LV`: Load tape block and verify it's correctly loaded.
- `TM`: Test memory and return to Basic.
- Ctrl-B: Return to Basic.
