Apple II BASICs
===============

- [[as78]] _Applesoft BASIC Programming Reference Manual_, Apple, 1978.
- [[as77]] _Applesoft BASIC Extended Precision Floating Point BASIC
  Language Reference Manual [ Cassette - RAM Version ]_, Apple, 1977.
  Documents very old version of only historical interest.


Applesoft BASIC
---------------

High-resolution graphics:
- `HGR`, `HGR2`: Switch to high resolution graphics screen 1 or 2. Screen 1
  leaves 4 lines of text on the bottom; screen 2 does not. `POKE -16302,0`
  to switch screen 1 to full screen.
- `HCOLOR = n`: _n_ is 0-7 for:
  - black1, green, purple, white1, black2, orange, blue, white2.
- `HPLOT x,y`; `HPLOT TO x,y`, `HPLOT x₀,y₀ TO x₁,y₁ [TO x₂,y₂ ...]`:
  uses current HCOLOR setting. x=0-278; y=0-191.


<!-------------------------------------------------------------------->
[as77]: https://archive.org/details/applesoft_basic_language_reference_manual_1977/mode/1up?view=theater
[as78]: https://archive.org/details/Applesoft_BASIC_Programming_Reference_Manual_Apple_Computer/mode/1up?view=theater
