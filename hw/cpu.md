CPU Information
===============

Key:
* __PM__: [PassMark CPU]
* __ST__: Single thread PassMark
* __Cores__: Phyiscal cores, with subscript for threads/core
* __TDP__
* __Date__: Approx. release date (year.quarter)
* __GHz__: standard/turbo

|    PM |    ST | Cores|  TDP | LGA  | Date | GHz     | CPU
|------:|:-----:|:-----|-----:|------|------|---------|-----------------------
| 19358 |  2610 |  10₂ | 140W | 2066 | 17.2 | 3.3      | Intel Core i9-7900X
| 17828 |  2571 |   6₂ |  65W |  AM4 | 19.2 | 3.6      | AMD Ryzen 5 3600
| 14533 |  2897 |   8  |  95W | 1151 | 18.4 | 3.6      | Intel Core i7-9700K
| 12675 |  1973 |   8₂ | 140W | 2011 | 14.2 | 3.0      | Intel Core i7-5960X
| 13012 |  2657 |   6₂ |  65W | 1151 | 17.4 | 3.2      | Intel Core i7-8700
|  9545 |  2469 |   6  |  65W | 1151 | 19.1 | 2.9      | Intel Core i5-9400F
|  9578 |  2482 |   6  |  65W | 1151 | 18.1 | 3.0      | Intel Core i5-8500
|  8057 |  2464 |   4₂ |  88W | 1150 | 14.2 | 4.0      | Intel Core i7-4790K
|  6400 |  2075 |   4₂ |  77W | 1155 | 12.1 | 3.4      | Intel Core i7-3770
|  6173 |  2239 |   4  |  65W | 1151 | 17.4 | 3.6      | Intel Core i3-8100
|  5020 |  1642 |   4₂ |  80W | 1150 | 11.2 | 3.2      | Intel Xeon E3-1230
|  5034 |  2042 |   4  |  84W | 1150 | 13.2 | 3.4      | Intel Core i5-4670K
|  5460 |  2145 |   4  |  84W | 1150 | 13.2 | 3.4      | Intel Core i5-4670
|  5343 |  1741 |   4₂ |  95W | 1155 | 10.4 | 3.4      | Intel Core i7-2600
|  4502 |  1856 |   4  |  77W | 1155 | 12.2 | 3.1      | Intel Core i5-3450
|  4076 |  1517 |   4  |  10W | -    | 21.2 | 2.0      | Intel Celeron N5105
|  3904 |  1991 |   2₂ |  15W | -    | 17.2 | 2.2      | Intel Core i5-7260U
|  3510 |  2102 |   2₂ |  54W | 1151 | 17.1 | 3.5      | Intel Pentium G4560
|  3292 |  1887 |   2₂ |  54W | 1150 | 13.1 | 3.4      | Intel Core i3-4130
|  3391 |  1767 |   2₂ |  15W | -    |      | 2.5 t3.1 | Intel Core i5-7200U (Kalby Lake 14 nm)
|  3207 |  1665 |   2₂ |  15W | -    | 15.4 | 1.8 t2.9 | Intel Core i5-6260U
|  2979 |  1168 |   4  |  10W | -    | 20.1 | 2.0      | Intel Celeron J4125
|  2915 |  1325 |   4₂ |  95W | -    | 09.3 | 2.8 t3.5 | Intel Core i7-860
|  2635 |  1344 |   2₂ |  15W | -    | 15.4 | 2.3      | Intel Core i3-6100U
|  2150 |   859 |   4  |   6W | -    | 16.4 | 1.1 t2.5 | Intel Pentium N4200 (Apollo Lake)
|  1116 |   803 |   2  |   6W | -    | 16.4 | 1.1 t2.4 | Intel Celeron N3350 (Apollo Lake)

Laptop CPUs (ThinkPad models at end of description):

|  2535 |  1567 |   2₄ |  35W | -    | 13.1 | 2.6 t3.2 | Intel Core i5-3230M (X230)
|  2434 |  1567 |   2₄ |  35W | -    | 11.1 | 2.7 t3.4 | Intel Core i7-2620M (X220t)
|  2232 |  1567 |   2₄ |  35W | -    | 11.1 | 2.5 t3.2 | Intel Core i5-2520M (X220t)
|  1794 |  1151 |   2₂ |  35W | -    | 10.1 | 2.35t3.1 | Intel Core i5-540M  (X201s)
|  1718 |  1100 |   2₂ |  35W | -    | 10.1 | 2.4 t2.9 | Intel Core i5-520M  (T510)

The new PassMark seems to emphasise stuff using newer/extended instrs.
i7-3770 vs. i7-860 is 6400/2915 = 2.2×, but test suite individual results
are: int 1.4 float 1.7 primes 1.4 stringsort 1.555 encrypt 3.446 compress
1.6 physics 1.3 extended-instr 2.6 single-thread 1.6.


Socket Types
------------

See also [CPU benchmarks by socket type][pm-socket].

Be careful about the Xeons. E3-1230 v3 vs. v6 are different sockets.

- LGA1151 (2017-18)
- LGA1150 (2013-14)
- LGA1155 (2012)



[PassMark CPU]: https://www.cpubenchmark.net/cpu_list.php
[pm-socket]: https://www.cpubenchmark.net/socketType.html
