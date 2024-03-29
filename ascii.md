ASCII and Related Character Sets
================================

                              ––––––-––bit6–––––––––
                  –––bit5–––              –––bit5–––

    | 00 NUL  0 | 20 spc 32 | 40  @  64 | 60  `   96 |
    | 01 SOH  1 | 21  !  33 | 41  A  65 | 61  a   97 |
    | 02 STX  2 | 22  "  34 | 42  B  66 | 62  b   99 |
    | 03 ETX  3 | 23  #  35 | 43  C  67 | 63  c   99 |
    | 04 EOT  4 | 24  $  36 | 44  D  68 | 64  d  100 |
    | 05 ENQ  5 | 25  %  37 | 45  E  69 | 65  e  101 |
    | 06 ACK  6 | 26  &  38 | 46  F  70 | 66  f  102 |
    | 07 BEL  7 | 27  '  39 | 47  G  71 | 67  g  103 |
    | 08 BS   8 | 28  (  40 | 48  H  72 | 68  h  104 |  |
    | 09 TAB  9 | 29  )  41 | 49  I  73 | 69  i  105 |  |
    | 0A LF  10 | 2A  *  42 | 4A  J  74 | 6A  j  106 |  b
    | 0B VT  11 | 2B  +  43 | 4B  K  75 | 6B  k  107 |  i
    | 0C FF  12 | 2C  ,  44 | 4C  L  76 | 6C  l  108 |  t
    | 0D CR  13 | 2D  -  45 | 4D  M  77 | 6D  m  109 |  3
    | 0E SO  14 | 2E  .  46 | 4E  N  78 | 6E  n  110 |  |
    | 0F SI  15 | 2F  /  47 | 4F  O  79 | 6F  o  111 |  |

    | 10 DLE 16 | 30  0  48 | 50  P  80 | 70  p  112 |     |
    | 11 DC1 17 | 31  1  49 | 51  Q  81 | 71  q  113 |     |
    | 12 DC2 18 | 32  2  50 | 52  R  82 | 72  r  114 |     |
    | 13 DC3 19 | 33  3  51 | 53  S  83 | 73  s  115 |     |
    | 14 DC4 20 | 34  4  52 | 54  T  84 | 74  t  116 |     |
    | 15 NAK 21 | 35  5  53 | 55  U  85 | 75  u  117 |     |
    | 16 SYN 22 | 36  6  54 | 56  V  86 | 76  v  118 |     b
    | 17 ETB 23 | 37  7  55 | 57  W  87 | 77  w  119 |     i
    | 18 CAN 24 | 38  8  56 | 58  X  88 | 78  x  120 |  |  t
    | 19 EM  25 | 39  9  57 | 59  Y  89 | 79  y  121 |  |  4
    | 1A SUB 26 | 3A  :  58 | 5A  Z  90 | 7A  z  122 |  b  |
    | 1B ESC 27 | 3B  ;  59 | 5B  [  91 | 7B  {  123 |  i  |
    | 1C FS  28 | 3C  <  60 | 5C  \  92 | 7C  |  124 |  t  |
    | 1D GS  29 | 3D  =  61 | 5D  ]  93 | 7D  }  125 |  3  |
    | 1E RS  30 | 3E  >  62 | 5E  ^  94 | 7E  ~  126 |  |  |
    | 1F US  31 | 3F  ?  63 | 5F  _  95 | 7F DEL 127 |  |  |


"Safe" characters (unlikely to be interpreted wrongly in national
variants, etc.) are all chars from sticks 2 and 3 ($20-$3F)
excluding `#` ($23) and `$` ($24).

Earlier glyphs include:

    Code 1963 1965 1967
    -------------------
    $40    @    `    @
    $5C    \    ~    \
    $5E    ↑    ^    ^
    $5F    ←    _    _
    $60         @    `
    $7C   ACK   ¬    |
    $7E   ESC   |    ~

Also see:

    https://en.wikipedia.org/wiki/ASCII#Character_set
    https://www.kreativekorp.com/charset/encoding/
    http://jkorpela.fi/chars/
    https://czyborra.com/charsets/iso8859.html


Glyphs Representing Control Codes and Keys
------------------------------------------

Unicode has a set of [control pictures][ctrlpic] for C0 control codes and a
few other generic codes, including generic NL, but not C1 control codes:

            0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
    U+240x  ␀   ␁   ␂   ␃   ␄   ␅   ␆   ␇   ␈   ␉   ␊   ␋   ␌   ␍   ␎   ␏
    U+241x  ␐   ␑   ␒   ␓   ␔   ␕   ␖   ␗   ␘   ␙   ␚   ␛   ␜   ␝   ␞   ␟
    U+242x  ␠   ␡   ␢   ␣   ␤   ␥   ␦
    U+243x

[ISO/IEC 9995][iso9995] _Information technology — Keyboard layouts for text
and office systems_ specifies a standard set of keytop symbols in [ISO/IEC
9995-7][iso995-7].



<!-------------------------------------------------------------------->
[ctrlpic]: https://en.wikipedia.org/wiki/Unicode_control_characters#Control_pictures
[iso995-7]: http://jdebp.uk./FGA/iso-9995-7-symbols.html
[iso9995]: https://en.wikipedia.org/wiki/ISO/IEC_9995
