ANSI Terminal Escape Codes
==============================

These are also known as VT100, VT220, etc. codes.

Escape Code References
----------------------

* [Wikipedia: ANSI escape code](https://en.wikipedia.org/wiki/ANSI_escape_code)
* [termsys vtansi](http://www.termsys.demon.co.uk/vtansi.htm)
* [so-4842424](https://stackoverflow.com/q/4842424/107294)
* [XTerm Control Sequences](https://invisible-island.net/xterm/ctlseqs/ctlseqs.html)


Misc. Notes
-----------

`tput` is used to initalize a terminal or query the terminal database.
It will sometimes read information from the terminal driver, as with
`tput columns` and `tput lines`.

[wsize][] ([source code][wsize-source]) by Steve Friedl will query an
ANSI terminal for its size and print it out in `LINES=27 COLUMNS=132`
format.


[wsize]: http://unixwiz.net/techtips/windowsize.html
[wsize-source]: http://unixwiz.net/techtips/wsize.c
