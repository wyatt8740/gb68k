| Assembly Source File
| Created 7/30/2004; 12:28:37 AM

.include "gbasm.h"

/*
Bit 7 - LCD Display Enable             (0=Off, 1=On)
Bit 6 - Window Tile Map Display Select (0=9800-9BFF, 1=9C00-9FFF)
Bit 5 - Window Display Enable          (0=Off, 1=On)
Bit 4 - BG & Window Tile Data Select   (0=8800-97FF, 1=8000-8FFF)
Bit 3 - BG Tile Map Display Select     (0=9800-9BFF, 1=9C00-9FFF)
Bit 2 - OBJ (Sprite) Size              (0=8x8, 1=8x16)
Bit 1 - OBJ (Sprite) Display Enable    (0=Off, 1=On)
Bit 0 - BG Display (for CGB see below) (0=Off, 1=On)
*/


.equ BG_WIDTH, 22

/*
gb_mem - %a3
gb_pc - %a4
gb_data - %a5
gb_A %d5
gb_F0 %d6
gb_F1 %d7
*/

| inputs:
|	%a2 - pointer to palette
|	%a3 - pointer to sprite
|	%a4 - where to put the sprite
| modifies:
|	d0, d1, d2, d3, d4, d5, a6, d7 destroyed
|	a2 preserved, a3 += 16, a4 += 16
apply_bg_palette:
	moveq #7, %d7 | d7 is counter
	movea.l %a2, %a6
0:
	move.b (%a3)+, %d0 | get sprite into d0
	move.b (%a3)+, %d1 | get sprite into d1

	move.b %d0, %d2
	or.b %d1, %d2
	not.b %d2 | d2 = !dark & !light
	move.b %d2, %d3
	and.b (%a2)+, %d2 | d2 = palette_color & mask
	and.b (%a2)+, %d3 | d3 = palette_color & mask
	move.b %d2, %d4 | store the line so far
	move.b %d3, %d5

	move.b %d1, %d2
	not.b %d2
	and.b %d0, %d2 | d2 = !dark & light
	move.b %d2, %d3
	and.b (%a2)+, %d2 | d2 = palette_color & mask
	and.b (%a2)+, %d3 | d3 = palette_color & mask
	or.b %d2, %d4 | add the next color
	or.b %d3, %d5

	move.b %d0, %d2
	not.b %d2
	and.b %d1, %d2 | d2 = dark & !light
	move.b %d2, %d3
	and.b (%a2)+, %d2 | d2 = palette_color & mask
	and.b (%a2)+, %d3 | d3 = palette_color & mask
	or.b %d2, %d4 | add the next color
	or.b %d3, %d5

	move.b %d0, %d2
	and.b %d1, %d2 | d2 = dark & light
	move.b %d2, %d3
	and.b (%a2)+, %d2 | d2 = palette_color & mask
	and.b (%a2)+, %d3 | d3 = palette_color & mask
	or.b %d2, %d4 | add the final color
	or.b %d3, %d5

	move.b %d4, (%a4)+
	move.b %d5, (%a4)+
	movea.l %a6, %a2 | go back to start of palette
	dbf %d7, 0b
	rts

| inputs:
|	%a2 - pointer to palette
|	%a3 - where to put the sprite
|	%a4 - pointer to sprite
|	%a6 - where to put the mask
|	%d7 - hieght of sprite
| modifies:
|	d0, d1, d2, d3, d4, d5, d7 destroyed
|	a2 preserved, a3 += 16, a4 += 16, a6 += 8
apply_obj_palette:
0:
	move.b (%a4)+, %d0 | get sprite into d0
	move.b (%a4)+, %d1 | get sprite into d1

	move.b %d1, %d2
	not.b %d2
	and.b %d0, %d2 | d2 = !dark & light
	move.b %d2, %d3
	and.b (%a2)+, %d2 | d2 = palette_color & mask
	and.b (%a2)+, %d3 | d3 = palette_color & mask
	move.b %d2, %d4 | add the next color
	move.b %d3, %d5

	move.b %d0, %d2
	not.b %d2
	and.b %d1, %d2 | d2 = dark & !light
	move.b %d2, %d3
	and.b (%a2)+, %d2 | d2 = palette_color & mask
	and.b (%a2)+, %d3 | d3 = palette_color & mask
	or.b %d2, %d4 | add the next color
	or.b %d3, %d5

	move.b %d0, %d2
	and.b %d1, %d2 | d2 = dark & light
	move.b %d2, %d3
	and.b (%a2)+, %d2 | d2 = palette_color & mask
	and.b (%a2)+, %d3 | d3 = palette_color & mask
	or.b %d2, %d4 | add the final color
	or.b %d3, %d5

	move.b %d0, %d2
	or.b %d1, %d2
	not.b %d2

	move.b %d2, (%a6)+ | store mask
	move.b %d4, (%a3)+ | store light
	move.b %d5, (%a3)+ | store dark
	lea (-6, %a2), %a2 | go back to start of palette
	dbf %d7, 0b
	rts

| %a0 is light plane
| %a1 is dark plane

| %a2 is video ram base
| %a3 is IO base
| %a4 is tilemap data / oam data
| %a6 is tiledata
| %d1 is scx
| %d2 is scy
| %d4 is x counter
| %d5 is y counter
| %d7 is y offset

clear_buffer:
	movem.l %d0-%d5/%a0-%a1, -(%a7)
	movea.l screen_buffer(%pc), %a0
	tst.b (CALC_TYPE, %a5)
	beq 0f
| TI92
	lea (144*24+2,%a0),%a0
	lea (160*24, %a0), %a1
	moveq #127, %d5
	bra 1f
0:
| TI89
	lea (116*24+2,%a0),%a0
	lea (132*24, %a0), %a1
	moveq #99, %d5	
1:
	moveq #0x0, %d0
	moveq #0x0, %d1
	moveq #0x0, %d2
	moveq #0x0, %d3
	moveq #0x0, %d4
0:
	lea (-4, %a0), %a0
	movem.l %d0-%d4, -(%a0)
	lea (-4, %a1), %a1
	movem.l %d0-%d4, -(%a1)

	dbf %d5, 0b

	movem.l (%a7)+, %d0-%d5/%a0-%a1
	rts

.even
.global screen_buffer
screen_buffer:
.long 0
.global draw_screen
.global apply_patch89
.global apply_patch92
.global bg_next_tile | code modified by io_write_LCDC
.global window_next_tile | code modified by io_write_LCDC
patch_loc_table:
.long patch02
.long patch03
.long patch04
.long patch09
.long patch0A
.long patch0F
.long patch01
.long patch08
.long patch0B
.long patch0C
.long patch0D
.long patch0E
.long patch10
.long patch11

patch_table89:
	moveq #13, %d5 | draw 14 rows | PATCH 2
	moveq #13, %d5 | PATCH 3
	moveq #99, %d1 | PATCH 4
	moveq #14-1, %d5 | PATCH 9
	moveq #99, %d5 | PATCH 10
	moveq #99, %d7 | PATCH 15

	lea (132*24, %a0), %a1 | a1 is dark | PATCH 1
	cmpi.w #100, %d1 | PATCH 8
	lea (132*24, %a0), %a1 | PATCH 11
	lea (132*24, %a0), %a1 | PATCH 12
	cmpi.w #115, %d1 | PATCH 13
	lea (132*24, %a0), %a1 | PATCH 14
	lea (-(192 * 14 - 1), %a0), %a0 | get set for next colum | PATCH 16
	lea (-(192 * 14 - 1), %a1), %a1 | PATCH 17
	
patch_table92:
	moveq #16, %d5 | draw 17 rows | PATCH 2
	moveq #16, %d5 | PATCH 3
	moveq #127, %d1 | PATCH 4
	moveq #17-1, %d5 | PATCH 9
	moveq #127, %d5 | PATCH 10
	moveq #127, %d7 | PATCH 15
	
	lea (160*24, %a0), %a1 | a1 is dark | PATCH 1
	cmpi.w #128, %d1 | PATCH 8
	lea (160*24, %a0), %a1 | PATCH 11
	lea (160*24, %a0), %a1 | PATCH 12
	cmpi.w #143, %d1 | PATCH 13
	lea (160*24, %a0), %a1 | PATCH 14
	lea (-(192 * 17 - 1), %a0), %a0 | get set for next colum | PATCH 16
	lea (-(192 * 17 - 1), %a1), %a1 | PATCH 17
	
apply_patch89:
	movem.l %a0-%a2/%d0, -(%a7)	
	lea patch_table89, %a0
	bra apply_patch
apply_patch92:
	movem.l %a0-%a2/%d0, -(%a7)	
	lea patch_table92, %a0
apply_patch:
	lea patch_loc_table, %a1
	moveq #6 - 1, %d0
0:
	move.l (%a1)+, %a2
	move.w (%a0)+, (%a2)
	dbf %d0,0b

	moveq.l #8 - 1,%d0
0:
	move.l (%a1)+, %a2
	move.l (%a0)+, (%a2)
	dbf %d0,0b
	movem.l (%a7)+, %a0-%a2/%d0
	rts


draw_screen:
	movem.l  %d0-%d7/%a0-%a6,-(%a7)

	movea.l (MEM_TABLE+1024, %a5), %a2 | a2 is video ram
	movea.l (MEM_TABLE+2040, %a5), %a3 | a3 is IO base
	move.b (LCDC, %a3), %d0
	btst #0, %d0
	bne 0f
	jbsr clear_buffer | bg turned off
	bra draw_window
0:
	moveq.l #0,%d1
	moveq.l #0,%d2
	move.b (SCX, %a3), %d1
	move.b (SCY, %a3), %d2
	add.b (Y_OFFSET, %a5), %d2

	movea.l screen_buffer(%pc), %a0
	lea (16*24 + 2, %a0), %a0 | a0 is light
	move.l %d2, %d3
	and.b #0x07, %d3
	lsl.w #3, %d3
	move.w %d3, %d4
	add.w %d3, %d3
	add.w %d4, %d3 | d3 = y_off * 24
	suba.l %d3, %a0 | move up y_off rows
	move.w %d1, %d3
	and.b #7, %d3
patch01:
	lea (132*24, %a0), %a1 | a1 is dark | PATCH 1

	lsr.b #3, %d1 | d1 -> tile_x
	and.w #~7, %d2
	lsl.w #2, %d2
	move.w %d1, %d3
	add.w %d2, %d3 | d3 is now map_pos
	moveq #21-1, %d4 | draw 21 colums
patch02:
	moveq #14-1, %d5 | draw 14 rows | PATCH 2
	movea.l (BG_TILEMAP, %a5), %a3
	movea.l (BG_WINDOW_UPDATE_PAL, %a5), %a2
	movea.l (BG_WINDOW_GFX, %a5), %a6
| %a0 is light plane
| %a1 is dark plane
| %a2 is tile updates
| %a3 is tilemap
| %a4 is current (palettized) tile
| %a6 is palettized gfx
bg_next_tile:
| There are two cases for code here to get tile index in d6
| unsigned version:
|	clr.w %d6
|	move.b (%a3, %d3.w), %d6
| or signed version:
|	move.b (%a3, %d3.w), %d6
|	ext.w %d6
	.word 0x4246 | 0100 0010 01 000 110 - clr.w %d6
	.word 0x1C33 | 0001 000 110 110 011 - move.b (%a3, %d3.w), %d6
	.word 0x3000 | 0 011 0 000 00000000 - ext word for move
|	.word 0x1C33
|	.word 0x3000
|	.word 0x4886 | 0100 100 010 000 110 - ext.w %d6

	btst.b #0, (%a2, %d6.w)
	bne no_update_palette
| apply palette to current tile
	movem.l %d0-%d7/%a2-%a3/%a6, -(%a7)
	bset.b #0, (%a2, %d6.w) | set flag to indicate palette is up to date
	lea (BG_PALETTE, %a5), %a2 | a2 is palette to apply
	lsl.w #4, %d6 | d6 *= 16
	lea (%a6, %d6.w), %a4 | a4 points to to-be-palettized tile
	movea.l (BG_WINDOW_TILEDATA, %a5), %a3
	lea (%a3, %d6.w), %a3 | a3 points to origonal tile
	jbsr apply_bg_palette
	movem.l (%a7)+, %d0-%d7/%a2-%a3/%a6
no_update_palette:
	lsl.w #4, %d6 | d6 *= 16
	lea (%a6, %d6.w), %a4 | a4 points to tile we want to draw
	| here we draw the tile
	move.b (%a4)+, (%a0)
	move.b (%a4)+, (%a1)
	move.b (%a4)+, (%a0, 24)
	move.b (%a4)+, (%a1, 24)
	move.b (%a4)+, (%a0, 48)
	move.b (%a4)+, (%a1, 48)
	move.b (%a4)+, (%a0, 72)
	move.b (%a4)+, (%a1, 72)
	move.b (%a4)+, (%a0, 96)
	move.b (%a4)+, (%a1, 96)
	move.b (%a4)+, (%a0, 120)
	move.b (%a4)+, (%a1, 120)
	move.b (%a4)+, (%a0, 144)
	move.b (%a4)+, (%a1, 144)
	move.b (%a4)+, (%a0, 168)
	move.b (%a4), (%a1, 168)

	addi.w #32, %d3 | advance map pos to next row
	and.w #1023, %d3 | loop back if needed
	lea (192, %a0), %a0
	lea (192, %a1), %a1
	dbf %d5, bg_next_tile
patch03:
	moveq #13, %d5 | PATCH 3
patch10:
	lea (-(192 * 14 - 1), %a0), %a0 | get set for next colum | PATCH 16
patch11:
	lea (-(192 * 14 - 1), %a1), %a1 | PATCH 17
	addq.w #1, %d1 | tile_x++;
	and.w #31, %d1 | loop back if needed
	move.w %d1, %d3
	add.w %d2, %d3 | d3 is updated map pos
	dbf %d4, bg_next_tile

	| Here, all the tiles have been drawn on the screen. Now, we need to scroll them !

	movea.l (MEM_TABLE+2040, %a5), %a3 | a3 is IO base
	clr.w %d0
	move.b (SCX, %a3), %d0
	and.b #7, %d0 | d0 = shift
	beq draw_window
	moveq.l #-1,%d2
	lsl.w %d0,%d2
	move.w %d2,%d3
	not.w %d3

	movea.l screen_buffer(%pc), %a0
	lea (16*24 + 2, %a0), %a0 | Skip 16 rows

	moveq.l #1,%d7 | plane count
screen_loop:
patch04:
	moveq #99, %d1 | PATCH 4 - draw 100 rows
scroll_loop:
	movea.l %a0, %a1 | source and destination are the same

	move.l (%a0)+, %d4
	lsl.l  %d0, %d4

	move.l (%a0)+, %d5
	rol.l %d0, %d5
	move.w %d5, %d6
	and.w %d3, %d6 | erase the left part
	or.w %d6, %d4 | add it to the previous datas
	move.l %d4, (%a1)+ | draw it ! (0-32)
	and.w %d2, %d5 | erase the right part

	move.l (%a0)+, %d4
	rol.l %d0, %d4
	move.w %d4, %d6
	and.w %d3,%d6
	or.w %d6, %d5
	move.l %d5,(%a1)+ | (32-64)
	and.w %d2,%d4

	move.l (%a0)+, %d5
	rol.l %d0, %d5
	move.w %d5, %d6
	and.w %d3, %d6
	or.w %d6, %d4
	move.l %d4, (%a1)+ | (64-96)
	and.w %d2, %d5

	move.l (%a0)+, %d4
	rol.l %d0, %d4
	move.w %d4, %d6
	and.w %d3,%d6
	or.w %d6, %d5
	move.l %d5,(%a1)+ | (96-128)
	and.w %d2,%d4

	move.b (%a0)+, %d5
	rol.b %d0, %d5
	and.b %d3, %d5
	or.b %d5, %d4
	move.l %d4, (%a1)+ | (128-160)

	addq.l #3,%a0

	dbf %d1, scroll_loop

	lea.l (32*24, %a0),%a0 | Work with the dark screen now
	dbf %d7, screen_loop

draw_window:
	movea.l (MEM_TABLE+2040, %a5), %a0 | a0 is io base
	movea.l (MEM_TABLE+1024, %a5), %a2 | a2 is video ram
	move.b (LCDC, %a0), %d0
	btst #5, %d0
	beq draw_sprites | window turned off
	move.b (WX, %a0), %d1
	subq.b #7, %d1
	bgt draw_sprites | no support for unaligned window (for now)
	moveq.l #0, %d1
	move.b (WY, %a0), %d1
	clr.w %d2
	move.b (Y_OFFSET, %a5), %d2
	sub.w %d2, %d1
patch08:
	cmpi.w #100, %d1 | PATCH 8
	bge draw_sprites
	tst.w %d1
	bge 0f
| clip off the top
	ext.w %d1
	neg.w %d1
	move.w %d1, %d3
	and.w #~7, %d3
	lsl.w #2, %d3 | d3 is now map_pos ((d3 / 8) * 32)
	and.w #0x07, %d1
	lsl.w #3, %d1
	move.w %d1, %d2
	add.w %d2, %d2
	add.w %d2, %d1 | d1 = y_off * 24
	neg.w %d1
	ext.l %d1
patch09:
	moveq #14-1, %d5 | PATCH 9
	bra 1f
0:
| no clipping
patch0A:
	moveq #99, %d5 | PATCH 10
	addq #1, %d5
	sub.w %d1, %d5 | d2 = 100 - WY
	lsr.w #3, %d5
	lsl.w #3, %d1
	move.w %d1, %d2
	add.w %d2, %d2
	add.w %d2, %d1 | d1 = WY * 24
	moveq #0, %d3 | d3 is map_pos
1:
	movea.l screen_buffer(%pc), %a0
	lea (16*24+2, %a0), %a0
	adda.l %d1, %a0
patch0B:
	lea (132*24, %a0), %a1 | PATCH 11
	moveq #21-1, %d4 | draw 21 colums
	move.w %d5, -(%a7)
	move.w %d3, -(%a7)
	move.l %a0, -(%a7)
	move.l %a1, -(%a7)
| %a0 is light plane
| %a1 is dark plane
| %a2 is tile updates
| %a3 is tilemap
| %a4 is current (palettized) tile
| %a6 is palettized gfx
	movea.l (BG_WINDOW_UPDATE_PAL, %a5), %a2
	movea.l (WINDOW_TILEMAP, %a5), %a3
	movea.l (BG_WINDOW_GFX, %a5), %a6
window_next_tile:
	.word 0x4246 | 0100 0010 01 000 110 - clr.w %d6
	.word 0x1C33 | 0001 000 110 110 011 - move.b (%a3, %d3.w), %d6
	.word 0x3000 | 0 011 0 000 00000000 - ext word for move

	btst.b #0, (%a2, %d6.w)
	bne 0f
| apply palette to current tile
	movem.l %d0-%d7/%a2-%a3/%a6, -(%a7)
	bset.b #0, (%a2, %d6.w) | set flag to indicate palette is up to date
	lea (BG_PALETTE, %a5), %a2 | a2 is palette to apply
	lsl.w #4, %d6 | d6 *= 16
	lea (%a6, %d6.w), %a4 | a4 points to to-be-palettized tile
	movea.l (BG_WINDOW_TILEDATA, %a5), %a3
	lea (%a3, %d6.w), %a3 | a3 points to origonal tile
	jbsr apply_bg_palette
	movem.l (%a7)+, %d0-%d7/%a2-%a3/%a6
0:
	lsl.w #4, %d6 | d6 *= 16
	lea (%a6, %d6.w), %a4 | a4 points to tile we want to draw
	| here we draw the tile
	move.b (%a4)+, (%a0)
	move.b (%a4)+, (%a1)
	move.b (%a4)+, (%a0, 24)
	move.b (%a4)+, (%a1, 24)
	move.b (%a4)+, (%a0, 48)
	move.b (%a4)+, (%a1, 48)
	move.b (%a4)+, (%a0, 72)
	move.b (%a4)+, (%a1, 72)
	move.b (%a4)+, (%a0, 96)
	move.b (%a4)+, (%a1, 96)
	move.b (%a4)+, (%a0, 120)
	move.b (%a4)+, (%a1, 120)
	move.b (%a4)+, (%a0, 144)
	move.b (%a4)+, (%a1, 144)
	move.b (%a4)+, (%a0, 168)
	move.b (%a4), (%a1, 168)

	addi.w #32, %d3 | advance map pos to next row
	lea (192, %a0), %a0
	lea (192, %a1), %a1
	dbf %d5, window_next_tile

	move.w (10, %a7), %d5
	movea.l (%a7)+, %a1 | get dark ready for next colum
	movea.l (%a7)+, %a0 | get light ready for next colum
	addq.l #1, %a0
	addq.l #1, %a1
	move.l %a0, -(%a7)
	move.l %a1, -(%a7)
	moveq #22-1, %d3
	sub.w %d4, %d3 | map_pos = 22 - x_counter
	add.w (8, %a7), %d3
	dbf %d4, window_next_tile

	lea (12, %a7), %a7 | cleanup stack
draw_sprites:
	movea.l (MEM_TABLE+2040, %a5), %a0
	move.b (LCDC, %a0), %d0
	btst #1, %d0
	beq copy_buffer | sprites turned off
	movea.l screen_buffer(%pc), %a0
patch0C:
	lea (132*24, %a0), %a1 | PATCH 12
	move.l %a0, -(%a7)
	move.l %a1, -(%a7)
	movea.l (MEM_TABLE+2032, %a5), %a4 | a4 is oam memory
	lea (160, %a4), %a4
	andi.w #0x0004, %d0 | store sprite size on stack
	move.w %d0, -(%a7)
	moveq.l #41, %d6 | d6 is counter
sprite_loop:
	subq.b #1, %d6
	beq sprite_done
	clr.w %d0
	clr.w %d1
	clr.w %d3
	move.b -(%a4), %d4 | sprite attr
	move.b -(%a4), %d3 | sprite index
	move.b -(%a4), %d0 | sprite X
	move.b -(%a4), %d1 | sprite Y
	sub.b (Y_OFFSET, %a5), %d1
	cmpi.w #167, %d0
	bgt sprite_loop
patch0D:
	cmpi.w #115, %d1 | PATCH 13
	bgt sprite_loop
	tst.w %d1
	bmi sprite_loop
	moveq.l #7, %d2
	tst.w (%a7)
	beq sprite8x8
	moveq.l #15, %d2 | 8x16 sprite
	andi.b #0xfe, %d3
sprite8x8:
	lea (UPDATE_PAL, %a5), %a6 | a6 is pal updates
	btst #4, %d4
	beq use_obp0
	lea (OBP1_GFX, %a5), %a3
	lea (OB1_PALETTE, %a5), %a2
	bset #2, (%a6, %d3.w) | test first, then set
	beq obj_update_pal
	bra no_obj_update_pal
use_obp0:
	lea (OBP0_GFX, %a5), %a3
	lea (OB0_PALETTE, %a5), %a2
	bset #1, (%a6, %d3.w) | test first, then set
	bne no_obj_update_pal
obj_update_pal:
	movem.l %d0-%d7/%a0-%a6, -(%a7)
	move.w %d2, %d7
	lsl.w #3, %d3 | index *= 8
	lea (MASK_GFX, %a5), %a6
	lea (%a6, %d3.w), %a6 | a6 is where to put mask
	add.w %d3, %d3 | index *= 16
	lea (%a3, %d3.w), %a3 | a3 is where we put palettized sprite
	movea.l (MEM_TABLE+1024, %a5), %a4
	lea (%a4, %d3.w), %a4 | a4 is to-be-palettized sprite
	jbsr apply_obj_palette | a2, is already set
	movem.l (%a7)+, %d0-%d7/%a0-%a6
no_obj_update_pal:
	lsl.w #3, %d3 | index *= 8
	lea (MASK_GFX, %a5), %a6
	lea (%a6, %d3.w), %a6 | a6 points to mask
	add.w %d3, %d3 | index *= 16
	lea (%a3, %d3.w), %a2 | a2 points to gfx to draw

	addq.w #8, %d0
	movea.l (2, %a7), %a1
	movea.l (6, %a7), %a0

| Start calculating where to draw the sprite
	lea x_flip_table(%pc), %a3
	lsl.w #3, %d1
	move.w %d1, %d3 | d3 = y
	add.w %d3,%d3
	add.w %d3, %d1 | d1 = y * 24

	move.w %d0, %d3 | d3 = x
	lsr.w #4, %d3 | d3 = x/16
	add.w %d3,%d3

	add.w %d3, %d1 | d1 = 24*y + x/8
	adda.w %d1, %a0 | a0 += offset
	adda.w %d1, %a1

	and.w #0xF, %d0
	moveq #8, %d1

| Here we diverge into the appropriate flipped version
	andi.b #0x60, %d4
	lsr.b #5, %d4 | lower 2 bits of d4 are now Y-flip/X-flip
	moveq #3, %d5
	cmp.b %d5, %d4
	beq sprite_x_flip_y_flip
	subq.b #1, %d5
	cmp.b %d5, %d4
	beq sprite_y_flip
	subq.b #1, %d5
	cmp.b %d5, %d4
	beq sprite_x_flip

| 8 x 8 sprite, no flipping
	sub.w %d0, %d1
	bge.s __loop_GraySprite8_OR_R_2

	neg.w %d1
_loop_GraySprite8_OR_R_1:
	moveq #-1, %d0
	move.b (%a6)+, %d0
	swap %d0
	ror.l %d1, %d0
	move.l %d0, %d3
	and.l (%a0), %d0
	and.l (%a1), %d3

	moveq #0, %d4
	move.b (%a2)+, %d4
	swap.w %d4
	lsr.l %d1, %d4
	or.l %d4, %d0
	move.l %d0, (%a0)
	lea.l (24, %a0),%a0

	moveq #0, %d0
	move.b (%a2)+, %d0
	swap.w %d0
	lsr.l %d1, %d0
	or.l %d0, %d3
	move.l %d3, (%a1)
	lea.l (24, %a1),%a1

	dbf %d2, _loop_GraySprite8_OR_R_1
	bra sprite_loop
_loop_GraySprite8_OR_R_2:
	lea (24, %a0), %a0
	lea (24, %a1), %a1
__loop_GraySprite8_OR_R_2:
	moveq #-1, %d0
	move.b (%a6)+, %d0
	rol.w %d1, %d0
	move.w %d0, %d3
	and.w (%a0), %d0
	and.w (%a1), %d3

	moveq #0, %d4
	move.b (%a2)+, %d4
	lsl.w %d1, %d4
	or.w %d4, %d0
	move.w %d0, (%a0)

	moveq #0, %d0
	move.b (%a2)+, %d0
	lsl.w %d1, %d0
	or.w %d0, %d3
	move.w %d3, (%a1)

	dbf %d2, _loop_GraySprite8_OR_R_2
	bra sprite_loop

sprite_x_flip:
	sub.w %d0, %d1
	bge.s __loop_GraySprite8_OR_R_2_x_flip

	neg.w %d1
_loop_GraySprite8_OR_R_1_x_flip:
	moveq #-1, %d0
	moveq #0, %d3
	move.b (%a6)+, %d3
	move.b (%a3, %d3.w), %d0
	swap %d0
	ror.l %d1, %d0
	move.l %d0, %d3
	and.l (%a0), %d0
	and.l (%a1), %d3

	moveq #0, %d4
	move.b (%a2)+, %d4
	move.b (%a3, %d4.w), %d4
	swap.w %d4
	lsr.l %d1, %d4
	or.l %d4, %d0
	move.l %d0, (%a0)
	lea.l (24, %a0),%a0

	moveq #0, %d0
	move.b (%a2)+, %d0
	move.b (%a3, %d0.w), %d0
	swap.w %d0
	lsr.l %d1, %d0
	or.l %d0, %d3
	move.l %d3, (%a1)
	lea.l (24, %a1),%a1

	dbf %d2, _loop_GraySprite8_OR_R_1_x_flip
	bra sprite_loop
_loop_GraySprite8_OR_R_2_x_flip:
	lea (24, %a0), %a0
	lea (24, %a1), %a1
__loop_GraySprite8_OR_R_2_x_flip:
	moveq #-1, %d0
	moveq #0, %d3
	move.b (%a6)+, %d3
	move.b (%a3, %d3.w), %d0
	rol.w %d1, %d0
	move.w %d0, %d3
	and.w (%a0), %d0
	and.w (%a1), %d3

	moveq #0, %d4
	move.b (%a2)+, %d4
	move.b (%a3, %d4.w), %d4
	lsl.w %d1, %d4
	or.w %d4, %d0
	move.w %d0, (%a0)

	moveq #0, %d0
	move.b (%a2)+, %d0
	move.b (%a3, %d0.w), %d0
	lsl.w %d1, %d0
	or.w %d0, %d3
	move.w %d3, (%a1)

	dbf %d2, _loop_GraySprite8_OR_R_2_x_flip
	bra sprite_loop

sprite_y_flip:
	lea (2, %a2, %d2.l), %a2
	adda.l %d2, %a2
	lea (1, %a6, %d2.l), %a6
	sub.w %d0, %d1
	bge.s __loop_GraySprite8_OR_R_2_y_flip

	neg.w %d1
_loop_GraySprite8_OR_R_1_y_flip:
	moveq #-1, %d0
	move.b -(%a6), %d0
	swap %d0
	ror.l %d1, %d0
	move.l %d0, %d3
	and.l (%a1), %d0
	and.l (%a0), %d3

	moveq #0, %d4
	move.b -(%a2), %d4
	swap.w %d4
	lsr.l %d1, %d4
	or.l %d4, %d0
	move.l %d0, (%a1)
	lea.l (24, %a1),%a1

	moveq #0, %d0
	move.b -(%a2), %d0
	swap.w %d0
	lsr.l %d1, %d0
	or.l %d0, %d3
	move.l %d3, (%a0)
	lea.l (24, %a0),%a0

	dbf %d2, _loop_GraySprite8_OR_R_1_y_flip
	bra sprite_loop
_loop_GraySprite8_OR_R_2_y_flip:
	lea (24, %a0), %a0
	lea (24, %a1), %a1
__loop_GraySprite8_OR_R_2_y_flip:
	moveq #-1, %d0
	move.b -(%a6), %d0
	rol.w %d1, %d0
	move.w %d0, %d3
	and.w (%a1), %d0
	and.w (%a0), %d3

	moveq #0, %d4
	move.b -(%a2), %d4
	lsl.w %d1, %d4
	or.w %d4, %d0
	move.w %d0, (%a1)

	moveq #0, %d0
	move.b -(%a2), %d0
	lsl.w %d1, %d0
	or.w %d0, %d3
	move.w %d3, (%a0)

	dbf %d2, _loop_GraySprite8_OR_R_2_y_flip
	bra sprite_loop

sprite_x_flip_y_flip:
	lea (2, %a2, %d2.l), %a2
	adda.l %d2, %a2
	lea (1, %a6, %d2.l), %a6
	sub.w %d0, %d1
	bge.s __loop_GraySprite8_OR_R_2_x_flip_y_flip

	neg.w %d1
_loop_GraySprite8_OR_R_1_x_flip_y_flip:
	moveq #-1, %d0
	moveq #0, %d3
	move.b -(%a6), %d3
	move.b (%a3, %d3.w), %d0
	swap %d0
	ror.l %d1, %d0
	move.l %d0, %d3
	and.l (%a1), %d0
	and.l (%a0), %d3

	moveq #0, %d4
	move.b -(%a2), %d4
	move.b (%a3, %d4.w), %d4
	swap.w %d4
	lsr.l %d1, %d4
	or.l %d4, %d0
	move.l %d0, (%a1)
	lea.l (24, %a1),%a1

	moveq #0, %d0
	move.b -(%a2), %d0
	move.b (%a3, %d0.w), %d0
	swap.w %d0
	lsr.l %d1, %d0
	or.l %d0, %d3
	move.l %d3, (%a0)
	lea.l (24, %a0),%a0

	dbf %d2, _loop_GraySprite8_OR_R_1_x_flip_y_flip
	bra sprite_loop
_loop_GraySprite8_OR_R_2_x_flip_y_flip:
	lea (24, %a0), %a0
	lea (24, %a1), %a1
__loop_GraySprite8_OR_R_2_x_flip_y_flip:
	moveq #-1, %d0
	moveq #0, %d3
	move.b -(%a6), %d3
	move.b (%a3, %d3.w), %d0
	rol.w %d1, %d0
	move.w %d0, %d3
	and.w (%a1), %d0
	and.w (%a0), %d3

	moveq #0, %d4
	move.b -(%a2), %d4
	move.b (%a3, %d4.w), %d4
	lsl.w %d1, %d4
	or.w %d4, %d0
	move.w %d0, (%a1)

	moveq #0, %d0
	move.b -(%a2), %d0
	move.b (%a3, %d0.w), %d0
	lsl.w %d1, %d0
	or.w %d0, %d3
	move.w %d3, (%a0)

	dbf %d2, _loop_GraySprite8_OR_R_2_x_flip_y_flip
	bra sprite_loop
sprite_done:
	lea (10 ,%a7), %a7
copy_buffer:
	movea.l screen_buffer, %a0 | a0 is light
	lea (16*24+2, %a0), %a0
patch0E:
	lea (132*24, %a0), %a1 | PATCH 14
	tst.b (SHOW_FPS, %a5)
	beq no_fps
	moveq.l #0, %d0
	move.w current_fps, %d0
	divu.w #10, %d0
	move.w %d0, %d1 | d1 contains quotient (10's place)
	swap %d0 | d0 contains remainder (1's place)
	
	move.w %d0, %d2
	lsl.w #2, %d0
	add.w %d2, %d0 | d0 *= 5
	
	move.w %d1, %d2
	lsl.w #2, %d1
	add.w %d2, %d1 | d1 *= 5
	
	lea small_font, %a2
	movea.l %a2, %a3
	lea (%a2, %d0.w), %a2 | 1's place
	lea (%a3, %d1.w), %a3 | 10's place
	moveq #4, %d1
draw_fps_loop:
	move.b (%a2)+, %d0
	lsr.b #4, %d0
	or.b (%a3)+, %d0
	move.b %d0, (%a0)
	move.b %d0, (%a1)
	lea (24, %a0), %a0
	lea (24, %a1), %a1
	dbf %d1, draw_fps_loop
	move.b #0x00, (%a0)
	move.b #0x00, (%a1)
	lea (-24*5, %a0), %a0 | put back light
	lea (-24*5, %a1), %a1 | put back dark
no_fps:
	movea.l __L_plane, %a2
	movea.l __D_plane, %a3
patch0F:
	moveq #99, %d7 | PATCH 15
0:
	movem.l (%a0)+, %d0-%d4
	movem.l %d0-%d4, (%a2)
	movem.l (%a1)+, %d0-%d4
	movem.l %d0-%d4, (%a3)
	addq.l #4, %a0
	addq.l #4, %a1
	lea (30, %a2), %a2
	lea (30, %a3), %a3
	dbf %d7, 0b
	
	addq.w #1, frames
	movem.l  (%a7)+, %d0-%d7/%a0-%a6
	rts

| borrowed from TIGB
x_flip_table:
.byte 0x00,0x80,0x40,0xc0,0x20,0xa0,0x60,0xe0,0x10,0x90,0x50,0xd0,0x30,0xb0,0x70,0xf0
.byte 0x08,0x88,0x48,0xc8,0x28,0xa8,0x68,0xe8,0x18,0x98,0x58,0xd8,0x38,0xb8,0x78,0xf8
.byte 0x04,0x84,0x44,0xc4,0x24,0xa4,0x64,0xe4,0x14,0x94,0x54,0xd4,0x34,0xb4,0x74,0xf4
.byte 0x0c,0x8c,0x4c,0xcc,0x2c,0xac,0x6c,0xec,0x1c,0x9c,0x5c,0xdc,0x3c,0xbc,0x7c,0xfc
.byte 0x02,0x82,0x42,0xc2,0x22,0xa2,0x62,0xe2,0x12,0x92,0x52,0xd2,0x32,0xb2,0x72,0xf2
.byte 0x0a,0x8a,0x4a,0xca,0x2a,0xaa,0x6a,0xea,0x1a,0x9a,0x5a,0xda,0x3a,0xba,0x7a,0xfa
.byte 0x06,0x86,0x46,0xc6,0x26,0xa6,0x66,0xe6,0x16,0x96,0x56,0xd6,0x36,0xb6,0x76,0xf6
.byte 0x0e,0x8e,0x4e,0xce,0x2e,0xae,0x6e,0xee,0x1e,0x9e,0x5e,0xde,0x3e,0xbe,0x7e,0xfe
.byte 0x01,0x81,0x41,0xc1,0x21,0xa1,0x61,0xe1,0x11,0x91,0x51,0xd1,0x31,0xb1,0x71,0xf1
.byte 0x09,0x89,0x49,0xc9,0x29,0xa9,0x69,0xe9,0x19,0x99,0x59,0xd9,0x39,0xb9,0x79,0xf9
.byte 0x05,0x85,0x45,0xc5,0x25,0xa5,0x65,0xe5,0x15,0x95,0x55,0xd5,0x35,0xb5,0x75,0xf5
.byte 0x0d,0x8d,0x4d,0xcd,0x2d,0xad,0x6d,0xed,0x1d,0x9d,0x5d,0xdd,0x3d,0xbd,0x7d,0xfd
.byte 0x03,0x83,0x43,0xc3,0x23,0xa3,0x63,0xe3,0x13,0x93,0x53,0xd3,0x33,0xb3,0x73,0xf3
.byte 0x0b,0x8b,0x4b,0xcb,0x2b,0xab,0x6b,0xeb,0x1b,0x9b,0x5b,0xdb,0x3b,0xbb,0x7b,0xfb
.byte 0x07,0x87,0x47,0xc7,0x27,0xa7,0x67,0xe7,0x17,0x97,0x57,0xd7,0x37,0xb7,0x77,0xf7
.byte 0x0f,0x8f,0x4f,0xcf,0x2f,0xaf,0x6f,0xef,0x1f,0x9f,0x5f,0xdf,0x3f,0xbf,0x7f,0xff

small_font:
.byte 0xe0,0xa0,0xa0,0xa0,0xe0
.byte 0xc0,0x40,0x40,0x40,0xe0
.byte 0xe0,0x20,0xe0,0x80,0xe0
.byte 0xe0,0x20,0xe0,0x20,0xe0
.byte 0xa0,0xa0,0xe0,0x20,0x20
.byte 0xe0,0x80,0xe0,0x20,0xe0
.byte 0xe0,0x80,0xe0,0xa0,0xe0
.byte 0xe0,0x20,0x20,0x20,0x20
.byte 0xe0,0xa0,0xe0,0xa0,0xe0
.byte 0xe0,0xa0,0xe0,0x20,0x20

/*
C prototype: void ClipSprite8_OR_R(
register short x asm("%d0"),
register short y asm("%d1"),
register short h asm("%d2"),
register unsigned char *sprt asm("%a2"),
register void *light asm("%a5"));
register void *dark asm("%a6"));
*/

