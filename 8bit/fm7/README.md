FM-7 and FM77 Information
=========================

Documentation
-------------

- [Retro PC Gallery (by はせりん)][haserin] has lots of great
  FM-8/FM-7/FM77 info: hardware, screenshots, software.


Expansion Connectors
--------------------

The connectors used for expansion cards are Fujitsu Component Connector
[FCN-360 series][fcn360]. (The size range is 8, 16, 24, 32, 40, 48, 56, 64,
and 80 pin.) The AU below indicates gold plating; the H is something to do
with cover or mating port. Those parts might be wrong.

- 32-pin (FM-7 I/O board): FCN-365P032-AU/H
- 40-pin (FM-7 Z80 board): FCN-365P040-AU/H

Sources:
- (2022-10) [RS Components Japan][rs]: only panel-mount
  [FCN-364P056-AU][rs56] ¥1,683.
- (2018?) [Mouser], ¥750 qty. 1. Not in stock for a long time now.

Since nobody can find 32-pin (or any PCB mount) any more, these pages show
you how to cut down a 56-pin panel mount and solder it to a right-angle .1"
header:
- [基板コネクタ　FCN-365P032　もう自作しちゃう？][kk 0bff17]
- [基板コネクタ　FCN-365P032　もう自作しちゃう？　その２][kk 772fd4]
- [FM-7 RS-232Cボードの組立　その１][kk 5773e8]
- [FM-7 RS-232Cボードの組立　その２][kk 7d9331]


RS-232 Serial
-------------

Ysflight.com has a [blog post][ys serial] with a serial card KiCAD
schematic and board layout and discussion of his work on it. It also
includes some hints on using it from BASIC with, e.g., `OPEN
"O",#1,"COM0:(F8N1)"` (19.2 kbps) etc.

In in particular, hey says that `POKE &hFD0C,5 : POKE &hFD0B,16 : EXEC
-512` will restart BASIC (-512 is the start of the Boot ROM) and after
about 30 seconds, "you can use the serial port from F-BASIC." It's not
clear if this means it runs on the serial port or that this is merely
needed for initialization. Ports $FD0C/D are not documented in the Sysref;
the data and status registers are $FD06 and $FD07.



<!-------------------------------------------------------------------->
[haserin]: http://haserin09.la.coocan.jp/index.html

[fcn360]: https://www.fujitsu.com/downloads/MICRO/fcl/connectors/fcn-360.pdf
[kk 0bff17]: http://kk.txt-nifty.com/retro/2022/04/post-0bff17.html
[kk 5773e8]: http://kk.txt-nifty.com/retro/2022/04/post-5773e8.html
[kk 772fd4]: http://kk.txt-nifty.com/retro/2022/04/post-772fd4.html
[kk 7d9331]: http://kk.txt-nifty.com/retro/2022/04/post-7d9331.html
[mouser]: https://www.mouser.com/ProductDetail/Fujitsu/FCN-365P032-AU?qs=PmsrIvV%2FzvfKbGjWKUmkZQ%3D%3D
[rs56]: https://jp.rs-online.com/web/p/pcb-headers/6020353
[rs]: https://jp.rs-online.com

[ys serial]: http://ysflight.in.coocan.jp/FM/fm7_rs232c/e.html
