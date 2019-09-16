Apple II Logo
=============

This documents Apple Logo II, a fairly late version ('84 or so?) requiring
a 128K Enhanced IIe or IIc (65C02).

References:
- \[logo2ref] [Apple Logo II Reference Manual][logo2ref], Apple, 1984.
- \[cs61a] [CS 61A Programming project #4:  A Logo Interpreter][cs61a] has
  much useful information on implementing a Logo interpreter that explains
  a lot about the language.
- \[ucblogo] [Berkeley Log (UCBLogo)][ucblogo] web page. Advanced samples,
  books, etc.
- \[csls2] [_Computer Science Logo Style:_ Volume 2: _Advanced
  Techniques_][csls2]. Shows why Logo is _way_ more powerful than BASIC.

Source, Emulators and Disks Images:
- \[a2mit80] [`logo.958` from ITS files][a2mit80] seems to be the earliest
  version I can find. "Preliminary version," "assembled 8/06/80."
- \[a2mit81] [`logo.299` from ITS files][a2mit81] is a slightly later
  version, possibly "1.0", "assembled 7/9/81." Adds "music" stuff.
- \[itsvault] [Source and Documentation from ITS][itsvault]. Many files,
  including both above, and some documentation.
- The `LOGO.dsk` image in [pnebauer/ptp2bin][ptp2bin] appears to have been
  built from [a2mit80] above ("preliminary version," "assembled 8/06/80"),
  though the link in the README points to the newer [a2mit81] source code.
- The MIT version of the two from [106 MIT Terrapin Logo][106disk] appears
  to be newer than [a2mit80] but earlier than [a2mit81], ("prototype
  version 2," "assembled 8 February 1981").
- [MIT LOGO for the Apple II (1981)][a2disk81], reassembled by Lars
  Brinkhoff from [a2mit81] above. The other "1.0" versions on archive.org
  appear to be the same version as this.
- [Apple Logo 1.5][1.5disk]. Newer than 1.0 versions above, but still not
  "Logo II." Has `NODES` procedure; 1627 free.
- [Apple Logo II][a2logo2disk]: 1984 128K ProDOS version.
- \[AppleWin] [Apple II Emulator for Windows][AppleWin]


Input, Keystrokes, Editing
--------------------------

Open and closed Apple modifier keys are represented here with ○ (`0m`)/●
(`0M`), left/right Alt key in [AppleWin].

    ○-ESC               Break; return to previous screen from help
    ○-?   ●-?           Help screen (also /)

    ○-←  ○-→            Left/right word
    ○-<  ○->            Beginning/end of line; ,/. also work
    ○-↑  ○-↓            Beginning/end of page, prev/next page
    ○-1 … ○-9           Move to beginning/proportion/end of buffer

    ^D  DEL  ^Bksp      Delete char to left
    ^F                  Del char under cursor
    ^X                  Delete entire line (stores in buffer)
    ^Y                  Delete to EOL (stores in buffer)
    ^R                  Restore text from buffer
    ^O                  Open line at current cursor position

    ^L                  Show graphics screen (works in editor)
    ^S                  Show mixed graphics/text screen
    ^T                  Show text screen (works in editor)

Input lines at the top level contain max 125 characters; the edit buffer is
max 6144 characters. `!` is printed at the end of the screen line (both at
top-level and in editor) to indicate continuation of the logical line.


Syntax and Semantics
--------------------

Throughout this document, parameters specified as _quoted_ are either a
quoted _word_ (atom) `"foo` or a list of words (auto-)quoted by brackets
`[foo bar]`. Parameters specified as _uqname_ are unquoted names that will
not be evaluated.

_Variables_ (sometimes called _names_) and _procedures_ (sometimes called
_definitions_) have separate namespaces. Procedures are further divided
into _commands_ returning no value and _operations_ that `OUTPUT` or `OP` a
value.

Variables are always dereferenced with a `:` prefix, e.g., `PRINT :foo`.
Global bindings are created with `MAKE "name obj` or `NAME obj "name` (even
inside procedures). Procedure parameters and variables set with
`MAKE`/`NAME` after using `LOCAL quoted` in a procedure introduce
dynamically scoped local variables.

Procedures are defined with `TO uqname :param1 :param2 …` (which is
the only special form in Logo; the procedure and parameter names, even
though not quoted, are not evaluated) followed by lines with the code
then `END`. If an `OUTPUT obj` or `OP obj` statement is given, that
sets the return value and terminates. (`STOP` will terminate without a
return value.)

Some primitives (but not user-defined procedures) can take extra optional
parameters. These are marked "#proc" in the manual and `PROC n m …` here.
If any optional parameters are given, the invocation must be surrounded by
parens: `(sum 2 3 4)`.

### Parsing

Summary of [logo2ref]:
- Appendix E p.275
- "Understanding a Logo Line" p.17

Lines are parsed as a list of delimiter-separated atoms that Logo calls
_words_. Delimiters are space and `[]()=<>+-*` and can be escaped with `\`.
But the first char after `"`, except `[`, does not need to be escaped,
others do, e.g., `"+\+`.

All non-list literals are actually just words, though some functions will
interpret, e.g. `"1.23` as a number. (Some won't: `FIRST .23` will return
`1`!) But the types are, more or less:
- _Integer numbers_, with optional `-` prefix. These are "auto-quoted," but
  may equivalently be quoted with `"`: `2 + "2 = "4`.
- Floating-point _decimal numbers_, as above but also with optional
  leading/internal `.`, positive/negative exponent indicators `E`/`N` (must
  be upper case).
- _Words_ (atoms) quoted with leading double-quote: `"foo`.
- _lists_ of (auto-quoted) words in brackets: `[foo bar baz]`.
- Predicates return (and `IF` takes) words `"TRUE` and `"FALSE`, which have
  no special meaning otherwise.

`+-*/=<>` are infix procedures with one arg on each side of the operator,
but otherwise standard procedures. `-` is parsed as infix only if preceeded
by a numeric expression, otherwise it's parsed a unary `-` (either
procedure or part of a number).

Precedence ([logo2ref] §9 p.107) from highest to lowest is as follows.
(WARNING: procedure application is lowest, unlike Haskell!)

    Unary -
    Infix * /
    Infix + -
    Infix < > =
    Words

Parens are used `()` for grouping binary operators and a procedure and its
arguments when it's a non-default number of args: `(LIST "a)`, `LIST "a
"b`, `(LIST "a "b "c)`. All open brackets and parens are automatically
closed when you press RETURN, e.g., `PR (SENTENCE "a [b c] [d e f`.

The first word of the line must always be a command. Further words are read
to recursively satisfy all non-optional arguments and then parsing starts
again with a following command, if any. E.g.,

    PRINT SUM RANDOM :n 100         ⇒ PRINT (SUM (RANDOM :N) 100)
    PRINT LIST CHAR 192 CHAR 193    ⇒ PRINT (LIST (CHAR 192) (CHAR 193))

Use `HELP "word` to see parameters for a procedure and output if an
operation.


Built-in Procedures and Primitives
----------------------------------

[logo2ref] Appendix G contains the full list.

Variables:
- `NAMEP word`: Is a variable named _word_ defined?
- `:name`: Dereference _name_, which is automatically quoted.
- `THING word`: Return value of variable named _word_.
- `MAKE word obj`, `NAME obj word`: Set variable _word_ to _obj_. (Not a
  special form; it's secretly called with an extra arg for the environment.)
- `ERN quoted`: Erase given variable(s).
- `LOCAL quoted`: Given variable name(s) become non-global (dynamic scope)
  after this statement.
- `PON quoted`, `PONS`: Print `MAKE` statements for given/all global vars.
- `EDN quoted`, `EDNS`: Edit `MAKE` statements for given/all global vars.
- `ERALL`: Erase everything in the workspace.

Procedures:
- `DEFINEDP word`: Outputs TRUE if _word_ is a procedure.
- `PRIMITIVEP word`: Outputs TRUE if _name_ is a primitive.
- `RUN list`: Evaluates  _list_, giving output.
- `PO quoted`: Print the named procedures.
- `POT quoted`: Print the title lines of the named procedures.
- `POTS`, `POPS`: Prints titles/contents of all unburied procedures.
- `ERASE quoted`, `ER quoted`: Erase the named procedure(s).
- `ED quoted`: Edit the named procedure(s).
- `COPYDEF name newname`: Create copy of definition of _name_ and bind it
  to _newname_. Both names must be quoted.
- `TEXT name`: Returns a list representing the definition of a procedure.
  The first element is a list of parameter names and remaining elements are
  lines of the definition as given to `TO` (without `END`). Gives `[]` for
  undefined procedures.
- `DEFINE name list`: Make _list_ the definition (as given by `TEXT`) of
  procedure _name_.

Workspace:
- `.CONTENTS`: Output a list of all procedures, variables and other
  words in the workspace.
- `POALL`: Print all procedure and variable definitions (even buried).
- `ERALL`: Erase all (unburied) procedures, variables, and properties.
- `ERNS`, `ERPS`, `ERALL`: Erase all (unburied) names, procedures.
- `BURY quoted`, `BURYNAME quoted`, `BURYALL`: Bury procedures, vars, all.
- `UNBURY quoted`, `UNBURYNAME quoted`, `UNBURYALL`

Control flow:
- `obj₁ = obj₂`,`EQUALP obj₁ obj₂`: any objects
- `IF p list₁ list₂`: The predicate must return the word `"TRUE` or
  `"FALSE` (case-insensitive); `RUN list₁` or `RUN list₂` will be
  executed. (_list₂_ is optional.)
- `TEST p`: Remember result of predicate _p_ for future `IFTRUE` etc.
  Always local to procedure in which it occurs.
- `IFTRUE list`/`IFT list`, `IFFALSE list`/`IFF list`: Runs _list_ if
  most recent `TEST` was true/false. Does nothing if a test has not
  been made.
- `REPEAT n list`: Runs _list_ _n_ times, discarding results.

Procedure control flow:
- Tail call optimization seems to be supported.
- `OUTPUT expr`: Terminate procedure, returning _expr_.
- `STOP`: Terminate procedure.
- `PAUSE`, `CONTINUE`/`CO`: Suspends procedure execution and gives
  interactive prompt. Continue with `CO`.

Non-local control flow:
- `THROW name`: Throws up to `CATCH`; error if no `CATCH` unless
  _name_ is `"TOPLEVEL`.
- `CATCH name list`: Execute _list_, moving on to next statement after
  CATCH if `THROW name` is called in _list_. _name_ may be `"ERROR` to
  catch any error thrown. (Use `ERROR` to get four-element list of
  `[errno message primname procedure]`; _procedure_ will be empty list
  if it was the toplevel.
- `LABEL word`, `GO word`: Takes literal words only.

_Words_ are atoms, i.e. strings of characters. Empty word is `"` followed
by space delimiter. Lists contain words or other objects; literal `[]`
lists automatically quote all words in them.
- `EMPTYP obj`: Returns `"TRUE` if obj is empty list or word.
- `COUNT obj`: Number of elements in list or word.
- `FIRST obj`, `BUTFIRST obj`/`BF obj`: Car/cdr of list or chars in word.
  Car of empty list/word is an errors
- `LAST obj`, `BUTLAST obj`/`BL obj`
- `ITEM n obj`: Return _n_th element of word or list _obj_ (first is 1).
- `MEMBERP obj₁ obj₂`: Is _obj₁_ in _obj₂_? Matches subsequences for words,
  but not for lists.
- `MEMBER obj₁ obj₂`: Returns subsequence of _obj₂_ that starts with
  _obj₁_.

List procedures:
- `LISTP obj`: Returns `"TRUE` if object is a list.
- `FPUT obj list`: Cons.
- `LIST obj₁ obj₂ …`: Return list of elements.
- `LPUT obj list`: Appends _obj_ to _list_.
- `SENTENCE obj₁ obj₂ …`: Concatenates words, flattens (1 level) list args.
- `PARSE word`: Return list parsed from _word_.

Word procedures:
- `WORDP obj`: True if _obj_ is a word.
- `BEFOREP word₁ word₂`: True if _word₁_ sorts (ASCII) before _word₂_.
- `WORD word₁ word₂ …`: Return word that is catenation of params.
- `READWORD`: Read a word from input.
- `CHAR n`: Return word of ASCII char _n_.
- `LOWERCASE word`, `UPPERCASE word`

Integer procedures:
- `ASCII word`: Numeric ASCII code of first char of _word_.
- `INT`, `ROUND`
- `INTQUOTIENT`, `REMAINDER`
- `RANDOM n`: Return random integer >= 0, < _n_.
- `RERANDOM`: Reset PRNG seed.

Numeric procedures:
- `NUMBERP obj`
- `SUM n₁ n₂ ...`
- `FORM num field precision`: Return number in field size _field_ with
  _precision_ digits after the decimal. Error if _field_ not big enough
  for number.
- `<`, `>`

Logical operations:
- `NOT pred`
- `AND pred₁ pred₂ …`
- `OR pred₁ pred₂ …`

User input (keyboard, etc.):
- `KEYP`: Returns TRUE if a key has been pressed but not yet read.

Text screen:
- `TYPE obj …`: Print _obj_ or if list, each item in _obj_ (bracket strip).
- `PRINT _obj_ …`/`PR _obj_`: `TYPE` object(s) followed by newline.
- `SHOW _obj_`: Print object, not stripping brackets for lists.
- `CLEARTEXT`/`CT`: Clear text screen and position to upper left.
- `CURSOR`: Return `[x y]` of cursor position (upper left is `[0 0]`).
- `SETCURSOR [x y]`
- `WIDTH`: Return width of screen (40 or 80 columns).
- `SETWIDTH width`: Set screen to 40 or 80 columns.
- `FULLSCREEN`/`FS`, `SPLITSCREEN`/`SS`, `TEXTSCREEN`/`TS`: Graphics mode
  (programatic `^L`, `^S`, `^T`).

The graphic screen co-ordinates are upper left `[-140 119]` to lower right
`[139 -120]` with .8 aspect ratio. Non-turtle procedures:
- `CLEAN`: Clears graphics screen.
- `DOT [x y]`: Draw dot in current pen state/color.
- `DOTP [x y]`: True if dot at co-ordinate.
- `SETBG n`: Background color, 0=black, 1=white, 2=green, 3=violet,
  4=orange, 5=blue, 6=black (for B/W TV; pen draws thinner lines).
- `PEN`, `PENCOLOR`: Return state, color of pen.
- `PENUP`, `PENDOWN`, `PENERASE`, `PENREVERSE`: Dot and turtle movements
  draw, erase, XOR.
- `SETPC n`: Pen color, see `SETBG` above.
- `HOME`: = `SETPOS [0 0] SETHEADING 0`.
- `CLEARSCREEN`/`CS`: `CLEAN HOME`.

Turtle procedures:
- `HIDETURTLE`, `SHOWTURTLE`
- `FENCE`: Generates error if turtle moves beyond screen bounds. Resets
  turtle to `[0 0]` if already outside screen bounds.
- `WINDOW`, `WRAP`: Window on 40960×32768 drawing space, turtle wraps.
- `FORWARD n`, `FD n`, `BACK n`, `BK n`
- `LEFT n`, `RIGHT n`, `SETHEADING n`: Relative/absolute rotation, in
  degrees.
- `SETX x`, `SETY y`, `SETPOS [x y]`
- `HEADING`: Returns heading in degrees.
- `POS`, `XCOR`, `YCOR`: Returns `[x, y]`, x, y.
- `SHOWNP`: Returns `TRUE`if turtle is hidden.
- `TOWARDS [x y]`: Return a heading, e.g., `SETHEADING TOWARDS [20 10]`.
- `FILL`: Fills shape outlined with current pen color with that color.
  Lines of other colors ignored.

Files/Disk:
- `FILEP path`: Does _path_ exist on disk?
- `ONLINE`: Return list of volume names of online disks.
- `CATALOG`
- `PREFIX`: Show current prefix (working directory).
- `SETPREFIX path`: Changes prefix; relative (no leading `/`) or absolute.
- `POFILE path`: Print out contents of file _path_.
- `LOAD path`
- `EDITFILE path`
- `SAVE path`: Save all unburied procedures. Delete file first w/`ERASEFILE`.
- `SAVEL quoted path`: Save specified procedures to _path_.
- `CREATEDIR path`
- `RENAME path newpath`
- `ERASEFILE path`

Misc.:
- `HELP prim`: Get help (show params) for (quoted) _prim_.
- `WAIT n`: Pause for _n_ 60ths of a second.
- `.QUIT`
- `TRACE word`, `UNTRACE word`: Trace entries/exits for given
  procedures, showing args and return values. May remove tail call
  optimization.

#### Startup

A file named `STARTUP` on disk 1 will be `LOAD`ed after pressing
RETURN from the title display. If a `LOAD`ed file sets a variable
named `STARTUP`, that list will be `RUN` after loading.


Example Code
------------

On Logo boot disk:

    SETPREFIX "/LOGO/SAMPLES
    LOAD "LOGO.SINGS

Dereferencing names:

    TO INC :x
    IF NOT NAMEP :x [STOP]
    IF NUMBERP THING :x [MAKE :x 1 + THING :x]
    END

To convert char to inverse video:

    TO ; :comment
    END

    TO invchar :c
    IF (ASCII :c) > 127  [OUTPUT :c]
    ; [Yes, this must all be on one line.]
    IF OR (ASCII :c) < 64 AND (ASCII :c) > 96 (ASCII :c) < 128 [OUTPUT CHAR 128 + ASCII :c] [OUTPUT CHAR 64 + ASCII :c]
    END

The operator version of `REPEAT`, with tail-call optimization:

    TO oprpt :n :list
    OUTPUT oprpt_ :n :list []
    END

    TO oprpt_ :n :list :acc
    IF :n = 0 [OUTPUT :acc]
    OUTPUT oprpt_ (:n-1) :list (LPUT RUN :list :acc)
    END


Technical Notes
---------------

Memory is allocated in 5-byte _nodes_.
- Literal words: one node per two chars.
- Variable names and procedures: 3 nodes + size of name. (Variable and
  procedure names are shared; if two separate procedures have a `:FOO`
  parameter, and there is a procedure named `FOO`, space is allocated
  to that name only once.
- Property list: three nodes + 2 nodes/property + size of list itself.
- Number (integer or decimal): 1 node.
- List: 1 node/element + size of element itself.
- `NODES` returns number of free nodes; `RECYCLE` runs GC.
- 7179 nodes free at startup on 128K Enhanced IIe.

Integers appear to be 32-bit signed. "Decimal" (floating point) has
exponents ranging from -38 to 38, and six digits of precision, thus
appearing to be 32-bit as well.



<!-------------------------------------------------------------------->
[clls2]: https://people.eecs.berkeley.edu/~bh/v2-toc2.html
[cs61a]: https://inst.eecs.berkeley.edu/~cs61a/reader/nodate-logo.txt
[logo2ref]: https://archive.org/details/Apple_Logo_II_Reference_Manual_HiRes
[ucblogo]: http://people.eecs.berkeley.edu/~bh/logo.html

[1.5disk]: https://archive.org/details/Apple_Logo_1.5
[106disk]: https://archive.org/details/106_MIT_Terrapin_Logo
[AppleWin]: https://github.com/AppleWin/AppleWin
[a2disk81]: https://archive.org/details/MIT_LOGO_for_the_Apple_II_1981
[a2logo2disk]: https://archive.org/details/Apple_Logo_II
[a2mit80]: https://github.com/PDP-10/its-vault/blob/master/files/aplogo/logo.958
[a2mit81]: https://github.com/PDP-10/its-vault/blob/master/files/aplogo/logo.299
[ptp2bin]: https://github.com/pneubauer/ptp2bin/
