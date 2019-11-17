/*=======================================================

	PC-6031 Emulator Farmware (2 of 2) for ATMEGA164P
	
	2010.3.26 by Koichi Nishida

=======================================================*/

.global wait5

.func wait5
wait5:
	ldi r18,24
wait51:
	nop
	dec r18
	brne wait51
	sbiw r24,1
	brne wait5
	ret
.endfunc	
