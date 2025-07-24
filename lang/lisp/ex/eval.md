Early Lisp EVAL
===============

References:
- \[1] McCarthy et al., _[LISP I Programmer's Manual][1],_ MIT, 1960-03-01.
- \[1.5] McCarthy et al., _[LISP 1.5 Programmer's Manual][1.5],_ MIT Press, 1962-08-17.

From [[1]] p.19/P.22:

    apply[f;args] = eval[cons[f;appq[args]];NIL]
    appq[m] = [ null[m] → NIL;
                T → cons[list[QUOTE;car[m]];appq[cdr[m]]]]

    ;   `e`: expression to evaluate, with everything but the function
    ;        symbol at the start quoted by `apply`.
    ;   `p`: the environment as a list of pairs of (sym,expr).
    eval[e;p] = [
      ;   If the expression is atomic, we look up the symbol and return
      ;   its binding. NOTE: We removed a spurious bracket before `assoc`
      ;   in text.
      atom[e] → assoc[e;p];
      ;
      atom[car[e]] → [
          eq[car[e];QUOTE]  → cadr[e];
          eq[car[e];ATOM]   → atom[eval[cadr[e];p]];
          eq[car[e];EQ]     → eq[eval[cadr[e];p];eval[caddr[e];p]];
          eq[car[e];COND]   → evcon[cdr[e];p];
          eq[car[e];CAR]    → car[eval[cadr[e];p]];
          eq[car[e];CDR]    → cdr[eval[cadr[e];p]];
          eq[car[e];CONS]   → cons[eval[cadr[e];p];eval[caddr[e];p]];
          T                 → eval[cons[assoc[car[e];p];evlis[cdr[e];p]];p]
        ];
      eq[caar[e];LABEL]   → eval[cons[caddr[e];cdr[e]];cdr[e]];
        cons[list[]cadar[e];car[e]];p]];
      eq[caar[e];LAMBDA]  → eval[caddar[e];append[pair[cadar[e]];
        evlis[cdr[e];p];p]]]]

From [[1.5]] p.13/P.21:

    XXX

There is a detailed explanation in subsequent pages.


<!-------------------------------------------------------------------->
[1.5]: https://www.softwarepreservation.org/projects/LISP/book/LISP%201.5%20Programmers%20Manual.pdf
[1.5ar]: https://archive.org/details/DTIC_AD0406138/page/13/mode/1up
[1]: https://web.archive.org/web/20220409064202/http://history.siam.org/sup/Fox_1960_LISP.pdf
