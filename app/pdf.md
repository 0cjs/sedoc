Linux PDF Viewers and Tools
===========================

Viewers
-------

- `zathura`: Vi-style user interface. Needs more development, but
  what's there works well.


Editors
-------

- [`pdfarranger`]: Simple python-gtk program to let you add (merge), remove
  and re-arrange pages to create a new PDF document from existing ones.
  - This is a fork of the older `pdfshuffler`; Debian still has both
    package names but `pdfshuffler` is a backward-compat name for
    `pdfarranger`.
  - There is a Windows version as well.

Also see [JakeLittle's post][jakelittle] discussing the Linux
toolchain he uses for PDF editing (pdftk, qpdf, pdfbeads, pdftotext,
pdfimages, ImageMagick, ScanTailor).


Web-based
---------

- <https://pdfresizer.com>: Merge, split, resize, convert, crop,
  rotate, optimize, reorder, delete pages. For some reason the
  multipage/N-up tool isn't linked from the top page, but is at
  <https://pdfresizer.com/multipage>.


Page Numbering
--------------

- PDF page renumbering
- tools (move to above): pdftk, qpdf
- `/PageLabels`, [Page Number
  Format](https://www.w3.org/WAI/WCAG21/Techniques/pdf/PDF17))



<!-------------------------------------------------------------------->
[`pdfarranger`]: https://github.com/jeromerobert/pdfarranger
[jakelittle]: http://forum.6502.org/viewtopic.php?f=4&t=5952#p73594
