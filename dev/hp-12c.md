HP 12c Financial Calculator Quickref
====================================

(This assumes general familiarity with HP RPN calculators.)

* [Quick Start Guide][qs]
* [Owners Handbook and Problem Solving Guide][oh]

* `EEX` = exponent, `CHS` = change sign
* `CLX` clears X reg; no backspace.
* `Σ` clears stack, stats.
  `REG` clears stack, Σ, FIN, REG, but leaves PRGM. (Not programmable.)
* `PREFIX` cancel/noop.
* Decimals displayed: `f0` through `f9`, `f.` for scientific.

* Registers: `0`, `1`, ... `9`, `.0` ... `.9`
* `STO+` etc. register arithmetic works as usual.

* `INTG`, `FRAC`: prev value can be recalled with `LSTX`
* `RND`: round X to current number of display digits

* `%`: of Y, X%.  `Δ%` Y→X %change.  `%T`: of Y, X is ?%.
* `DATE`: from Y, X days (must input full month.dayyear)
* `ΔDYS`: days from Y to X

* Financial registers:
  * `n`: periods
  * `i`: interest/period
  * `PV`: present value
  * `PMT`: payment/period
  * `FV`: future value
* `12×`, `12÷` enter into `n`/`i` registers after mult/div


[qs]: http://www.hp.com/ctg/Manual/c01798099.pdf
[oh]: http://h10032.www1.hp.com/ctg/Manual/bpia5309.pdf
