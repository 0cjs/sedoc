ImageMagick
===========

`display` and `convert`/`mogrify` are the primary programs for displaying
and transforming images.

`import` captures from the screen:

    import my-image.png     # Click and release to capture window contents.
                            # Click and drag to capture the area of a screen.

    import -window root screen.png  # Full screen capture

display Keyboard Shortcuts
--------------------------

Left mouse button turns menu on/off.

- Navigation:
  - space/backspace: next/prev; can prefix with number
  - `^Q`: quit
  - `^D`: delete file
  - `^S`: save
  - `Cmd-A`: Make image changes permanent (save in file?)

- Manipulation:
  - `^X`, `^C`, `^V`: cut/copy/paste
  - `C`, `[`: cut rectangular region, chop
  - `^Z`, `^R`: undo/redo
  - `<`, `-`, `>`, `%`: half/original/double/set size (`Alt-A` allows save)
  - `H`, `V`: horizontal/vertical flip
  - `/`, `\`, backtick:  clockwise/widdershins/specify rotate
  - `S`, `R`, `T`: shear, roll, trim edges
  - Various contrast/color/etc manipulations available


Resizing an Image
-----------------

See [examples here][im-resize].

    convert foo.jpg -resize 50% foo-small.jpg



<!-------------------------------------------------------------------->
[im-resize]: https://www.imagemagick.org/Usage/resize/
