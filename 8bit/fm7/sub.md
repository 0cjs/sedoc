FM-7 Sub-system and Sub-CPU
===========================

The main CPU communicates with the sub-CPU via 128 bytes of shared
RAM at $FC80-$FCFF (main side) and $D380-$D3FF (sub side).

$FD05 b7=1 indicates the sub-CPU is busy. The communication sequence is:
1. Wait for $FD05 b7=0 (or b7‥0=0?) (sub-CPU no longer busy)
2. Set $FD05 b7=1 (halt sub-CPU)
3. Wait for $FD05 b7‥0=0 (confirm sub-CPU halted)
4. Write command to shared RAM.
5. Write $FD05 ← 0 (Restart sub-CPU).

If you restart without writing a command, ensure that $FD80 b7 ← 0.

There is an undocumented `YAMAUCHI` subsystem command that allows running
code on the subsystem. See [[kasai]] for details. That page also provides
an example program to dump the sub-CPU's ROM.


### References

- \[kasai] [FM-7/8 Subシステムメンテナンスコマンド][kasai]



<!-------------------------------------------------------------------->
[kasai]: https://kasayan86.web.fc2.com/old/fmsubsystem.htm
