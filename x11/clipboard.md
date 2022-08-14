X11 Selections, Clipboards and Screenshots
==========================================

X11 Selections
--------------

There are three selections available in X11: XA_PRIMARY (middle-button
paste), XA_SECONDARY and XA_CLIPBOARD (Ctrl-V paste).
- `xsel` selection is chosen with `-p`/`--primary` (default),
  `-s`/`--secondary` or `-b`/`--clipbaord`.
- `xclip` selection is chosen with `-selection primary` (default),
  `-selection secondary` or `-selection clipboard`. These can be
  abbreviated to `-se c` etc.
- Vim uses registers `"*` for PRIMARY and `"+` for CLIPBOARD. Also see
  `:help "+` and [SE answers here][vise-84]. This requires `+clipboard`
  feature flag (test with `has('clipboard')`).

There are apparently two different versions of `xsel` with different
command-line arguments; thus `xclip` should be preferred.

### Data Formats and Target Atoms

For pasting other than text, a data format can be specified by using a
_target atom_ (ICCCM §2.6.2). `xsel` does not support this; `xclip` uses
the `-t`/`-target` option, e.g., `-t image/png`. In output mode the special
atom `TARGETS` will get a list of valid target atoms for the current
selection held by whatever program: `xclip -o -t TARGETS`.

### Selection Maintenance

Unlike Windows or Mac, selections in X11 are maintained by by individual
programs; other programs wanting to fetch the selection send a request
through the X11 server to the program currently maintaining the selection.
Thus, any program that captures a selection must continue running for the
selection to be available.

`xsel -i` does this by starting a background process to maintain the
selection; that process will exit when another program (including another
`xsel -i`) makes that selection available. The `-t MS` option will time out
the background process after _MS_ milliseconds (default 0 = never time
out).

`xclip -i` does the same. There is no timeout option, but with the
`-verbose` option it will run the server process in the foreground and show
when a selection request is received. (Exit with Ctrl-C.)


ImageMagick/GraphicsMagick
--------------------------

The `import` program will capture a screenshot.
- Single argument is a filename (type taken from extension) or `type:-` for
  standard output. (Type is `png`, `jpeg`, etc.)
- Brings up a cross cursor:
  - Click-drag-release to capture any arbitrary area of the screen.
  - Click-release to capture visible area of that window (not including
    title bar or other decorations).
- XXX other options to capture entire desktop, etc.: `man import`

The standard output of the above can be fed to `xclip` for pasting
into GUI programs:

    import  png:- | xclip -se c -t image/png  -i
    import jpeg:- | xclip -se c -t image/jpeg -i



<!-------------------------------------------------------------------->
[vise-84]: https://vi.stackexchange.com/q/84/15666
