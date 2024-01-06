SCANLINE Scanning Software
==========================

The SCANLINE software (Windows-only) comes with iCODIS scanners, which
call it "CamShop" in the manual. The [Download page][x9-dl] leads to one
of:
- (previously) ZIP file on Dropbox. Use the Dropbox "Download" button to
  download  it,  unzip and run `setup.exe`. Latest version was v6.8.4.0.
- (now) .EXE file on Google Drive. Download and run to install. v7.0.7.

SCANLINE works with:
- iCODIS [Megascan Pro X9][x9-home] 21 MP Book Scanner (5312×3984)
- (others?)

Documentation:
- The manual is brought up through the Help menu, which will open
  `C:\Program Files (x86)\ScanLine\Documents\en-us.pdf` (`ja` and `zh` also
  available) in your PDF viewer.
- The [FAQ][x9-faq] online is oriented towards pre-purchase questions.


Usage
-----

__IMPORTANT:__
- Carefully check _all_ export settings before export; see notes below.

Bugs:
- Maximized mode breaks when task bar is at left and places the window
  under the task bar, leaving a blank space at the right. This can be
  worked around for the main window by not using it maximized, but pop-up
  windows (e.g., when double-clicking in the Book mode page list to see the
  scan) will always be maximized. Work around this by moving your task bar
  to the right side while using the software.
- Crashes noted below; some (all?) settings saved on exit not on crash.
- In PDF export pages are all different sizes depending on scan borders;
  don't know how to fix this.

Lighting:
- The manual claims you can touch the light icon at the tip of the arm to
  switch between four brightness levels. Mine has a manual switch and
  seemingly only one brightness level.

Modes are listed across the top where the menu bar would normally be:
- Book mode has curve fitting, etc.

Control areas are:
- __Settings__ Globe (language) and Gear (settings/help) icons in window
  title bar next to minimise/maximise/close.
- __Mode Bar__ (where menu bar normally is):
  - Modes: Document, Book, Barcode, Email, Photocopy, Video.
  - Book Mode for normal use (only one with curve fitting)
- __Left toolbar__ (narrow, small icons along entire left edge):
  - Rotate, +/- zoom only available in Document Mode.
  - Manual cropping only on covers in Book Mode.
  - 1:1 / Fit Srcreen button swaps between the two views.
- __Camera Controls__ (narrow bar along bottom of window)
  - Select device, format, camera resolution
  - Formats: MJPEG, YUV (uncompressed video)
  - Lower resolutions increase frame rate in video mode.
  - Zoom: 88% is full frame; automatically chosen in Book Mode.
- __Output__ (right side column)
  - Not original image storage; just for files created with Export button.
  - Output folder setting is remembered per-Mode
  - Thumbnail for each file in output directory; "Open Folder" button will
    bring up directory in File explorer.
  - Following settings in Top Bar apply to export:
    - Output Format (PDF, JPEG, etc.)
      - PDF (Searchable) files named with `_SCH` suffix
    - Language: only for formats including OCR (set this to language of
      what you're scanning; defaults to UI language). Japanese+English
      works well on computer books; haven't tried Japanese on them yet.
    - Prefix (filename prefix)
    - Named by (filename suffix): serial number (4-digit number of file
      written, continues across multiple exports) or `YYYYMMDD_HHMMSS`.
  - Right-click on item (or on selected set of items) brings up file
    management options.
    - "Compare" is an image viewer. 1, 2, 3, 4 or 6 panes up; each pane can
      display any one of the selected images; + button loads a new (or
      existing) image into a pane via load dialogue. The zoom setting is
      per-pane so you can see e.g., fit-to-pane in one pane and 1:1 of same
      image in another pane. Save button saves the current view of all
      panes as a single image.
    - "Convert to ..." options bring up File Conversion Tool (see below).

File Conversion Tool:
- Maximized window that's actual modal dialogue.
- Essentially same thing as Export button but lets you select individual
  files (JPEG, whatever), order them, add new ones via File Explorer
  dialogue, etc.
- Output Format, Language (for OCR), Save Path, filename can all be
  (re-)set separately in this window; defaults are from Top Bar.
- Including a PDF in the list of JPEGs crashed the program.

Export:
- Remember _always_ to check following dropdowns which easily default back
  to incorrect settings:
  - Output Format: "PDF (Searchable)" (defaults to "JPG")
  - Language: "Japanese+English" (defaults to "English")
- Must choose one of five modes when exporting a PDF:
  - "Do not merge (Flip right page) A←B". With cover, produced cover on left
    side followed by first page on right side in two-page-up mode. Inserting
    a blank page at start with `pdfarranger` makes 2-up left/right display
    correctly in Acroreader.
  - ✗ "Do not merge (Flip left page): "B→A": Starts PDF with LH page with
    cover, then totally blew up page order: (cover,title), (cover back,
    dedication), (cover verso, contents), ..., (4,7), (6,9), (8,11) etc.
  - ✗ "Merge left and right pages" should not be used for PDFs; it will make
    each page in the PDF contain two pages from the book.
  - ✗ "Export left pages only" and "Export right pages only" drop half the
    pages, as you might expect.
- Pages are all different sizes in PDF depending on scan borders; don't
  know how to fix this.

### Document Mode

"Auto Cropping (multiple objects)" will generate a separate image file for
each object it detects on the mat. Ensure one object is in centre of frame
or the image may be over-exposed.

### Book Mode

General:
- Pairs of pages are stored as a single image. (JPEGs are somewhere.)
- Settings in menu bar (edge fixing, finger hiding, Image Settings, etc.)
  determine scan processing; changing them in the Book Page Editor window
  will change these for future scans.

Image settings (dropdown in menu bar):
- B&W (Document): seems to use an edge following algorithm to move black
  specks in background and white specks along edges of characters.
- B&W (Binarized)
- B&W (Red Stamp): according to FAQ, fixes noise (black dots) and shadows.
- Color
- Color (Enhanced)
- Grayscale: seems to be best look for old books with faded and yellowing
  pages; removes the yellowing.

- LHS shows thumbnails of processed scans.
  - Front/back cover thumbnails are always present; click on one to scan
    the cover. (Image Settings greyed out; setting is always full color.)
    Click on it again to return to scanning new pages.
  - Up/down arrows move page pair in list; X deletes page pair image.
  - Double click on any pair to bring up Book Page Editor window (a full
    screen modal dialogue, apparently).

Book Page Editor:
- Far left has zoom settings for view.
- Left thumbnails are the split left and right parts of images. Click to
  view that page.
- Right bar shows:
  - Original image: click image or Edit button to view large and enter Edit
    mode. Original image includes a band of other page.
  - Scan settings: VERY BUGGY.
    - Settings are per-page, but what's displayed before and during edit is
      the last settings entered there, regardless of the current page's
      scan settings.
    - Apply button previews without saving and exits edit mode. To change
      preview, click edit again to be able to change settings again.
    - During Edit, originally displayed settings will not enable Apply/Save
      buttons, so you can't change page to those. __Workaround:__ Edit,
      change setting to one neither currently displayed nor actual current
      setting of page; click Save (Apply won't do it); displayed settings
      change to actual current page settings; Edit again.
  - Cropping: in curve fitting mode a series of points defines the curve.
    Double-click a point to remove it. Double-click on line to add a point.
    - Common issue is it detects edges of pages underneath as part of page.
      Just delete the last few points to fix this.

### Technical Info / Hacking

- "Export log" under the gear menu will drop a ZIP file in the selected
  directory that contains lots of useful internal info.
- Image files are named with version 4 (random) variant 1 (RFC 4122/DCE 1.1)
  UUIDs. `UUID` below is a placeholder for one of these.
- Some names are misspelled; sometimes (not always) `dispaly` for `display`.
- Work dir is:
  - `C:\Users\cjs\AppData\Local\Temp\SCANLINE\`
  - `/c/Users/cjs/AppData/Local/Temp/SCANLINE/`
- Under work dir are:
  - many images that appear to be small (300 pixel) versions of pages from
    scans; the UUIDs do not match any of the "real" scans.
  - `DevInfo.xml`: uninteresting; unused licensing file?
  - `Barcode/` `Book/` `Document/` `Email/` `Photocopy/` `Video/`
- Under `Book/`:
  - `src/UUID.jpg`: full original photo (unsplit)
  - `pages/UUID_{Left,Right}.jpg`: original photo left and right halves.
  - `dispaly/UUID_{Left,Right}.jpg`: also? original photo left and right
    halves?
  - `dispaly/UUID.jpg`: original photos for cover shots
  - `process/UUID_{Left,Right}.jpg`: processed scan left and right pages
  - `process/N.txt` where _N_ is a number starting at 1: contains a JSON
    document info for a pair of pages (source paths, cropping, scan settings,
    etc.)
  - Overall large in size (3 GB for 120 p. Fujitsu manual)
- Files in `SCANLNE/` left intact on exit; will be prompted "Do you want to
  restore" at next startup.
  - "No" will clear all files out, both top-level and under `Book/` etc.
  - Seems to be no way within program to archive this for later restore.
  - Can probably tar up entire `SCANLINE/` dir and save for later restore, but
    tarball must be kept outside of `SCANLINE/` or will be deleted with other
    stuff. Consider putting in Dropbox under `/b/bu/cbooks/scan/iCODIS X9/`.



<!-------------------------------------------------------------------->
[x9-home]: https://www.projecticodis.com/products/megascan-pro-x9-21-megapixels
[x9-dl]: https://www.projecticodis.com/pages/software
[x9-faq]: https://community.projecticodis.com/megascan-pro-x9-book-scanner-faq/
