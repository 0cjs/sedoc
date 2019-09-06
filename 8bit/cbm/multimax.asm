; zp usage
; $00, $01 - CPU registers
; $02 - counter to show how many times current scrollx has been shown
; $03,$04 - temp counters used to display cartridge names
; $05 - last highlighted name index
; $06,$07 - temp address of message colour ram used in highight_row
; $08 - new highlighted name index
; $09 - temp storage of paddle value to divide it by 7
; $0a - pointer to next location for 'rolling average' calculation
; $0b - read raw paddle value
; $0c - high byte of sum of read paddle values for rolling average calculation
; $0d - low byte of sum of read paddle values for rolling average calculation
; $0e - the last detected input value
; $0f - countdown value to ensure 'n' seqential read values before we consider it genuine
; $10 - low byte of crc current location
; $11 - high byte of crc current location
; $12 - flag to determine if current message should be faded out
; $13,$14 - print_msg : pointer to msg data
; $15,$16 - print_msg : pointer to screen location
; $17     - print_msg : text colour
; $18,$19 - print_msg : colour location...
; $1a - music state
; $1b - which logo is diplayed
; $1c-$1d - exram test vector
; $1e-$1f - *unused*
; $20 - calculated checksum low
; $21 - calculated checksum high
; $22 - calculated checksum low of boot loader
; $23 - calculated checksum high of boot loader
; $24,$25 - printed CRC location
; $26 - print_hex_byte: byte to print
; $27 - stress_test : outbound errors
; $28 - stress_test : inbound errors
; $29,$2a - scrollx reset address
; $2b,$2c - next character to be scrolled
; $2d - current x-smooth scroll value
; $2e - * unused *
; $2f - * unused *
; $30-$35 - unused
; $36-$45 - unused
; $46-$55 - unused
; $56-$ff - *unused*

colour_ram=$d800
screen_ram=$0400
vic_base=$d000

black=$00
white=$01
red=$02
cyan=$03
magenta=$04
green=$05
blue=$06
yellow=$07
orange=$08
brown=$09
pink=$0a
darkgrey=$0b
medgrey=$0c
lightgreen=$0d
lightblue=$0e
lightgrey=$0f

sp_pointer=$07f8
sp_xpos=$d000
sp_ypos=$d001
sp_msb=$d010
scroly=$d011
raster=$d012
sp_enable=$d015
sp_vexp=$d017
sp_bprio=$d01b
sp_multi=$d01c
sp_hexp=$d01d
VIC_Border=$d020
VIC_Background0=$d021
VIC_Background1=$d022
VIC_Background2=$d023
VIC_Background3=$d024
sp_multicol0=$d025
sp_multicol1=$d026
sp_colour=$d027

rows=40

boot_cart=$0200
test_cart=$0200
crc_lo=$0600
crc_hi=$0700

music_init=$e000
music_play=$e003
music_stop=$e006

num_carts=35
msg_show_count=3
msg_fade_init=$04

*=$c000
.fill $4000, $ff

*=$c000
.logical $8000
help_table
	.word help_def
	.word help_avenger
	.word help_avenger
	.word help_avenger

	.word help_billiards
	.word help_billiards
	.word help_bowling
	.word help_clowns

	.word help_clowns
	.word help_gorf
	.word help_jlander
	.word help_jlander

	.word help_kickman
	.word help_kickman
	.word help_lemans
	.word help_maxbasic

	.word help_minibasic
	.word help_moleattack
	.word help_moneywars
	.word help_music_comp

	.word help_music_mach
	.word help_omega
	.word help_omega
	.word help_pinball

	.word help_ratrace
	.word help_ratrace
	.word help_ratrace
	.word help_roadrace

	.word help_roadrace
	.word help_seawolf
	.word help_slalom
	.word help_bingomath

	.word help_superalien
	.word help_vss
	.word help_wizardwor
	.word help_wizardwor

.enc screen
help_def
	.text "     "
	.text "welcome to the multimax cartridge <www.multimax.co> developed by michal pleban and rob clarke "
	.text "with music by joachim wijnhoven and roland hermans. "
	.text "the multimax contains all known versions of MAX machine compatible games cartridges "
	.text "released by commodore. some background information about the versions "
	.text "is shown when the image is selected and more can be found by visiting "
	.text "the multimax website, pete rittwage's MAX page at www.c64preservation.com/ultimax "
	.null "or mat allen's at www.mayhem64.co.uk. "
	.text "select a game using the keyboard, joystick or paddles. "
	.text "press fire, space or return to start game. "
	.text "f"+64, "1"+64, " displays this general help and credits. "
	.text "f"+128, "3"+128, " starts the cartridge self-diagnostic test. "
	.text "left arrow toggles music. "
	.text "all MAX games use joystick port 1 except speed/bingo math. "
help_avenger
	.text "     "
	.text "avenger is commodore's space invaders clone. "
	.text "use joystick in port 1 or keys ", "l"+64, " and ", ";"+64, " to move and ", "a"+64, " to fire. "
	.text "3 versions are known to exist. the first two, known as v.01 and v.02 were the original "
	.text "releases for the max machine in japan which are very similar except for a few colour differences "
	.text "and text labels. the cartridge dump of v.01 also included a bug which hangs the game when a wave "
	.text "is completed. this has been fixed in the multimax version for the sake of playability. "
	.null "the 3rd version is the classic version released for the 64."
help_billiards
	.text "     "
	.text "use joystick in port 1 or keys ", "p"+128, ", ", "."+128, ", ", "l"+128, ", ", ";"+128, " and ", "f"+128, "1"+128, " to select. "
	.text "there are several variations of pool included. "
	.text "STRAIGHT POOL - 2 player, nominate the pocket and ball. "
	.text "ROTATION - 2 player, pot the balls in order. "
	.text "ONE POCKET - 2 player, only scores for potting ball in own pocket. "
	.text "PLAYER - 2 player, player keeps playing until a foul is made. "
	.text "HUSTLER - 1 player, score as many points as possible with a limited number of shots. "
	.text "TRICK SHOT - set the table up as you want to perform trick shots. "
	.text "the SET-UP menu allows you to adjust the scoring, table friction and random factor to your liking. "
	.null "it is unknown what the differences are between the two versions."
help_bowling
	.text "     "
	.text "you just need one key to play bowling, using either ", "f"+64, "1"+64, " or fire on a joystick in port 1 "
	.null "to control your line and spin. despite the simple controls, it's surprisingly addictive."
help_clowns
	.text "     "
	.text "a paddles only game. keep your clowns bouncing to pop as many balloons as possible. "
	.null "it is unknown what the differences between the versions are other than the copyright notice."
help_gorf
	.text "     "
	.text "a gorf conversion for the MAX only released in japan. "
	.text "use joystick in port 1 or keys ", "p"+128, ", ", "."+128, ", ", "l"+128, ", ", ";"+128, " and ", "a"+128, " to fire. "
	.text "this is a poor conversion compared to the later 16k version released for the C64 and the 2nd level is very hard. "
	.null "it is possible that this was only a prototype."
help_jlander
	.text "     "
	.text "the classic commodore jupiter lander game. "
	.text "use joystick in port 1 or keys ", "a"+128, ", ", "d"+128, " and ", "f"+128, "1"+128, ". "
	.text "the differences from the max version to the c64 version are mainly cosmetic, including the "
	.null "addition of a title screen and changed engine noises."
help_kickman
	.text "     "
	.text "pop, catch or kick the balloons before they hit the ground. "
	.text "use joystick in port 1 or keys ", "l"+128, ", ", ";"+128, " and ", "a"+128, " to kick. "
	.null "the earlier version has much simpler graphics and different music compared to the later release."
help_lemans
	.text "     "
	.text "a paddles only game. overtake other cars to accumulate time and points. "
	.null "modern formula 1 could learn from this game by adding ice and single track roads."
help_maxbasic
	.text "     "
	.text "the MAX basic cartridge was a more complete implementation of commodore basic which "
	.text "gave the ability to load and save programs to an attached cassette. the cartridge "
	.null "includes an extra 2k of ram so you have 2048 bytes free to play with."
help_minibasic
	.text "     "
	.text "the rather pointless mini basic cartridge had no extra ram on board so this version of commodore basic "
	.null "gives you only 510 bytes free."
help_moleattack
	.text "     "
	.text "a keyboard only game where you have to hit moles over the head with a mallet. "
	.text "the sooner you hit the mole the more points scored. you lose points for hitting "
	.null "the moles on the 'tail'. the keys to use are shown in game."
help_moneywars
	.text "     "
	.text "use joystick in port 1 or keys to steal bags of money. bonus is reduced if you run "
	.null "or make use of the shield. full instructions are included in the game."
help_music_comp
	.text "     "
	.text "music composer is a well featured music program written by andy finkel. instructions for use are "
	.text "beyond the scope of including in these instructions but can be found here: "
	.null "<http://inchocks.co.uk/commodore/multimax/musiccomposer.pdf> "
help_music_mach
	.text "     "
	.text "music machine is a rather basic music tool compared to music composer. "
	.text "use the second row of keys from q to the up arrow as the white keys of a music keyboard "
	.text "and the top row as the black keys. "
	.text "the ", "c"+128, "="+128,", ","z"+128,", left and right ","s"+128,"h"+128,"i"+128,"f"+128,"t"+128
	.text " and cursor keys control sound parameters while the function keys control percussion. "
	.null "more complete instructions can be found here: <http://inchocks.co.uk/commodore/multimax/musicmachine.pdf> "
help_omega
	.text "     "
	.text "the MAX version of the classic omega race game which can be played using joystick, keyboard or paddles. "
	.text "keyboard controls are detailed in the game and are different between versions. when using the paddles a "
	.text "quick press fires missiles and a longer press fires the thrusters. these two MAX versions also have very "
	.text "different colour schemes and character sets but the gameplay seems to be the the same. the common version "
	.null "of omega race found on the 64 is substantially different was a complete rewrite and not MAX compatible."
help_pinball
	.text "     "
	.text "pinball spectacular is a paddles only mash-up of breakout and pinball. after pressing the button on the paddle to start a game, "
	.text "rotate the paddle to the left or right to select 1 or 2 players. this game is unusual in that it is a 12k cartridge which also "
	.null "uses the area from 8000-8fff."
help_ratrace
	.text "     "
	.text "radar rat race is commodore's conversion of rally-x. "
	.text "use joystick in port 1 or keys, which are slightly different between versions so refer to the in-game instructions for details. "
	.text "02a is the version known to have been released in japan for the MAX. "
	.text "02b is the common version released in the west and available for the c64. the third version 02c, has some changes in the code "
	.text "where the rat changes direction, but i suspect this was only done to make it run in ram when it was ripped from the cartridge. "
	.null "it has been included for completeness but i don't think there is any difference. please let us know if you find one."
help_roadrace
	.text "     "
	.text "road race allows you to use joystick, paddles and keys ", "a"+128, ", ", "l"+128, " and ", ";"+128
	.text " but using paddles is much easier. the only obvious difference between the two versions is the engine noise "
	.null "as v.01 has a much 'throatier' rumble."
help_seawolf
	.text "     "
	.text "seawolf is a paddles only game. the instructions are included in-game. it always starts in 2 player mode even "
	.null "if only 1 person is playing. this is the only known version."
help_slalom
	.text "     "
	.text "slalom, also known as ski or skier, is one of the best games available for the MAX, "
	.text "and its also the biggest, using the area from 8000-91a0 for a total of 12.4k. "
	.null "use joystick or keys; ", "a"+128, " to accelerate", ", ", "l"+128, " and ", ";"+128, " to turn."
help_bingomath
	.text "     "
	.text "speed / bingo math is actually 2 games in 1. speed math is played on the keyboard where the player has to answer "
	.text "simple math problems as quickly as possible. bingo math is played using joysticks and is the only MAX compatible game "
	.text "to make use of a joystick in port 2 for the second player. the idea is to make a row from top to bottom or side to side of "
	.null "correct answers."
help_superalien
	.text "     "
	.text "dig holes to catch the super aliens and fill them in again to safely dispose of them. "
	.text "using the joystick hold fire and push left to dig a hole and fire and right to fill it in again. "
	.text "with keys, ", "a"+128, "digs a hole and ", "d"+128, " fills it. maybe this is the spiritual predecessor "
	.null "to lode runner?"
help_vss
	.text "     "
	.text "visible solar system is an educational program that allows you to explore the solar system. "
	.text "read the full instructions at: <http://inchocks.co.uk/commodore/multimax/vss.pdf> "
	.text "in summary, ", "o"+128, " returns to orbits, cursor and arrow keys move ship destination, ", "g"+128, " goes there, "
	.null "s"+128, " and ", "a"+128, " are animations, ", "p"+128, " gives planet close-ups and ", "1"+128, "-", "6"+128, " gives detailed planet stats."
help_wizardwor
	.text "     "
	.text "the MAX version of wizard of wor is very different to the c64 classic. there is no 2-player "
	.text "option here, the legendary sound is missing and the game just doesn't flow. "
	.null "the 2 MAX versions have some map differences and the copyright messages are different."
.enc none

.here

*=$e000
.byte $4C,$FD,$E0,$4C,$2F,$E1,$4C,$77,$E1,$2D,$4D,$55,$53,$49,$43,$20 
.byte $42,$59,$20,$4A,$4F,$41,$43,$48,$49,$4D,$20,$57,$49,$4A,$4E,$48 
.byte $4F,$56,$45,$4E,$2E,$20,$50,$4C,$41,$59,$45,$52,$20,$42,$59,$20 
.byte $52,$4F,$4C,$41,$4E,$44,$20,$48,$45,$52,$4D,$41,$4E,$53,$2D,$00 
.byte $1C,$2D,$3F,$52,$66,$7B,$92,$AA,$C3,$DE,$FA,$18,$38,$5A,$7E,$A4 
.byte $CC,$F7,$24,$54,$86,$BC,$F5,$31,$71,$B4,$FC,$48,$98,$ED,$48,$A7 
.byte $0C,$78,$E9,$62,$E2,$69,$F8,$90,$30,$DB,$8F,$4E,$19,$F0,$D3,$C4 
.byte $C3,$D1,$F0,$1F,$61,$B6,$1E,$9D,$32,$DF,$A6,$88,$86,$A3,$E0,$3F 
.byte $C2,$6B,$3D,$3A,$64,$BE,$4C,$0F,$0C,$46,$BF,$7D,$84,$D6,$7A,$73 
.byte $C8,$7D,$97,$1E,$18,$8B,$7F,$FB,$07,$AC,$F4,$E7,$8F,$F9,$00,$01 
.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02 
.byte $02,$03,$03,$03,$03,$03,$04,$04,$04,$04,$05,$05,$05,$06,$06,$07 
.byte $07,$07,$08,$08,$09,$09,$0A,$0B,$0B,$0C,$0D,$0E,$0E,$0F,$10,$11 
.byte $12,$13,$15,$16,$17,$19,$1A,$1C,$1D,$1F,$21,$23,$25,$27,$2A,$2C 
.byte $2F,$32,$35,$38,$3B,$3F,$43,$47,$4B,$4F,$54,$59,$5E,$64,$6A,$70 
.byte $77,$7E,$86,$8E,$96,$9F,$A8,$B3,$BD,$C8,$D4,$E1,$EE,$0A,$0A,$0A 
.byte $AA,$20,$77,$E1,$86,$85,$BD,$EA,$E4,$85,$83,$BD,$EB,$E4,$85,$82 
.byte $A9,$F1,$8D,$17,$D4,$A9,$0F,$85,$84,$A9,$00,$A2,$68,$95,$86,$CA 
.byte $D0,$FB,$85,$80,$A2,$15,$9D,$00,$D4,$CA,$10,$FA,$85,$81,$60,$A6 
.byte $81,$D0,$FB,$A5,$80,$F0,$0C,$C6,$DF,$10,$08,$85,$DF,$A5,$84,$F0 
.byte $36,$C6,$84,$C6,$DE,$10,$06,$A5,$82,$85,$DE,$D0,$0E,$C6,$EE,$10 
.byte $0A,$A5,$83,$85,$EE,$C6,$8C,$C6,$93,$C6,$9A,$A5,$84,$05,$E8,$8D 
.byte $18,$D4,$20,$6C,$E1,$A2,$07,$20,$6C,$E1,$A2,$0E,$B5,$8C,$30,$15 
.byte $B5,$CA,$10,$10,$4C,$13,$E3,$A9,$08,$8D,$04,$D4,$8D,$0B,$D4,$8D 
.byte $12,$D4,$85,$81,$60,$95,$DD,$95,$CA,$A9,$00,$9D,$01,$D4,$9D,$00 
.byte $D4,$95,$CB,$95,$9E,$95,$B2,$95,$B3,$95,$B5,$A9,$01,$95,$C6,$95 
.byte $B6,$BD,$9E,$E0,$0A,$65,$85,$A8,$B9,$E4,$E4,$85,$F1,$B9,$E5,$E4 
.byte $85,$F2,$B4,$87,$B1,$F1,$10,$2C,$C9,$A0,$B0,$08,$29,$1F,$95,$89 
.byte $F6,$87,$D0,$EE,$C9,$FE,$90,$08,$F0,$AD,$B5,$88,$95,$87,$B0,$E2 
.byte $C9,$FD,$90,$08,$C8,$98,$95,$87,$95,$88,$D0,$D8,$69,$40,$95,$9C 
.byte $F6,$87,$D0,$CE,$0A,$A8,$B9,$FC,$E4,$85,$EF,$B9,$FD,$E4,$85,$F0 
.byte $B4,$8A,$B1,$EF,$30,$07,$C9,$60,$B0,$41,$4C,$88,$E2,$C9,$FF,$D0 
.byte $0E,$A9,$00,$95,$8A,$D6,$89,$10,$E7,$95,$89,$F6,$87,$D0,$A3,$C9 
.byte $C0,$B0,$17,$29,$3F,$95,$8B,$C8,$B1,$EF,$10,$DA,$C9,$C0,$B0,$DD 
.byte $29,$3F,$38,$75,$8B,$95,$8B,$C8,$D0,$C8,$C9,$E0,$B0,$15,$0A,$0A 
.byte $0A,$95,$8D,$84,$86,$A8,$B9,$54,$E5,$A4,$86,$29,$1F,$0A,$95,$B4 
.byte $C8,$D0,$AF,$C9,$FB,$90,$1A,$D0,$05,$95,$CB,$C8,$D0,$A4,$C8,$C9 
.byte $FD,$F0,$19,$B1,$EF,$90,$05,$85,$83,$C8,$D0,$96,$85,$80,$C8,$D0 
.byte $91,$29,$1F,$95,$8C,$95,$CA,$C8,$98,$95,$8A,$60,$A9,$00,$95,$A0 
.byte $B1,$EF,$0A,$36,$A0,$0A,$36,$A0,$0A,$36,$A0,$95,$9F,$C8,$B1,$EF 
.byte $18,$75,$9C,$95,$9E,$C8,$B1,$EF,$18,$75,$9C,$95,$9D,$C8,$98,$95 
.byte $8A,$B4,$9D,$B9,$3F,$E0,$95,$A1,$B9,$9E,$E0,$95,$A2,$B5,$8B,$95 
.byte $8C,$B4,$8D,$B9,$5A,$E5,$29,$0F,$4A,$69,$00,$95,$B1,$B9,$55,$E5 
.byte $95,$B7,$F0,$14,$A8,$18,$79,$23,$E6,$95,$CC,$B9,$24,$E6,$A8,$29 
.byte $0F,$95,$C9,$98,$29,$F0,$95,$C8,$B4,$8D,$B9,$57,$E5,$9D,$05,$D4 
.byte $B9,$58,$E5,$9D,$06,$D4,$B9,$56,$E5,$A8,$18,$69,$01,$95,$DC,$79 
.byte $6D,$E6,$95,$DB,$B9,$6E,$E6,$9D,$04,$D4,$8A,$D0,$25,$A4,$8D,$B9 
.byte $59,$E5,$85,$E0,$D0,$08,$A9,$10,$85,$E8,$A9,$FF,$D0,$0F,$A8,$A9 
.byte $01,$85,$E1,$B9,$86,$E6,$29,$F0,$85,$E8,$B9,$87,$E6,$85,$EC,$8D 
.byte $16,$D4,$60,$B4,$8D,$B9,$5A,$E5,$85,$E6,$B9,$5B,$E5,$85,$E7,$A4 
.byte $EE,$D0,$12,$4A,$4A,$4A,$4A,$C9,$0F,$F0,$04,$D5,$8C,$90,$06,$B5 
.byte $CB,$09,$FE,$95,$DD,$B4,$9E,$F0,$4A,$B5,$9D,$D5,$9E,$B5,$A1,$90 
.byte $29,$F5,$9F,$95,$A1,$B5,$A2,$F5,$A0,$95,$A2,$B5,$A1,$D9,$3F,$E0 
.byte $B5,$A2,$F9,$9E,$E0,$B0,$29,$98,$95,$9D,$B9,$3F,$E0,$95,$A1,$B9 
.byte $9E,$E0,$95,$A2,$A9,$00,$95,$9E,$F0,$16,$75,$9F,$95,$A1,$B5,$A2 
.byte $75,$A0,$95,$A2,$B5,$A1,$D9,$3F,$E0,$B5,$A2,$F9,$9E,$E0,$B0,$D7 
.byte $4C,$4A,$E4,$B4,$B4,$F0,$4E,$D6,$B5,$10,$4A,$B9,$EA,$E5,$85,$EF 
.byte $B9,$EB,$E5,$85,$F0,$A0,$00,$B1,$EF,$85,$E5,$4A,$4A,$4A,$4A,$29 
.byte $07,$95,$B5,$B4,$B6,$B1,$EF,$C9,$FE,$90,$0D,$F0,$28,$A5,$E5,$29 
.byte $0F,$69,$00,$95,$B6,$A8,$B1,$EF,$24,$E5,$10,$04,$95,$A1,$30,$11 
.byte $C9,$80,$B0,$02,$75,$9D,$29,$7F,$A8,$B9,$3F,$E0,$95,$A1,$B9,$9E 
.byte $E0,$95,$A2,$F6,$B6,$A5,$E6,$F0,$09,$A5,$E7,$29,$0F,$38,$F5,$8B 
.byte $75,$8C,$10,$66,$B4,$9D,$B9,$3F,$E0,$38,$F9,$3E,$E0,$85,$EF,$B9 
.byte $9E,$E0,$F9,$9D,$E0,$85,$F0,$A5,$E6,$29,$70,$F0,$0F,$4A,$4A,$4A 
.byte $4A,$A8,$A5,$F0,$4A,$66,$EF,$88,$D0,$FA,$85,$F0,$A5,$E6,$10,$13 
.byte $B5,$B3,$C9,$58,$B0,$04,$69,$02,$95,$B3,$18,$65,$EF,$85,$EF,$90 
.byte $02,$E6,$F0,$D6,$B1,$10,$08,$A5,$E6,$29,$0F,$95,$B1,$F6,$B2,$B5 
.byte $B2,$4A,$B5,$A1,$B0,$0A,$65,$EF,$95,$A1,$B5,$A2,$65,$F0,$90,$08 
.byte $E5,$EF,$95,$A1,$B5,$A2,$E5,$F0,$95,$A2,$8A,$D0,$28,$A4,$E0,$F0 
.byte $24,$C6,$E1,$D0,$16,$B9,$88,$E6,$C9,$FF,$D0,$04,$86,$E0,$F0,$15 
.byte $85,$E1,$C8,$B9,$88,$E6,$85,$ED,$C8,$84,$E0,$18,$A5,$EC,$65,$ED 
.byte $85,$EC,$8D,$16,$D4,$B4,$B7,$F0,$3C,$D6,$C6,$D0,$17,$B9,$25,$E6 
.byte $C9,$FF,$D0,$04,$B4,$CC,$B0,$F5,$95,$C7,$C8,$B9,$25,$E6,$95,$C6 
.byte $C8,$98,$95,$B7,$B5,$C7,$0A,$B0,$08,$75,$C8,$90,$0E,$F6,$C9,$B0 
.byte $0A,$85,$EF,$B5,$C8,$E5,$EF,$B0,$02,$D6,$C9,$95,$C8,$9D,$02,$D4 
.byte $B5,$C9,$9D,$03,$D4,$B4,$DC,$B9,$6D,$E6,$C9,$F0,$90,$12,$C9,$FF 
.byte $F0,$09,$29,$0F,$D5,$8C,$90,$11,$C8,$B0,$02,$B4,$DB,$B9,$6D,$E6 
.byte $35,$DD,$9D,$04,$D4,$C8,$98,$95,$DC,$B5,$A2,$9D,$01,$D4,$B5,$A1 
.byte $9D,$00,$D4,$60,$A4,$E6,$B7,$E6,$CD,$E6,$04,$00,$E3,$E6,$E5,$E6 
.byte $E8,$E6,$06,$00,$EB,$E6,$EE,$E6,$F1,$E6,$06,$00,$E4,$EA,$F4,$E6 
.byte $F8,$E6,$16,$E7,$36,$E7,$83,$E7,$D5,$E7,$D7,$E7,$FB,$E7,$1D,$E8 
.byte $3F,$E8,$59,$E8,$6E,$E8,$75,$E8,$9A,$E8,$D4,$E8,$FA,$E8,$21,$E9 
.byte $2C,$E9,$3A,$E9,$47,$E9,$52,$E9,$5D,$E9,$6B,$E9,$78,$E9,$84,$E9 
.byte $96,$E9,$A9,$E9,$C3,$E9,$D9,$E9,$00,$EA,$25,$EA,$4C,$EA,$51,$EA 
.byte $5C,$EA,$6A,$EA,$77,$EA,$82,$EA,$8D,$EA,$9B,$EA,$A8,$EA,$B4,$EA 
.byte $C6,$EA,$DC,$EA,$00,$02,$03,$00,$99,$02,$00,$20,$00,$07,$00,$00 
.byte $B9,$07,$54,$10,$06,$10,$06,$08,$88,$10,$00,$00,$07,$19,$0D,$08 
.byte $08,$00,$00,$00,$00,$1E,$00,$09,$B9,$00,$44,$02,$00,$25,$00,$09 
.byte $BA,$00,$44,$12,$00,$2C,$00,$08,$89,$00,$00,$10,$00,$35,$00,$00 
.byte $99,$00,$00,$10,$00,$1E,$00,$08,$89,$00,$44,$12,$00,$1E,$00,$08 
.byte $89,$00,$44,$12,$00,$19,$13,$00,$FB,$00,$43,$72,$00,$2C,$00,$08 
.byte $89,$00,$00,$10,$00,$35,$00,$00,$89,$00,$34,$23,$00,$1E,$00,$08 
.byte $89,$00,$44,$12,$00,$1E,$00,$08,$89,$00,$44,$12,$00,$19,$00,$00 
.byte $99,$00,$43,$12,$08,$3E,$17,$08,$89,$19,$00,$00,$00,$1E,$00,$09 
.byte $89,$00,$44,$02,$05,$43,$00,$00,$AA,$00,$54,$10,$FC,$E5,$01,$E6 
.byte $06,$E6,$0B,$E6,$10,$E6,$14,$E6,$1B,$E6,$21,$E6,$20,$00,$03,$08 
.byte $FF,$20,$00,$05,$09,$FF,$20,$00,$02,$07,$FF,$20,$00,$04,$07,$FF 
.byte $40,$0C,$00,$FF,$00,$DE,$A0,$98,$80,$00,$FE,$00,$DE,$A8,$A0,$DE 
.byte $FE,$00,$0C,$00,$FE,$00,$04,$10,$00,$FF,$02,$00,$19,$01,$20,$56 
.byte $60,$03,$FF,$04,$08,$00,$02,$7F,$04,$A8,$00,$FF,$00,$08,$00,$00 
.byte $FF,$00,$CE,$90,$40,$10,$40,$FF,$00,$CE,$90,$18,$10,$18,$FF,$02 
.byte $00,$19,$01,$20,$56,$60,$03,$FF,$00,$BC,$18,$0E,$98,$1C,$18,$0E 
.byte $FF,$00,$0C,$A8,$00,$FF,$00,$0C,$10,$18,$90,$18,$FF,$00,$41,$FF 
.byte $00,$21,$FF,$04,$81,$41,$41,$41,$40,$FF,$03,$81,$41,$41,$81,$FF 
.byte $01,$41,$11,$FF,$01,$41,$40,$FF,$30,$AE,$30,$FF,$FF,$10,$A0,$03 
.byte $F0,$01,$C0,$10,$FF,$FF,$10,$FF,$04,$00,$01,$79,$00,$FC,$FF,$10 
.byte $78,$00,$FC,$FF,$01,$02,$03,$01,$04,$05,$04,$05,$06,$07,$08,$07 
.byte $09,$07,$08,$07,$09,$01,$FF,$0C,$0D,$0E,$01,$B4,$0F,$10,$0F,$10 
.byte $06,$CC,$11,$12,$13,$14,$C0,$15,$16,$17,$18,$01,$FF,$C0,$2B,$1B 
.byte $1C,$01,$CC,$1D,$1E,$1F,$1E,$20,$C0,$21,$22,$23,$24,$25,$26,$27 
.byte $28,$01,$FF,$0A,$FE,$B4,$19,$FE,$B4,$29,$FE,$B4,$0B,$FE,$B4,$1A 
.byte $FE,$B4,$2A,$FE,$FE,$03,$E7,$FF,$C0,$87,$61,$40,$3B,$8F,$62,$37 
.byte $87,$61,$40,$3B,$8F,$62,$37,$87,$61,$40,$3B,$8F,$62,$37,$87,$61 
.byte $40,$3B,$8F,$62,$37,$FF,$C0,$87,$61,$40,$62,$3E,$8F,$61,$40,$87 
.byte $34,$62,$32,$8F,$61,$34,$87,$40,$62,$3E,$8F,$61,$40,$87,$63,$41 
.byte $62,$3E,$8F,$61,$40,$FF,$FE,$06,$E5,$C1,$81,$29,$C0,$61,$39,$C1 
.byte $24,$C0,$61,$39,$C1,$29,$C0,$61,$39,$C1,$24,$C0,$61,$39,$C1,$2E 
.byte $C0,$64,$3A,$C1,$29,$C0,$64,$3A,$C1,$2E,$C0,$64,$3A,$C1,$29,$C0 
.byte $64,$3A,$C1,$2B,$C0,$64,$3C,$C1,$24,$C0,$64,$3C,$C1,$2B,$C0,$64 
.byte $3C,$C1,$24,$C0,$64,$3C,$C1,$29,$C0,$61,$39,$C1,$24,$C0,$64,$3C 
.byte $C1,$2B,$FF,$C0,$81,$64,$3C,$C1,$24,$C0,$64,$3C,$C1,$29,$C0,$61 
.byte $39,$C1,$24,$C0,$61,$39,$C1,$29,$C0,$61,$39,$C1,$24,$C0,$61,$39 
.byte $C1,$2E,$C0,$64,$3A,$C1,$29,$C0,$64,$3A,$C1,$2E,$C0,$64,$3A,$C1 
.byte $29,$C0,$64,$3A,$C1,$2B,$C0,$64,$3C,$C1,$24,$C0,$64,$3C,$C1,$2B 
.byte $C0,$64,$3C,$C1,$24,$C0,$64,$3C,$C1,$29,$C0,$61,$39,$C1,$24,$C0 
.byte $61,$39,$C1,$29,$FF,$E3,$FF,$FE,$04,$C2,$81,$22,$D0,$22,$C3,$00 
.byte $D0,$22,$C2,$2E,$D0,$22,$C3,$00,$D0,$2E,$C2,$22,$D0,$22,$C3,$00 
.byte $D0,$22,$C2,$2E,$D0,$22,$C3,$00,$D0,$2E,$FF,$C2,$81,$1D,$D0,$1D 
.byte $C3,$00,$D0,$1D,$C2,$29,$D0,$1D,$C3,$00,$D0,$29,$C2,$1D,$D0,$1D 
.byte $C3,$00,$D0,$1D,$C2,$29,$D0,$1D,$C3,$00,$D0,$29,$FF,$C2,$81,$1D 
.byte $D0,$1D,$C3,$00,$D0,$1D,$C2,$29,$D0,$1D,$C3,$00,$D0,$29,$C2,$22 
.byte $D0,$2E,$C3,$00,$D0,$22,$C2,$2E,$D0,$2E,$C3,$00,$D0,$2E,$FF,$C1 
.byte $81,$29,$C0,$61,$39,$C1,$24,$C0,$61,$39,$C1,$2E,$C0,$64,$3A,$C1 
.byte $2B,$C0,$64,$3C,$C1,$87,$29,$E7,$FF,$D1,$83,$35,$81,$32,$30,$2E 
.byte $2D,$2E,$3A,$35,$36,$2E,$82,$31,$8B,$2A,$92,$29,$E7,$FF,$C4,$81 
.byte $2B,$2D,$2F,$30,$FF,$C4,$87,$34,$32,$8F,$30,$87,$34,$32,$30,$81 
.byte $30,$32,$34,$35,$87,$37,$85,$35,$81,$35,$8F,$34,$87,$37,$85,$35 
.byte $81,$35,$87,$34,$81,$35,$37,$39,$3B,$FF,$C4,$85,$3C,$81,$3C,$82 
.byte $3B,$39,$81,$3B,$85,$3C,$81,$37,$85,$37,$81,$37,$85,$3C,$81,$3C 
.byte $82,$3B,$39,$81,$3B,$85,$3C,$81,$37,$85,$37,$81,$37,$85,$3C,$81 
.byte $3C,$82,$3B,$39,$81,$3B,$85,$3C,$81,$37,$85,$37,$81,$37,$87,$34 
.byte $32,$8F,$30,$FF,$C5,$81,$3C,$41,$43,$83,$45,$81,$45,$46,$83,$48 
.byte $81,$48,$4D,$83,$4C,$85,$4A,$81,$48,$46,$45,$83,$43,$81,$43,$45 
.byte $83,$46,$81,$48,$46,$83,$45,$85,$43,$FF,$C5,$81,$40,$41,$43,$83 
.byte $45,$81,$45,$46,$83,$48,$81,$48,$4D,$83,$4F,$85,$4A,$81,$4A,$4C 
.byte $4A,$83,$48,$81,$46,$45,$83,$43,$81,$45,$43,$83,$41,$3C,$81,$41 
.byte $FF,$C6,$87,$35,$85,$32,$81,$33,$87,$35,$2E,$FF,$C6,$81,$30,$32 
.byte $33,$35,$83,$33,$32,$30,$30,$30,$30,$FF,$C6,$81,$32,$33,$35,$37 
.byte $83,$35,$35,$87,$3A,$35,$FF,$C6,$83,$33,$32,$85,$30,$81,$2E,$8F 
.byte $2E,$FF,$C7,$87,$41,$85,$3E,$81,$3F,$87,$41,$3A,$FF,$C7,$81,$3C 
.byte $3E,$3F,$41,$83,$3F,$3E,$3C,$3C,$3C,$3C,$FF,$C7,$81,$3E,$3F,$41 
.byte $43,$83,$41,$41,$87,$46,$41,$FF,$C7,$83,$3F,$3E,$85,$3C,$81,$3A 
.byte $87,$3A,$46,$FF,$C8,$82,$41,$80,$43,$81,$45,$48,$4A,$46,$80,$48 
.byte $82,$43,$87,$48,$E7,$FF,$C9,$81,$45,$45,$85,$45,$81,$48,$41,$4A 
.byte $45,$83,$46,$82,$44,$9E,$41,$E7,$FF,$D2,$87,$24,$2B,$24,$81,$1F 
.byte $21,$83,$23,$87,$24,$2B,$8F,$24,$87,$28,$26,$8F,$28,$87,$28,$26 
.byte $8F,$24,$FF,$D2,$87,$24,$2B,$8F,$24,$87,$24,$2B,$8F,$24,$87,$24 
.byte $26,$8F,$28,$87,$26,$2B,$8F,$24,$FF,$E0,$CF,$81,$24,$29,$2B,$83 
.byte $2D,$81,$2D,$2E,$83,$30,$81,$30,$35,$83,$34,$85,$32,$81,$30,$2E 
.byte $2D,$83,$2B,$81,$2B,$2D,$83,$2E,$81,$30,$2E,$83,$2D,$85,$2B,$FF 
.byte $CF,$81,$28,$29,$2B,$83,$2D,$81,$2D,$2E,$83,$30,$81,$30,$35,$83 
.byte $37,$85,$32,$81,$32,$34,$32,$83,$30,$81,$2E,$2D,$83,$2B,$81,$2D 
.byte $2B,$83,$29,$24,$FF,$CF,$81,$29,$24,$29,$2B,$83,$2D,$81,$2D,$2E 
.byte $83,$30,$81,$30,$35,$83,$34,$85,$32,$81,$30,$2E,$2D,$83,$2B,$81 
.byte $2B,$2D,$83,$2E,$81,$30,$2E,$83,$2D,$85,$2B,$FF,$CF,$80,$29,$E3 
.byte $FF,$CB,$87,$3E,$85,$3A,$81,$3C,$87,$3E,$35,$FF,$CB,$81,$39,$3A 
.byte $3C,$3E,$83,$3C,$3A,$39,$35,$37,$39,$FF,$CB,$81,$3A,$3C,$3E,$3F 
.byte $83,$3E,$3E,$87,$41,$3E,$FF,$CB,$83,$3C,$3A,$85,$39,$81,$35,$8F 
.byte $35,$FF,$CC,$87,$3E,$85,$3A,$81,$3C,$87,$3E,$35,$FF,$CC,$81,$39 
.byte $3A,$3C,$3E,$83,$3C,$3A,$39,$35,$37,$39,$FF,$CC,$81,$3A,$3C,$3E 
.byte $3F,$83,$3E,$3E,$87,$41,$3E,$FF,$CC,$83,$3C,$3A,$85,$39,$81,$35 
.byte $87,$35,$41,$FF,$CD,$82,$45,$80,$46,$81,$48,$4D,$4F,$4A,$80,$4C 
.byte $82,$48,$87,$4D,$E7,$FF,$CE,$81,$48,$48,$48,$83,$4D,$81,$4C,$4A 
.byte $4D,$48,$83,$49,$82,$48,$8B,$46,$92,$48,$E7,$FF,$E0,$CF,$81,$2B 
.byte $2D,$82,$2F,$FF,$EF,$EF,$FF

start
	sei
	ldx #$ff
	txs
	cld

	; initialise CIA's CIA2 at DD00 will not be present on a MAX
	lda #$7f
	sta $dc0d		; clear all interrupt sources for CIA's
	sta $dd0d
	lda $dc0d		; and acknowlege any existing ones
	lda $dd0d
	
	ldx #$00
	stx $dc02		; port B - input
	stx $dc03		; port B - input

	stx $dc0f		; default control register B
	lda #$08
	sta $dc0e		; default control register A

	ldx #$1d
-	lda vic_registers,x
	sta vic_base+$11,x
	dex
	bpl -
	inx
	
	; check RAM from 0000 to 07FF
	jmp low_ram_test

begin_main
	ldy #$00		; reset screen with black background
	jsr reset_screen

	; this will trigger a logo display when it drops into the main loop
	lda #$02
	sta $31
	sta $2f
	
	; print the cartridge names
+	ldx #$02
-	stx $03
	lda cart_list,x
	ldy cart_list+1,x
	tax
	lda #(lightgrey << 4) + lightblue
	jsr print_msg
	ldx $03
	cpx #(num_carts)*2
	beq +
	inx
	inx
	bne -
	
+	lda #$40	; paddles port 1
	sta $dc00

	; currently selected row
	jsr highlight_row

	; set text colour on scrolly row
	lda #lightgrey
	ldx #$02
-	sta colour_ram+( 24 * rows),x
	inx
	cpx #$25
	bne -
	; fade the colour at the edges
	lda #medgrey
	sta colour_ram+( 24 * rows)+1
	sta colour_ram+( 24 * rows)+37
	lda #darkgrey
	sta colour_ram+( 24 * rows)+0
	sta colour_ram+( 24 * rows)+38
	
	lda #<help_def
	sta $29
	sta $2b
	lda #>help_def
	sta $2a
	sta $2c
	
	lda #msg_show_count
	sta $02
	
	jsr sprite_setup

	lda #$00			; initialise with tune 0
	jsr music_init
	
	cli
	
main_loop
	lda $31		; this flag will be set by the interupt routine roughly every 10 seconds
	beq +
	lda #$00
	sta $31
	jsr print_logo
	
+	lda $d419	; paddle 1
	cmp #$ff
	beq no_paddle
	sta $0b		; store read value
	inc $0a		; increment pointer to read value table
	ldy $0a
	lda $0d		; subtract oldest value from total
	sec
	sbc $0300,y
	sta $0d
	lda $0c
	sbc #$00
	sta $0c
	lda $0d		; add new value to total
	clc
	adc $0b
	sta $0d
	lda $0c
	adc #$00
	sta $0c
	lda $0b		; store the new value back in the table
	sta $0300,y
	lda $0c		; the 'rolling average' value is the high byte of the sum as we have 256 values

set_paddle_row	
	sta $09		; divide read paddle value by 7, giving a value from 0 -> 36
	lda #$00
	ldx #$07
	clc
-	rol $09
	rol
	cmp #$07		; divide value by 7 
	bcc +
	sbc #$07		; divide value by 7 
+	dex
	bpl -
	rol $09			; here $09 contains 0-36
	
	inc $09			; our rows start at 1, giving 1-37
	lda $09
	cmp #num_carts+1	; if its >= 36...
	bcc +
	lda #num_carts		; ...set to 35
+	cmp $05			; is the value same as last time?
	beq +
	sta $08			; if not, highlight the new row
	jsr highlight_row	
+	jsr get_input	; lets check if paddle fire buttons are active
	cmp #$84
	beq +
	cmp #$88
	beq +
	jmp main_loop
+	jmp pre_boot_cart

no_paddle
	jsr get_input
	bne +			; anything pressed?
	ldx #$00		; small delay if not
	stx $0e
-	dex
	bne -
	jmp main_loop	; and loop

	; only if the input remains constant for a number of cycles to we consider it genuine
+	cmp $0e			; $0e is what we saw last time...
	beq +			; if it's the same...
	sta $0e			; otherwise reset the last seen value
	ldx #$03		; and initialise the counter
	stx $0f
+	dec $0f			; decrement the counter
	beq +			; and if its been stable for ^^ cycles we consider it input
	lda #$00		; else we don't
+	tay
	and #$c0		; joystick input?
	bne +
	jmp no_joystick
+	ldx $05			; get current row

joy_down
	tya
	and #$02		; down
	beq joy_up
	inx
	cpx #num_carts+1	; have we gone past row 35?
	bne +
	ldx #$01		; go to 1
+	jmp end_joystick

joy_up
	tya
	and #$01		; up
	beq joy_left_right
	dex
	bne +
	ldx #num_carts
+	jmp end_joystick

joy_left_right
	tya
	and #$0c		; left or right
	beq joy_fire
	cpx #$13		
	bcc +
	txa			; current row is >=19
	sec
	sbc #$12
	tax
	jmp end_joystick
+	txa			; current row < 19
	clc
	adc #$12
	cmp #num_carts+1		; if its >= 35...
	bcc +
	lda #num_carts		; ...set to 34
+	tax
	jmp end_joystick
	
joy_fire
	tya
	and #$10
	beq no_joystick
	jmp pre_boot_cart
	
end_joystick
	stx $08
	jsr highlight_row
	ldy #$80
	ldx #$00
-	dex
	bne -
	dey
	bne -
	jmp main_loop

no_joystick	
	cpy #$00
	beq end_main_loop
	lda keyboard_matrix,y
	beq end_main_loop

	cmp #$30
	bcs +
	sta $08				; process an image selection
	jsr highlight_row
	jmp main_loop
	
+	bne check_f_keys		; $30 is back arrow, toggle music on/off
	lda $1a
	bne +
	jsr music_stop
	lda #$01
	sta $1a 
	jmp delay_main_loop
+	lda #$00
	sta $1a
	jsr music_init
delay_main_loop
	ldx #$00
	ldy #$00
-	dex
	bne -
	dey
	bne -
	jmp main_loop
		
check_f_keys
	cmp #$31	; F1 - reset the help message
	bne +
	lda #<help_def
	sta $29
	sta $2b
	lda #>help_def
	sta $2a
	sta $2c
	
	lda #message_fade_init	; trigger fade out of old message
	sta $12
	
	jmp main_loop
	
+	cmp #$33	; F3 - testing
	beq start_stress_test

	cmp #$35	; F5 - EXRAM testing
	beq start_exram
	
	cmp #$37	; sidbench
	beq start_sidbench
	
	cmp #$40	; Return - start a new image
	beq start_image

	cmp #$41	; SPACE - start a new image
	beq start_image

end_main_loop
	jmp main_loop

start_image
	jmp pre_boot_cart

start_exram
	sei
	jsr music_stop
	jmp test_exram

start_stress_test
	sei
	jsr music_stop
	jmp stress_test

start_sidbench
	lda #$24
	sta $05
	jsr music_stop
	jmp pre_boot_cart

get_input
	lda #$00	; configure both ports as input
	sta $dc02
	nop
	nop
	lda $dc00	; check joy port 2 (cia #1, port a)
	and #$1f	; only interested in joystick
	eor #$1f	; are any selected?
	beq +
	ora #$40	; set bit 6 on returned value to indicate joystick 2
	rts
+	lda $dc01	; check joy port 1 (cia #1, port b)
	and #$1f	; only interested in joystick
	eor #$1f	; are any selected?
	beq +
	ora #$80	; set bit 7 on returned value to indicate joystick 1
	rts
+	lda #$ff
	sta $dc02	; configure port A as output (KB columns)
	lda #$80
	clc
do_kb_column
	tay
	eor #$ff
	sta $dc00	; strobe column
	nop
	lda $dc01	; read input
	eor #$ff
	beq next_column
	tax			; key maybe pressed, recheck joysticks
	lda #$00	; configure both ports as input
	sta $dc02
	nop
	nop
	lda $dc00
	and #$1f
	eor #$1f
	beq +
	ora #$40
	rts
+	lda $dc01
	and #$1f
	eor #$1f
	beq +
	ora #$80
	rts
+	txa			; no joystick, KB must be pressed
	jmp key_pressed

next_column
	tya			; check next keyboard column
	lsr
	bcc do_kb_column
	ldy #$ff
	sty $dc00
	iny
	sta $dc02
	lda #$00
	rts
	
key_pressed			; a contains row, y contains column
	tax
	tya
	ldy #$ff		; x contains row, a contains column
-	iny				; count which column bit is set
	lsr				; a value from $00-$07
	bcc -
	tya				
	asl				; shift that value 3 bits left...
	asl
	asl
	tay
	txa				; then count which row was selected (0-7)
	dey				; and add that to the result
-	iny				; leaving a 6-bit value showing which key was pressed
	lsr
	bcc -
	tya
	rts

highlight_row
	lda $05		; find the pointer to the old message and print it
	beq skip_oldrow
	
	asl
	tax
	lda cart_list,x
	ldy cart_list+1,x
	tax
	lda #(lightgrey << 4) + lightblue
	jsr print_msg

skip_oldrow
	lda $08		; highlight the new row
	sta $05
	beq skip_oldrow2
	
	asl
	tax
	lda cart_list,x
	ldy cart_list+1,x
	tax
	lda #(yellow << 4) + yellow
	jsr print_msg

skip_oldrow2	
	ldx $08		; enable the appropriate controller icons
	lda sp_enable
	and #$1f
	ora controller_table,x
	sta sp_enable
	
	txa		; multiply the value by 2 to get an index to the lookup table
	asl
	tax
	lda help_table,x	; get the new index value
	tay
	lda help_table+1,x
	cpy $29				; and only reset it if it is a completely different game
	bne +
	cmp $2a
	beq hr_exit
+	sty $29				; reset the scroller 'reset' address
	sta $2a
	sty $2b				; reset the current address
	sta $2c
	lda #msg_show_count	; reset the number of times shown
	sta $02
	lda #message_fade_init
	sta $12		; trigger fade out

hr_exit
	rts

pre_boot_cart
	sei
	lda $05
	bne +
	jmp main_loop
	
+	jsr music_stop
	jsr reset_vic
	
	lda $05
	asl
	tax
	lda cart_checksums,x
	sta $03
	inx
	lda cart_checksums,x
	sta $04

	ldx #>reloc_boot_cart	; transfer booter handler into lo ram
	ldy #<reloc_boot_cart
	lda #>boot_cart
	jsr trans

	ldx #>reloc_crc_lo		; transfer crc_tables int lo ram
	ldy #<reloc_crc_lo
	lda #>crc_lo
	jsr trans

	ldx #>reloc_crc_hi
	ldy #<reloc_crc_hi
	lda #>crc_hi
	jsr trans
	
	jmp boot_cart

print_logo
	lda $30
	beq show_multimax

logo_base = screen_ram + 5
logo_col_base = logo_base + $d400

show_maxmachine
 	ldx #29
-	lda mlogo_1,x
	sta logo_base,x
	lda mlogo_2,x
	sta logo_base + 40,x
	lda mlogo_3,x
	sta logo_base + 80,x
	lda mlogo_4,x
	sta logo_base + 120,x
	lda #red
	sta logo_col_base,x
	sta logo_col_base + 40,x
	sta logo_col_base + 80,x
	sta logo_col_base + 120,x
	dex
	bpl -
	lda #$00
	sta $30
	rts	

show_multimax
 	ldx #29
-	lda logo_1,x
	sta logo_base,x
	lda logo_2,x
	sta logo_base + 40,x
	lda logo_3,x
	sta logo_base + 80,x
	lda logo_4,x
	sta logo_base + 120,x
	lda #blue
	sta logo_col_base,x
	lda #lightblue
	sta logo_col_base + 40,x
	lda #cyan
	sta logo_col_base + 80,x
	lda #lightgrey
	sta logo_col_base + 120,x
	dex
	bpl -
	lda #$01
	sta $30
	rts
	
reset_vic
	sei			; disable interrupts
	ldx #$00
	stx $d01a	; turn off interrupt sources
	dex
	stx $d019	; clear any set bits
	lda $d01e	; clear any collision detects
	lda $d01f

	; reset VIC-II registers to power-on defaults
	ldx #$2e
-	lda default_vic_registers,x
	sta vic_base,x
	dex
	bpl -

	; also reset SID
	lda #$00
	ldx #$18
-	sta $d400,x
	dex
	bpl -
	
	rts

test_exram
	jsr reset_vic

	ldy #$0d	; light green
	jsr reset_screen

	lda #$00	; this should latch bank 0 and make ram visible
	sta $de80
	sta $0880	
	sta $1c
	tay
	
	lda #$08
	sta $1d
	
exram_restart
	ldx #$13

exram_write_loop
	lda test_bytes,x
-	sta ($1c),y
	dey
	bne -
	lda #$0f
	cmp $1d
	beq exram_read_loop
	inc $1d
	jmp exram_write_loop

exram_read_loop
	lda ($1c),y
	sta $0400,y
	eor test_bytes,x
	bne exram_error
;	lda #$02
;	sta $d800,x
;	sta $d020
;+	dey
	dey
	bne exram_read_loop
	lda #$08
	cmp $1d
	beq exram_next_test
	dec $1d
	jmp exram_read_loop

exram_next_test
	dex
	bpl exram_write_loop
	bmi exram_restart

exram_error
	pha
	lda test_bytes,x
	pha
	lda ($1c),y
	pha
	
	lda #$92	; screen location lo byte
	sta $24
	lda #$05
	sta $25

	sty $26
	jsr hi_print_hex_byte

	lda #$90	; screen location for hi byte
	sta $24

	lda $1d		; hi byte
	sta $26
	jsr hi_print_hex_byte
	
	lda #$95
	sta $24
	pla
	sta $26
	jsr hi_print_hex_byte

	lda #$98
	sta $24
	pla
	sta $26
	jsr hi_print_hex_byte

	lda #$9b
	sta $24
	pla
	sta $26
	jsr hi_print_hex_byte
	
endless_loop
	jmp endless_loop
	
stress_test
	jsr reset_vic
	ldy #$00
	jsr reset_screen
	
	lda #$00
	sta VIC_Background1
	sta VIC_Background2
	sta VIC_Background3
	
	lda #$00	; total number of banking errors
	sta $27		; outbound
	sta $28		; inbound
	
	ldx #<msg_boot_rom
	ldy #>msg_boot_rom
	lda #(lightblue << 4) + lightblue
	jsr print_msg

	ldx #<msg_inbound
	ldy #>msg_inbound
	lda #(lightblue << 4) + lightblue
	jsr print_msg

	ldx #<msg_outbound
	ldy #>msg_outbound
	lda #(lightblue << 4) + lightblue
	jsr print_msg

	ldx #>reloc_test_cart	; transfer booter handler into lo ram
	ldy #<reloc_test_cart
	lda #>test_cart
	jsr trans

	ldx #>reloc_crc_lo		; transfer crc_tables intp lo ram
	ldy #<reloc_crc_lo
	lda #>crc_lo
	jsr trans

	ldx #>reloc_crc_hi
	ldy #<reloc_crc_hi
	lda #>crc_hi
	jsr trans
	
	lda #$5f	; screen location for checksum
	sta $24
	lda #$04
	sta $25

	; calculate CRC of boot loader rom, print it and store in $22,$23
	jsr calc_crc

	lda $21		; lo byte
	sta $23
	sta $26
	jsr print_hex_byte

	lda #$61	; screen location for hi byte
	sta $24

	lda $20		; hi byte
	sta $22
	sta $26
	jsr print_hex_byte

	lda #yellow		; colour the text where the checksums are printed
	ldx #$08
-	sta $d85f,x
	sta $d8af,x
	sta $d8ff,x
	dex
	bpl -	

	ldx #num_carts		; reset the character ram used for fail indicators
	lda #$00
-	sta screen_ram,x
	dex
	bpl -
	
	ldy #$01
	sty $05
	lda #green
	sta VIC_Border

test_cart_loop	
	tya
	asl						; checksums are two bytes so multiply by 2
	tax
	lda cart_checksums,x
	sta $03
	inx
	lda cart_checksums,x
	sta $04

	lda #black
	sta VIC_Background0

	jsr test_cart
	
	ldy $05
	iny
	cpy #num_carts+1
	bne +
	ldy #$01
+	sty $05	
	jmp test_cart_loop

sprite_setup
	lda #$00
	sta sp_enable
	sta sp_vexp
	sta sp_hexp
	sta sp_multi
	
	lda #$e0
	sta sp_msb
	lda #$1f
	sta sp_bprio

	lda #green
	sta sp_colour+5
	sta sp_colour+6
	sta sp_colour+7
	
	; keyboard icon
	lda #$41
	sta sp_xpos+10
	ldx #$46
	stx sp_ypos+10

	; joystick icon
	lda #$30
	sta sp_xpos+12
	ldx #$35
	stx sp_ypos+12

	; paddles icon
	lda #$41
	sta sp_xpos+14
	ldx #$26
	stx sp_ypos+14
	
	ldx #spd_keyboard
	stx sp_pointer+5
	inx
	stx sp_pointer+6
	inx
	stx sp_pointer+7
	rts

print_msg
	sta $17
	stx $13			; lo byte of msg data location
	sty $14			; hi byte of msg data location
	ldy #$01
-	lda ($13),y
	sta $15,y
	dey
	bpl -

	lda $15		; screen location is at $15
	sta $18		; copy to colour location by adding $d400
	clc
	lda $16
	adc #$d4	; colour location an $18
	sta $19

	lda $13		; adjust value at $13 to point to msg text
	clc
	adc #$02
	sta $13
	bcc +
	inc $14

+	ldx $17		; colour value at $17

	ldy #$00
-	lda ($13),y
	beq +
	sta ($15),y
	txa
	sta ($18),y
	iny
	bne -		; always branch

+	txa
	lsr
	lsr
	lsr
	lsr
	ldy #$00		; highlight first character
	sta ($18),y
	rts

reloc_test_cart
.logical test_cart
	sta $de00,y		; select bank y
	sta $0800,y

	jsr calc_crc

	lda #$af	; screen location for checksum
	sta $24
	
	lda $21		; print hi byte of checksum
	sta $26
	jsr print_hex_byte

	lda #$b1	; screen location for checksum
	sta $24

	lda $20		; print lo byte of checksum
	sta $26

	jsr print_hex_byte

	lda $20		; check if wrong
	cmp $03
	bne +
	lda $21
	cmp $04
	beq test_crt_return

+	inc $27		; increment fail counters
	ldx $05		
	inc screen_ram,x
	lda #white
	sta colour_ram,x
	lda $27
	sta $26
	lda #$b6		; screen location for fail count
	sta $24
	jsr print_hex_byte
	lda #$02	; make border red
	sta VIC_Border

test_crt_return
	sta $de00	;	set bank 0
	sta $0800

	jsr calc_crc

	lda #$ff	; screen location for checksum
	sta $24

	lda $21
	sta $26
	jsr print_hex_byte

	lda #$01	; screen location for checksum
	sta $24
	lda #$05
	sta $25

	lda $20
	sta $26
	jsr print_hex_byte

	lda $20		; check we've banked in the boot loader correctly
	cmp $22
	bne +
	lda $21
	cmp $23
	bne +

	lda #$04	; reset hi-byte of screen to #$04
	sta $25
	rts

+	inc VIC_Border
	inc $28
	lda $28
	sta $26
	lda #$05	; screen location for checksum
	sta $24
	jsr print_hex_byte
	lda #$04	; reset hi-byte of screen to #$04
	sta $25
	jmp test_crt_return
	
calc_crc
	ldx #$e0
	stx $11
	ldy #$ff	; CRC checksum
	sty	$20
	sty $21
	iny			; reset checksum
	sty $10

-	lda ($10),y		; CRC16 (CRC-CCITT)
	eor $21
	tax
	lda $20
	eor crc_hi,x
	sta $21
	lda crc_lo,x
	sta $20
	iny
	bne -
	inc $11
	bne -
	rts		

print_hex_byte
.here
hi_print_hex_byte
	pha
	tya
	pha
	ldy #$01
	lda $26
	and #$0f
	cmp #$0a
	bcs +
	adc #$30
	bcc ++
+	sbc #$09
+	sta ($24),y
	dey
	lda $26
	lsr
	lsr
	lsr
	lsr
	and #$0f
	cmp #$0a
	bcs +
	adc #$30
	bcc ++
+	sbc #$09
+	sta ($24),y
	pla
	tay
	pla
	rts


reloc_boot_cart
	lda $05
	tax
	sta $de80,x
	sta $0880,x
	ldx #$e0
	stx $11
	ldy #$ff	; CRC checksum
	sty	$20
	sty $21
	iny			; reset checksum
	sty $10

-	lda ($10),y		; CRC16 (CRC-CCITT)
	eor $21
	tax
	lda $20
	eor crc_hi,x
	sta $21
	lda crc_lo,x
	sta $20
	iny
	bne -
	inc $11
	bne -

	lda $20
	cmp $03
	bne crc_fail
	lda $21
	cmp $04
	bne crc_fail
	jmp ($fffc)
crc_fail
	inc VIC_Border
	jmp reloc_boot_cart

trans
	stx $fb
	sty $fa
	sta $fd
	ldy #$00
	sty $fc
-	lda ($fa),y ; move a page at a time
	sta ($fc),y
	iny
	bne -
	ldy $fd
	iny
	tya
	ldy $fa
	inx
	rts
	
reset_screen
	ldx #$1d
-	lda vic_registers,x
	sta vic_base+$11,x
	dex
	bpl -
	inx
	
	ldx #$00
-	tya
	sta colour_ram,x
	sta colour_ram + $0100,x
	sta colour_ram + $0200,x
	sta colour_ram + $0300,x
	lda #$20
	sta screen_ram,x
	sta screen_ram + $0100,x
	sta screen_ram + $0200,x
	sta screen_ram + $0300,x
	inx
	bne -
    rts
    
low_ram_test		; basic ram test avoiding use of stack or zero page
	ldy #$02		; dark red
	sty VIC_Background0

	lda #$01		; databus test
-	sta $02
	cmp $02
	beq +
	eor $02
	jmp calc_bad_bit
+	clc
	rol
	bcc -
	
address_test
	ldy #$06			; dark blue
	sty VIC_Background0

	lda #$00
	sta $ff
	sta $fe
	sta $fd
	sta $fb
	sta $f7
	sta $ef
	sta $df
	sta $bf
	sta $7f
	sta $01ff
	sta $02ff
	sta $04ff

	lda #$ff
	sta $ff
	
	lda #$00
	ldx #$01
	cmp $fe
	bne add_fail1
	inx
	cmp $fd
	bne add_fail1
	inx
	cmp $fb
	bne add_fail1
	inx
	cmp $f7
	bne add_fail1
	inx
	cmp $ef
	bne add_fail1
	inx
	cmp $df
	bne add_fail1
	inx
	cmp $bf
	bne add_fail1
	inx
	cmp $7f
	bne add_fail1
	inx
	cmp $01ff
	bne add_fail1
	inx
	cmp $02ff
	bne add_fail1
	inx
	cmp $04ff
	bne add_fail1
	beq device_test
	
add_fail1
	jmp flash
	
device_test
	ldx #$13		; the current test byte value
	ldy #black
	sty VIC_Background0
byte_loop
	lda test_bytes,x
-	cpy #$02		; we don't want to test $00 or $01, the cpu port registers
	bcc +
	sta $00,y
+	sta $0100,y
	sta $0200,y
	sta $0300,y
	sta $0400,y
	sta $0500,y
	sta $0600,y
	sta $0700,y
	iny
	bne -
	
loop1
	cpy #$02		; we don't want to test $00 or $01, the cpu port registers
	bcc +
	lda $00,y
	cmp test_bytes,x
	bne ram_fail
+	lda $0100,y
	cmp test_bytes,x
	bne ram_fail
	lda $0200,y
	cmp test_bytes,x
	bne ram_fail
	lda $0300,y
	cmp test_bytes,x
	bne ram_fail
	lda $0400,y
	cmp test_bytes,x
	bne ram_fail
	lda $0500,y
	cmp test_bytes,x
	bne ram_fail
	lda $0600,y
	cmp test_bytes,x
	bne ram_fail
	lda $0700,y
	cmp test_bytes,x
	bne ram_fail
	iny
	beq next_test_byte
	jmp loop1

ram_fail
	eor test_bytes,x
	jmp calc_bad_bit
	
next_test_byte
	dex
	bmi end_dead_test
	ldy #$00
	jmp byte_loop

end_dead_test
	jmp begin_main

calc_bad_bit
	ldx #$00
	clc
-	inx
	ror
	bcc -

flash
	txs			; x contains the number of flashes, cunningly stored in the stack pointer

flash_start
	ldy #$00
-	lda #yellow
	sta colour_ram,y
	sta colour_ram + $0100,y
	sta colour_ram + $0200,y
	sta colour_ram + $0300,y
	lda #$ff
	sta screen_ram,y
	sta screen_ram + $0100,y
	sta screen_ram + $0200,y
	sta screen_ram + $0300,y
	dey
	bne -
	
flash_loop		; flash the border x times
	txa
	ldx #yellow	
	stx VIC_Border
	ldx #$80
delay1			; delay approx 0.125 second with border on (pale yellow, luminance 7)
	dey
	bne delay1
	dex
	bne delay1
	stx VIC_Border
delay2			; delay approx 0.4 second with border off
	nop
	dey
	bne delay2
	dex
	bne delay2
	tax
	dex
	beq invert_screen
	jmp flash_loop

invert_screen
	lda screen_ram,y
	eor #$ff
	sta screen_ram,y
	lda screen_ram + $0100,y
	eor #$ff
	sta screen_ram + $0100,y
	lda screen_ram + $0200,y
	eor #$ff
	sta screen_ram + $0200,y
	lda screen_ram + $0300,y
	eor #$ff
	sta screen_ram + $0300,y
	dey
	bne invert_screen
	
longer_delay	; delay approx 1 second with border off
	nop
	nop
	nop
	nop
	nop
	nop
	dey
	bne longer_delay
	dex
	bne longer_delay
	tsx
	jmp flash_loop

raster_1=$f1	; start of line 24
raster_2=$f9
raster_3=$fc	; during the bottom border

irq_handler
	pha
 	tya
	pha
 	txa
 	pha

 	ldx $d012

	lda $d019
	and #$81
	cmp #$81
	beq +
	pla
	tax
	pla
	tay
	pla
	rti
	
+	lda #$ff			; clear raster line interrupt source
	sta $d019
 	
 	cpx #raster_2
 	beq ras2_main
	bcs ras3_main
	
	lda $2d		; smooth scroll line 25
	sta $d016

	lda #raster_2		; set raster interrup to next position
	jmp exit_handler
	
ras2_main
	lda $d011
	and #$f7
	sta $d011
	lda #raster_3		; set raster interrup to next position
	jmp exit_handler
	
ras3_main
	lda $d011
	ora #$08
	sta $d011
	
	lda #$c8		; 40 column mode
	sta $d016

	ldx $2d		; should we scroll?	
	dex			; scroll 2 pixels
	dex
	txa
	and #$06	; 38 columns - save for later
	sta $2d
	cmp #$06
	bne end_xscroll
	
	ldy $12			; are we fading out the old scroller?
	beq no_fade
	dey
	sty $12
	lda fade_lookup,y
	tay

	ldx #$00	; shift the text one to the left and get next character
-	lda screen_ram+( 24 * rows) + 1,x
	cmp #$20
	beq +
	tya
+	sta screen_ram+( 24 * rows),x
	inx
	cpx #$27
	bne -
	jmp next_scroll_char
	
message_fade_init=$06

fade_lookup
	.byte $00, $20, $2e, $2d, $2b, $00
	
no_fade	
	ldx #$00	; shift the text one to the left and get next character
-	lda screen_ram+( 24 * rows) + 1,x
	sta screen_ram+( 24 * rows),x
	inx
	cpx #$27
	bne -

next_scroll_char	
	ldy #$00		; get the next character
	lda ($2b),y
	bne next_char	; have we reached the end of the message...
	ldx $02			; check how many times we displayed this message
	dex
	bne +
	ldx #msg_show_count
	stx $02
	ldx #<help_def
	lda #>help_def
	stx $29			; reset the message
	sta $2a
	jmp ++
	
+	stx $02
	ldx $29			; reset the message
	lda $2a
+
	stx $2b
	sta $2c
	lda ($2b),y
	
next_char
	sta screen_ram+( 24 * rows) + 39
	clc
	lda $2b
	adc #$01
	sta $2b
	lda $2c
	adc #$00
	sta $2c

end_xscroll
	dec $2e
	bne +
	dec $2f
	bne +
	lda #$02
	sta $31
	sta $2f
+	jsr $e003			; play music
	lda #raster_1

exit_handler
	sta raster
	pla
	tax
	pla
	tay
	pla
nmi_handler
	rti
	
.enc screen
msg_boot_rom
	.word screen_ram+(  2 * rows) + 1
	.null "boot rom crc"
msg_inbound
	.word screen_ram+(  4 * rows) + 1
	.null "outbound crc"
msg_outbound
	.word screen_ram+(  6 * rows) + 1
	.null " inbound crc"
msg_avenger1
	.word screen_ram+(  5 * rows) + 1
	.null "a avenger max v1"
msg_avenger2
	.word screen_ram+(  6 * rows) + 1
	.null "b avenger max v2"
msg_avenger_c64	
	.word screen_ram+(  7 * rows) + 1
	.null "c avenger c64"
msg_billiards1	
	.word screen_ram+(  8 * rows) + 1
	.null "d billiards v1"
msg_billiards2	
	.word screen_ram+(  9 * rows) + 1
	.null "e billiards v2"
msg_bowling	
	.word screen_ram+( 10 * rows) + 1
	.null "f bowling"
msg_clowns1	
	.word screen_ram+( 11 * rows) + 1
	.null "g clowns v1"
mag_clowns2	
	.word screen_ram+( 12 * rows) + 1
	.null "h clowns v2"
msg_gorf	
	.word screen_ram+( 13 * rows) + 1
	.null "i gorf"
msg_jupiter1	
	.word screen_ram+( 14 * rows) + 1
	.null "j jupiter lander v1"
msg_jupiter2	
	.word screen_ram+( 15 * rows) + 1
	.null "k jupiter lander v2"
msg_kickman1	
	.word screen_ram+( 16 * rows) + 1
	.null "l kickman max"
msg_kickman2	
	.word screen_ram+( 17 * rows) + 1
	.null "m kickman c64"
msg_lemans	
	.word screen_ram+( 18 * rows) + 1
	.null "n le mans"
msg_maxbasic
	.word screen_ram+( 19 * rows) + 1
	.null "o max basic"
msg_minibasic
	.word screen_ram+( 20 * rows) + 1
	.null "p mini basic"
msg_moleattack	
	.word screen_ram+( 21 * rows) + 1
	.null "q mole attack"
msg_moneywars	
	.word screen_ram+( 22 * rows) + 1
	.null "r money wars"
msg_music_composer	
	.word screen_ram+( 5 * rows) + 21
	.null "s music composer"
msg_music_machine	
	.word screen_ram+(  6 * rows) + 21
	.null "t music machine"
msg_omegarace2	
	.word screen_ram+(  7 * rows) + 21
	.null "u omega race v2"
msg_omegarace3	
	.word screen_ram+(  8 * rows) + 21
	.null "v omega race v3"
msg_pinball	
	.word screen_ram+(  9 * rows) + 21
	.null "w pinball"
msg_radarratrace2	
	.word screen_ram+( 10 * rows) + 21
	.null "x radar rat race 2a"
msg_radarratrace3	
	.word screen_ram+( 11 * rows) + 21
	.null "y radar rat race 2b"
msg_radarratrace4	
	.word screen_ram+( 12 * rows) + 21
	.null "z radar rat race 2c"
msg_roadrace1
	.word screen_ram+( 13 * rows) + 21
	.null "0 road race v1"
msg_roadrace2
	.word screen_ram+( 14 * rows) + 21
	.null "1 road race v2"
msg_seawolf
	.word screen_ram+( 15 * rows) + 21
	.null "2 sea wolf"
msg_slalom
	.word screen_ram+( 16 * rows) + 21
	.null "3 slalom"
msg_speedbingomath
	.word screen_ram+( 17 * rows) + 21
	.null "4 speed/bingo math"
msg_superalien
	.word screen_ram+( 18 * rows) + 21
	.null "5 super alien"
msg_visiblesolars
	.word screen_ram+( 19 * rows) + 21
	.null "6 visi solar system"
msg_wizardwor1
	.word screen_ram+( 20 * rows) + 21
	.null "7 wizard of wor v1"
msg_wizardwor2
	.word screen_ram+( 21 * rows) + 21
	.null "8 wizard of wor v2"
.enc none

*=$f800 ; character data
.byte $00,$66,$3c,$ff,$3c,$66,$00,$00 ; '*'

; A - G
.byte $18,$3c,$66,$7e,$66,$66,$66,$00
.byte $7c,$66,$66,$7c,$66,$66,$7c,$00,$3c,$66,$60,$60,$60,$66,$3c,$00
.byte $78,$6c,$66,$66,$66,$6c,$78,$00,$7e,$60,$60,$78,$60,$60,$7e,$00
.byte $7e,$60,$60,$78,$60,$60,$60,$00,$3c,$66,$60,$6e,$66,$66,$3c,$00
; H - O
.byte $66,$66,$66,$7e,$66,$66,$66,$00,$3c,$18,$18,$18,$18,$18,$3c,$00
.byte $1e,$0c,$0c,$0c,$0c,$6c,$38,$00,$66,$6c,$78,$70,$78,$6c,$66,$00
.byte $60,$60,$60,$60,$60,$60,$7e,$00,$63,$77,$7f,$6b,$63,$63,$63,$00
.byte $66,$76,$7e,$7e,$6e,$66,$66,$00,$3c,$66,$66,$66,$66,$66,$3c,$00
; P - W
.byte $7c,$66,$66,$7c,$60,$60,$60,$00,$3c,$66,$66,$66,$66,$3c,$0e,$00
.byte $7c,$66,$66,$7c,$78,$6c,$66,$00,$3c,$66,$60,$3c,$06,$66,$3c,$00
.byte $7e,$18,$18,$18,$18,$18,$18,$00,$66,$66,$66,$66,$66,$66,$3c,$00
.byte $66,$66,$66,$66,$66,$3c,$18,$00,$63,$63,$63,$6b,$7f,$77,$63,$00
; X - Z
.byte $66,$66,$3c,$18,$3c,$66,$66,$00,$66,$66,$66,$3c,$18,$18,$18,$00
.byte $7e,$06,$0c,$18,$30,$60,$7e,$00

; $1B - $1F (max_logo part 1)
.byte $ff,$fe,$fc,$f8,$f0,$e0,$c0,$80
.byte $80,$c0,$e0,$f0,$f8,$fc,$fe,$ff
.byte $01,$03,$07,$0f,$1f,$3f,$7f,$ff
.byte $ff,$7f,$3f,$1f,$0f,$07,$03,$01
.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

; $20 (space)
.byte $00,$00,$00,$00,$00,$00,$00,$00

; $21 - $26 (max_logo part 2)
.byte $ff,$7f,$3f,$1f,$1f,$3f,$7f,$ff
.byte $81,$c3,$e7,$ff,$ff,$ff,$ff,$ff
.byte $ff,$ff,$ff,$ff,$ff,$e7,$c3,$81
.byte $00,$18,$18,$15,$15,$12,$12,$10
.byte $00,$c6,$c6,$49,$49,$5f,$50,$50
.byte $00,$0c,$12,$20,$20,$a0,$92,$8c

; $27 - ' apostrophe
.byte $06,$0c,$18,$00,$00,$00,$00,$00

; $28 - $2a (max_logo part 3)
.byte $00,$cb,$ca,$aa,$ab,$aa,$9a,$9b
.byte $03,$e3,$03,$03,$c3,$03,$03,$e3
.byte $00,$8a,$8a,$8a,$fa,$8a,$8a,$8a

; $2B - $2F ( + , - . / )
.byte $00,$18,$18,$7e,$18,$18,$00,$00
.byte $00,$00,$00,$00,$00,$18,$18,$30,$00,$00,$00,$7e,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$18,$18,$00,$00,$03,$06,$0c,$18,$30,$60,$00

; $30 - $39
; numerals
.byte $3c,$66,$6e,$76,$66,$66,$3c,$00
.byte $18,$18,$38,$18,$18,$18,$7e,$00
.byte $3c,$66,$06,$0c,$30,$60,$7e,$00
.byte $3c,$66,$06,$1c,$06,$66,$3c,$00
.byte $06,$0e,$1e,$66,$7f,$06,$06,$00
.byte $7e,$60,$7c,$06,$06,$66,$3c,$00
.byte $3c,$66,$60,$7c,$66,$66,$3c,$00
.byte $7e,$66,$0c,$18,$18,$18,$18,$00
.byte $3c,$66,$66,$3c,$66,$66,$3c,$00
.byte $3c,$66,$66,$3e,$06,$66,$3c,$00

; $3a - $3f ( : ; < = > ? )
.byte $00,$00,$18,$00,$00,$18,$00,$00,$00,$00,$18,$00,$00,$18,$18,$30
.byte $0e,$18,$30,$60,$30,$18,$0e,$00,$00,$00,$7e,$00,$7e,$00,$00,$00
.byte $70,$18,$0c,$06,$0c,$18,$70,$00,$3c,$66,$06,$0c,$18,$00,$18,$00

reloc_crc_lo
.byte $00, $21, $42, $63, $84, $a5, $c6, $e7, $08, $29, $4a, $6b, $8c, $ad, $ce, $ef
.byte $31, $10, $73, $52, $b5, $94, $f7, $d6, $39, $18, $7b, $5a, $bd, $9c, $ff, $de
.byte $62, $43, $20, $01, $e6, $c7, $a4, $85, $6a, $4b, $28, $09, $ee, $cf, $ac, $8d
.byte $53, $72, $11, $30, $d7, $f6, $95, $b4, $5b, $7a, $19, $38, $df, $fe, $9d, $bc
.byte $c4, $e5, $86, $a7, $40, $61, $02, $23, $cc, $ed, $8e, $af, $48, $69, $0a, $2b
.byte $f5, $d4, $b7, $96, $71, $50, $33, $12, $fd, $dc, $bf, $9e, $79, $58, $3b, $1a
.byte $a6, $87, $e4, $c5, $22, $03, $60, $41, $ae, $8f, $ec, $cd, $2a, $0b, $68, $49
.byte $97, $b6, $d5, $f4, $13, $32, $51, $70, $9f, $be, $dd, $fc, $1b, $3a, $59, $78
.byte $88, $a9, $ca, $eb, $0c, $2d, $4e, $6f, $80, $a1, $c2, $e3, $04, $25, $46, $67
.byte $b9, $98, $fb, $da, $3d, $1c, $7f, $5e, $b1, $90, $f3, $d2, $35, $14, $77, $56
.byte $ea, $cb, $a8, $89, $6e, $4f, $2c, $0d, $e2, $c3, $a0, $81, $66, $47, $24, $05
.byte $db, $fa, $99, $b8, $5f, $7e, $1d, $3c, $d3, $f2, $91, $b0, $57, $76, $15, $34
.byte $4c, $6d, $0e, $2f, $c8, $e9, $8a, $ab, $44, $65, $06, $27, $c0, $e1, $82, $a3
.byte $7d, $5c, $3f, $1e, $f9, $d8, $bb, $9a, $75, $54, $37, $16, $f1, $d0, $b3, $92
.byte $2e, $0f, $6c, $4d, $aa, $8b, $e8, $c9, $26, $07, $64, $45, $a2, $83, $e0, $c1
.byte $1f, $3e, $5d, $7c, $9b, $ba, $d9, $f8, $17, $36, $55, $74, $93, $b2, $d1, $f0
reloc_crc_hi
.byte $00, $10, $20, $30, $40, $50, $60, $70, $81, $91, $a1, $b1, $c1, $d1, $e1, $f1
.byte $12, $02, $32, $22, $52, $42, $72, $62, $93, $83, $b3, $a3, $d3, $c3, $f3, $e3
.byte $24, $34, $04, $14, $64, $74, $44, $54, $a5, $b5, $85, $95, $e5, $f5, $c5, $d5
.byte $36, $26, $16, $06, $76, $66, $56, $46, $b7, $a7, $97, $87, $f7, $e7, $d7, $c7
.byte $48, $58, $68, $78, $08, $18, $28, $38, $c9, $d9, $e9, $f9, $89, $99, $a9, $b9
.byte $5a, $4a, $7a, $6a, $1a, $0a, $3a, $2a, $db, $cb, $fb, $eb, $9b, $8b, $bb, $ab
.byte $6c, $7c, $4c, $5c, $2c, $3c, $0c, $1c, $ed, $fd, $cd, $dd, $ad, $bd, $8d, $9d
.byte $7e, $6e, $5e, $4e, $3e, $2e, $1e, $0e, $ff, $ef, $df, $cf, $bf, $af, $9f, $8f
.byte $91, $81, $b1, $a1, $d1, $c1, $f1, $e1, $10, $00, $30, $20, $50, $40, $70, $60
.byte $83, $93, $a3, $b3, $c3, $d3, $e3, $f3, $02, $12, $22, $32, $42, $52, $62, $72
.byte $b5, $a5, $95, $85, $f5, $e5, $d5, $c5, $34, $24, $14, $04, $74, $64, $54, $44
.byte $a7, $b7, $87, $97, $e7, $f7, $c7, $d7, $26, $36, $06, $16, $66, $76, $46, $56
.byte $d9, $c9, $f9, $e9, $99, $89, $b9, $a9, $58, $48, $78, $68, $18, $08, $38, $28
.byte $cb, $db, $eb, $fb, $8b, $9b, $ab, $bb, $4a, $5a, $6a, $7a, $0a, $1a, $2a, $3a
.byte $fd, $ed, $dd, $cd, $bd, $ad, $9d, $8d, $7c, $6c, $5c, $4c, $3c, $2c, $1c, $0c
.byte $ef, $ff, $cf, $df, $af, $bf, $8f, $9f, $6e, $7e, $4e, $5e, $2e, $3e, $0e, $1e

*=$fc00
sp_data
spd_base=(sp_data//$4000)/$40

spd_keyboard=spd_base+0		; keyboard
.byte $00,$00,$00,$00, $00,$00,$7F,$FF, $F8,$61,$86,$18, $69,$96,$58,$61
.byte $B6,$58,$61,$86, $18,$7F,$FF,$FE, $18,$61,$86,$18, $69,$B6,$18,$65
.byte $86,$18,$61,$86, $FF,$FF,$FE,$C0, $06,$0C,$C0,$06, $0C,$C0,$06,$0C
.byte $C0,$06,$0C,$FF, $FF,$FC,$00,$00, $00,$00,$00,$00, $00,$00,$00,$05

spd_joystick=spd_base+1		; joystick
.byte $00,$06,$00,$00, $0D,$00,$80,$0B, $00,$80,$0B,$00, $C0,$3B,$00,$60
.byte $4B,$00,$38,$9B, $00,$0F,$1B,$C0, $02,$0B,$30,$05, $CB,$0C,$09,$4B
.byte $02,$11,$86,$05, $2C,$00,$09,$23, $00,$12,$20,$C0, $24,$18,$30,$48
.byte $06,$0C,$D0,$01, $83,$20,$00,$62, $40,$00,$1A,$80, $00,$07,$00,$05

spd_paddles=spd_base+2		; paddles
.byte $00,$00,$1C,$00, $F0,$38,$01,$0F, $F0,$01,$00,$10, $02,$00,$20,$04
.byte $00,$20,$04,$00, $20,$3F,$C3,$FC, $40,$24,$02,$40, $24,$02,$CF,$2C
.byte $F2,$D9,$AD,$9A, $D0,$AD,$0A,$50, $A5,$0A,$59,$A5, $9A,$4F,$24,$F2
.byte $40,$24,$02,$40, $24,$02,$40,$24, $02,$3F,$C3,$FC, $00,$00,$00,$05

cart_checksums
	.byte $00, $00
	.byte $76, $13		; avenger01_fixed.bin
	.byte $31, $8a		; avenger_max.bin
	.byte $a5, $2c		; avenger_c64.bin
	.byte $f6, $84		; billiards01.bin
	.byte $51, $f5		; billiards02.bin
	.byte $ad, $83		; bowling.bin
	.byte $87, $fc		; clowns_max.bin
	.byte $65, $d4		; clowns_c64.bin
	.byte $25, $98		; gorf.bin
	.byte $bc, $e4		; jupiter_lander01.bin
	.byte $65, $d0		; jupiter_lander.bin
	.byte $b3, $2b		; kickman02.bin
	.byte $b2, $8e		; kickman.bin (c64)
	.byte $45, $22		; lemans.bin
	.byte $0d, $26		; max_basic_e000.bin ($e000)
	.byte $a2, $fb		; mini_basic.bin
	.byte $ad, $7a		; mole_attack.bin
	.byte $3d, $7c		; money_wars.bin
	.byte $e5, $51		; music_composer.bin
	.byte $57, $14		; music_machine.bin
	.byte $b8, $f6		; omega_race_max.bin
	.byte $d1, $ed		; omegarace03.bin
	.byte $98, $0f		; pinball_e000.bin
	.byte $0a, $08		; radarratrace02a.bin
 	.byte $fa, $0f		; radarratrace02b.bin - 0ffa
 	.byte $56, $4e		; radarratrace02c.bin
	.byte $6e, $88		; roadrace01.bin - 886e
	.byte $19, $55		; roadrace02.bin - 5519
	.byte $32, $14		; seawolf.bin - 1432
	.byte $5b, $e0		; slalom_e000.bin
	.byte $8a, $61		; speedbingo01.bin - 618a
	.byte $f8, $d4		; superalien01.bin - d4f8
	.byte $8e, $51		; vss.bin - 518e
	.byte $3d, $1f		; wizard01.bin - 1f3d
	.byte $60, $2e		; wizard02.bin (wizard_of_wor_max.crt) - 2e60
	.byte $a5, $4f		; sidbench
	
keyboard_matrix
	;	DEL,RET,RIGHT,F7,F1,F3,F5,DOWN
	.byte $00,$40,$00,$00,$31,$33,$00,$00

	;   3,W,A,4,Z,S,E,LSHIFT
	.byte $1e,$17,$01,$1f,$1a,$13,$05,$00

	;	5,R,D,6,C,F,T,X
	.byte $20,$12,$04,$21,$03,$06,$14,$18

	;	7,Y,G,8,B,H,U,V
	.byte $22,$19,$07,$23,$02,$08,$15,$16

	;	9,I,J,0,M,K,O,N
	.byte $00,$09,$0a,$1b,$0d,$0b,$0f,$0e

	;	+,P,L,-,.,:,@,,
	.byte $00,$10,$0c,$00,$00,$00,$00,$00

	;	£,*,;,HOME,RSHIFT,=,UP ARROW,/
	.byte $35,$00,$00,$00,$00,$00,$00,$00

	;	1,LEFT ARROW,CTRL,2,SPACE,C=,Q,STOP
	.byte $1c,$30,$37,$1d,$41,$00,$11,$00

nw=$1b
sw=$1c
se=$1d
ne=$1e
xx=$1f
ww=$21 
wn=$22
ws=$23
oo=$20

logo_1
.byte oo, oo, oo, oo, xx, xx, xx, sw, se, xx, xx, xx, oo, se, xx, xx, xx, xx, sw, ne, xx, xx, wn, xx, xx, nw, oo, oo, oo, oo
logo_2
.byte oo, oo, oo, oo, xx, xx, xx, xx, xx, xx, xx, xx, se, xx, xx, nw, ne, xx, xx, sw, ne, xx, xx, xx, nw, oo, oo, oo, oo, oo
logo_3
.byte oo, oo, oo, oo, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, wn, xx, xx, xx, sw, oo, oo, oo, oo, oo
logo_4
.byte oo, oo, oo, oo, xx, xx, ne, xx, xx, nw, xx, xx, xx,$24,$25,$26,$2a,$28,$29, xx, xx, xx, ws, xx, xx, sw, oo, oo, oo, oo

mlogo_1
.byte xx, sw, se, xx, oo, xx, oo, xx, oo, xx, oo, oo, xx, xx, xx, oo, xx, oo, xx, sw, se, xx, oo, se, ws, sw, oo, xx, oo, xx
mlogo_2
.byte xx, xx, xx, xx, oo, xx, oo, xx, oo, xx, oo, oo, oo, xx, oo, oo, xx, oo, xx, xx, xx, xx, oo, xx, oo, xx, oo, ne, wn, nw
mlogo_3
.byte xx, ne, nw, xx, oo, xx, oo, xx, oo, xx, oo, oo, oo, xx, oo, oo, xx, oo, xx, ne, nw, xx, oo, xx, xx, xx, oo, se, ws, sw
mlogo_4
.byte xx, oo, oo, xx, oo, ne, wn, nw, oo, xx, xx, xx, oo, xx, oo, oo, xx, oo, xx, oo, oo, xx, oo, xx, oo, xx, oo, xx, oo, xx

cart_list
	.word $0000
	.word msg_avenger1
	.word msg_avenger2
	.word msg_avenger_c64	
	.word msg_billiards1	
	.word msg_billiards2	
	.word msg_bowling	
	.word msg_clowns1	
	.word mag_clowns2	
	.word msg_gorf	
	.word msg_jupiter1	
	.word msg_jupiter2	
	.word msg_kickman1	
	.word msg_kickman2	
	.word msg_lemans	
	.word msg_maxbasic
	.word msg_minibasic
	.word msg_moleattack	
	.word msg_moneywars	
	.word msg_music_composer	
	.word msg_music_machine	
	.word msg_omegarace2	
	.word msg_omegarace3	
	.word msg_pinball	
	.word msg_radarratrace2	
	.word msg_radarratrace3	
	.word msg_radarratrace4	
	.word msg_roadrace1
	.word msg_roadrace2
	.word msg_seawolf
	.word msg_slalom
	.word msg_speedbingomath
	.word msg_superalien
	.word msg_visiblesolars
	.word msg_wizardwor1
	.word msg_wizardwor2

default_vic_registers ; from $d000 -> $d02e
	.byte $00, $00, $00, $00,  $00, $00, $00, $00
	.byte $00, $00, $00, $00,  $00, $00, $00, $00
	.byte $00, $00, $00, $00,  $00, $00, $c0, $00
	.byte $01, $ff, $f0, $00,  $00, $00, $00, $00
	.byte $f0, $f0, $f0, $f0,  $f0, $f0, $f0, $f0
	.byte $f0, $f0, $f0, $f0,  $f0, $f0, $f0

vic_registers ; from $d011 -> $d02e
	.byte      $5b, $00, $00,  $00, $00, $08, $00
	.byte $1e, $ff, $01, $00,  $00, $00, $00, $00
	.byte black, black, blue, red,  brown, $00, $00, $00
	.byte $03, $02, $08, $00,  $00, $00, $00

test_bytes
	.byte $00,$55,$aa,$ff
	.byte $01,$02,$04,$08
	.byte $10,$20,$40,$80
	.byte $fe,$fd,$fb,$f7
	.byte $ef,$df,$bf,$7f

ct_kb_js_pad=$e0
ct_js_pad=$c0
ct_kb_pad=$90
ct_pad=$80
ct_kb_js=$60
ct_js=$40
ct_kb=$20
ct_none=$00

controller_table
	.byte 	ct_none		; nothing selected
	.byte	ct_kb_js	; "a avenger max v1"
	.byte	ct_kb_js	; "b avenger max v2"
	.byte	ct_kb_js	; "c avenger c64"
	.byte	ct_kb_js	; "d billiards v1"
	.byte	ct_kb_js	; "e billiards v2"
	.byte	ct_kb_js	; "f bowling"
	.byte	ct_pad		; "g clowns v1"
	.byte	ct_pad		; "h clowns v2"
	.byte	ct_kb_js	; "i gorf"
	.byte	ct_kb_js	; "j jupiter lander v1"
	.byte	ct_kb_js	; "k jupiter lander v2"
	.byte	ct_kb_js	; "l kickman max"
	.byte	ct_kb_js	; "m kickman c64"
	.byte	ct_pad		; "n le mans"
	.byte	ct_kb		; "o max basic"
	.byte	ct_kb		; "p mini basic";
	.byte	ct_kb		; "q mole attack"
	.byte	ct_kb_js	; "r money wars"
	.byte	ct_kb		; "s music composer"
	.byte	ct_kb		; "t music machine"
	.byte	ct_kb_js_pad; "u omega race v2"
	.byte	ct_kb_js_pad; "v omega race v3"
	.byte	ct_pad		; "w pinball"
	.byte	ct_kb_js	; "x radar rat race 2a"
	.byte	ct_kb_js	; "y radar rat race 2b"
	.byte	ct_kb_js	; "z radar rat race 2c"
	.byte	ct_kb_js_pad; "0 road race v1"
	.byte	ct_kb_js_pad; "1 road race v2"
	.byte	ct_pad		; "2 sea wolf"
	.byte	ct_kb_js	; "3 slalom"
	.byte	ct_kb_js	; "4 speed/bingo math"
	.byte	ct_kb_js	; "5 super alien"
	.byte	ct_kb		; "6 visi solar system"
	.byte	ct_kb_js	; "7 wizard of wor v1"	
	.byte	ct_kb_js	; "8 wizard of wor v2"	
	
*=$fffa
	.word nmi_handler
	.word start
	.word irq_handler

