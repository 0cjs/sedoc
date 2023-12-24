Misc. EE Tools
==============

Adjustible Constant Current Electronic Load
-------------------------------------------

[AliExpress page][ali-ccload].

Max load is 150 W.

Measures voltage, current, capacity (Ah), energy (Wh), time. Also
shows temperature and (on screen 3) load resistance. All stats and
settings (including threshold alarms) are kept across power-off. Time
clock stops when drawing < 20 mA or so.

Unit is powered by jacks on rear:
- 6-12 V on barrel connector, center-positive. (9 V 1 A adapter supplied.)
- 5 V on micro-USB. (May draw at least 0.8 A.)

Test inputs are on left side:
- "Multi-purpose USB port" (see below). Aligator clip adapter supplied.
- +/- (top/bot) screw terminals
- 5.5mm barrel connector, center positive. "DC 5.0 jack."
- Mini USB. Micro USB. Type C USB.

At upper left side is a "multi-purpose USB port" that can be used to
draw power for testing. Docs also say "by qualcomm quick charge
QC2.0/3.0 trigger etc."; perhaps it can fake some quick charge
protocols? Not seeing why this would be on an A connector.

Switch screens with a single click between:
1. Chinese.
2. English all text same size. "OFF" probably indicating alert status.
3. Large V/A across top.
4. Large V/A at left, w/current load resistance (Ω) display.
5. Backlight: 2click for on, 3click for 60s timeout.
6. through 9: Alarm screens.

Stats screen control button use:
- Hold >3 sec to reset all stats.
- On V/A/etc. display screens resets are quick clicks:
  2. Capacity (Ah)
  3. Energy (Wh)
  4. Time
- Five quick clicks sets timer for discharge alert.

On other screens:
- Double-click to increment and set direction to up.
- Triple-click to decrement and set direction to down.
- Hold to continue to increment/decrement in set direction.
- Wait 10 sec. to return to previous stats screen.

Alarm screens allow setting thresholds (kept across power-cycles).
When exceeded, load will stop drawing current, beep continously, and
display the threshold exceeded. Single button press will start load
again where it will run for 5 sec. or so before checking thresholds
again. Thresholds are:
- Overvoltage (max limit > 300 V).
- Undervoltage (min limit < 0.00 V). 0.1 V increments up to 30 V, 1 V
  increments thereafter.
- Current draw (max limit > 100 A).
- Power draw (max limit > 185 W).


Buck Converter in Plastic Case
------------------------------

[AliExpress page][bcpc] ($4.04)

- Input: 5-23 V, <20 V recommended.
- Output: 0-16.5 V; dropout 1 V
- Current: 0-3 A, ≤2 A recommended. <10 mA not displayed.
- Specs:
  - Efficiency: 95%
  - Regulation: ≤0.8% (voltage and load)
  - Size: 62 × 44 × 18 mm, 45 g

Calibration: with input power off, hold down left button and turn on input
power. Display will start flashing and 5 V will be output; use buttons to
set display voltage to match output voltage on multimeter.

Reads about 0.1 V low at 12 V output from 16 V input.


Sepic Power Supply XY-SEP4
--------------------------

[AliExpress page][XY-SEP4] (¥931).

- Input: 5-30 VDC
  - Min. 8 V for full output; 5 V gives about 15 W
  - LVP settable (default 4.7 V); disconnects output
- Output: 0.5-30 VDC, 0.0-4.0 A, 35 W or 50 W w/air cooling
- Accuracy: ±1%+1word @10 mV; ±1.5%+3words @1 mA
- Efficiency: ~88%
- Protection: input reverse, temp 100°C, user-settable
  - Protection display codes are `OEP` for internal protection and the
    shutoff menu items below.

Upper pot on side is voltage setting; lower pot is current limit setting.
Short output to set current limit.

Display interface (`V` appears as `U`):

    Key   Short Press               Long Press
     ▲    disp. V in/out            Calibration interface
     ▼    disp. A/W/Ah/Wh/time      Ah/Wh/time reset (individual per item)
    SET   (none)                    Shutoff menu
    PWR   output on/off (& timer?)  Set boot state (output on/off)

The shutoff menu is for settings that shut down output. As well as arrows,
`PWR` will change the range (9/99/etc.) or on/off for some settings. `SET`
moves to the next item; long press it to exit.
- `LVP` (4.70 V): minimum input voltage
- `OVP` (31 V): maximum output voltage
- `OCP` (4.1 A): maximum output current
- `OPP` (35 W): maximum output power
- `OAH` (-- Ah): maximum capacity
- `OPH` (-- Wh): maximum energy
- `OHP` (-- h): maximum time
- `DAT` (0): ???

The calibration interface appears to let you set what's displayed for the
current settings, e.g., change the value sensed for the current voltage
output. Long-press `SET` to exit.



<!-------------------------------------------------------------------->
[XY-SEP4]: https://www.aliexpress.com/item/1005001316643778.html
[ali-ccload]: https://www.aliexpress.com/item/32821877897.html
[bcpc]: https://www.aliexpress.com/item/32802079884.html
