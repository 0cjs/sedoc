Connector and Connectivity Information
======================================

This covers standardized or at least somewhat cross-platform plugs, jacks,
sockets and other interfaces, mostly related to 8-bit microcomputers but
often touching on 16- and higher-bit systems as well.

Subject Index:
- CMT (Cassette Tape): [DIN].
- Serial: [DIN], [serial].
- Video: [Video], [DIN].

Connector Index:
- [0.1" Pin Headers][header]
- [JST Connectors][jst]: XH wire-to-board, SM wire-to-wire
- DA-15: [Video]
- DB-25: [Serial]
- D?-19: Apple II diskette connector, IIc onward.
- DE-9: [DIN], [Joystick], [Serial].
- DIN: [DIN], Apple [serial].
- JP-21 and SCART: [Video], [FM77]


Barrel Connectors
-----------------

Two-conductor with gender determined by center contact. Used only for power
with female output on cable and male input on device. Dot before `ID`
column indicates inner pin present in plug.

    Standard        Name        OD (mm) ID      Notes
    ──────────────────────────────────────────────────────────────────────
    IEC 60130-10    Type A      5.5     2.1     Most common?
                    Type A      5.5     2.5
    EIAJ            EIAJ-01     2.35    0.7      0    -  3.15 V
         (yellow    EIAJ-02     4.0     1.7      3.15 -  6.3  V
         plastic    EIAJ-03     4.75    1.7      6.3  - 10.5  V
         tips?)     EIAJ-04     5.5   ● 3.3     10.5  - 13.5  V
                    EIAJ-05     6.5   ● 4.4     13.5  - 18.0  V
                                7.5?  ● 5.5?    Thinkpad



References
----------

A massive source for all sorts of Japanese computer connectors is
[OLD Hard Connector Information ][oh].



<!-------------------------------------------------------------------->
[din]: ./din.md
[header]: ./header.md
[joystick]: ./joystick.md
[jst]: ./jst.md
[serial]: ./serial.md
[video]: ./video.md

[fm77]: ../fm7fm77.md

[oh]: https://www14.big.or.jp/~nijiyume/hard/jyoho/connect.htm
