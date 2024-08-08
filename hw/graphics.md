Graphics Card Information
=========================

- kG3D: G3D (in thousands) from [Passmark].
- Date: year and quarter
- GB: Standard mem configs
- Prices from Amazon.co.jp as of 2018-07 or 2017-11.
  Price is for most appropriate memory config, e.g., 4 GB for 1050
- †=integrated graphics

To-do: 7945HX

| Model                 | kG3D | Date | TDP  |  GB | ¥1000 | Comment
|-----------------------|-----:|------|-----:|----:|------:|-------------------
| GeForce RTX 4080      | 34.6 | 22.4 | 320W |  16 |  170+ |
| GeForce RTX 3070      | 22.4 | 20.4 | 220W |   8 |   65+ |
| GeForce RTX 3060      | 17.0 | 21.1 | 170W |  12 |   30+ |
| GeForce GTX 1080 Ti   | 13.6 |      |      |     |   90+ |
| GeForce GTX 1070 Ti   | 12.5 |      |      |     |   68+ |
| GeForce GTX 1080      | 12.0 |      |      |     | 64-80 |
| GeForce GTX 980  Ti   | 11.3 |      |      |     |   47  |
| GeForce GTX 1070      | 11.1 | 16.2 | 150W |     | 49-60 |
| GeForce GTX 980       |  9.6 |      |      |     |       |
| GeForce GTX 1060      |  8.9 | 16.2 | 120W | 3,6 | 30-40 | 3G ver. a few K cheaper
| GeForce GTX 970       |  9.6 | 14.2 | 145W |   4 |    19 |
| Radeon RX 580         |  8.4 | 17.2 | 185W | 4,8 | 24-32 |
| GeForce GTX 1050 Ti   |  5.8 | 16.4 |  75W |   4 |    20 |
| GeForce GTX 960       |  5.8 |      |      |     |       |
| GeForce GTX 980M      |  5.7 |      |      |     |       |
| GeForce GTX 1050      |  4.5 | 16.4 |  75W |     |    20 |
| Radeon HD 7870        |  4.4 | 12.2 | 175W |   2 |       |
| †Ryzen 9 7950X        |  4.1 | 22.4 |      |     |       |
| GeForce GTX 970M      |  3.9 |      |      |     |       |
| GeForce GTX 960M      |  2.1 |      |      |     |       |
| GeForce GT  1030      |  2.2 | 17.2 |  30W |   2 |    12 |
| GeForce GTX 560 SE    |  2.2 | 12.2 | 150W |   1 |       |
| Iris Plus 640         |  1.4 | 17.1 |   0W |     |     0 |
| GeForce GT   710      |  0.7 | 14.2 |  25W |     |     3 |

PCEe x1 cards are rare, but there is a [PCIe x1 GT 710].

[Passmark]: https://www.videocardbenchmark.net/gpu_list.php
[PCIe x1 GT 710]: http://kakaku.com/item/K0000872584


Cable and Adapter Notes
-----------------------

### HDMI Cables

[HDMI] cables can be tested at an Authorized Testing Center (ATC) for one
of [three compliance levels][se-400122], measured in bandwidth per channel.
The level names at the right are the only valid designations; advertising
an HDMI version number for a cable is [explicitly non-compliant][hdmi-usage].

          Pixel        B/W Cable
    HDMI Clk.MHz  Chan GHz  Cat.  Level
    ──────────────────────────────────────────────────────────────
    1.4   148.5   3 ×  3.4   2    High Speed HDMI cable
    2.0   296     3 ×  6.0   2    Premium High Speed HDMI cable
    2.1   594     4 × 12.0   3    Ultra High Speed HDMI cable
                                  (no cert. avail as of 2018-08)

References:
- [Blue Jeans Cable]. Much more useful information.
- [CabletimeTech].

### DisplayPort to HDMI Adapters

Dual-mode (passive) adapters adapters rely on the video source to be able
to generate HDMI on the DP output. There are two types of passive adapters
([[elce2017]] p.18):
- Type 1: 165 Mhz. Totally passive design? No adapter registers.
- Type 2: 300 Mhz. Has adapter registers with the adapter revision.

The Linux Intel GPU driver checks the adapter type and, unless a Type 2
adapter is detected, disallows pixel frequencies >165 MHz. Windows and Mac
don't care.

References:
- Verkuil, [HDMI 4k Video: Lessons Learned][elce2017].


### Monitors

Eletoker 1600XT-S: 16" 16:10 2560×1600 portable display
- <http://eletoker.com/> (no manual online); <yatuservice@outlook.com>
- Size: 355 × 233 × 10 mm, 674 g. Cover ~400g.
- Power (USB): 5 VDC, 3 A max
- Display: 2560×1600 native; IPS; 344.67 × 215.42 mm
  - 178° viewing angle. 5 ms. 300 cd/m² 1000:1 contrast.
- Inputs: mini-HDMI, USB-C ×2 (power and video)
- Sound: 2× internal 2W speakers; 3.5mm stereo headphone jack



<!-------------------------------------------------------------------->
[Blue Jeans Cable]: https://www.bluejeanscable.com/articles/bad-reasons-to-upgrade-hdmi-cable.htm
[CabletimeTech]: https://www.cabletimetech.com/technology/hdmi-technology/
[HDMI]: https://www.hdmi.org/
[elce2017]: https://events.static.linuxfound.org/sites/events/files/slides/elce2017.pdf
[hdmi-usage]: https://www.hdmi.org/pdf/atlug_faqs/2011_12_20_ATLUG_Q09_UPDATE.PDF
[se-400122]: https://electronics.stackexchange.com/a/400122/15390
