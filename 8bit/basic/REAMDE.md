Generic BASIC Programs and Information
======================================


Mandelbrot, by Gordon Henderson (drogon)
----------------------------------------

[`mandel.bas`](./mandel.bas.txt), from forum.6502.org thread
[Benchmarking][f65 bench].

#### MSX1 (Sanyo MPC-2 Wavy2)

The following changes may be made:

    165 DEFSNG A-Z          Use single-precision ints (vs. [dbl])
    265 W=38:H=21           Make it fit 40x24 screen (per litwr)
    285 TIME=0              Avoid wrap so runtime is not a negative number
    515 GOTO 515            Avoid prompt scrolling screen (per litwr)

Also change the end of line 510 from `100` to `60;` (for NTSC systems) to
show number of seconds and scroll the screen one line less at the end (per
litwr in the first reply). The first line will still scroll off unless you
turn off the function key labels.

Timings (in seconds):

                  Sanyo MPC-2  Sony HB-55
    ──────────────────────────────────────
      DBL           521.9        521.98
      SNG           413.37       413.45
      improvement    21%          21%

(HB-55 once produced 412.78, perhaps because first run after reset?)



<!-------------------------------------------------------------------->
[f65 bench]: http://forum.6502.org/viewtopic.php?f=1&t=6323
