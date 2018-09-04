X11 Fonts
=========


Fontconfig Library
------------------

* [The Fontconfig User Guide][fc-user]

#### Commands:

Commands that take a `--format` use formats as specified in the
`FcPatternFormat(3)` manpage and parsed by `fc-pattern`.

* `fc-list [-v] [pattern [element]]`
  - _pattern_ may be `:` to match everything
* `fc-match [-v] [-s] [pattern [element]]`
  - Like `fc-list`, but displays only best match
  - `-s` gives sorted list of best matches
  - `-a` gives sorted list without pruning

Font file reading:
* `fc-scan`: Scans a file or directory recursively, printing out infomation
  about the fonts in files.
* `fc-query`: Like `fc-scan`, but takes only an explicit list of filenames.
* `fc-cat`: Reads font cache information files. No `--format` option.

Command Hints/Samples:

    fc-list :spacing=100 family         # List monospaced families
    fc-scan -f '%{family}\n' .fonts/    # List families of all files under dir


Preferred Fonts
---------------

`bin/update-fonts` from [desktop-utils] installs the important stuff.

* Adobe [Source Code Pro][scp]:  
  - Open source monospaced sans-serif that I use in urxvt.
  - Stroked font only; no bitmap support. Looks poor (too "thick") at low res.
  - Download site is [releases][scp-releases], but easier is ???.

I am currently considering adding the following fonts:

* Noto Mono, from the Debian fonts-noto-mono package, is formerly
  known as Droid Mono.
  - The kanji in it doesn't seem to render well, though they are taken
    from Adobe Source fonts. For some reason the JP edition renders
    better but uses smaller box size?
  - Mono has a much smaller repertoirse than Noto Sans or Noto Serif
    (which aim to cover all living Unicode scripts) and so should
    probably use one of those as a fallback.

* [Fantasque](https://github.com/belluzj/fantasque-sans)

* [FiraCode](https://github.com/tonsky/FiraCode/wiki)
  (available in the `fonts-firacode` Debian package).


urxvt Display
-------------

Source Code Pro 9pt at 120 DPI gives 106 line `urxvt` terminals on a
4K monitor. If the width is wrong, this is maybe an issue with
`Rxvt.letterSpace` where 1.5 seems normal but sometimes it needs to be 2:

    echo 'Rxvt.letterSpace: -2' | xrdb -merge

Be careful that narrowing it too much for certain fonts may break
display of special full-cell characters such as the Braille ones used
in `htop` graphs.

Also see [so-118641].



[so-118641]: https://unix.stackexchange.com/q/118641/10489
[desktop-utils]: https://github.com/0cjs/desktop-utils
[fc-user]: https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
[scp-releases]: https://github.com/adobe-fonts/source-code-pro/releases
[scp]: https://en.wikipedia.org/wiki/Source_Code_Pro
