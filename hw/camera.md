Camera and Photography Notes
============================

Google Photos
-------------

Three storage options ([settings][gpset]). (There seems [no way to tell][gp
8486259] which option is being used for an item, though you can get an
[overview of all storage use][gpstor].)
- "Original." Uses account storage. Photos/videos not modified.
- "High quality." Unlimited free storage. JPEG-only? Photos ≤ 16 MP and
  videos ≤ 1080p  not modified; larger sizes will be resized down.
  (Captions and other info may be lost.)
- "Express Backup." Like HQ, but 3MP/480p, for faster backup over wireless.

The [settings][gpset] menu also offers a "Recover Storage" button if you
have photos stored as "Original"; this will convert them to "High quality."
(It doesn't tell you what it will convert, or if any of the photos need
conversion at all, though it does tell you how much storage you will save.)

[gpset]: https://photos.google.com/settings
[gp 8486259]: https://support.google.com/photos/thread/8486259?msgid=8533938
[gpstor]: https://drive.google.com/settings/storage


Panasonic DMC-GF1
-----------------

Page numbers are from [the manual][dmc-gf1-man] ([alternate][dmc-gf1-ae]).

Notes:
- Proprietary USB cable and composite cable included. HDMI mini cable
  is an option.
- Max card size is SDHC 32 GB.
- Firmware at v1.2 ([latest][dmc-fw]) but JP model apparently has no
  language switching.
- 14-45/F3.5-5.6 supports direction (vert/horiz) function; 20mm/F1.7
  doesn't. See "Rotate Disp." (p.144)

Terminology and Controls:
- SB: Shutter button. MB: Motion picture button (red, beside shutter).

Menus:
- Top level on left icons (p.27): Rec (p.115), Motion Picture (p.125),
  Custom (p.126), Setup (p.31), MY (menus for last five setting
  changes), Playback (p.134).
- Settings under Custom» can be registered to C1/C2₁₂₃ mode settings.
  - But some others, too? E.g, Record»Self-timer.
  - Settings changed in C1/C2 still must be registered to stick.
- Q.Menu button brings up a more limited set of menus over viewfinder
  display; varies based on mode. Arrows or dial selects; close
  w/Q.Menu or Half-SB.

General Photography Controls:
- __Mode dial__
  - iA: Intelligent Auto (p.41): Avoid! (Except maybe for video?)
  - P,A,S,M: Program AE, Aperture prio, Shutter prio, Manual. (p.41)
  - movieP: Motion Picture P mode. (p.104)
  - C1,C2₁₂₃: Custom modes (see above). C2₁₂₃ submenus give quickref screen.
  - SCN,pallette: Scene (p.89), My Color (p.94)
- __Rear Dial__: Controls shutter/aperture or exposure compensation;
  press in to switch. Exposure comp. also available in quick menu
  (bigger, faster setting w/up-down keys).

Focus:
- __AF/MF button__ (p.46) sets:
  - __AFS__ Auto Focus Single. Half-depressing SB fixes focus for next
    frame (all frames in burst mode).
  - __AFC__ Auto Focus Continuous. (Not all lenses.) Half- SB refocuses
    continuously.

Video:
- VIERA Link controls playback via HDMI cable. (p.151)

Image management:
- Setup»Auto-Review: after taking pic, show:
  - normal for 0-5s followed by zoom for 0-5s, any control aborts.
  - "hold" goes into playback mode.
  - In autoreview, oversaturated areas blink.
- In playback mode dial zooms, menu unzooms then goes to menus.
- Pics can be marked with Playback»Favorite menu; marking a few allows
  »»Delete All to delete all not marked.

Remote shutter:
- [Schematic and details][dmc-rem-sch 1], [alternate][dmc-rem-sch 2].
  2.5mm TRSM connector; camera supplies 3.1 V on M, expects resistors:
  `M=3.1V ── 36k ── 2k9 ── 2k2 ── S`. Short 36K out of circuit for
  focus pushbutton, additionally short 3K out for shutter button.
  Close values, e.g. 3k3 for 2k9, also work.

[dmc-fw]: https://av.jpn.support.panasonic.com/support/global/cs/dsc/download/index.html
[dmc-gf1-ae]: http://panasonic.ae/en/manuals/DMC-GF1%20%281-80%29.pdf
[dmc-gf1-man]: https://www.panasonic.com/au/support/manual-download/imaging/lumix-g-cameras/dmc-gf1.html
[dmc-rem-sch 1]: http://www.doc-diy.net/photo/remote_pinout/#lumix
[dmc-rem-sch 2]: https://www.robotroom.com/Macro-Photography-2.html
