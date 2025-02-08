XGecu EEPROM Programmers
========================

Models:
- TL866II: old model, out of production.
- TL866II Plus: T48?
- T48: current base model.
  - USB ID `a466:0a53 Haikou Xingong Electronics Co.,Ltd TL866II Plus Device
    Programmer [MiniPRO]`
- T56: suports a few more modern devices

Software:
- [T48/T56/TL866II Plus Programmer Application Software][sw-en] (en, Windows).
- Minipro is native Linux command-line software.
- [radiomanV/TL866]: open source Linux software for TL866II.

Wine Setup
----------

The native Windows software, XGPro, works under Wine on Linux.
- It's 32-bit, so ensure you have 32- as well as 64-bit Wine installed.
  Remember to remove `~/.wine` after installing the 32-bit Wine.
- Extract the rar (Debian `unrar` package) to get a single setup program;
  run it under Wine. (32-bit, so install to `C:\Program Files (x86)\`.)
- "USB driver for Windows (DPInst.exe) does not execute on your current
  Operating System" is expected and can be ignored.
- Fetch [setupapi.dll][] (from radiomanV/TL866) and copy it to the
  installation folder.
- Create `/etc/udev/rules.d/50-xgpro.rules` with `SUBSYSTEM=="usb",
  ATTR{idVendor}=="a466", ATTR{idProduct}=="0a53", GROUP="plugdev",
  MODE="0660"`. (Ensure you're in plugdev group, or use mode 0666, or
  whatever.
- Reload with `udevadm trigger`. (Not required to replug programmer.) Can
  check w/`lsusb` to find bus and device, and `ls -l /dev/bus/usb/…`.

Other TL866II installation guides at: [[winehq]], [[spun]], [[seeu]].

#### Errors

Unfortunately, without setupapi.dll in that dir, XGecu can't connect to
the programmer. With it, I get:

    0024:err:module:import_dll Loading library SETUPAPI.dll (which is needed by L"C:\\Program Files\\XGPro\\Xgpro.exe") failed (error c000012f).
    0024:err:module:LdrInitializeThunk Importing dlls for L"C:\\Program Files\\XGPro\\Xgpro.exe" failed, status c0000135




<!-------------------------------------------------------------------->
[radiomanV/TL866]: https://github.com/radiomanV/TL866/
[sw-en]: http://www.xgecu.com/EN/download.html?refreshed=1738998475737

[seeu]: https://systemembedded.eu/viewtopic.php?t=44
[setupapi.dll]: https://github.com/radiomanV/TL866/blob/master/wine/TL866II/setupapi.dll
[spun]: https://spun.io/2018/07/04/using-the-xgecu-tl866ii-plus-under-linux-with-wine/
[winehq]: https://appdb.winehq.org/objectManager.php?sClass=version&iId=38538
