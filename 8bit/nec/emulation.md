PC-8001/8801 Emulators
======================

- ePC-8801/mkII/MA, ePC-8001/mkII/SR from the 
  [Common Source Code Project][cscp]. These are Win32 only.
- [XM8]: Derived from ePC-8x01 above. Windows/Linux/MacOS/Android.
- MAME

MAME
----

Starting `mame` will bring up a selection window where you can search for
PC-8001 and get a start menu for it. Without proper configuration of ROMs
it will just give you a message that they are missing.

- `mame -ll` to list all "game" (system emulation) names.
- `mame -romident DIR`
- `mame -lr pc8001` to list internal hashes it wants for a system.
  (But it still says `BAD` and `BAD_DUMP` for the system ROMs!)

Options:
- `-rp PATHNAME`: list of paths to find ROM or HDD images.

https://docs.mamedev.org/usingmame/assetsearch.html



<!-------------------------------------------------------------------->
[XM8]: http://retropc.net/pi/xm8/
[cscp]: http://takeda-toshiya.my.coocan.jp/
