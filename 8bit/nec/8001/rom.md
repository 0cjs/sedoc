PC-8001 ROM Notes
=================

If `STOP` key is being held down while the reset button is pushed, the
system will warm start (like `RST 8`) instead of cold start (`RST 0`).

ROM Routines
------------

- $0257  crt output routine
- $0D5D  monitor (BASIC keyword routine)
- $0D60  printer output routine
- $0F75  INKEY$ 担当機能
- $0F7B  INP 担当機能
- $1875  "Disk Basic Feature" error; return to BASIC prompt
- $279C  MAKINT routine
- $34C1  BASIC reserved words (keywords)
- $3C82  ??? Return to BASIC after USR, etc.
- $3F71  error message
- $52ED  Print HL→ $00-terminated string. Does not work before full init.
- $5C66  monitor restart


RST Disassembly
---------------

    RST $00  ;  Cold start (reset)
             0000: F3           di          ; disable interrupts
             0001: 31 FF FF     ld sp,$FFFF
             0004: C3 3B 00     jp reset
             0007: 00
    RST $08  ;  Warm start (stop+reset)
             0008: C3 6A 00     jp $006A
             000B: C3 57 17     jp $1757
             000E: AB           xor e
             000F: F0           ret p       ; ? flag
    RST $10  0010: C3 59 42     jp $4259
             0013: C3 6A 00     jp $006A
             0016: DA 0C        db $DA,$0C
             ;  Print char in A
    RST $18  0018: C3 A6 40     jp $40A6
             001B: F3           di
             001C: 0B           dec bc
             001D: C3 7E 50     jp $507E
    RST $20  0020: C3 DA F1     jp $F1DA    ; to user-set jump instruction
                                            ; (defaults to `ret`)
             0023: C3 9C 27     jp $279C
             0026: 88           adc a,b     ; data?
             0027: 0C           inc c
    RST $28  0028: C3 DD F1     jp $F1DD    ; to user-set jump instruction
             002B: C3 60 0D     jp $0D60
             002E: 46           ld b,(hl)   ; data?
             002F: 0C           inc c
    RST $30  0030: C3 E0 F1     jp $F1E0    ; to user-set jump instruction
             0033: 9F           sbc a,a     ; data?
             0034: 0F           rrca        ; rotate A right through carry
             0035: C3 57 02     jp $0257    ; CRT output routine
    RST $38  0038: C3 E3 F1     jp $F1E3    ; to user-set jump instruction

    reset:   003B: AF           xor a
             003C: 32 75 EA     ld sp,$EA75
             003F: CD F1 0C     call $0CF1

