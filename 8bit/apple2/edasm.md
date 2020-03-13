EDASM: Editor/Assembler
=======================

EDASM came with the the [DOS Tool Kit][dtk1.0] (1980). (Modified
image; others also available on archive.org.) [Apple 6502
Assembler/Editor][edasm] documents EDASM and the additional tools are
documented in [Applesoft Tool Kit (Part 1)][astk1] and
[Part 2][astk2]. A newer version of EDASM is available for ProDOS,
documented in [ProDOS Assembler Tools][pat].

Source files may be up to about 29K in size (13K on a 32K system) and
chained to build larger sources.


Files and Startup
-----------------

`EDASM` and `INTEDASM` are BASIC programs that  show and update the
`ASMIDSTAMP` file and then `BRUN EDASM.OBJ`. The timestamp file is
a 17 byte binary file that contains an ASCII (with high bit set)
timestamp, usually of the format `29-NOV-79 #000000`. The assembler
will increment the number in the `#000000` with each assembly.

#000027

`EDASM.OBJ` is the command interpreter and is always in memory. When
the editor is loaded a `:` prompt will be given. The `ASM` command
replaces the editor with the assembler, erasing any edit file in
memory; the editor is automatically reloaded when the assembler
completes.


Editor Commands
---------------

Commands may skip optional characters and need only the minimum
sequence of non-optional characters to distinguish them; `LOaD` may be
abbreviated `LOD`; `List` may be abbreivated `LIS`, `LI` or `L`.
Parameters need not be separated by a space.

Multiple commands may be separated by the command delimiter, default
`:`. Change it with `<ESC>:` followed by the new command delimiter.
The command delimiter may not be used in arguments to `Find`, `Change`
or `Edit`.

Parameters (optional params in brackets):
- `num`: Decimal number.
- `line#`: Line number, 1-65519.
- `lrange`: Optional line number range, one or two _line#_ separated
  by `-`. With no hyphen, the number is beginning and end of range.
  With trailing hyphen, end of range is end of file. If second _line#_
  is less than the first, it is a line count rather than line number.
- `lranges`: One or more _lrange_s separated by commas. E.g.,
  `2,1,4-2` for lines 2, 1, 4, 5.
- `dstr`: Delimited string; inital char is delimiter and cannot
  appear in the string.
- `dstr2`: Two strings between three delimiters: `/old/new/`.
- `file`, `objfile`: 1-30 char filename for text/object (binary) file.

Edit Commands:
- `? [cmd]`: Print help. Shows only the most common forms of commands.
- `List lranges`, `Print lranges`: List (with preceeding line number)
  or print (at left margin with no line number) lines. Space pauses
  listing; Ctrl-C aborts.
- `<Ctrl-R>`: Re-list: repeat of the last `List` command with all
  parameters. (The command char is not displayed on the screen, but
  can be followed by the command delimiter like any other command.)
- `Add [line#]`: Append new lines after EOF or _line#_. Terminate with
  Ctrl-D or Ctrl-Q at start of line, followed by Return.
- `Insert line#`: Insert lines before _line#_. Terminate as with `Add`.
- `Delete lrange`: Delete the lines _lrange_.
- `Replace lrange`: Delete the lines in _lrange_ and then enter insert
  mode to insert where the lines were deleted.
- `Find dstr`: Print lines with text matching _dstr_. Ctrl-A is
  single-character wildcard.
- `Change [lrange] dstr2`: Change first string to second. Prompts `ALL
  OR SOME? (A/S)`; the latter will prompt for verification of every
  change. Ctrl-C cancels further changes. Ctrl-A in old string is
  single-character wildcard.
- `COpy line# [-line#] TO line#`: Copies line or range to just before
  target _line#_.

`Edit lrange` brings up an interactive "visual" editor for each line
in turn. The commands are:
- Return: Accept the line as it appears on the screen, replacing the
  old version of the line.
- Ctrl-X: Cancel changes, leaving the original version of the line.
- Ctrl-T: Truncate current line from cursor position onward and save
  changes.
- Ctrl-R: Restore original line and continue editing.
- Ctrl-D: Delete char at current position, shortening line.
- Ctrl-I: Change to insert mode; subsequent chars will insert rather
  than overwrite.
- Arrows keys: Move cursor forward/backward.
- Ctrl-F: Find: jump to next occurance in line of next char typed.
- Ctrl-V: Next char is inserted verbatim, even if normally a command.

Display commands:
- `TRuncON`, `TRuncOFF`: Enable/disable truncation. When enabled, the
  portion of a line starting starting with ` ;`/space-semicolon will
  not be printed by the `List` and `Print` commands, though it will
  still be present (and appear for `Edit` etc.).
- `Tabs tablist dstr`: _tablist_ is a comma-separated list of screen
  columns - 2 (i.e., `T6` will set a tab at column 8) at which to
  place the second and subsequent space-separated fields.
  - This makes `Print` have different tabbing from `List` since it
    prints lines from the left edge rather than after a 6-character
    line number field.)
  - The field separator may be changed by supplying a new _dstr_, but
    the assembler accepts only space.
  - No tablist clears all tabs.
  - Default setting is `T14,19,29`.
  - My "condensed" setting is `T12,16,24` for `List` mode and
    `T7,11,19` for `Print` mode.

Operation Commands:
- `FILE`: Display current file/drive/memory info.
- `MON`: Enter monitor. Return with monitor Ctrl-Y command or `3D0G`.
- `CATalog`: As with `.CATALOG` but does not accept `,Dn,Sn` options.
- `END`: Exit to BASIC interpreter.
- `.cmd`: Issue _cmd_ to DOS to execute. Designed only for `RENAME`,
  `LOCK`, `UNLOCK`, `MON` and `NOMON`, but other commands (e.g.,
  `BLOAD`) will execute. `INIT` will produce disks without a `HELLO`
  program that will not boot.

Memory usage:  
`LOMEM=nnn`, `HIMEM=nnn`, `WHERE line#` and `LENGTH` are described in
the "Memory Usage" section.


Assembler
---------

Assembles only from files on disk; no co-resident assembly. Pass one
determines instruction lengths and generates the symbol table. Forward
references are always absolute, not zero-page. Pass two re-reads the
source, writes object code one sector (256 bytes) at a time to the
object or relocatable output file (with RLD relocation dictionary at
end), and generates the listing in 80-column lines (using both text
pages) scrolling right/left.

### Commands During Assembly

- Ctrl-C: Abort assembly.
- Space: Suspend listing; scroll listing one line while suspended.
- Ctrl-N, Ctrl-O: Listing off ("no") and on.

### Syntax

All ASCII chars must have high bit set. Lines terminated with CR
($8D). Lines with `*` or `;` in first column are full-line comments.

Fields are space-separated:
- Label, optionally with trailing `:`. Initial letter and containing
  only letters, digits and `.`. 1-250 chars.
- Instruction ("opcode") or pseudo-op. Two or more chars.
- Operand. Expressions use only left-to-right precedence.
- Comment. ` ;` prefix not strictly necessary, but editor's truncate
  commands needs those chars.

Expressions:
- Decimal numeric constants start with `0`-`9`, hex with `$`, and
  octal with `@`.
- Strings are in single quotes; as operands to an immediate-mode
  instruction the trailing single quote is not required.

### Directives

#### Data Definition

`dstr` is a delimited string; the first character is the delimiter
and may not be present in the string itself. Termination with the same
delimiter is optional if there is no comment after the string.

- `ASC dstr`: ASCII string. The `MSB` directive determines whether
  the MSB is set for each character.
- `DCI dstr`: As `ASC` but with MSB always 0 for all bytes except
  the last, for which MSB is 1.
- `DFB expr[,expr…]`: Define byte(s). Expressions are modulo 256.
  Bytes defined with relocatable expressions generate a relocation
  entry in the RLD.
- `DW expr`: Define word, stored LSB first.
- `DDB expr`: Define double byte stored MSB first.
- `DS expr`: Define storage; _expr_ is the size in bytes. Forward
  references not allowed in _expr_. Written as a hole in the object
  file unless used in a `DSECT`.

#### Conditional Assembly

A `DO expr` directive assembles the following code up to an `ELSE` or
`FIN` (finish). No statements are required between `DO` and `ELSE`.


External Listings
-----------------

After the slot number, `PR#` can take a comma followed by output to
send to the driver for that slot. On the IIc, the default control
character for driver commands is Ctrl-A, and the commands are
documented on [page 170][a2r-170] of the _Apple IIc Technical
Reference Manual_. For 19,200 bps ouput to a Unix terminal window:

- Apple II: `PR#2,`\<Ctrl-A>`15B`
- Linux: `stty </dev/ttyUSB0 19200 min 1 -parenb istrip icrnl; cat /dev/ttyUSB0`

(The `min 1` setting ensures that `cat` will not immediately exit when
no characters are available to read.)


Memory Usage
------------

    $0200 - $02FF   Input buffer for command/text entry
    $0300 - $03CF   Numeric input stack, flags, ASMIDSTAMP
    $03D0 - $03FF   Unused (assembler/monitor DOS interface)
    $0400 - $07FF   Screen RAM
    $0800 - $1FFF   Editor/assembler code and data
    $2000           Editor buffer start (default)
    $9600 - $BFFF   DOS (48K)

- `LOMEM=nnn`: Set start of edit buffer and assembler work area,
  default $2000 (8192).
- `HIMEM=nnn`: Set end of edit buffer and assembler work area; default
  38400 (48K), 26112 (36K), 22016 (32K).
- `WHERE line#`: Show hex address of _line#_ in memory. `W1` will show
  LOMEM pointer.
- `LENGTH`: Show bytes used and remaining (as with `FILE`). Add these
  to LOMEM to get HIMEM.

Set `HIMEM=36864` to leave $9000-$9600 free on a 48K system.



<!-------------------------------------------------------------------->
[a2r-170]: https://archive.org/details/Apple_IIc_Technical_Reference_Manual/page/n197/mode/1up
[astk1]: https://archive.org/details/applesoft_toolkit_part_1/
[astk2]: https://archive.org/details/applesoft_toolkit_part_2/
[dtk1.0]: https://archive.org/search.php?query=dos%20tool%20kit
[edasm]: https://archive.org/details/apple-6502-assembler-editor/
[pat]: https://archive.org/details/EDASM-ProDOS_Assembler_Tools_Manual/mode/2up
[pdasmtools]: https://archive.org/details/EDASM-ProDOS_Assembler_Tools_Manual/mode/1up
