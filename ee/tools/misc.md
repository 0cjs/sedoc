Misc. EE Tools
==============

### [Adjustible Constant Current Electronic Load][ali-ccload].

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


<!-------------------------------------------------------------------->
[ali-ccload]: https://www.aliexpress.com/item/32821877897.html
