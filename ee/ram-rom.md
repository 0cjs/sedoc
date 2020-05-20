RAM/ROM/etc. Pinouts, Specs
===========================

JEDEC (I think) pinouts, from Ciarcia, "Build an Intelligent Serial
EPROM Programmer," _BYTE_ Oct. 1986, [p.106][byte-8610-106].

        O̅E̅+ = O̅E̅/Vpp

    '512 '256 '128  '64 '32A  '16           '16 '32A  '64 '128 '256 '512
                                  ┌───∪───┐
     A15  Vpp  Vpp  Vpp           │1    28│           Vcc  Vcc  Vcc  Vcc
     A12  A12  A12  A12           │2    27│           P̅G̅M̅  P̅G̅M̅  A14  A14
     A7   A7   A7   A7   A7   A7  │3    26│ Vcc  Vcc  N/C  A13  A13  A13
     A6   A6   A6   A6   A6   A6  │4    25│  A8   A8   A8   A8   A8   A8
     A5   A5   A5   A5   A5   A5  │5    24│  A9   A9   A9   A9   A9   A9
     A4   A4   A4   A4   A4   A4  │6    23│ Vpp  A11  A11  A11  A11  A11
     A3   A3   A3   A3   A3   A3  │7    22│  O̅E̅  O̅E̅+   O̅E̅   O̅E̅   O̅E̅  O̅E̅+
     A2   A2   A2   A2   A2   A2  │8    21│ A10  A10  A10  A10  A10  A10
     A1   A1   A1   A1   A1   A1  │9    20│  C̅E̅   C̅E̅   C̅E̅   C̅E̅   C̅E̅   C̅E̅
     A0   A0   A0   A0   A0   A0  │10   19│  D7   D7   D7   D7   D7   D7
     D0   D0   D0   D0   D0   D0  │11   18│  D6   D6   D6   D6   D6   D6
     D1   D1   D1   D1   D1   D1  │12   17│  D5   D5   D5   D5   D5   D5
     D2   D2   D2   D2   D2   D2  │13   16│  D4   D4   D4   D4   D4   D4
     GND  GND  GND  GND  GND  GND │14   15│  D3   D3   D3   D3   D3   D3
                                  └───────┘
    '512 '256 '128  '64 '32A  '16           '16 '32A  '64 '128 '256 '512

Amtel AT28C devices, from data sheets.
Two pins, marked with `●`, are different from JEDEC.

                                  ┌───∪───┐
                             ●A14 │1    28│ Vcc
                              A12 │2    27│  W̅E̅●
                              A7  │3    26│ A13
                              A6  │4    25│  A8
                              A5  │5    24│  A9
                              A4  │6    23│ A11
                              A3  │7    22│  O̅E̅
                              A2  │8    21│ A10
                              A1  │9    20│  C̅E̅
                              A0  │10   19│  D7
                              D0  │11   18│  D6
                              D1  │12   17│  D5
                              D2  │13   16│  D4
                              GND │14   15│  D3
                                  └───────┘


Data Sheets
-----------

- Microchip [27C256]
- Catalyst Semiconductor [CAT28F512]; 12 V programming/erase
- Amtel [AT28C256]; 5 V programming/erase


<!-------------------------------------------------------------------->
[byte-8610-106]: https://archive.org/details/byte-magazine-1986-10/page/n117/mode/1up

[27C256]: http://esd.cs.ucr.edu/webres/27c256.pdf
[AT28C256]: http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf
[CAT28F512]: https://datasheet.octopart.com/CAT28F512PI-90-Catalyst-Semiconductor-datasheet-1983.pdf
