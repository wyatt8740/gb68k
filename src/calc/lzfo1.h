/* lzfo1.h -- LZFO1 1.00 compression for TI-89

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

#define HASH_TABLE_LENGTH (1<<HASH_TABLE_LENGTH_BITS)
#define COPY_LENGTH_BITS (HASH_TABLE_LENGTH_BITS-8)

/* The following definitions are all self-explanatory and follow from the     */
/* definition of HASH_TABLE_DEPTH_BITS.                                       */
#define PARTITION_LENGTH_BITS (HASH_TABLE_LENGTH_BITS-HASH_TABLE_DEPTH_BITS)
#define PARTITION_LENGTH      (1<<PARTITION_LENGTH_BITS)
#define HASH_TABLE_DEPTH      (1<<HASH_TABLE_DEPTH_BITS )
#define HASH_MASK             (PARTITION_LENGTH-1)
#define DEPTH_MASK            (HASH_TABLE_DEPTH-1)

/* The following macro accepts a pointer PTR to three consecutive bytes in    */
/* memory and hashes them into an integer that is a hash table index that     */
/* points to the zeroth (first) element of a partition. Thus, the hash        */
/* function really hashes to a partition number but, for convenience,         */
/* multiplies it up to yield a hash table index. From all this, we see that   */
/* the resultant number is in the range [0,HASH_TABLE_LENGTH-1] and is a      */
/* multiple of HASH_TABLE_DEPTH.                                              */
/* A macro is used, because in LZRW3-A we have to hash more than once.        */
#define HASH(PTR) \
 ( \
     ( (( 40543U * (   *(PTR) ^ ((*((PTR)+1))<<8)   ) ) & 0xFFFF) >>(16-PARTITION_LENGTH_BITS) ) \
 )

// NOTA nn posso shiftare + di 8 bit x volta???

#define LZFO_E_OK								(0)
#define LZFO_E_OVERRUN					(-1)
//#define LZFO_E_ERROR                 (-1)
//#define LZFO_E_INPUT_OVERRUN         (-4)
//#define LZFO_E_OUTPUT_OVERRUN        (-5)
//#define LZFO_E_LOOKBEHIND_OVERRUN    (-6)
//#define LZFO_E_EOF_NOT_FOUND         (-7)
//#define LZFO_E_INPUT_NOT_CONSUMED    (-8)


char lzfo_pack(unsigned char *p_src_first,
                 unsigned long  src_len,
                 unsigned char *p_dst_first,
                 unsigned long *p_dst_len,
                 unsigned char *p_wrk_mem);

void lzfo_unpack(unsigned char* p_src_first,
                 unsigned long  src_len,
                 unsigned char* p_dst_first,
                 unsigned long dst_len,
                 unsigned char *p_wrk_mem);

#include "lzfo1_conf.h"
