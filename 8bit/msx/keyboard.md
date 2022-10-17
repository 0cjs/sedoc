MSX Keyboards
=============

References:
- \[td1] [_MSX Technical Data Book_][td1], Sony, 1984.
- MSX Wiki, [Keyboard Matrices][mw matrix]

#### Layout (ja)

      F1    F2    F3    F4    F5              STOP   HOME INS DEL
    ESC  1  2  3  4  5  6  7  8  9  0  -  ^  ¥  BS   SELECT
    TAB   q  w  e  r  t  y  u  i  o  p  @  [  ENTER          ↑
     CTRL  a  s  d  f  g  h  j  k  l  ;  :  ]              ←   →
     SHIFT  z x c v b n m , . /  □                           ↓
       CAPS GRAPH    SPACE             KANA

[td1 p.328]

#### Matrix (ja)

PPI PB0-PB7 are column inputs X0-X7. PC0-PC3 go to a decoder that brings to
ground one of 10 row outputs Y0-Y10. [td1 p.13]

Matrix (ja):

          Bit: 7    6    5    4    3    2    1    0      OLDKEY  NEWKEY
        ───────────────────────────────────────────────┐
      row Y0   7    6    5    4    3    2    1    0    │  $fbda  $fbe5
          Y1   ;    [    @    ¥    ^    -    9    8    │  $fbdb  $fbe6
          Y2   B    A    _    /    .    ,    ]    :    │  $fbdc  $fbe7
          Y3   J    I    H    G    F    E    D    C    │  $fbdd  $fbe8
          Y4   R    Q    P    O    N    M    L    K    │  $fbde  $fbe9
          Y5   Z    Y    X    W    V    U    T    S    │  $fbdf  $fbea
          Y6  F3   F2   F1  KANA CAPS GRPH CTRL SHFT   │  $fbe0  $fbeb
          Y7  RET  SEL  BS  STOP  TAB  ESC  F5   F4    │  $fbe1  $fbec
          Y8   →    ↓    ↑    ←   DEL  INS HOME SPACE  │  $fbe2  $fbed
          Y9                                           │  $fbe3  $fbee
         Y10                                           │  $fbe4  $fbef
              X7   X6   X5   X4   X3   X2   X1   X0    │
              col

The memory locations are in the 11-byte `OLDKEY` ($FBDA) and `NEWKEY`
($FBE5) arrays contain a `0` bit for keys currently pressed, `1` otherwise.
They are updated by the keyboard scanner in the timer interrupt handler.



<!-------------------------------------------------------------------->
[mw matrix]: https://www.msx.org/wiki/Keyboard_Matrices
[td1]: https://archive.org/stream/MSXTechnicalHandbookBySony#page/n5/mode/1up
