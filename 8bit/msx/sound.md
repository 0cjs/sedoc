MSX Sound Chips
===============

PSG
---

The MSX standard specifies that all machines will have a PSG (Programmable
Sound Generator), which is [GI AY-3-8910][wp-psg] compatible. It has three
square wave sound channels (A, B and C) and one noise channel.

The AY-3-8910 also has two 8-bit GPIO ports with internal pull-ups on each
pin. (Other AY-3-89xx models are missing the ports.) On MSX these are
used for joystick inputs, the kana lamp, etc. (See section 1.7.12 in the
Sony MSX1 manual.)

The AY-3-8910 has 16 registers, accessed by putting its bus into "address
mode," writing the register number, and then switching to "data mode" to
write the data to the selected register. GI's CPUs had native support for
this bus protocol; other systems need to emulate the various bus signals
for the above, usually with a PIA (6820 or similar was common).

On MSX, the I/O ports are:

    $A0   WR  address latch
    $A1   WR  data write
    $A2   RD  data read

The MSX BIOS has some calls to ease use:
- $090 `GICINI` (no parameters): initialises the PSG (turning off any sound
  that's currently running) and sets up static data for the MS-BASIC `PLAY`
  statement.
- $093 `WRTPSG`: write data in E to PSG reg in A
- $096 `RDPSG`: read data from register in A, returning in A.
- $099 `STRTMS`: checks/starts background tasks for BASIC `PLAY`.
- The BASIC `SOUND reg,value` statement will write directly to the PSG.
  (`PLAY` uses a music macro language, MML.)

Many BASIC games will use machine-language routines to run the music; the
timer interrupt hook H.TIMI will be set to call the playback routine
60 times per second and that routine will update the PSG registers.

### PSG Registers

The register layout varies depending on how the chip is connected, and
perhaps with the chip itself. Non-MSX references may not map the register
functions to the same register numbers.

     R0   ch.A period LSB (fine tune)
     R1   ch.A period MSB (coarse tune): bits 0-3 only
     R2   ch.B period LSB
     R3   ch.B period MSB
     R4   ch.C period LSB
     R5   ch.C period MSB
     R6   noise period: bits 0-4 only

     R7   Channel enable:
            b7-6: GPIO B,A:      0=input  1=output
            b5-3: ch.C,B,A noise 0=enable 1=disable
            b2-0: ch.C,B,A tone  0=enable 1=disable

     R8   ch.A amplitude
            b7-5: unused
              b4: amplitude mode: 0=fixed 1=variable (use envelope)
            b3-0: level for fixed amplitude
     R9   ch.B amplitude
    R10   ch.C amplitude

    R11   envelope period LSB
    R12   envelope period MSB
    R13   envelope shape/cycle control
            b7-4: unused
              b3: continue    0=reset+hold    1=per hold bit
              b2: attack      0=down (decay)  1=up (attack)
              b1: alternate   0=loop          1=reversing
              b0: hold        0=cycle         1=single-shot

    R14   GPIO port A data (must be programmed for input)
            b7: CMT input
            b6: kbd mode
            b5: joystick trigger B
            b4: joystick trigger A
            b3: joystick right
            b2: joystick left
            b1: joystick back
            b0: joystick forward
    R15   GPIO port B data (must be programmed for output)
            b7: kana LED
            b6: joystick select
            b5: pulse 2
            b4: pulse 1
            b3-0: always 1

Notes:
- Higher periods give lower frequencies.
- A period of 0 actually indicates a period of $1000.
- R7 disables do not turn off channels; write 0 to R10-R12 amplitude control.

References:
- _MSX Red Book Revised_ [5. Programmable Sound Generator][rrr-regs].
  This seeems to be the correct register listing for MSX.
- [Original datasheet scan][aydata]
- [AY-3-8910/8912 Programmable Sound Generator Data Manual][aydata] (PDF).
  Reformatted version; searchable text. Registers in octal.
- [PSG][iwiki] page on the Intellivision Wiki
  (AY-3-8914, AY-3-8916 and AY-3-8917; not same register layout as AY-8510)


<!-------------------------------------------------------------------->
[aydata1]: https://f.rdw.se/AY-3-8910-datasheet.pdf
[aydata]: https://map.grauw.nl/resources/sound/generalinstrument_ay-3-8910.pdf
[iwiki]: http://wiki.intellivision.us/index.php?title=PSG
[wp-psg]: https://en.wikipedia.org/wiki/General_Instrument_AY-3-8910
[rrr-regs]: https://www.angelfire.com/art2/unicorndreams/msx/RR-PSG.html
