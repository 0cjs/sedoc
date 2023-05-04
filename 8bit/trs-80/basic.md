TRS-80 BASIC
============


Level II
--------

### Lines/vars/ops

- Line numbers 0-65529.
  - `.` is current line (last `STOP`/`END`/interrupt/error).
  - 65535 is used internally for direct statements.
- Variable names: 2 char significant; letter followed by letter/number.
  - `%`=int, `!`=single prec., `#`= double prec., `$`=string (max 255).
  - `DEFINT`, `DEFSNG`, `DEFDBL`, `DEFSTR`, `DIM name (i)`
  - FP cast to int is truncated.
- Operators:
  - `+`, `-`, `*`, `^` (exponentation)
  - `AND`, `OR`, `NOT`: bitwise ops, args cast to int. 0=false, non-0=true.
  - `<`, `<=`, `=`, `>`, `>=`, `<>`

### Input/Output

- `INKEY$`: currently pressed key; no repeat.
- `POS(n)`: current horizontal cursor pos; _n_ ignored.
- `PRINT USING`

### Screen/Graphics

- `CLS`
- `SET (x,y)`, `RESET (x,y)`: sets/resets pixel at _x_ (0-127), _y_ (0-47).
- `POINT (x,y)`: returns 0=off, 1=on pixel

### Errors

      Code Abbr  Error
        1   NF   NEXT without FOR
        2   SN   Syntax error
        3   RG   RETURN without GOSUB
        4   OD   Out of data
        5   FC   Illegal function call (e.g. argument type mismatch)
        6   OV   Numeric overflow
        7   OM   Out of memory
        8   UL   Undefined line
        9   BS   Subscript out of range
       10   DD   Redimensioned array
       11   /0   Division by zero
       12   ID   Illegal direct (can't use INPUT at READY prompt)
       13   TM   Type mismatch
       14   OS   Out of string space
       15   LS   String too long
       16   ST   String formula too complex
       17   CN   Can't CONTinue
       18   NR   No RESUME
       19   RW   RESUME without error
       20   UE   Unprintable error (e.g. nested error)
       21   MO   Missing operand
       22   FD   Bad file data
       23   L3   Level 3 (disk) BASIC only

- `ON ERROR GOTO line`: after GOTO, `ERR` contains code from table above.
- `RESUME [ NEXT | line]`

### Misc

- `RANDOM`: seeds RNG with Z80 `R` (DRAM refresh) register
- `RND(0)`: single prec. 0 < _retval_ < 1 (≤?)
- `RND(n)`: int 1 ≤ _retval_ ≤ n

### Load/Save

- `CLOAD str`, `CSAVE str`, `CLOAD? str`: load, save, verify

### Machine Language

- `SYSTEM`: enter monitor; `*?` prompt. Two commands:
  - _filename:_ loads named binary program from CMT
  - `/`: jump to load address of last file loaded
  - `/a`: jump to address _a_
- `USR(n)`: calls routine at $408E (addr LSB @16526, MSB @16527)
  - `call $0A7F`: loads _n_ (int) into HL
  - `jp $0A9A`: returns HL as USR() retval
- `PEEK(a)`, `POKE a,v`, `IN(a)`, `OUT a,v`
- `VARPTR(v)`: return addr _a_; _a-3_ type, _a-2/1_ first two chars of name.
- `MEM`, `FRE(0)`: memory available in bytes.
- `FRE(x$)`: string heap space available.
- `CLEAR [n]`: erase all vars in mem; optional _n_ is new string heap size.


### References

- trs-80.com, [TRS-80 Model I Level 2 BASIC Language Reference][trscom-bas].



<!-------------------------------------------------------------------->
[trscom-bas]: https://www.trs-80.com/wordpress/reference/level-2-basic/
