/*=======================================================

	PC-6031 Emulator Farmware (1 of 2) for ATMEGA164P
	
	2010.3.26 by Koichi Nishida

=======================================================*/

/*
hardware information of SD6031

use ATMEGA164P AVR.
connect 20MHz crystal to the AVR.

the fuse setting :
(note that JTAG must be disable by this setting)

 LOW: 11011110
 HIGH: 11011001

port direction and connection to P6:
DDRA = 0b01111010; (1D/2D SW), LED2, LED1, SD card (CS,DI,EJECT,CLK,DO)
DDRB = 0b11111111; data out to P6
DDRC = 0b00000000; data in from P6
DDRD = 0b11110000; ctrl out to P6 (ATN,DAC,RFD,DAV), ctrl in from P6 (ATN,DAC,RFD,DAV)
*/
/*
This is the firmware of PC-6031 emulator by Nishida Radio.

Copyright (C) 2010 Koichi NISHIDA
email to Koichi NISHIDA: tulip-house@msf.biglobe.ne.jp

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#include <avr/io.h>
#include <avr/interrupt.h>

#define WAIT 1

#define nop() __asm__ __volatile__ ("nop")
#define min(a,b) ((a)>(b)?(b):(a))

// ==================== prototypes ====================

// calculate 2^x
unsigned char pow2(register unsigned char x);
// wait 5u sec (assembler functions)
void wait5(unsigned short time);

// ---------- for SD card and image ----------

// SD card information 
struct SD_info {
	unsigned char slow;					// slow access for initialization
	unsigned char inited;
	unsigned long bpbAddr, rootAddr;
	unsigned long fatAddr;				// the beginning of FAT
	unsigned char sectorsPerCluster;	// sectors per cluster
	unsigned short sectorsPerFat;	
	unsigned long userAddr;				// the beginning of user data
};

// disk image information
#define DRIVE_NUM 4
#define FAT_ELEMS 64
struct image_info {
	unsigned short id[DRIVE_NUM];				// image ID (512 if not mounted)
	unsigned short fat[DRIVE_NUM][FAT_ELEMS];	// the fat for the image
	unsigned char prevFatNum[DRIVE_NUM];		// previous fat number for the mage
	unsigned char protect[DRIVE_NUM];			// write protect
	unsigned long len[DRIVE_NUM];				// image length
};

// write a byte data to the SD card
void SD_writeByte(unsigned char c);

// read data from the SD card
unsigned char SD_readByte(void);

// wait until finish a command
void SD_waitFinish(void);

// issue SD card command without getting response
void SD_cmd_(unsigned char cmd, unsigned long adr);

// issue SD card command and wait normal response
void SD_cmd(unsigned char cmd, unsigned long adr);

// get command response from the SD card
unsigned char getResp(void);

// issue command 17 and get ready for reading
void SD_cmd17(unsigned long adr);

// find the file extension and create the image information
int SD_findImage(char *str, unsigned char *protect, 
	unsigned char *name, unsigned long *length);
	
// prepare the FAT table on memory
void SD_prepareFatSub(int i, unsigned short *fat, unsigned short len,
	unsigned char fatNum, unsigned char fatElemNum);
void SD_prepareFat(unsigned short *long_sector, unsigned short *ft,
	unsigned char track, unsigned char sector, unsigned char drive);
	
// initialization called from SD_checkEject
void SD_init(void);

// called when the SD card is inserted or removed
void SD_checkEject(void);

// ---------- communication with P6  ----------

// communicate with PC-6001
// send data to PC-6001
void P6_snd(unsigned char d1, unsigned char d2);
// receive data to PC-6001
void P6_rcv(unsigned char *d1, unsigned char *d2);

// ---------- PC-6031 status ----------
struct pc6031_status {
	unsigned char drive;
	unsigned char track;
	unsigned char sector;
	unsigned char length;
	unsigned char valid;
	unsigned char mode;
	unsigned char error;
};

// initialize PC-6031 status
void pc6031_init(void);

// process PC-6031 command
void pc6031_process(void);

//==================== implementation ====================

struct SD_info SD;				// SD card information
struct image_info image;		// image information
struct pc6031_status pc6031;	// PC-6031 status
unsigned char LED;				// LED status

// calculate 2^x
unsigned char pow2(register unsigned char x)
{
	register unsigned char i, r=1;
	for (i=0; i!=x; i++) {
		r<<=1;
	}
	return r;
}

// write a byte data to the SD card
void SD_writeByte(unsigned char c)
{
	unsigned char d;
	register unsigned char led = LED;
	register unsigned char v10 = (0b10001101 | led);
	register unsigned char v11 = (0b10001111 | led);
	register unsigned char v00 = (0b10000101 | led);
	register unsigned char v01 = (0b10000111 | led);
	
	if (SD.slow) {
		for (d = 0b10000000; d; d >>= 1) {
			if (c&d) {
				PORTA = v10;
				wait5(WAIT);
				PORTA = v11;
			} else {
				PORTA = v00;
				wait5(WAIT);
				PORTA = v01;
			}
			wait5(WAIT);
		}
		
	} else {
		for (d = 0b10000000; d; d >>= 1) {
			if (c&d) {
				PORTA = v10;
				PORTA = v11;
			} else {
				PORTA = v00;
				PORTA = v01;
			}
		}
	}
	PORTA = (0b10000101 | led);
}

// read data from the SD card
unsigned char SD_readByte(void)
{
	unsigned char c = 0, i;
	register unsigned char led = LED;
	register unsigned char v0 = (0b10001111 | led);
	register unsigned char v1 = (0b10001101 | led);
	
	if (SD.slow) {
		PORTA = (0b10001101 | led);
		wait5(WAIT);
		for (i = 0; i != 8; i++) {
			PORTA = v0;
			wait5(WAIT);
			c = ((c<<1) | (PINA&1));
			PORTA = v1;
			wait5(WAIT);
		}
	} else {
		PORTA = (0b10001101 | led);
		for (i = 0; i != 8; i++) {
			PORTA = v0;
			c = ((c<<1) | (PINA&1));
			PORTA = v1;
		}	
	}

	return c;
}

// wait until data is written to the SD card
void SD_waitFinish(void)
{
	unsigned char ch;
	do {
		ch = SD_readByte();
		if (bit_is_set(PINA,2)) return;
	} while (ch != 0xff);
}

// issue a SD card command without getting response
void SD_cmd_(unsigned char cmd, unsigned long adr)
{
	SD_writeByte(0xff);
	SD_writeByte(0x40+cmd);
	SD_writeByte(adr>>24);
	SD_writeByte((adr>>16)&0xff);
	SD_writeByte((adr>>8)&0xff);
	SD_writeByte(adr&0xff);
	SD_writeByte(0x95);
	SD_writeByte(0xff);
}

// issue a SD card command and wait normal response
void SD_cmd(unsigned char cmd, unsigned long adr)
{
	unsigned char res;
	do {
		SD_cmd_(cmd, adr);
	} while (((res=getResp())!=0) && (res!=0xff));
}

// get a command response from the SD card
unsigned char getResp(void)
{
	unsigned char ch;
	do {
		ch = SD_readByte();
		if (bit_is_set(PINA,2)) return 0xff;
	} while ((ch&0x80) != 0);
	return ch;
}

// issue command 17 and get ready for reading
void SD_cmd17(unsigned long adr)
{
	unsigned char ch;

	SD_cmd(17, adr);
	do {	
		ch = SD_readByte();
		if (bit_is_set(PINA,2)) return;
	} while (ch != 0xfe);
}

// find the file extension and create the image information
int SD_findImage(char *str, unsigned char *protect, unsigned char *name,
	unsigned long *length)
{
	short i;
	unsigned max_file = 512;
	unsigned short max_time = 0, max_date = 0;

	// find extension
	for (i=0; i!=512; i++) {
		unsigned char ext[3], d;
		unsigned char time[2], date[2];
		
		if (bit_is_set(PINA,2)) return 512;
		// check first char
		SD_cmd(16, 1);
		SD_cmd17(SD.rootAddr+i*32);
		d = SD_readByte();
		SD_readByte(); SD_readByte(); // discard CRC bytes
		if ((d==0x00)||(d==0x05)||(d==0x2e)||(d==0xe5)) continue;
		if (!(((d>='A')&&(d<='Z'))||((d>='0')&&(d<='9')))) continue;
		SD_cmd17(SD.rootAddr+i*32+11);
		d = SD_readByte();
		SD_readByte(); SD_readByte(); // discard CRC bytes
		if (d&0x1e) continue;
		if (d==0xf) continue;
		// check extension
		SD_cmd(16, 4);
		SD_cmd17(SD.rootAddr+i*32+8);
		ext[0] = SD_readByte(); ext[1] = SD_readByte(); ext[2] = SD_readByte();
		if (protect) *protect = ((SD_readByte()&1)<<3); else SD_readByte();
		SD_readByte(); SD_readByte(); // discard CRC bytes

		// check time stamp
		SD_cmd(16, 4);
		SD_cmd17(SD.rootAddr+i*32+22);
		time[0] = SD_readByte(); time[1] = SD_readByte();
		date[0] = SD_readByte(); date[1] = SD_readByte();
		SD_readByte(); SD_readByte(); // discard CRC bytes
		if ((ext[0]==str[0])&&(ext[1]==str[1])&&(ext[2]==str[2])) {
			unsigned short tm = *(unsigned short *)time;
			unsigned short dt = *(unsigned short *)date;

			if ((dt>max_date)||((dt==max_date)&&(tm>=max_time))) {
				max_time = tm;
				max_date = dt;
				max_file = i;
			}
		}
	}
	if (max_file != 512) {
		unsigned char j;
		unsigned char *tmp = (unsigned char *)length;
		SD_cmd(16, 4);
		SD_cmd17(SD.rootAddr+max_file*32+28);
		for (j=0; j<4; j++) *(tmp++) = SD_readByte();
		SD_readByte(); SD_readByte();
		if (name != 0) {
			SD_cmd(16, 8);
			SD_cmd17(SD.rootAddr+max_file*32);
			for (j=0; j<8; j++) name[j] = SD_readByte();
			SD_readByte(); SD_readByte();
		}
	}
	return max_file;
	// if 512 then not found...
}

// prepare a FAT table on memory
void SD_prepareFat(unsigned short *long_sector, unsigned short *ft,
	unsigned char track, unsigned char sector, unsigned char drive)
{
	unsigned char fatNum;
	unsigned short long_cluster;
	
	*long_sector = (unsigned short)track*16+(sector-1);
	long_cluster = (*long_sector)/SD.sectorsPerCluster;
	fatNum = long_cluster/FAT_ELEMS;
	if (fatNum != image.prevFatNum[drive]) {
		unsigned short sectLen = (image.len[drive]+511)/512;
		image.prevFatNum[drive] = fatNum;
		SD_prepareFatSub(image.id[drive], image.fat[drive], (sectLen+SD.sectorsPerCluster-1)/SD.sectorsPerCluster, fatNum, FAT_ELEMS);
	}
	*ft = image.fat[drive][long_cluster%FAT_ELEMS];
}

void SD_prepareFatSub(int i, unsigned short *fat, unsigned short len,
	unsigned char fatNum, unsigned char fatElemNum)
{
	unsigned short ft;
	unsigned char fn;

	if (bit_is_set(PINA,2)) return;
	SD_cmd(16, (unsigned long)2);
	SD_cmd17(SD.rootAddr+i*32+26);
	ft = SD_readByte();
	ft += (unsigned short)SD_readByte()*0x100;
	SD_readByte(); SD_readByte(); // discard CRC bytes
	if (0==fatNum) fat[0] = ft;
	for (i=0; i<len; i++) {
		fn = (i+1)/fatElemNum;
		SD_cmd17((unsigned long)SD.fatAddr+(unsigned long)ft*2);
		ft = SD_readByte();
		ft += (unsigned short)SD_readByte()*0x100;
		SD_readByte(); SD_readByte(); // discard CRC bytes
		if (fn==fatNum) fat[(i+1)%fatElemNum] = ft;
		if ((ft>0xfff6)||(fn>fatNum)) break;
	}
	SD_cmd(16, (unsigned long)512);	
}

// initialization called from SD_checkEject
void SD_init(void)
{
	unsigned char ch;
	unsigned short i;
	char str[5];

	// initialize the SD card
	SD.slow = 1;
	PORTA = (0b10010101 | LED);
	for (i = 0; i != 200; i++) {
		PORTA = (0b10011111 | LED);
		wait5(WAIT);
		PORTA = (0b10011101 | LED);
		wait5(WAIT);
	 }	// input 200 clock
 	PORTA = (0b10000101 | LED);
	SD_cmd_(0, 0);	// command 0	
 	do {	
		if (bit_is_set(PINA,2)) return;	
		ch = SD_readByte();
	} while (ch != 0x01);
	PORTA = (0b10010101 | LED);
	while (1) {
		if (bit_is_set(PINA,2)) return;
		PORTA = (0b10000101 | LED);
		SD_cmd_(55, 0);	// command 55
		ch = getResp();
		if (ch == 0xff) return;
		if (ch & 0xfe) continue;
		// if (ch == 0x00) break;
		PORTA = (0b10010101 | LED);
		PORTA = (0b10000101 | LED);
		SD_cmd_(41, 0);	// command 41	
		if (!(ch=getResp())) break;
		if (ch == 0xff) return;
		PORTA = (0b10010101 | LED);
	}
	SD.slow = 0;

	// BPB address
	SD_cmd(16,5);
	SD_cmd17(54);
	for (i=0; i<5; i++) str[i] = SD_readByte();
	SD_readByte(); SD_readByte(); // discard CRC
	if ((str[0]=='F')&&(str[1]=='A')&&(str[2]=='T')&&
		(str[3]=='1')&&(str[4]=='6')) {
		SD.bpbAddr = 0;
	} else {
		SD_cmd(16, 4);
		SD_cmd17((unsigned long)0x1c6);
		SD.bpbAddr = SD_readByte();
		SD.bpbAddr += (unsigned long)SD_readByte()*0x100;
		SD.bpbAddr += (unsigned long)SD_readByte()*0x10000;
		SD.bpbAddr += (unsigned long)SD_readByte()*0x1000000;
		SD.bpbAddr *= 512;
		SD_readByte(); SD_readByte(); // discard CRC bytes
	}
	if (bit_is_set(PINA,2)) return;

	// sectorsPerCluster and reservedSectors
	{
		unsigned short reservedSectors;
		SD_cmd(16, 3);
		SD_cmd17(SD.bpbAddr+0xd);		
		SD.sectorsPerCluster = SD_readByte();
		reservedSectors = SD_readByte();
		reservedSectors += (unsigned short)SD_readByte()*0x100;
		SD_readByte(); SD_readByte(); // discard CRC bytes	
		// sectorsPerCluster = 0x40 at 2GB, 0x10 at 512MB
		// reservedSectors = 2 at 2GB
		SD.fatAddr = SD.bpbAddr + (unsigned long)512*reservedSectors;
	}
	if (bit_is_set(PINA,2)) return;

	{
		// sectorsPerFat and rootAddr
		SD_cmd(16, 2);
		SD_cmd17(SD.bpbAddr+0x16);
		SD.sectorsPerFat = SD_readByte();
		SD.sectorsPerFat += (unsigned short)SD_readByte()*0x100;
		SD_readByte(); SD_readByte(); // discard CRC bytes		
		// sectorsPerFat =  at 512MB,  0xEF at 2GB
		SD.rootAddr = SD.fatAddr + ((unsigned long)SD.sectorsPerFat*2*512);
		SD.userAddr = SD.rootAddr+(unsigned long)512*32;
	}
	if (bit_is_set(PINA,2)) return;

	SD_cmd(16, (unsigned long)512);

	str[0]='P'; str[1]='3'; str[3]=0;
	for (i=0; i!=DRIVE_NUM; i++) {
		image.prevFatNum[i] = 0xff;
		str[2]=(i+('1'));
		// find "P31" - "P34" extension
		image.id[i] = SD_findImage(str, &(image.protect[i]), (unsigned char *)0, &(image.len[i]));
	}
}

// called when the card is inserted or removed
void SD_checkEject(void)
{
	unsigned long i;
	unsigned char j;

	if (bit_is_set(PINA,2)) {
		for (j=0; j<DRIVE_NUM; j++) image.id[j] = 512;
		SD.inited = 0;
	} else if (!SD.inited) {
		for (i=0; i!=0x50000;i++)
			if (bit_is_set(PINA,2)) return;
		LED = 0b11100000;
		PORTA = (0b10000101 | LED);
		SD_init();
		SD.inited = 1;
		LED = 0b10000000;
		PORTA = (0b10000101 | LED);
	}
}

// communicate with PC-6001
// send data to PC-6001
void P6_snd(unsigned char d1, unsigned char d2)
{ 
	while (bit_is_clear(PIND,1)) nop();	// wait RFD set
	PORTB = d1;
	PORTD |= 0b00010000;					// set DAV
	while (bit_is_clear(PIND,2)) nop();	// wait DAC set
	PORTB = d2;
	PORTD &= 0b11101111;					// reset DAV
	while (bit_is_set(PIND,2))	nop();		// wait DAC reset
}

// receive data from PC-6001
void P6_rcv(unsigned char *d1, unsigned char *d2)
{
	PORTD |= 0b00100000;					// set RFD
	while (bit_is_clear(PIND,0)) nop();	// wait DAV set
	PORTD &= 0b11011111;					// reset RFD
	*d1 = PINC;
	PORTD |= 0b01000000;					// set DAC
	while (bit_is_set(PIND,0))	nop();		// wait DAV reset
	if (d2) *d2 = PINC;
	PORTD &= 0b10111111;					// reset DAC
}

// PC interrupt is used for detecting SD card eject
ISR(PCINT_vect)
{
	SD_checkEject();
}

// initialize PC-6031 status
void pc6031_init(void)
{
	pc6031.valid = 0;
	pc6031.error = 0;
	//if SW=LOW 1D mode else 2D mode
	// this is initial mode and can change mode after by command 23
	pc6031.mode = ((PINA&0b10000000)?0b00001111:0b00000000);
}

// process PC-6031 command
void pc6031_process(void)
{
	while (1) {
		unsigned char cmd;
			
		while (bit_is_clear(PIND,3)) nop();	// wait attention
		P6_rcv(&cmd, 0);						// receive command
		while (bit_is_set(PIND,3)) nop();		// wait not attention
		switch (cmd) {
		case 0:		// init
			pc6031.error = 0;	
			break;
		case 1:		// write
		case 17: {	// high speed write
			unsigned char lg, dr, trk, sec, i;
			unsigned short j;

			P6_rcv(&lg, 0); P6_rcv(&dr, 0); P6_rcv(&trk, 0); P6_rcv(&sec, 0);
			if (image.protect[dr] || (image.id[dr]==512)) { pc6031.error = 1; break; }
			if (!(pow2(dr)&pc6031.mode)) trk<<=1;
			LED = ((pow2(dr)&0b00000011)<<5);
			for (i=0; i!=lg; i++) {
				unsigned short long_sector;
				unsigned short ft;

				SD_prepareFat(&long_sector, &ft, trk, sec, dr);
				PORTA = (0b10011101 | LED);
				PORTA = (0b10001101 | LED);
				SD_cmd(24, (unsigned long)SD.userAddr+((unsigned long)(ft-2)*SD.sectorsPerCluster
					+ (unsigned long)(long_sector%SD.sectorsPerCluster))*512);
				SD_writeByte(0xff);
				SD_writeByte(0xfe);
				if (cmd==1)
					for (j=0; j!=256; j++) {
						unsigned char d;
						
						P6_rcv(&d, 0);
						SD_writeByte(d);
					}
				else
					for (j=0; j!=128; j++) {
						unsigned char d1, d2;
						
						P6_rcv(&d1, &d2);
						SD_writeByte(d1);
						SD_writeByte(d2);	
					}							
				for (j=0; j!=256; j++) SD_writeByte(0);
				SD_writeByte(0xff);
				SD_writeByte(0xff);
				SD_readByte();
				SD_waitFinish();
				PORTA = (0b10011101 | LED);
				PORTA = (0b10001101 | LED);
				if (sec == 16) sec=1; else sec++;
			}
			pc6031.error = 0;
			LED = 0;
			PORTA = (0b10000101 | LED);
			break;
		}
		case 2:		// read
			P6_rcv(&pc6031.length, 0);
			P6_rcv(&pc6031.drive, 0);
			P6_rcv(&pc6031.track, 0);
			P6_rcv(&pc6031.sector, 0);
			
			if (image.id[pc6031.drive]==512) { pc6031.error=1; break; }
			if (!(pow2(pc6031.drive)&pc6031.mode)) pc6031.track<<=1;
			LED = ((pow2(pc6031.drive)&0b00000011)<<5);
			PORTA = (0b10000101 | LED);
			pc6031.valid = 1;
			pc6031.error = 0;
			LED = 0;
			PORTA = (0b10000101 | LED);
			break;
		case 3:		// transfer read data
		case 18: {	// high speed transfer read data
			unsigned char i;
			unsigned short j;

			if ((!pc6031.valid) || (image.id[pc6031.drive]==512)) { pc6031.error=1; break; }
			LED = ((pow2(pc6031.drive)&0b00000011)<<5);
			for (i=0; i!=pc6031.length; i++) {
				unsigned short long_sector;
				unsigned short ft;

				SD_prepareFat(&long_sector, &ft, pc6031.track, pc6031.sector, pc6031.drive);
				SD_cmd17(SD.userAddr+((unsigned long)(ft-2)*SD.sectorsPerCluster
					+ (long_sector%SD.sectorsPerCluster))*512);
				if (cmd==3) for (j=0; j!=256; j++) {
					unsigned char d = SD_readByte();
					
					P6_snd(d, 0);
				} else for (j=0; j!=128; j++) {
					unsigned char d1 = SD_readByte();
					unsigned char d2 = SD_readByte();
					
					P6_snd(d1, d2);
				}
				for (j=0; j!=256; j++) SD_readByte();
				SD_readByte(); SD_readByte(); // discard CRC
				if (pc6031.sector == 16) pc6031.sector=1; else pc6031.sector++;
			}
			pc6031.valid = 0;
			pc6031.error = 0;
			LED = 0;
			PORTA = (0b10000101 | LED);
			break;
		}
		case 4:	{	// sector copy
			unsigned char len, i;
			unsigned char src_drv, src_trk, src_sec;
			unsigned char dst_drv, dst_trk, dst_sec;
			unsigned short j;
				
			P6_rcv(&len, 0);
			P6_rcv(&src_drv, 0); P6_rcv(&src_trk, 0); P6_rcv(&src_sec, 0);
			P6_rcv(&dst_drv, 0); P6_rcv(&dst_trk, 0); P6_rcv(&dst_sec, 0);

			if (!(pow2(src_drv)&pc6031.mode)) src_trk<<=1;
			if (!(pow2(dst_drv)&pc6031.mode)) dst_trk<<=1;
				
			if ((image.protect[dst_drv])||(image.id[src_drv]==512)||(image.id[dst_drv]==512)) {
				pc6031.error=1; break; }
				
			LED = ((pow2(src_drv)&0b00000011)<<5);
			for (i=0; i<len; i++) {
				unsigned short long_sector;
				unsigned short ft;
				static unsigned char buff[256];

				SD_prepareFat(&long_sector, &ft, src_trk, src_sec, src_drv);
				SD_cmd17(SD.userAddr+((unsigned long)(ft-2)*SD.sectorsPerCluster
					+ (long_sector%SD.sectorsPerCluster))*512);
				for (j=0; j!=256; j++) buff[j] = SD_readByte();
				for (j=0; j!=256; j++) SD_readByte();
				SD_readByte(); SD_readByte(); // discard CRC
				if (src_sec == 16) src_sec=1; else src_sec++;

				LED = ((pow2(dst_drv)&0b00000011)<<5);
				SD_prepareFat(&long_sector, &ft, dst_trk, dst_sec, dst_drv);
				PORTA = (0b10011101 | LED);
				PORTA = (0b10001101 | LED);
				SD_cmd(24, (unsigned long)SD.userAddr+((unsigned long)(ft-2)*SD.sectorsPerCluster
					+ (unsigned long)(long_sector%SD.sectorsPerCluster))*512);
				SD_writeByte(0xff);
				SD_writeByte(0xfe);
				for (j=0; j!=256; j++) SD_writeByte(buff[j]);
				for (j=0; j!=256; j++) SD_writeByte(0);
				SD_writeByte(0xff);
				SD_writeByte(0xff);
				SD_readByte();
				SD_waitFinish();
				PORTA = (0b10011101 | LED);
				PORTA = (0b10001101 | LED);
				if (dst_sec == 16) dst_sec=1; else dst_sec++;	
			}
			LED = 0;
			PORTA = (0b10000101 | LED);	
			pc6031.error = 1;
			break;
		}
		case 5:	{	// format
			unsigned char trk, sec;
			unsigned char drv, is1d;
			unsigned short j;
				
			P6_rcv(&drv, 0);
			if (image.protect[drv] || (image.id[drv]==512)) { pc6031.error = 1; break; }
			is1d = (!(pow2(drv)&pc6031.mode));
			LED = ((pow2(drv)&0b00000011)<<5);
			// initialize the area with 0xff
			for (trk=0; trk!=80; trk++) {
				if (is1d && ((trk&1) || (trk>=70))) continue;
				for (sec=1; sec!=17; sec++) {
					unsigned short long_sector;
					unsigned short ft;
					unsigned char isMngTrk = ((is1d&&(trk==36))||(trk==37));
					unsigned char isIdSec = (isMngTrk&&(sec==13));
					unsigned char isFatSec = (isMngTrk&&((sec>=14)&&(sec<=16)));
					unsigned char d;

					SD_prepareFat(&long_sector, &ft, trk, sec, drv);
					PORTA = (0b10011101 | LED);
					PORTA = (0b10001101 | LED);
					SD_cmd(24, (unsigned long)SD.userAddr+((unsigned long)(ft-2)*SD.sectorsPerCluster
						+ (unsigned long)(long_sector%SD.sectorsPerCluster))*512);
					SD_writeByte(0xff);
					SD_writeByte(0xfe);	
					if (isFatSec) {
						// fat sector
						unsigned char mng = (is1d?(18*2):(37*2));

						for (j=0; j!=256; j++) {
							d = (((j==0)||((j>=mng)&&(j<=(mng+1))))?0xfe:0xff);
							SD_writeByte(d);	
						}	
					}	
					else {
						// ID sector						
						d = isIdSec?0x00:0xff;
						for (j=0; j!=256; j++) SD_writeByte(d);
					}
					// dummy 256 bytes
					for (j=0; j!=256; j++) SD_writeByte(0);
					SD_writeByte(0xff);
					SD_writeByte(0xff);
					SD_readByte();
					SD_waitFinish();
					PORTA = (0b10011101 | LED);
					PORTA = (0b10001101 | LED);
				}
			}
			pc6031.error = 0;
			LED = 0;
			PORTA = (0b10000101 | LED);
			pc6031.error = 1;
			break;
		}
		case 6:		// command status
			P6_snd(0b10000000 | (pc6031.valid<<6) | pc6031.error, 0);
			pc6031.error = 0;
			break;
		case 7: {	// drive status
			const unsigned char status =
				(DRIVE_NUM==1)?0b00011111:((DRIVE_NUM==2)?0b00111111:
				((DRIVE_NUM==3)?0b01111111:0b11111111));

			P6_snd(status, 0);
			pc6031.error = 0;
			break;
		}
		case 11: {	// transfer FDD's memory data to PC-6001
					// only for address 7EFh (return EFh) & 75Fh (return 77h)
			unsigned short i;
			unsigned char AH, AL, DH, DL;

			P6_rcv(&AH, 0); P6_rcv(&AL, 0); P6_rcv(&DH, 0); P6_rcv(&DL, 0);
			P6_snd((AH==7)?((AL==0x5f)?0x77:((AL==0xef)?0xef:0xff)):0xff, 0);
			for (i = 1; i < ((((short)DH)<<8)|DL); i++) P6_snd(0xff, 0);
			pc6031.error = 0;
			break;
		}
		case 23: {	// set mode (1D or 2D)
			unsigned char d;
			P6_rcv(&d, 0);
			pc6031.mode =(d&0b00001111);
			pc6031.error = 0;
			break;
		}
		case 24: {	// ask mode
			P6_snd(pc6031.mode, 0);
			pc6031.error = 0;
			break;
		}
		default: ;
		}
	}
}

int main(void)
{	
	DDRA = 0b01111010;	// (1D/2D SW), LED2, LED1, SD card (CS,DI,EJECT,CLK,DO)
	DDRB = 0b11111111;	// data out to P6
	DDRC = 0b00000000;	// data in from P6
	DDRD = 0b11110000;	// ctrl out to P6 (ATN,DAC,RFD,DAV),
						// ctrl in from P6 (ATN,DAC,RFD,DAV)

	PORTA = 0b10000101;	// pull up setting for inputs (1D/2D SW, EJECT, DO)
	PORTB = 0b00000000;
	PORTC = 0b00000000;
	PORTD = 0b10000000;	// ATN output is always 1

	// PC int is used for SD card's eject
	PCMSK0 |= 0x04;
	PCICR |= (1<<PCIE0);

	LED = 0;
	
	pc6031_init();
	
	SD.inited = 0;
	SD_checkEject();
	
	sei();
	
	pc6031_process();
}
