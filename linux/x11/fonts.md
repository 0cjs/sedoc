X11 Fonts
=========

Libraries
---------

* [FreeType][] is a library to render (rasterize) fonts into bitmaps.
  It supports various formats, including TrueType, Type1 and OpenType.
  It's widely used with many media, including Linux/X11 systems,
  Android, ChromeOS, and Ghostscript.
* [Fontconfig][] reads font files, stores information about them, and
  finds fonts matching patterns based on that information.
* [Xft][] uses FreeType and Fontconfig to find and read fonts and
  render them on X11 servers. If X Rendering Extension is not
  available you may want to disable anti-aliased rendering for speed.
  (See if a program uses Xft with `ldd` and look for `libXft.so.2`.)
* [Pango][] is another text rendering library (now mainted by the
  Gnome project) used by GTK+ and Firefox.

### Fontconfig

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

### Pango

The `libpango1.0-dev` package includes a `pango-view` command line
utility to render text. Note that the [font description][pango-fontdesc]
is different from that for Fontconfig and Xft.

    pango-view --font='Source Code Pro italic 9' --text 'Hello' &


Preferred Fonts
---------------

`bin/update-fonts` from [desktop-utils] installs the important stuff.

* Adobe [Source Code Pro][scp]:  
  - Open source monospaced sans-serif that I use in urxvt.
  - Stroked font only; no bitmap support. Looks poor (too "thick") at
    low res.
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

* [UbuntuMono](https://design.ubuntu.com/font/) seems good at small
  sizes but very poor at larger ones.


urxvt Font Notes
----------------

[rxvt-unicode], usually known as `urxvt`, uses the `Xft` library.

Fonts are set via command line or `Rxvt.font:` in `.Xresources`. [Font
declarations][urxvt-fontdec] can be X11 core fonts or Xft/Fontconfig.
* `-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso10646-1`
  is an example of an X11 core font. The easiest way to look these up
  is via `xfontsel`. The aliases in `/usr/share/fonts/X11/misc/fonts.alias`
  are use iso885901, not Unicode, and so probably should be avoided.
* `xft:Source Code Pro:size=10` is an Xft font.

When using the [font-size extension][urxvt-fontsize]
(`.urxvt/ext/font-size`), `Ctrl-?` will display the current fonts in
use. That extension uses the `ESC ] 710;Pt ST` (711/712/713 for
bold/italic/bold-italic) sequence to change fonts; do this by hand
with, e.g.,

    echo -e "\033]710;xft:Source Code Pro Light:size=10:embolden\033\\"

Source Code Pro 9pt at 120 DPI gives 106 line `urxvt` terminals on a
4K monitor. If the width is wrong, this is maybe an issue with
`Rxvt.letterSpace` where 1.5 seems normal but sometimes it needs to be 2:

    echo 'Rxvt.letterSpace: -2' | xrdb -merge

Be careful that narrowing it too much for certain fonts may break
display of special full-cell characters such as the Braille ones used
in `htop` graphs.

Also see [so-118641], `man 7 urxvt`, [urxvt-archwiki], [urxvt-archwikitips].

#### Character Width Problems

The 'looks like it's using double-width' problem may be the one
[described on Reddit][r/urxvt-glyphs] with a patch available there.
Alternatively, it seems to happen when only one font is selected and
fallback is a bitmap font; maybe just set better fallback fonts?

See:
- [Ubuntu bug 309792](https://bugs.launchpad.net/ubuntu/+source/rxvt-unicode/+bug/309792)



[Fontconfig]: https://freedesktop.org/wiki/Software/fontconfig/
[FreeType]: https://en.wikipedia.org/wiki/FreeType
[Pango]: https://en.wikipedia.org/wiki/Pango
[Xft]: https://freedesktop.org/wiki/Software/Xft/
[desktop-utils]: https://github.com/0cjs/desktop-utils
[fc-user]: https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
[pango-fontdesc]: https://developer.gnome.org/pygtk/stable/class-pangofontdescription.html
[r/urxvt-glyphs]: https://www.reddit.com/r/urxvt/comments/5nshat/glyphs_yes_again/
[rxvt-unicode]: http://software.schmorp.de/pkg/rxvt-unicode.html
[scp-releases]: https://github.com/adobe-fonts/source-code-pro/releases
[scp]: https://en.wikipedia.org/wiki/Source_Code_Pro
[so-118641]: https://unix.stackexchange.com/q/118641/10489
[urxvt-archwiki]: https://wiki.archlinux.org/index.php/Rxvt-unicode
[urxvt-archwikitips]: https://wiki.archlinux.org/index.php/Rxvt-unicode/Tips_and_tricks
[urxvt-fontdec]: https://wiki.archlinux.org/index.php/Rxvt-unicode#Font_declaration_methods
[urxvt-fontsize]: https://github.com/majutsushi/urxvt-font-size
