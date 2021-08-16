Hitachi MB-H1 (MSX1)
====================

    Released            1983-12, 1984
    RAM, Video RAM      32K, 16K
    Expansion           2 top cartridge slots
    PSU                 External, mini-DIN 7

An older 1983 version has cursor keys in a row and the MB-H1E variant has
only 16K RAM. The two colors are Elegant Almond (EA) and Trad Red (TR);
the later are always the 1984 version.


Power Supply
------------

The PSU is a large external unit (as heavy as the computer itself, and
always a dark beige) that can clip to the back, covering up the audio, CVBS
and printer ports. It has a short cable with a mini-DIN-7m plug that
connects to a mini-DIN-7f jack on the left side of the computer.

    Output: mini-DIN-7
    looking into male plug
                        ∪           ∪:chasGND
      5: 12.1  V     5  6  7        6: 1.66 V       7: -12.3 V
      3: 0.27 V      3  ▄  4        4: 0.27 V
      1: frame GND    1   2         2: 2.17 V

- All above are relative to frame ground, tested with no load.


Memory Map
----------

    Slot 3 4000-7FFF    Firmware (monitor, sketch, etc.) (bottom 8K only?)
    Slot 2 0000-FFFF    Cartridge Slot 2
    Slot 1 0000-FFFF    Cartridge Slot 1
    Slot 0 8000-FFFF    RAM
    Slot 0 0000-7FFF    Main-ROM


MB-H1 System Monitor Utility
----------------------------

Reached by pressing `F2` from the startup screen when no cartridge is
inserted. Prompt is `-`; `?` printed on error. Commands are not
case-sensitive.
- `↓`: immediately asks for an address (no CR).
- `*`: parameters required (listed after `P:`) followed by CR.
- `o`: command parameters are optional.
- `?`: unknown function

Commands/help screen:

      B: Break point        (see below)
    * C: Compare            P:start,end,start2. "Compare error" or no output.
    ↓ D: Display            hex dump 8 lines × 8 bytes; next default addr += $40
      E: Escape             reboots machine
    * F: Fill               P:start,end,value
    ↓ G: Go                 displays addr for modification then jumps to it
      H: Help               prints this screen
      I: Input I/O port
    ↓ M: Memory             modify memory; space=deposit/continue, CR=exit
      O: Output I/O port
    o R: Register           P:CR to display all regs.
                            P:reg name or abbreviation to set.
      S: Step               at PC, print opcode+args, PC, regs after step
    ? T: Transfer           P:3 word values; not sure what this does

- `D` and `M` first print the current default start address; hit `RETURN`
  to use it or type a new address. Non-digit chars are ignored; only the
  last four valid digits are used.)
- `M`, after taking a start address, displays the address and current
  value. Type replacement value or nothing to keep old value followed by
  Space to to continue with the next address, or hit CR to terminate entry
  (any param before CR is ignored). New default dump/modify address will be
  the termination address.
- `B`: Not clear how this works. Running code seems to see the proper
  instruction, not a break instruction, in that location. Doesn't seem to
  work in ROM.

#### System Configuration in Monitor

Some of these are guesses.

      $8000-$FFFF   RAM
      $6000-$7FFF   unmapped
      $5F4A-$5FFF   unprogrammed ($FF)
      $5F00-$5F49   ROM
      $5E48-$5EFF   unprogrammed ($FF)
      $40E0         initial PC (going here reboots)
      $0000         ROM; reset entry point
