https://batteryuniversity.com/articles

Extra stuff to add to ee/dc-power.md:

Implementation notes (LM-317-N):
- Minimum load is because the 50–100 μA sourced by ADJ is always minimised,
  with "quiescent operating current returned to the output, establishing a
  minimum load requirement." Not totally clear how this works. the output
  to rise.
- Current set resistor R₁ should be as close as possible to OUT and ADJ to
  avoid trace resistance (esp. at higher current loads) affecting the
  regulation. Conversely, the ground of R₂ can be near the load for remote
  sensing and improve load regulation.
- Bypassing: ceramic disc or solid tantalum recommended; see TI datasheet
  for more details.
- Input bypass, esp. recommended if input >15 cm from PSU: 0.1 μF disc or 1
  μF solid tantalum recommended, 25 μF aluminum electrolytic ok. More
  necessary when output bypass is used.
- Output bypass C₁:
  - Unless output capacitance ≤ 25 μF, consider protection diode from OUT
    to IN. (TI datasheet recommends 1N4002, but Schottky better?)
- Adjust bypass C₂:
  - 10 μF from ADJ to GND will help reduce ripple.
  - Consider protection diode from ADJ to OUT.

