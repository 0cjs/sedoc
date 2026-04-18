CZUR Scanning Software
======================

Latest version 2.2.230501.

CZUR comes with the czur.com Shine scanners, and possibly others.
- [Shine Ultra Pro][su] (1400A3 Pro) 24 MP Book Scanner (5686×4272)
- [Shine Ultra][su] 13 MP Book Scanner (4160×3120)


Usage
-----

CZUR doesn't have separate modes for documents, books, etc: the mode is
chosen per-page. For a book, choose "Flat Document" for the cover, then
switch to "Side by Side Page" for subsequent pages, going back to flat
for the back cover.

The Greyscale and B&W modes appear to be about the same, and along with
Auto Enhance and Color do extensive contrast processing that tends to
work poorly on old manuals. No Filter mode avoids all this processing
and is the best for old books.

The OCR seems a bit better than SCANLINE; it doesn't have the spaces
between Japanese characters that SCANLINE puts in. However, both seem to
drop a lot of characters, particularly 'の'.

### Technical Info / Hacking

Temp files are in `%APPDATA%\Roaming\ShineTemp\`. Under this directory:
- `base\`
- `base4imp\`
- `lines\`
- `manual\`
- `sources\`: Original images before processing.
- `thumbnail/`

Seems to clean this dir out on exit?


<!-------------------------------------------------------------------->
[su]: https://www.czur.com/product/shineultra
