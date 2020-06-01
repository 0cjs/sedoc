NEC PC-8000 Series
==================

The Z80-based __PC-8001__ was one of the first micros introduced into
Japan, in 1979-09, preceeded only by the Hitachi Basic Master. It could run
CP/M.
- __PC-8001A__ (1981-08): US release. Katakana replaced with Greek.
- __PC-8001B__ (?): European release (240V). [Pictures][retropc.net/404].
- __PC-8001mkII__ (1983-03): Improved graphics, many expansion modules
  (including FDC) built-in, two expansion slots.
- __PC-8001mkIISR__ (1985-01) Improved graphics again.

Specs:
- CPU: μPD780C-1 (Z80 clone), 4 MHz.
- Memory: 16/32 KB, VRAM separate
- Video: μPD2301, b/w composite, RGBI. Programmable CRTC; 4K VRAM (mkII: 32K).
- Text: 40×20/8, 80×25/8; graphics can be intermixed.
- Graphics: 160x100/8, 4×2 pixels per character cell; one colour per cell.
  (mkII: add 320x200/4.)
- BASIC: N-BASIC, variant of MS Disk Basic 4.51
- TOD clock (access w/`TIME$` in BASIC)

Documentation:
- [Byte Magazine review][byte], Jan. 1981. w/block diagram, chip names.
- [パソコンPCシリーズ 8001 6001 ハンドブック][asahi], covers BASIC, machine
  language, hardware details, etc.
- [Enri's PC-8001 page][enri]:
- [sbeach.seesaa.net] is the blog for a project to create the PC-6001F, an
  FPGA clone of the 6001. It has articles with extensive information on
  many aspects of PC-6000/PC-8000 hardware and software.
- [electric.com][er] has many posts on various PC-8001 topics.


Connector Pinouts
-----------------

See [DIN Connectors](../hw/din-connector.md) for pin numbering details.

#### RGBI (8-pin 270° DIN)

RGB connector, from Nishida Radio [デジタル RGB コンポーネント・アダプタ
][nr-drgb] and [PC-8001用RGBケーブルを作成してみよう！！ ][hkjunk0], which
also seems to contain information on converting it (via passive parts only)
to analogue RGB. (WARNING: This pinout needs to be confirmed on the
hardware; Nishida Radio claims the same pinout for the PC-8801mkII and
first-gen FM-7, but [Leaded Solder][ls-pc88cv] has a PC-8801mkII pinout
with green/red swapped and +12V on pin 3.)

    ＃      PC-8001mkII     備考
    1       VCC (12V?)      N/C
    2       GND
    3       Clock(14MHz)    N/C
    4       HSync           水平同期信号 (TTL or video level?)
    5       VSync           垂直同期信号 (TTL or video level?)
    6       Red
    7       Green
    8       Blue
    GND     GND             外周のシールド

Roughly, the passive conversion described above and in
[X1のデジタルRGB出力をSONYのTVのAVマルチ入力端子につなぐ実験][kenko858] is:
- To get composite sync, run hsync and vsync each into a 1N4148, tie the
  ouputs together with a 200Ω pulldown. 330Ω works too.
- Run R, G, B through 150Ω resistors, per [x1/rgb21]?

See also [RGBコンバータ(11)][sb-rgb11] (and updates [here][sb-rgb13] for an
FPGA-based RGB converter project.

#### B/W Composite (5-pin 180° DIN)

From my testing, pin 2 is ground and pin 3 is composite output. Others
were not clear.

The [Byte review][byte] claims that the 5-pin connector provides +12V.

#### CMT/Cassette (8-pin 270° DIN)

600 bps FSK Kansas City (1200/2400 Hz).

Motor relay included. (Toggle w/`MOTOR` in Basic.)

This pinout from [Enri's PC-8001][enri]:

    1   GND
    2   GND           Signal ground
    3   GND
    4   CMTOUT  out   Cassette record (red)
    5   CMTOUT  in    Cassette playback (white)
    6   REM+    out   Remote signal (black)
    7   REM-    out   Remote signal (black)
    8   GND           Signal ground

The pinout for the PC-6001mkII in [NEC PC-6001mkII 取扱説明書][pc6001]
is the same except:

    1   CMT1    out   Cassette control signal 1
    3   CMT2    out   Cassette control signal 2

PC-8801 pins 1 and 3 are `VCC` and `/ INT5`.

#### Floppy Disk

- [Hardware interface and commands](floppyif.md).
- [Disk data format](floppy.md).

#### Expansion Cards

The pinout is documented at [【コネクタ】 PC-8001,PC-8801シリーズ
拡張スロット][er519]. It varies slightly between the PC-8012 expansion
unit, PC-8001mkII and PC-8801.

See [PC-8001mk2 拡張ボード][er78] for an example of a homebrew
expansion card on protoboard adding a parallel port, ROM writer and FM
sound generator.


Character Set and Colors
------------------------

![NEC PC-8001 character set][chars]

RGBI colors (0-7): black, blue, red, magenta, green, cyan, yellow, white.

B/W composite output colors are:
- Bit 0: 0 = visibile, 1 = invisible.
- Bit 1: 0 = no flash, 1 = flash.
- Bit 2: 0 = normal, 1 = reverse.


Memory Map
----------

    $c000-$ffff 16K   Standard RAM
    $8000-$bfff 16K   Expansion RAM
    $6000-$7fff  8K   Available for expansion ROM
    $0000-$5fff 24K   BASIC

    $f300-$feb8       Screen memory (see Byte article)

The PC-8011 memory expansion unit can replace the lower 32K w/RAM.


Machine-language Monitor
------------------------

Enter from Basic with `MON` command. Prompt is `*`.

- `Dx,y`: Display bytes at addrs _x_ (def. 0) to _y_ (def. x+$10).
- `Sx`: Display byte at _x_ and prompt for new value;
  continue with next addr until no value entered.
- `G x`: Goto addr _x_.
- `W x, y`: Write tape block from _x_ to _y_.
- `L`: Load tape block.
- `LV`: Load tape block and verify it's correctly loaded.
- `TM`: Test memory and return to Basic.
- Ctrl-B: Return to Basic.


BASIC
-----

`Esc` pauses listings, program operation, etc. (Works in monitor, too.)

#### Extensions

- `BEEP`: Short beep; add `1` to turn on, `0` to turn off.
- `HEX$(n)`
- `MON`: Enter monitor.
- `MOTOR`: Toggle cassette motor relay. Add `1` to turn on, `0` to turn off.
- `STRING$(n,c)`: _n_ copies of character code _c_.
- `SWAP`: Exchange values of two vars.
- `TERM`: Act as terminal via RS-232.

Untested/unresearched:
- `CMD ...`: ???
- `IN p`,`OUT p,x`: Peek/poke for I/O ports.

#### Text/Graphics

Also see Table 2 (p.80) in [Byte] for summary and [asahi] for more details.

- `WIDTH h,v`: _h_ = 80, 72, 40, 36; 72 and 36 are same char cell size as
  80 and 24, with narrower lines. Optional _v_ = 25, 20.
- `LOCATE x,y`
- `PSET x,y`, `PRESET x,y`: Draws dot at _x_, _y_.
- `LINE x₀,y₀-x₁,y₁, "char", color, b, f`. _b_ if present is block, _f_ if
  present is fill.
- `GET @x₀,y₀-x₁,y₁, arr`: Store chars from screen into array _arr_.
- `PUT @x₀,y₀-x₁,y₁, arr`: Put chars from array _arr_ onto screen.



<!-------------------------------------------------------------------->
[asahi]: https://archive.org/details/PC8001600100160011982
[byte]: https://tech-insider.org/personal-computers/research/acrobat/8101.pdf
[enri]: http://www43.tok2.com/home/cmpslv/Pc80/EnrPc.htm
[er]: https://electrelic.com/
[retropc.net/404]: http://www.retropc.net/mm/archives/404
[sbeach.seesaa.net]: http://sbeach.seesaa.net/

<!-- Connector Pinouts -->
[er519]: https://electrelic.com/electrelic/node/519
[er78]: https://electrelic.com/electrelic/node/78
[hkjunk0]: https://hkjunk0.com/computer/hardware-and-maintenance/pc8001-rgb-output.html
[kenko858]: http://kenko858.blog.fc2.com/blog-entry-4.html
[ls-pc88cv]: https://www.leadedsolder.com/2018/09/24/pc88-colour-video.html
[nr-drgb]: http://tulip-house.ddo.jp/DIGITAL/DIGITAL_RGB_COMPONENT/
[pc6001]: https://archive.org/details/PC6001mkII
[sb-rgb11]: http://sbeach.seesaa.net/article/450572908.html
[sb-rgb13]: http://sbeach.seesaa.net/article/450981469.html
[we-pc8000]: https://en.wikipedia.org/wiki/PC-8000_series
[wj-pc8000]: https://ja.wikipedia.org/wiki/PC-8000シリーズ
[x1/rgb21]: http://www.retropc.net/mm/x1/rgb21/index.html

[chars]: https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/PC-8001_character_set.png/330px-PC-8001_character_set.png
