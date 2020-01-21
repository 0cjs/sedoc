Apple I Character ROM
=====================

The character ROM is a [Signetics 2513][2513] "64×8×5 Character
Generator," a 2560-bit static ROM. A1-A3 selects one of the eight rows
of five pixels for a character (the top row is usually all-zero for a
5×7 matrix) and and A4-A9 indicating the character code.

The standard version (2513N/CM2140) had ASCII sticks 4-5 (upper-case
characters) in addresses 0-31 and ASCII sticks 2-3 (punctuation and
numbers) in addresses 32-63. There was also a katakana version
(2513N/CM4800) available, and custom versions (assigned their own
CMnnnn code by Signetics) could be made.

    A4 0101...
    A5 0011...
    A6 0000...
    A7 0000...
    A8 0000...
       @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_ !"#$%&'()*+,-./0123456789:;<=>?
       ﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿ

                 +-------------------+
    dot clock -->| Parallel Load     |--> Serial Out
        latch -->| Serial Shift Reg. |   (video data without sync)
                 +-------------------+
                       ^ ^ ^ ^ ^
                       | | | | |
                 +-------------------+
                 |     1 2 3 4 5     |
                 |      outputs      |
     row addr -->| A1                |
      timing  -->| A2                |
       input  -->| A3                |
                 |                   |
              -->| A4                |
       ASCII  -->| A5                |
        code  -->| A6                |
       input  -->| A7                |-- +5V
              -->| A8                |-- GND
              -->| A9                |
                 +-------------------+

From [this motherboard picture][mobopic1], the Apple I version appears
to have been marked:

    RO-3-2513
    CGR-100
      7844U
    TAIWAN

But other images, such as [this one][mobopic2] can have quite
different markings.


ROM Dump Sources
----------------

Dumps of the character ROM are available in `Apple1_bios.zip` from the
[Call-A.P.P.L.E emulation page][ca-emul] and in the [Pom1]
distribution. These versions are different in the last 25%: the Pom1
version includes lower case in the $60-$7F range instead of
duplicating the upper case from $40-$5F.

These are not in the format used in the original ROMs. Instead,
character data is stored in an array of 128 eight-byte blocks designed
for lookup by ASCII code.

    $00-$1F  not data from ROM; all clear except for $01
    $20-$3F  codes $20-$3F from ROM: ASCII punctuation and digits
    $40-$5F  codes $00-$1F from ROM: @ABC…
    $60-$7F  duplicate of $40-$5F, or lower-case not from ROM

Each block is a sequence of eight bytes, each representing a row. The
bottom row, instead of the top, is the empty one. Bits 1-6 contain the
six bits from the ROM in reverse order, with bits 0 and 7 always 0.



<!-------------------------------------------------------------------->
[2513]: https://www.applefritter.com/files/signetics2513.pdf
[2513b]: https://www.datasheetarchive.com/pdf/download.php?id=5065adad5e4757ac90073038091de3931e7380&type=M&term=2513
[ca-emul]: https://www.callapple.org/soft/ap1/emul.html
[mobopic1]: https://pccdn.perfectchannel.com/christies/live/images/item/TSN11675/5944434/original/CSK_11675_0018.jpg
[mobopic2]: https://www.christies.com/img/LotImages/2017/NYR/2017_NYR_14376_0378_002(a_working_apple-1_personal_computer_palo_alto_1976).jpg
[pom1]: http://pom1.sourceforge.net/
