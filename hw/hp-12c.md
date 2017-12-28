HP 12c Financial Calculator Quickref
====================================

(This assumes general familiarity with HP RPN calculators.)

Documentation:
* [Quick Start Guide][qs]
* [Owners Handbook and Problem Solving Guide][oh]

Memory:
* Stack: X, Y, Z, T
* Registers: `R₀`, `R₁` … `R₉`, `R.₀`, … `R.₉` (latter are decimal point + num)
* Stats registers are `R₁`…`R.₆`
* Financial registers: `n` `i` `PV` `PMT` `FV` (can use `STO`/`RCL` on these)
* `STO+` etc. register arithmetic works as usual.
* After program steps 1-8, `R.₉` downward convert to 7 program steps each.

Input and Display:
* `EEX` = exponent, `CHS` = change sign
* `CLX` clears X reg; no backspace.
* `Σ` clears stack, LSTX, stats (`R₁`…`R₆`)
  `PRGM` clears program only in PRGM mode (`fP/R`).
  `FIN` clears financial registers
  `REG` clears stack, Σ, FIN, REG, but leaves PRGM. (Not programmable.)  
* `PREFIX` cancel/noop.
* Decimals displayed: `f0` through `f9`, `f.` for scientific.
* Hold `.` before `ON` to change digit and decimal separators

Operations:
* `INTG`, `FRAC`: prev value can be recalled with `LSTX`
* `RND`: round X to current number of display digits

Percentages and Dates:
* `%`: of Y, X%.  `Δ%` Y→X %change.  `%T`: of Y, X is ?%.
* `DATE`: from Y, X days (must input full month.dayyear)
* `ΔDYS`: days from Y to X

Financial:
* Registers
  * `n`: periods
  * `i`: interest/period
  * `PV`: present value
  * `PMT`: payment/period
  * `FV`: future value
* `12×`, `12÷` enter into `n`, `i` registers after mult/div


[qs]: http://www.hp.com/ctg/Manual/c01798099.pdf
[oh]: http://h10032.www1.hp.com/ctg/Manual/bpia5309.pdf
