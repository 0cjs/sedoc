Netgear Switch Information
==========================

Netgear has four lines of switches:
1. **Fully Managed:** expensive enterprise line
2. **Smart Managed:** most enterprise software features (filtering,
   routing, SNMP) but no hardware (POE, redundant power).
3. **Web Managed (Plus)/Click:** basic VLAN support. No ingres
   filtering, text-based config. Management fixed to VLAN 1.
4. **Unmanaged.**


Web Managed (Plus)/Click
------------------------

Includes GS105Ev2 but not many other 8-port or less switches.

* "Port-based" VLAN does not use 802.1Q but assigns a single VLAN to
  each (untagged port). Don't use this; interaction with 802.1Q is
  confusing.
* "802.1Q Basic" also confusing; turning on erases all VLAN settings.
* Use "802.1Q Advanced".

**"VLAN Configuration":** Add new VLAN by typing new ID in box and
clicking "Add". This will not assign the VLAN to any ports.

**"VLAN Membership":** Dropdown selects VLAN and each port can be
seleted for U (untagged) or T (tagged) output. This does not affect
untagged input.

**"Port PVID":** Determines VLAN used for untagged input packets?


Fully/Smart Managed
-------------------

If enabled (via site-map/something-or-other in Web UI) CLI runs on
port 60000 using telnet protocol. [CLI Reference].

[CLI Reference]: http://www.downloads.netgear.com/files/gsm7312_gsm7324_fsm7326p_60015_cliref.pdf

