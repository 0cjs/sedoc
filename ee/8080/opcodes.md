Intel 8080/8085 and Zilog Z80 Opcodes
=====================================

- See also [`8080.txt`](8080.txt) for instruction encoding/bitfield details.
- Cycles are 8080; 8085 varies.
- `rp`=register pair B, D, H. `rr`=Z80 register pair BC, DE, HL.
- Z80 mnemonics given in lower case. `c`=condition. `xx`=`a16`.

Table:

                                 scf   ccf¹     ¹not clear, complement!
    NOP    HLT      EI   DI      STC   CMC
    00₄    76₇      FB₄  F3₄     37₄   3F₄

    RST0 RST1 RST2 RST3 RST4 RST5 RST6 RST7
     C7   CF   D7   DF   E7   EF   F7   FF    ₁₁

                    xC xNC  xZ xNZ  xP  xM  xPE xPO
    JMP  a16   C3   DA  D2  CA  C2  F2  FA  EA  E2    ₁₀        jp   c,a16
    CALL a16   CD   DC  D4  CC  C4  F4  FC  EC  E4    ₁₁/₁₇     call c,a16
    RET        C9   D8  D0  C8  C0  F0  F8  E8  E0    ₅/₁₁      ret  c,a16
    PCHL       E9₅

    ──────────────────────────────────────────────────────────────────────

    ld a,(xx)  ld (xx),a  ld (xx),hl  ld hl,(xx)   │
    LDA a16    STA a16     SHLD a16   LHLD a16     │   IN  OUT   p8 (port)
    3A₁₃       32₁₃        22₁₆       2A₁₆         │   DB   D3   ₁₀

                    B   D   H   SP
    LXI  rp,d16     01  11  21  31  ₁₀      ld rr,d16
    DAD  rp         09  19  29  39  ₁₀      add hl,rr
    INX  rp         03  13  23  33   ₅      inc rr
    DCX  rp         0B  1B  2B  3B   ₅      dec rr
    LDAX rp         0A  1A           ₇      ld a,(rr)
    STAX rp         02  12           ₇      ld (rr),a

                    B   D   H   PSW
    PUSH r          C5  D5  E5  F5   ₁₁
    POP  r          C1  D1  E1  F1   ₁₀

    ex de,hl      ex (sp),hl    ld sp,hl    ‖         Z80 only
      XCHG          XTHL          SPHL      ‖   ex af,af'   ex (sp),ix
       EB₄          E3₁₈           F9₅      ‖     08          DDE3

    ──────────────────────────────────────────────────────────────────────

         r=   A   B   C   D   E   H   L       M

    MVI r,d8  3E  06  0E  16  1E  26  2E ₇   36₁₀       ld r,d8

    MOV B,r   47  40  41  42  43  44  45 ₅   46₇        ld r,r
    MOV C,r   4F  48  49  4A  4B  4C  4D ₅   4E₇
    MOV D,r   57  50  51  52  53  54  55 ₅   56₇
    MOV E,r   5F  58  59  5A  5B  5C  5D ₅   5E₇
    MOV H,r   67  60  61  62  63  64  65 ₅   66₇
    MOV L,r   6F  68  69  6A  6B  6C  6D ₅   6E₇
    MOV A,r   7F  78  79  7A  7B  7C  7D ₅   7E₇
    MOV M,r   77  70  71  72  73  74  75 ₇   HLT

    INR r     3C  04  0C  14  1C  24  2C ₅   34₁₀       inc r
    DCR r     3D  05  0D  15  1D  25  2D ₅   35₁₀       dec r

    ADD r     87  80  81  82  83  84  85 ₄   86₇
    ADC r     8F  88  89  8A  8B  8C  8D ₄   8E₇
    SUB r     97  90  91  92  93  94  95 ₄   96₇
    SBB r     9F  98  99  9A  9B  9C  9D ₄   9E₇        sbc r
    ANA r     A7  A0  A1  A2  A3  A4  A5 ₄   A6₇        and r
    XRA r     AF  A8  A9  AA  AB  AC  AD ₄   AE₇        xor r
    ORA r     B7  B0  B1  B2  B3  B4  B5 ₄   B6₇        or  r
    CMP r     BF  B8  B9  BA  BB  BC  BD ₄   BE₇        cp  r

    ADI  ACI  SUI  SBI  ANI  XRI  ORI  CPI    d8        add/adc/sub/sbc/and/
     C6   CE   D6   DE   E6   EE   F6   FE    ₇         xor/or/cp a,d8

    cpl                 rcla  rrca  rla  rra
    CMA   │   DAA   │   RLC   RRC   RAL  RAR
    2F₄   │   27₄   │    07    0F    17   1F  ₄

    ──────────────────────────────────────────────────────────────────────

    8080 unused opcodes: 08 10 18 20 28 30 38 CB D9 DD ED FD

    8085:  RIM  SIM
           20₄  30₄

    Z80:   djnz a8   jr a8   jr nz,a8   jr z,a8   jr nc,a8   jr c,a8   exx
             10        18        20        28        30         38      D9

    Z80 prefix ED (undoc/dup in parens; all not listed are unused):

               ldi cpi ini outi    ldd cpd ind outd
        ⋅⋅⋅     A0  A1  A2  A3      A8  A9  AA  AB
        ⋅⋅⋅r    B0  B1  B2  B3      B8  B9  BA  BB

        ld r,a  4F      ld a,r  5F      # refresh register

        neg  44 (54,64,74,4C,5C,6C,7C)  # A ← 0 - A
        rld  6F                         # rotate (HL),A pair left 1 nybble
                        bc  de  hl  sp
        ld  rr,(nn)     4B  5B  6B  7B
        ld (nn),rr      52  53  54  55
        adc hl,rr       4A  5A  6A  7A
        sbc hl,rr       42  43  44  45

                        b   c   d   e   h   l    _   a
        in r,(c)        40  48  50  58  60  68  70  78
        out (c),r       41  49  51  59  61  69  71  79

        reti          retn                im0       im1      im2
         4D            45                  64        65       5E
               (55,65,75,5D,6D,7D)     (66,4E,6E)   (67)      7E

    Z80 prefix CB: bit operations
    Z80 prefix DD: IX register operations
    Z80 prefix FD: IY register operations

    XXX Add ldir and other oft-used instructions.
