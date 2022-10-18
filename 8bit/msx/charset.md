MSX Character Sets
==================

References:
- [MSX Font][font] msx.org wiki
- [MSX Characters and Control Codes][codes] for info on BASIC's charset use
- [`bastok`] MS-BASIC tokenization tools documentation.
- OpenMSX [character set mappings][openmsx]
- KreativeKorp [Legacy Encodings][kk legacy]. Scroll down to "Legacy
  Computing - MSX" for a list of pages giving the charsets and Unicode
  conversions, including pop-ups giving copyable versions of for each char
  in a wide variety of string and programming language encodings.

[kk legacy]: https://www.kreativekorp.com/charset/encoding/

Related: [MSX Keyboards](./keyboard.md).

### Japanese

The Japanese character set is essentially 8-bit [JIS X 0201] in two
encodings.
- The [screen code encoding][kk ja video] is single-byte with the C0
  ($00-$1F) range containing kanji and line-drawing characrters and the C1
  ($80-$9F) and $E0-$FF ranges having hiragana.
- The [BASIC encoding][kk ja] uses the same C1 ($80-$9F) and $E0-$FF ranges
  containing hiragana, but the C0 ($00-$1F) range contains the standard
  control characters with the exception of $01, which indicates the start
  of a two-byte sequence. The second byte is $40-$5F; subtract $40 from
  this to get the screen code.

`│` indicates a range that is the same as JIS X 201.  
`┃` indicates a range unique to MSX.

         0 1 2 3 4 5 6 7 8 9 A B C D E F
    0x ┃   月火水木金土日年円時分秒百千万 ┃ 0x
    1x ┃ π ┴ ┬ ┤ ├ ┼ │ ─ ┌ ┐ └ ┘ ╳ 大中小 ┃ 1x
    2x │ ␠ ! " # $ % & ' ( ) * + , - . /  │ 2x
    3x │ 0 1 2 3 4 5 6 7 8 9 : ; < = > ?  │ 3x
    4x │ @ A B C D E F G H I J K L M N O  │ 4x
    5x │ P Q R S T U V W X Y Z [ ¥ ] ^ _  │ 5x
    6x │ ` a b c d e f g h i j k l m n o  │ 6x
    7x │ p q r s t u v w x y z { | } ‾ ␡  │ 7x
         0 1 2 3 4 5 6 7 8 9 A B C D E F
    8x ┃   あいうえおかきくけこさしすせそ ┃ 8x
    9x ┃   。「」、・ヲァィゥェォャュョッ ┃ 9x
    Ax │  ｡ ｢ ｣ ､ ･ ｦ ｧ ｨ ｩ ｪ ｫ ｬ ｭ ｮ ｯ   │ Ax
    Bx │ ｰ ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ  │ Bx
    Cx │ ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ  │ Cx
    Dx │ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾖ ﾗ ﾘ ﾙ ﾚ ﾛ ﾜ ﾝ ﾞ ﾟ  │ Dx
    Ex ┃ たちつてとなにぬねのはひふへほま ┃ Ex
    Fx ┃ みむめもやゆよらりるれろわん     ┃ Fx
         0 1 2 3 4 5 6 7 8 9 A B C D E F



<!-------------------------------------------------------------------->
[JIS X 0201]: https://en.wikipedia.org/wiki/JIS_X_0201#Codepage_layout
[`bastok`]: https://github.com/0cjs/bastok
[codes]: https://www.msx.org/wiki/MSX_Characters_and_Control_Codes
[font]: https://www.msx.org/wiki/MSX_font
[kk ja]:https://www.kreativekorp.com/charset/encoding/MSXJapanese/
[kk ja video]: https://www.kreativekorp.com/charset/encoding/MSXJapaneseVideo/
[openmsx]: https://github.com/openMSX/openMSX/tree/master/share/unicodemaps/character_set_mappings
