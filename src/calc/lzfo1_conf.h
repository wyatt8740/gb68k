/* lzfo1_conf.h -- LZFO1 1.00 compression for TI-89

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

/* This constant defines the number of pointers in the hash table. The number */
/* of partitions multiplied by the number of pointers in each partition must  */
/* multiply out to this value of 4096. In LZRW1, LZRW1-A, and LZRW2, this     */
/* table length value can be changed.                                         */
#define HASH_TABLE_LENGTH_BITS (13) /* Must be in range [0,16] */

/* The following definition is the log_2 of the depth of the hash table. This */
/* constant can be in the range [0,1,2,3,...,12]. Increasing the depth        */
/* increases compression at the expense of speed. However, you are not likely */
/* to see much of a compression improvement (e.g. not more than 0.5%) above a */
/* value of 6 and the algorithm will start to get very slow.                  */
/* Note: Changing the value of HASH_TABLE_DEPTH_BITS is the ONLY thing you    */
/* have to do to change the depth, so go ahead and recompile now!             */
#define HASH_TABLE_DEPTH_BITS (5) /* Must be in range [0,HASH_TABLE_LENGTH_BITS] */
