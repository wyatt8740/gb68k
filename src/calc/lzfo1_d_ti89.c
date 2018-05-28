/* lzfo1_d_ti89.c -- LZFO1 1.00 decompression for TI-89

   Copyright (C) 2003-2004 Francesco Orabona

   The LZFO1 is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of
   the License, or (at your option) any later version.

   The LZFO1 is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with the LZO library; see the file COPYING.
   If not, write to the Free Software Foundation, Inc.,
   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

   Francesco Orabona
   bremen79@infinito.it
*/

#define _GENERIC_ARCHIVE

#include "lzfo1.h"

#define N_OFF (15)

static const unsigned basi[N_OFF]={0,1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192};
static const unsigned char agg[N_OFF]={0,0,1,2,3,4,5,6,7,8,9,10,11,12,13};

//static const unsigned char agg2[N_OFF]={7,5,5,5,4,4,3,3,3,3,3,4,4,6,7}; //migliore

static const unsigned char decod2[N_OFF]={6,7,8,9,10,4,5,11,12,1,2,3,13,0,14}; //da questa si ricava cod2

static const unsigned char escl[N_OFF]={0,0,0,0,0,0,0,0,0,0,0,1,1,1,1}; // escl - 2


void lzfo_unpack(unsigned char* p_src_first,
                 unsigned long  src_len,
                 unsigned char* p_dst_first,
                 unsigned long dst_len,
                 unsigned char *p_wrk_mem)
/* Input  : Specify input block using p_src_first and src_len.                */
/* Input  : Point p_dst_first to the start of the output zone.                */
/* Input  : Point p_dst_len to an unsigned long to receive the output length. */
/* Input  : Input block and output zone must not overlap. User knows          */
/* Input  : upperbound on output block length from earlier compression.       */
/* Output : Length of output block written to *p_dst_len.                     */
/* Output : Output block in Mem[p_dst_first..p_dst_first+*p_dst_len-1].       */
/* Output : Writes only  in Mem[p_dst_first..p_dst_first+*p_dst_len-1].       */
/* Input  : Hand over the required amount of working memory in p_wrk_mem.     */
{
	/* Byte pointers p_src and p_dst scan through the input and output blocks.   */
	//register UBYTE *p_src = p_src_first+FLAG_BYTES;
	unsigned char *p_src = p_src_first;
	unsigned char *p_dst = p_dst_first;
	unsigned short b=0; //quanti bit massimo contiene?
	unsigned char nb=0;

	unsigned short index=1;

	unsigned short *ncb= (unsigned short *) p_wrk_mem;

	/* The following two variables are never modified and are used to control    */
	/* the main loop.                                                            */
	//unsigned char *p_src_post  = p_src_first+src_len;
	unsigned char *p_dst_post  = p_dst_first+dst_len;

	ncb[0]=1;
	ncb[1]=2;
	ncb[2]=3;

	*p_dst++=*p_src++;
	*p_dst++=*p_src++;

	//while (p_src!=p_src_post) { /* Start of outer loop */
	while (p_dst!=p_dst_post) { /* Start of outer loop */
		if (nb<8) {
			b|=(*p_src++)<<(8-nb);
			nb+=8;
		}
   
		// leggi bit di controllo
		if ((b&0x8000)==0) { //literal
			nb--;
			b+=b;
			//prendi 8
			if (nb<8) { //ne ho almeno 8?
				b|=(*p_src++)<<(8-nb);
				nb+=8;
			}
			*p_dst++=(b&0xFF00)>>8;
			b<<=8;
			nb-=8;

			index++;
			index&=0x3FFF;
			ncb[(index+1)&0x3FFF]=ncb[index]+1;
		} else { // copy item
			unsigned char lu=0; // lu è al massimo pari a 6
			unsigned char len;
			unsigned short mask;
			unsigned char *p;
			unsigned short offset;
			unsigned short offset2;
			unsigned char bt;

			nb--;
			b+=b;

			// length
			// leggi quanti uno consecutivi
			while ((b&0x8000)!=0) { // qui ne dovrei avere almeno 7, il numero max di uno è 6
				lu++;
				nb--;
				b+=b;
			}

			nb--; // salta il bit zero, dovrei avere questo bit: vedi commento di sopra
			b+=b;

			// prima di proseguire mi ricarico visto che posso aver esurito i bit
			if (nb<8) { //ne ho almeno 8?
				b|=(*p_src++)<<(8-nb);
				nb+=8;
			}

			if (lu==0) { // 2 o 3
				if (b&0x8000) // 3
					len=1;
				else
					len=0;
				nb--;
				b+=b;
			} else {
				// leggi un numero di lu bit
				// ho abbastanza bit?
				// qui ho almeno 7 bit, quindi il controllo dovrebbe essere superfluo
				mask = (1<<lu) - 1;
				mask<<=(16-lu);
				len = (1<<lu) + ((mask & b)>>(16-lu));
				nb-=lu;
				b<<=lu;
			}

			//offset
			// meglio prendere a 7 bit che non a 6
			if (nb<8) {
				b|=(*p_src++)<<(8-nb);
				nb+=8;
			}
			if ((b&0x8000)==0) { // da 0 a 3
				offset = (b & 0x6000) >> 13;
				b<<=3;
				nb-=3;
			} else { // da 4 a 14
				b+=b;
				if ((b&0x8000)==0) { // 4 o da 9 a 14
					b+=b;
					if ((b&0x8000)==0) { // 4
						b+=b;
						offset = 4;
						nb-=3;
					} else { // da 9 a 14
						offset = ((b & 0x6000) >> 13) + 9;
						b<<=3;
						if (offset==3+9) { // da 12 a 14
							if ((b&0x8000)==0) { // 12
								b+=b;
								offset = 12;
								nb-=6;
							} else {
								b+=b;
								if ((b&0x8000)==0)	// 13
									offset = 13;
								else				// 14
									offset =14;
								b+=b;
								nb-=7;
							} 
						} else
							nb-=5; // da 9 a 11

					}
				} else { // da 5 a 8
					offset = ((b & 0x6000) >> 13) + 5;
					b<<=3;
					nb-=4;
				}
			}

			offset=decod2[offset];
			
			len+=escl[offset];

			if (agg[offset]>0) {
				if (nb<8) {
					b|=(*p_src++)<<(8-nb);
					nb+=8;
				}
				bt=agg[offset];
				if (bt>8) {
					offset2=(b&0xFF00)>>(8-(bt-8));
					nb-=8;
					b<<=8;
					b|=(*p_src++)<<(8-nb);
					nb+=8;
					mask=(1<<(bt-8))-1;
					mask<<=16-(bt-8);
					offset2|=(b&mask)>>(16-(bt-8));
					offset=offset2+basi[offset];
					nb-=bt-8;
					b<<=bt-8;
				} else {
					mask=(basi[offset]-1)<<(16-bt);
					offset=basi[offset]+((b&mask)>>(16-bt));

					nb-=bt;
					b<<=bt;
				}
			}

			p = p_dst-(ncb[(index+1)&0x3FFF]-ncb[(index-offset)&0x3FFF]);

			index++;
			index&=0x3FFF;
			ncb[(index+1)&0x3FFF]=ncb[index]+len+2;

			/* Now perform the copy using a half unrolled loop. */
			*p_dst++=*p++;
			*p_dst++=*p++;
			while (len--)
				*p_dst++=*p++;
		}
	}       
}
