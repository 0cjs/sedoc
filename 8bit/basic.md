Generic BASIC Programs and Information
======================================

General References:
- [[ms5ref]] _BASIC-80 Reference Manual,_ Microsoft, 1979. For Revision 5.0
  of MS-BASIC for 8080 and Z80 (8K, Extended, Disk); major changes from
  4.51. Missing some front matter and appendicies; more complete but poorer
  scan at [[ms5ref-full]].


Input and Editing
-----------------

`EDIT lnno` ([[ms5ref]] p.2-20 P.39) edits a single line and activates the
edit mode subcommands, many of which are available in the screen editors on
microcomputers such as the PC-8001 and MSX. Commands preceeded with `ⁿ`
can take an optional repeat count for the action.

    ⁿSpace      cursor right
    ⁿ<DEL>      cursor left
     I          insert text; ESC to return to edit, CR to enter line
     X          extend line; cursor to EOL then insert mode
    ⁿD          delete char to right
    ⁿH          delete char to left
    ⁿSc         (search) move forward up to char `c`
    ⁿKc         (kill) delete forward up to char `c`
    ⁿC          change next ⁿ chars to same number of new chars typed

    <CR>        print remainder of line, save, exit edit mode
    E           same as <CR> but no print of remainder of line
    Q           exit editing without saving changes
    L           list remainder of line; reposition cursor at start
    A           restart editing from original version of line

MS-BASIC 5.0 will enter edit mode on any line throwing a Syntax Error;
press `Q` to exit without re-inserting line to avoid wiping variables.

<Ctrl-A> will enter edit mode on a line you're currently entering in input
mode.


Programs
--------

The [`retroabandon/bascode`] repo contains various code, the Mandelbrot
program, by Gordon Henderson (drogon), often used as a
[benchmark][f65 bench]. (The original is in `bbcmicro/mandel.bas`.)



<!-------------------------------------------------------------------->
[`retroabandon/bascode`]: https://gitlab.com/retroabandon/bascode
[f65 bench]: http://forum.6502.org/viewtopic.php?f=1&t=6323
[ms5ref]: https://archive.org/details/BASIC-80_MBASIC_Reference_Manual/
[ms5ref-full]: https://archive.org/details/BASIC-80_v5.0_1979_Microsoft/
