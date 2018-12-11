NTT Hardware
============

NTT VH-100[4]E[S] VDSL Modem
----------------------------

Used for Mansion Fiber connectivity.
This information from the (Japanese) manual.

#### Status Lights (§2 p. 9)

Status lights, from top to bottom. Status "slow" is 1 Hz blink, "fast"
is much faster (often varying) blink.

| Lamp Name     | Color | Status| Meaning
|---------------|-------|-------|----------------------------------
| Power         | Green | On    | Power on
|               | -     | Off   | No power
| VDSL Link/Act | Green | On    | Link up, no data flowing
|               | Green | Fast  | Link up, data transfer
|               | Green | Slow  | Waiting/trying to establish connection
|               | -     | Off   | Waiting (DSL not plugged in?)
| LAN Link      | Green | On    | Link up
|               | -     | Off   | Link down (no cable?)
| LAN Act       | Green | On    | Data xfer (basically, flashes)
|               | -     | Off   | No data xfer
| Alarm         | Red   | On    | Failure (lights during power-on)
|               | -     | Off   | No failure

VDSL Link/Act also flashes when firmware is being written.

#### Back Ports (page 10)

Top to bottom:

* "Line" (VDSL)
* LAN (Ethernet)
* DC 12V

#### Installation

* Keep 5 cm free space above and on all four sides (excepting base) of
  product.
* Base may be a small edge or large side when wall-mounted.
* AC Adapter accepts 100V only.

#### Specs (§7 p. 23)

* Modem
  - Ethernet:   RJ-45, 10/100, auto-MDI/MDI-X
  - Line:       RJ-11, DMT modulation/FDD method
  - Size:       40 x 175 x 117
  - Weight:     300 g
* AC Adapater
  - Size: 57 x 49 x 84
  - Weight: 540 g
  - Input: AC 100 V, 50/60 Hz ±1 Hz
  - Output: DC 12 V (no current given)
