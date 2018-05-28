/* lzfo1_c_ti89.c -- LZFO1 1.00 compression for TI-89

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

#include <tigcclib.h>
#include "lzfo1.h"

/* Updating of the hash table. */
/* Updating consists of identifying and overwriting a pointer in a partition  */
/* with a newer pointer and then updating the cycle values.             */
#define UPDATE_P(P_BASE,INDEX,NEWPTR,NCB) \
{(P_BASE)[cycle[INDEX]].offset=(NEWPTR); (P_BASE)[cycle[INDEX]++].ncbp=(NCB); cycle[INDEX]&=DEPTH_MASK;}

/******************************************************************************/

struct sHT {
	unsigned short offset;
	unsigned short ncbp; // number of partial control bits
};

typedef struct sHT HT;

typedef HT* pHT;

unsigned char *p_dst;
unsigned char putbuf;
unsigned char putlen;

static const unsigned char lun[128]={2,2,3,3,5,5,5,5,7,7,7,7,7,7,7,7,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,
                              11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,
                              13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,
                              13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13};

static const unsigned cod[128]={4,4,12,12,56,56,56,56,240,240,240,240,240,240,240,240,
					     992,992,992,992,992,992,992,992,992,992,992,992,992,992,992,992,
						 4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,
						 4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,4032,
						 16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,
						 16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,
						 16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,
						 16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256,16256};

static const unsigned cod2[15]={94,20,21,22,12,13,0,1,2,3,4,14,15,46,95};

#define N_OFF (15)
#define MAX_OFF (16384-2)

static const unsigned char agg[N_OFF]={0,0,1,2,3,4,5,6,7,8,9,10,11,12,13};
static const unsigned char agg2[N_OFF]={7,5,5,5,4,4,3,3,3,3,3,4,4,6,7}; //migliore

static const unsigned char escl[N_OFF]={2,2,2,2,2,2,2,2,2,2,2,3,3,3,3}; // per elias modificato

inline static unsigned char lunghezza(const unsigned int number)
{
	//0,1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192
  //0,1,2,3,4,5, 6, 7, 8,  9,  10, 11,  12,  13,  14
	if (number>=128)
		if (number>=1024)
			if (number>=4096)
				if (number>=8192)
					return 14;
				else
					return 13;
			else if (number>=2048)
				return 12;
			else
				return 11;
		else if (number>=256)
			if (number>=512)
				return 10;
			else
				return 9;
		else
			return 8; // 3 if
	else 
		if (number>=8)
			if (number>=32)
				if (number>=64)
					return 7;
				else
					return 6;
			else if (number>=16)
				return 5;
			else
				return 4;
		else if (number>=2)
			if (number>=4)
				return 3;
			else
				return 2;
		else if (number>=1)
			return 1; //4 if
		else
			return 0; //4 if
		// altra variante: tolgo quest'ultimo if e metto
		/*else
			return number;*/
}


// - se la lunghezza minima da inserire è 8 si può ottimizzare! ma i bit aggiunti sono min 0!
// l = lunghezza
// c = bit da inserire
static void Putcode(unsigned char l, unsigned c) {
	if ( putlen+l>=8 ) {
		*p_dst++ = putbuf | (c >> (l-(8-putlen)));
		l-=(8-putlen);
		c&=(1<<l)-1;
		if ( l>=8 ) { // solo in caso in cui putlen+l==16! putbuf si svuota tutto!
			*p_dst++ = c >> (l-8);
			putbuf = (c & ( (1<<(l-8))-1 ))<<(8-(l-8));
			putlen = l-8;
		} else {
			putbuf = c << (8-l);
			putlen = l;
		}
	} else {
		putbuf = putbuf | ( c << (8-putlen-l) );
		putlen+=l;
	}
}

// versione per inserire 9 bit
static void Putcode9(unsigned c) {
	unsigned char l=9;
	
	*p_dst++ = putbuf | (c >> (l-(8-putlen)));
	l-=(8-putlen);
	c&=(1<<l)-1;
	//if ( l>=8 ) { // solo in caso in cui putlen+l==16! putbuf si svuota tutto!
	if ( l==8 ) { // solo in caso in cui putlen+l==16! putbuf si svuota tutto!
		*p_dst++ = c;
		putbuf = 0;
		putlen = 0;
		/**p_dst++ = c >> (l-8);
		putbuf = (c & ( (1<<(l-8))-1 ))<<(8-(l-8));
		putlen = l-8;*/
	} else {
		putbuf = c << (8-l);
		putlen = l;
	}
}

char lzfo_pack(unsigned char *p_src_first,
                 unsigned long  src_len,
                 unsigned char *p_dst_first,
                 unsigned long *p_dst_len,
                 unsigned char *p_wrk_mem
                 )
/* Input  : Specify input block using p_src_first and src_len.                */
/* Input  : Point p_dst_first to the start of the output zone.                */
/* Input  : Point p_dst_len to a unsigned long to receive the output length.  */
/* Input  : Input block and output zone must not overlap.                     */
/* Output : Length of output block written to *p_dst_len.                     */
/* Output : Output block in Mem[p_dst_first..p_dst_first+*p_dst_len-1].       */
/* Input  : Hand over the required amount of working memory in p_wrk_mem.     */
{
	unsigned char *p_src = p_src_first;

	/* The following variables are never modified and are used in the            */
	/* calculations that determine when the main loop terminates.                */
	const unsigned char *p_src_post  = p_src_first+src_len;
	const unsigned char *p_dst_post  = p_dst_first+src_len;

	/* The variable 'hash' always points to the first element of the hash table. */
	pHT hash = (pHT) p_wrk_mem;
 
 	unsigned char *cycle = ((unsigned char *) hash)+sizeof(HT)*HASH_TABLE_LENGTH;

	unsigned short ncb=1;
	
	unsigned short index;

	putbuf = 0;
	putlen = 0;

	p_dst = p_dst_first;

	memset(hash,0,sizeof(HT)*HASH_TABLE_LENGTH+PARTITION_LENGTH*sizeof(unsigned char));
	
	// questa entry è già inserita in tutta la hash dal memset
	// inoltre nn deve essere inserita se si usa il break nella ricerca x evitare entry vuote
	// altrimenti la lista in cui viene inserita la entry 0,0 per prima rimarrà sempre inutilizzata
	index=HASH(p_src);
	UPDATE_P(&hash[index << HASH_TABLE_DEPTH_BITS],index,0,1);
	*p_dst++=*p_src++;
	index=HASH(p_src);
	UPDATE_P(&hash[index << HASH_TABLE_DEPTH_BITS],index,1,2);
	*p_dst++=*p_src++;
	ncb+=2;
	
	do { /* Begin main processing loop. */
		pHT p_h0;              /* Pointer to current partition.              */
		unsigned d;          /* Depth looping variable.                    */
		unsigned short bestlen;    /* Holds the best length seen so far.         */
		unsigned short bestpos;    /* Holds the offset of best pointer seen so far.  */
		unsigned short bestlen2;

		/* To process the next phrase, we hash the next three bytes to obtain  */
		/* an index to the zeroth (first) pointer in a target partition. We    */
		/* get the pointer.                                                    */
		index=HASH(p_src);
		p_h0=&hash[index << HASH_TABLE_DEPTH_BITS];

		/* This next part runs through the pointers in the partition matching  */
		/* the bytes they point to in the Lempel with the bytes in the Ziv.    */
		bestlen=1;
		bestlen2=50;
		for (d=0;d<HASH_TABLE_DEPTH;d++) {
			unsigned char *s=p_src;
			unsigned char *p=p_src_first + p_h0[d].offset;
						
			if (p_h0[d].ncbp==0) break;
			if (*p++==*s++ && *p++==*s++) {
				unsigned len;
				unsigned char len2;

				#define PS *p++!=*s++
				PS || PS || PS || PS || PS || PS || PS || PS || s++;
				len=s-p_src-1;

				if (len>9) {
				//if (len>17) {
					--s;
					while (*s++ == *p++)
						;
					len=s-p_src-1;
					if (len>129)
						len=129;

					if ( (ncb-p_h0[d].ncbp-1)<=MAX_OFF ) {
						unsigned char t=lunghezza(ncb-p_h0[d].ncbp-1);
						len2=agg[t]+agg2[t]+lun[len-escl[t]];
					} else
						continue;
				}	else if ( (ncb-p_h0[d].ncbp-1)<=MAX_OFF ) {
					unsigned char t=lunghezza(ncb-p_h0[d].ncbp-1);
					if (len>=escl[t])
						len2=agg[t]+agg2[t]+lun[len-escl[t]];
					else
						continue;
				} else
					continue;
				if (len2+bestlen*8<bestlen2+len*8) {
				//if ( len*(bestlen2+1)>bestlen*(len2+1) ) {
					bestpos=ncb-p_h0[d].ncbp-1;
					bestlen2=len2;
					bestlen=len;
				}
			}
		}
		
		mezzo:

    UPDATE_P(p_h0,index,(unsigned short)(p_src-p_src_first),ncb);
    
		if (bestlen==1) {
			literal:
			ncb++;
			Putcode9(*p_src);
			p_src++;
		} else {
			//LAZY MATCHING
			// all the variables for the second match have a 'b' in the ending of the name
			unsigned short bestlenb;
			unsigned short bestposb;
			unsigned short bestlen2b;

			index=HASH(p_src+1);
			p_h0=&hash[index << HASH_TABLE_DEPTH_BITS];
	
			bestlenb=1;
			bestlen2b=50;
			for (d=0;d<HASH_TABLE_DEPTH;d++) {
				unsigned char *s=p_src+1;
				unsigned char *p=p_src_first + p_h0[d].offset;
				
				if (p_h0[d].ncbp==0) break;
				if (*p++==*s++ && *p++==*s++) {
					unsigned len;
					unsigned char len2;

					#define PS *p++!=*s++
					PS || PS || PS || PS || PS || PS || PS || PS || s++;
					len=s-(p_src+1)-1;
					
					if (len>9) {
					//if (len>17) {
						--s;
						while (*s++ == *p++)
							;
						len=s-(p_src+1)-1;
						if (len>129)
							len=129;

						if ((ncb+1-p_h0[d].ncbp-1)<=MAX_OFF) {
							unsigned char t=lunghezza(ncb+1-p_h0[d].ncbp-1);
							len2=agg[t]+agg2[t]+lun[len-escl[t]];
						} else
							continue;
					}	else if ((ncb+1-p_h0[d].ncbp-1)<=MAX_OFF) {
						unsigned char t=lunghezza(ncb+1-p_h0[d].ncbp-1);
						if (len>=escl[t])
							len2=agg[t]+agg2[t]+lun[len-escl[t]];
						else
							continue;
					} else
						continue;

					if (len2+bestlenb*8<bestlen2b+len*8) {
					//if ( len*(bestlen2b+1)>bestlenb*(len2+1) ) {
						  bestposb=ncb+1-p_h0[d].ncbp-1;
						  bestlen2b=len2;
						  bestlenb=len;
					}
				}
			}


			if ( (1+bestlenb)*(bestlen2+1)>(1+bestlen2b+1+8)*bestlen ) {
				//literal
				ncb++;
				/*Putcode(1,0);
				Putcode(8,*p_src);*/
				Putcode9(*p_src);
				p_src++;
	
				// questo controllo dovrebbe stare anke prima del lazy matching???
				if (p_src == p_src_post) goto fine;
				
				bestlen=bestlenb;
				bestpos=bestposb;
				bestlen2=bestlen2b;
				
				goto mezzo;
			}
			
			unsigned char t=lunghezza(bestpos);
			
			if (p_src+bestlen>p_src_post) {
				bestlen=p_src_post-p_src;
				if (bestlen<escl[t] || (agg[t]+agg2[t]+lun[bestlen-escl[t]])>=bestlen*8)
					goto literal;
			}

			/* Copy */
			/* To code a copy item, we construct a hash table index of the      */
			/* winning pointer (index+=bestpos) and code it and the best length */

			// code for the lenghts
			#define mezzalun(x) ( (lun[x]-1)>>1 )
			#define codice(x) ( cod[(x)]|((x)-((x)<2?0:1<<mezzalun(x))) )

			ncb++;
			
			Putcode( lun[bestlen-escl[t]]+1, codice(bestlen-escl[t]) ); //lenght + flag
			Putcode(agg2[t],cod2[t]);
			if (agg[t]>0)
				Putcode(agg[t],bestpos-(1<<(t-1)));

			p_src+=bestlen;
		}
		
		if (p_dst>p_dst_post)
			return LZFO_E_OVERRUN;

	} while(p_src != p_src_post); /* End main processing loop. */
  
 fine:
	if (putlen>0)
		*p_dst++ = putbuf;

	/* Write the length of the output block to the dst_len parameter and return. */
	*p_dst_len=p_dst-p_dst_first;
	return LZFO_E_OK;
}
