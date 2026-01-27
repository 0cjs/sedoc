Headphones, Earphones, Bluetooth Audio Devices
----------------------------------------------

Bluetooth profiles:
- __A2DP__ Advanced Audio Distribution Profile
  (multimedia audio streaming, unidirectional)
- __HFP__ Hands-free Profile (telephone calls on automobile systems)
- __HID__ Human Interface Device Profile (game controllers, etc.; low latency)
- __HSP__ Headset Profile:
  (telephone calls; controls for ring, answer, hang-up, volume)

Bluetooth remote control:
- __AVCTP__ Audio/Video Control Transport Protocol:
  - Stereo headset buttons to control a music player (AV/C commands over L2CAP)
  - bluez-utils' [`mpris-proxy`][mpris] needed to pass on controls?
- __AVRCP__ Audio/Video Remote Control Profile (usu. w/A2DP)
  (`mpris-proxy` not required)

[MPRIS] supports play-pause, next, previous, but not volume/mute. (Use
`pactl` for the latter.)

[mpris]: https://wiki.archlinux.org/title/MPRIS

Aftershokz OpenMove
-------------------

Bone conduction Bluetooth headphones.

Bug notes:
- Power-up with auto-connect to Linux may disable ability to switch from
  A2DP to HSP. On Linux, disconnect then reconnect and it may fix it.
- Echo to remote end via mic feedback may be fixed by power-cycling
  headphones.

Outside of left transducer has __MF Multifunction__ button.
Base of right arm has (front to back) LED, covered USB-C charge
port, __`V+ Volume Up/Power__ button, __V- Volume Down__ button.

LED:
- Solid Red: charging
- Solid Blue: charging complete
- Flashing Red/Blue: pairing mode
- Flashing Blue: incoming call
- Flashes red every 2 minutes: low battery
  (Battery is about 6 hours play, up to 10 days standby.)

Pairing mode:
- From power off, hold __V+__ >5s.
  Will say, "welcome," then "pairing." Red/blue flash on LED.
- Change announcer language: double-click __MF__.
  (English → Japanese → Korean → Mandarin.)
- Reset all: Hold all three butons, __MF, V+, V-__, for 3-5 seconds until
  hear two beeps or feel vibrations.
- Also see <https://bit.ly/aftershokzpairing>

Multipoint pairing:
- Needed for two _simultaneous_ connections only? Last two (or more)
  devices paired in the regular way seem to be rememembered and connect
  fine when using just one.
- I think it does HSP profile to one device and A2DP to the other; couldn't
  play 2× A2DP at same time.
- To multipoint pair: in pairing mode, __MF,V+__ >3s, says "multipoint
  enabled." Pair, power off. Re-enter (regular) pairing mode, pair again,
  power off. Power up, says "device connected," "device 2 connected."
- Reset multipoint from power off with __V+, V-__ >3s.

Button functions (`,`=and, `/`=or):

    Mode      Button      Function              Prompt
    ───────────────────────────────────────────────────────────────────────────
    off       V+    >2s   power on              "welcome"
    on        V+    >2s   power off             "power off"

    idle      V+ / V-     battery status       "high"/"medium"/"low"/"charge me"
    idle      MF          play                  1 beep
    idle      MF ×2       redial last call      1 beep
    idle      MF >2s      phone assistant†      device beep

    playing   MF          pause (idle)          1 beep
    playing   MF ×2       next song†            1 beep
    playing   MF ×3       previous song†        1 beep
    playing   V+ / V-     volume up, down       1 beep
    playing   V+,V- >3s   EQ adjust             "standard"/"vocal"/"earplug"

    call      V+,V- >2s   mute                  "mute on"/"off"
    ringing   MF          answer call           2 beeps
    ringing   MF >2s      answer call waiting   1 beep
                          (hangup current call)
    ringing   MF >2s      reject call           2 beeps

† Notes:
- Next/prev song mapped to skip backward/forward in my BeyondPod config.
- "Activate assistant" seems unneeded on Android phones, which always
  respond to "Hey, Google."


Aftershokz Trekz Titanium
-------------------------

Bone conduction Bluetooth headphones.

This is a brief summary of the [manual].

### Multifunction button (left transducer)

All actions respond with one beep unless indicated otherewise.

| Action       | State         | Function
|:-------------|:--------------|:---------------
| click        | call incoming | Answer call
|              | on call       | Hold and answer call waiting
|              |               | Play/pause
| double-click | playing       | Skip to next song
|              |               | Redial last number ("last number redial")
| hold 2 sec.  | on call       | Hang up and answer call waiting
|              | call incoming | Reject call (two beeps)
|              |               | Voice dial ("voice dial")

### Volume Up/Power (`+`), Volume Down (`-`) Buttons

| Function      | State         | Action     | Response
|:--------------|:--------------|:-----------|:--------------
| Power on/off  | any           | `+` 2 sec  | 4 beeps, "Welcome"
| Mute          | on call       | Both 2 sec | "Mute on", "Mute off"
| Change EQ     | music playing | Both 2 sec | "EQ changed"
| Change Volume | music playing | `+` / `-`  | "Batt. high/med/low", "Charge me"
| Check Batt.   | music paused  | `+` / `-`  | 1 beep

### Pairing

`+` for 5 sec. enters pairing mode.

For multipoint pairing (up to 2 devices):
1. Enter pairing mode (`+` for 5 sec.)
2. Press multifunction and `+` together for 2 sec ("multipoint enabled")
3. Pair first device ("connected")
4. Shut down
5. Re-enter pairing mode
6. Pair second device ("second device connected")
7. Power device off then on

### Reset

1. Enter pairing mode (`+` for 5 sec.)
2. Hold all three buttons for 3 sec.

[manual]: https://cdn.shopify.com/s/files/1/0857/5574/files/Trekz_Titanium_Manual_English.pdf?
