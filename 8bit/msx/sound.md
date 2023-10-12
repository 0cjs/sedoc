MSX Sound Chips
===============

- Standard (MSX1 onward)
  - 1-bit Sound Port
  - PSG
- FM Sound
  - MSX-AUDIO
  - MSX-MUSIC
  - Moonsound
- Other Sound Systems
  - Konami SCC
- Music Macro Language (MML) and MGS


1-bit Sound Port
----------------

Described in [[2the 5.1.2]]. This is used for key click and can be used for
1-bit PCM. Available on all systems from MSX1 onward.

PPI Port C bit 7 is connected to the speaker (mixed with the PSG output).
The $135 `CHGSND` will set this to 0 if A=0 or 1 if A is non-zero.

[[2the lst5.2]] gives an assembly language program to play back a cassette
tape via the port. [[msx.org kcsp]] has a BASIC version.


PSG
---

The MSX standard specifies that all machines will have a PSG (Programmable
Sound Generator), which is [GI AY-3-8910][wp-psg] compatible. It has three
square wave sound channels (A, B and C) and one noise channel.

MSX1 often uses an actual AY-3-8910; MSX2/2+/TurboR use a compatible YM2149
SSG (Software Sound Generator), which was also used on the Atari ST and some
arcade games.

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

The [MSX BIOS has some calls][2the 5.1.2] to ease use:
- $090 `GICINI` (no parameters): initialises the PSG (to [[2the f5.9]],
  turning off any sound that's currently running) and sets up static data
  for the MS-BASIC `PLAY` statement.
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
- See also [`README: Joystick`](README.md#joystick) for R14/R15 ports.
- Higher periods give lower frequencies.
- A period of 0 actually indicates a period of $1000.
- R7 disables do not turn off channels; write 0 to R10-R12 amplitude control.
- GPIO ports have on-chip pull-ups as well as typ. 10 kΩ pull-ups on the
  MSX motherboard.

Chip References:
- _MSX2 Technical Manual,_ [Figure 5.2 PSG register structure][2the f5.2]
- _MSX Red Book Revised_ [5. Programmable Sound Generator][rrr-regs].
  This seeems to be the correct register listing for MSX.
- [Original datasheet scan][aydata]
- [AY-3-8910/8912 Programmable Sound Generator Data Manual][aydata] (PDF).
  Reformatted version; searchable text. Registers in octal.
- [PSG][iwiki] page on the Intellivision Wiki
  (AY-3-8914, AY-3-8916 and AY-3-8917; not same register layout as AY-8510)
- [YM2149 pinout]


MSX References:
- _MSX2 Technical Manual,_ [Ch. 5.1 PSG and Sound Output][2the 5.1]
- _MSX Red Book Revised_ [5. Programmable Sound Generator][rrr-regs].

Other References:
- [PSG WAV Play][wavplay] will play back 8-bit 11 KHz WAV data on the PSG.


FM Sound
========

These are based around Yamaha FM synthesis chips often known as the OPL
(FM Operator Type-L) series, which started with the YM3526. It offers 9
channels of FM synthesis, or 6 channels of FM plus 5 of percussion. Some
versions of the chip (such as the Y8590) also offered GPIO and keyboard
scanning. [[opl3prog]] provides a brief overview of OPL programming.

Summary:
- MSX-AUDIO:  OPL1 [Y8590]
- MSX-MUSIC:  OPLL [YM2413]
- Moonsound:  OPL4 [YMF-278B-F]

BiFi's Weblog post [Detection of FM sound chips][bifi] may provide further
useful information on detecting MSX-AUDIO, MSX-MUSIC (both real and
emulated by MSX-AUDIO with recent ROM updates) and MoonSound.


MSX-AUDIO
---------

[MSX-AUDIO] was available in three implementations. The Panasonic FS-CA1
offered full suport for the standard, the Philips NMS-1205 and Toshiba
HX-MU900 partial support. It uses the OPL1 [Y8590], which includes 4-bit
ADPCM sampling support (sample ram varies from 0-32KB), and has a keyboard
connector. The ROM includes [MSX-AUDIO BASIC] extensions.
[Detection/programming][maud prog]:
- $80-$84 contain signature `AUDIO`.
- Y8950 ports: $C0 reg number (delay 12 cyc), $C1 data (delay 84 cyc).
  $C2 and $C3 if second Y8950 present.
- Page 0: $0000-$2FFFF MBIOS, $3000-$3FFF 4 KB work RAM
- Page 1/2: $4000-$BFFF segment selected by writing $3FFF b1-b0:
  - 0: $4000-$6FFF BASIC extn, $7000-$7FFF RAM mirror
  - 1: $4000-$BFFF custom firmware
  - 2, 3: $4000-$BFFF ADPCM data 1, 2
- Also see [Hardware][maud hw] and [拡張BIOS][maud bios].


MSX-MUSIC
---------

[MSX-MUSIC][] (also see [here][MSX-Music-fmpac])  was a later but inferior
system using the cheaper OPLL Yamaha [YM2413], which is still partially
compatible (only 1 user instrument; no ADPCM). It was built into most MSX2+
systems. The original cart is the Panasonic SW-M004 FM-PAC; there were a
few others, including stereo versions. [Detection/programming][mmus prog]:
- Scan for internal first, then external:
  - Internal: $4018-$401F signature `APRLOPLL` (also clone carts);
    I/O ports usable; no memory-mapped I/O.
  - External: $401C-$401F signature `OPLL` (FM-PAC);
    use memory mapped I/O or enable ports by setting $7FF6 b1 = 1.
  - Also see [this thread][mmus detect]
  - Some modern MSX-AUDIO ROMs may emulate MSX-MUSIC BIOS, e.g., `AUD1OPLL`,
    `AUD3OPLL`, `AUD4OPLL` (Moonsound); FM-BIOS must be used for these.
  - Writing to $7FF0-$7FFF on Panasonic MSX2+ will disable MSX-MUSIC ROM
- YM2413 ports:
  - $7C (mem $7FF4) register index (delay 12 cyc),
  - $7D (mem $7FF5) data (delay 84 cyc)

### FM-BIOS

References: [[mdp.7.3.3]].

Memory map:

    4000        ROM header?
    4100  2k75  FM BIOS (2.
    4C00  0k5   Sound data area
    4E00        unused?

The BIOS is usually called via interslot calls. `INIOPL` _must_ be called
before any other routines, and given a 160 byte _work area_ that must be in
RAM. Thus it cannot be in page 1 (FM-BIOS ROM itself, during the call) at
all, or in page 0 (MSX-BIOS ROM) without special arrangements. Most calls
may destroy all registers and use up to 32 bytes of stack.

    4110   WRTOPL   Write to OPLL register. A=register, E=data.
    4113   INIOPL   Init OPLL. HL=work area (word aligned, stored in SLTWRK)
                    The work area is used continuously and so must be in RAM
                    and not in page 1 (FM-BIOS ROM page).
    4116   MSTART   Start music. HL=music addr, A=repeat count (0=infinite)
    4119   MSTOP`   Stop music, re-init work area.
    411C   RDDATA   Read instrument data. A=instno (0-63), HL=8 byte
                    buffer for result.
    411F   OPLDRV   H.TIMI hook for MSTART.
    4122   TESTBGM  Status returned in A. 0=not playing.

    5000            Statement handler.
    5003            Interrupt handler.
    5006            Stop BGM handler.
    5009            Enable and reset OPLL handler.

    FD09 2 SLTWRK   Pointer to work area set by INIOPL.

### YM2413 Registers

References: [[mdp.7.3.4]], [datasheet][YM2413ds] (pp.4-5),
            [Application Manual][YM2413am] (pp.6-, PDF.9-)

The OPLL has two modes:
- Tone mode: 9 voices, each a 2-operator (modulator, carrier)
  FM tone generator.
- Rhythm mode: 6 voices of 2-operator FM tone generators;
  5 rhythm sounds (base, snare, tom, top cymbal, hi-hat).

Init `I̅C̅` clears all registers to 0.

    $00 modulator   AM/VIB/EG-TYP/KSR/Mutiple
    $00 carrier     AM/VIB/EG-TYP/KSR/Mutiple
    $02 modulator   KSL/Total (modulation?) Level
    $03 carrier     KSL/Distortion/Feedback level
    $04 modulator           b7-4: attack  rate
                            b3-0: decay   rate
    $05 carrier             b7-4: attack  rate
                            b3-0: decay   rate
    $06 modulator           b7-4: sustain level
                            b3-0: release rate
    $06 modulator           b7-4: sustain level
                            b3-0: release rate
    $0E Rhythm Control      b7-6: unused
                              b5: 0=tone mode   (9 tone voices)
                                  1=rhythm mode (6 tone voices + drum kit)
                              b4: base drum   0=disabled 1=enabled
                              b3: snare drum  0=disabled 1=enabled
                              b2: tom-tom     0=disabled 1=enabled
                              b1: top cymbal  0=disabled 1=enabled
                              b0: hi-hat      0=disabled 1=enabled

    $0F Test mode:             0 = normal playback
                           non-0 . undocumented test mode

Per-voice registers (9 in tone mode; 6 in rhythm mode):

    $10-18  F-number (frequency) low 8 bits

    $20-28  Voice Config    b7-6: unused
                              b5: 0=decay 1=sustain (RR=5 w/key off)
                              b4: key on/off: 0=mute 1=play
                            b1-3: octave
                              b0: high bit of note frequency

    $30-38  Inst/Vol        b7-4: instrument (0-15: see below)
                            b3-0: volume (0-15)

In rhythm mode voices 7-9 must be configured to specific values for the
expected sounds to be produced, and the Inst/Vol settings for those voices
are changed to just volume for the five rhythm instruments:

    $16 Rhythm F-number:  $20
    $17 Rhythm F-number:  $50
    $18 Rhythm F-number:  $C0

    $26 Rhythm config:    $05
    $27 Rhythm config:    $05
    $28 Rhythm config:    $01

    $36 Rhythm Volume         b7-4: unused
                              b3-0: bass drum
    $37 Rhythm Volume         b7-4: hi-hat
                              b3-0: snare drum
    $38 Rhythm Volume         b7-4: tom-tom
                              b3-0: top cymbal

Instrument values (original is the sole user-programmable patch):

    $0 original   $4 flute      $8 organ        $C vibraphone
    $1 violin     $5 clarinet   $9 horn         $D synth bass
    $2 guitar     $6 oboe       $A synthesizer  $F acoustic bass
    $3 piano      $7 trumpet    $B harpsichord  $F elec guitar/bass


Moonsound
---------

The Moonsound uses an OPL4 [YMF-278B-F] offering 16-bit wavetable and FM
synthesis.


Other Sound Systems
===================

### Konami SCC

The [Konami SCC][] ([tech info][scc tech])  was a custom sound chip
providing 5 channels of wavetable synthsis. It was included in some Konami
game carts and in a standalone cart for use with disk games. There was also
an improved SCC-1 version.


Music Macro Language (MML) and MGS
==================================

MSX game composers typically used MML to compose their soundtracks, but a
far more sophisticated version of MML than that used in BASIC.

[MGSC111.TXT] describes the format used by the [`MGSC.COM` MML
compiler][mgs-create], which reads `.MUS` files containing MML and
generates a `.MGS` file as output that can then be used by a player such as
[`MGSDRV.COM`][mgsplay].

These formats typically allow one to use all available sound sources in the
machine simultaneously, so that a system with MSX-MUSIC can give you the
three PSG voices along with the 6 FM voices plus rhythm.

[`msxplay.com/editor.html`][msxplay-ed] is an on-line interactive
editor/player; the [`msxplay.com`][msxplay] home page explains how to have
it load directly from GitHub, as well as where to get the source for the JS
player.



<!-------------------------------------------------------------------->

<!-- 1-bit Sound Port -->
[msx.org kcsp]: https://www.msx.org/forum/msx-talk/software/key-click-sample-player
[2the 5.1.3]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter5a.md#13-tone-generation-by-1-bit-sound-port
[2the lst5.2]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter5a.md#list-52--reading-from-cassette-tape

<!-- PSG -->
[2the 5.1.2]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter5a.md#12-access-to-the-psg
[2the 5.1]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter5a.md#1-psg-and-sound-output
[2the f5.2]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter5a.md#figure-52--psg-register-structure
[2the f5.9]: https://github.com/Konamiman/MSX2-Technical-Handbook/blob/master/md/Chapter5a.md#figure-59--initial-values-of-psg-registers
[YM2149 pinout]: https://www.vgmpf.com/Wiki/index.php?title=File:YM2149_-_Pin_Out.png
[aydata1]: https://f.rdw.se/AY-3-8910-datasheet.pdf
[aydata]: https://map.grauw.nl/resources/sound/generalinstrument_ay-3-8910.pdf
[iwiki]: http://wiki.intellivision.us/index.php?title=PSG
[rrr-regs]: https://www.angelfire.com/art2/unicorndreams/msx/RR-PSG.html
[wavplay]: https://github.com/LarsThe18Th/Small-Projects/tree/master/MSX/ASM/DOS/PSG%20WAV%20Play
[wp-psg]: https://en.wikipedia.org/wiki/General_Instrument_AY-3-8910

<!-- FM Sound -->
[MSX-AUDIO BASIC]: https://www.msx.org/wiki/MSX-AUDIO_BASIC
[MSX-AUDIO]: https://www.msx.org/wiki/MSX-AUDIO
[MSX-MUSIC]: https://www.msx.org/wiki/MSX-MUSIC
[MSX-Music-fmpac]: http://www.faq.msxnet.org/fmpac.html
[Y8590]: https://en.wikipedia.org/wiki/Yamaha_Y8950
[YM2413]: https://en.wikipedia.org/wiki/Yamaha_YM2413
[YM2413am]: https://map.grauw.nl/resources/sound/yamaha_ym2413_frs.pdf
[YM2413ds]: https://en.wikipedia.org/wiki/Yamaha_YM2413
[YMF-278B-F]: http://www.msxarchive.nl/pub/msx/docs/datasheets/opl4.pdf
[bifi]: http://bifi.msxnet.org/blog/index.php?entry=entry110809-114719
[maud bios]: http://map.grauw.nl/resources/datapack/Vol2-4.1MSX-AUDIOHardware.pdf
[maud hw]: http://map.grauw.nl/resources/datapack/Vol2-4.3MSX-AUDIOExtendedBIOS.pdf
[maud prog]: https://www.msx.org/wiki/MSX-AUDIO_programming
[mdp.7.3.3]: http://ngs.no.coocan.jp/doc/wiki.cgi/datapack?page=3.3+FM+BIOS
[mdp.7.3.4]: http://ngs.no.coocan.jp/doc/wiki.cgi/datapack?page=3.4+YM2413(OPLL)
[mmus detect]: https://www.msx.org/forum/msx-talk/development/how-to-detect-sound-chips-without-bios
[mmus prog]: https://www.msx.org/wiki/MSX-MUSIC_programming
[opl3prog]: http://www.fit.vutbr.cz/~arnost/opl/opl3.html
[scc tech]: http://bifi.msxnet.org/msxnet/tech/scc.html

<!-- Other Sound Systems -->
[Konami SCC]: https://www.msx.org/wiki/Konami_SCC

<!-- MML -->
[MGSC111.TXT]: https://www.gigamix.jp/mgsdrv/MGSC111.TXT
[mgsc]: htps://gigamix.hatenablog.com/entry/mgsdrv/#MGS形式のデータを作りたい
[mgsplay]: https://gigamix.hatenablog.com/entry/mgsdrv/#MGS形式のデータを聴きたい
[msxplay-ed]: https://msxplay.com/editor.html
[msxplay]: https://msxplay.com/
