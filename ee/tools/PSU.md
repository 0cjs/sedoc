Power Supplies
==============


Rockseed RS305P (30 V 5 A bench PSU)
------------------------------------

- USB interface
- Dimensions: 280d × 130w × 165h mm; ~2kg
- Input Power: 110 V 60 Hz
- Max Output: 30 V 5 A

Display:
- top voltage: off=preset, on=actual
- middle amps: off=preset, on=actual
- bottom: off="off"; on=power (W); time param set=time;  
  protection=OVP/OCP/OPP/OTP (voltage/current/power/temp)  
  settings modes: S--U=set voltage, etc.

Big red button is system power. Small red/green lit is output off/on.

    M1      ╭─╮
    M2      ╰─╯
    M3   <-    ->
    M4   OVP  U/CV
    M5   OCP  I/CC
    M6  List  B/Lock

Editing:
- Single parameter (current parameters): knob edits current digit; arrow
  keys and knob press switch current digit.
- Parameter group (memory): knob edits current digit; arrows keys switch
  digit; knob press moves to next parameter.
- Tab `B` or wait 5s to exit editing mode.

Currently active output settings:
- __U/CV__: green=constant voltage mode; tap to set voltage
- __I/CC__: red=constant current mode; tap to set current limit
- __B/Lock__: off=unlocked; yellow=locked.  
  Hold 3s to lock/unlock controls (except ouput on/off).  
  Tap when editing paramers to return (or returns after 5s).

Not clear how overvoltage/overcurrent protection features differ from the
voltage/current settings. Maybe (for current) shutdown at that level
instead of continuing to deliver?
- __OVP__: press to view/set voltage; press again to switch on/off.
- __OCP__: press to view/set current; press again to switch on/off.

Memory
- `M1`…`M6`: tap to preview/edit; tap again to switch. Exit does not switch
  but retains currently active settings. Third setting is number of seconds
  to run this setting in list playback mode.
- `List`: Hold to enter/exit list mode; light turns blue and output turns
  off. Tap `M1`…`M6` to enable/disable entries; tap `On` to start
  sequencing through list.
