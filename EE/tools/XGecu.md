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
- `curl -LO` [setupapi.dll][] (info/source [here][setupapi]]) and copy it
  to the installation folder. Check with `file` to ensure it's a ELF shared
  object. (If it doesn't load when XGPro starts, you have a bad file.)
- Create `/etc/udev/rules.d/50-xgpro.rules` with `SUBSYSTEM=="usb",
  ATTR{idVendor}=="a466", ATTR{idProduct}=="0a53", GROUP="plugdev",
  MODE="0660"`. (Ensure you're in plugdev group, or use mode 0666, or
  whatever.
- Reload with `udevadm trigger`. (Not required to replug programmer.) Can
  check w/`lsusb` to find bus and device, and `ls -l /dev/bus/usb/…`.

There are notes on the software at [[winehq]], and installation guides
at [[dirksan28]], [[spun]], [[seeu]], etc..



<!-------------------------------------------------------------------->
[radiomanV/TL866]: https://github.com/radiomanV/TL866/
[setupapi.dll]: https://github.com/radiomanV/TL866/raw/refs/heads/master/wine/setupapi.dll
[setupapi]: https://github.com/radiomanV/TL866/tree/master/wine
[sw-en]: http://www.xgecu.com/EN/download.html?refreshed=1738998475737

[dirksan28]: https://gist.github.com/dirksan28/6abc71d676466cd3379e9ad098c46486
[seeu]: https://systemembedded.eu/viewtopic.php?t=44
[spun]: https://spun.io/2018/07/04/using-the-xgecu-tl866ii-plus-under-linux-with-wine/
[winehq]: https://appdb.winehq.org/objectManager.php?sClass=version&iId=38538
