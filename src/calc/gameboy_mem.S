| Assembly Source File
| Created 8/2/2004; 2:38:27 PM

.global function_base
.global io_write
.global write_disable
.global P1_89
.global P1_92
.global io_write_table
.global io_write_offset
.global bg_gfx_write_offsets
.global mbc1_offsets
.global mbc2_offsets
.global mbc3_offsets
.global mbc5_offsets
.global no_mbc_offsets
.global write_disable_offset

.include "gbasm.h"

|Write functions
|inputs: %d0 - offset into block, %d3 - index of block * 8, %d2 - data to write
|outputs: data is written

.even
P1_89:
.word io_write_P1_89 - function_base
P1_92:
.word io_write_P1_92 - function_base

io_write_offset:
.word io_write - function_base

write_disable_offset:
.word write_disable - function_base

bg_gfx_write_offsets:
.word bg_gfx_write00 - function_base
.word bg_gfx_write01 - function_base
.word bg_gfx_write02 - function_base
.word bg_gfx_write03 - function_base
.word bg_gfx_write04 - function_base
.word bg_gfx_write05 - function_base
.word bg_gfx_write06 - function_base
.word bg_gfx_write07 - function_base
.word bg_gfx_write08 - function_base
.word bg_gfx_write09 - function_base
.word bg_gfx_write0A - function_base
.word bg_gfx_write0B - function_base
.word bg_gfx_write0C - function_base
.word bg_gfx_write0D - function_base
.word bg_gfx_write0E - function_base
.word bg_gfx_write0F - function_base
.word bg_gfx_write10 - function_base
.word bg_gfx_write11 - function_base
.word bg_gfx_write12 - function_base
.word bg_gfx_write13 - function_base
.word bg_gfx_write14 - function_base
.word bg_gfx_write15 - function_base
.word bg_gfx_write16 - function_base
.word bg_gfx_write17 - function_base

mbc1_offsets:
.word write_disable - function_base
.word write_disable - function_base
.word mbc1_2000 - function_base
.word mbc1_2000 - function_base
.word mbc1_4000 - function_base
.word mbc1_4000 - function_base
.word mbc1_6000 - function_base
.word mbc1_6000 - function_base

mbc2_offsets:
.word write_disable - function_base
.word write_disable - function_base
.word mbc2_2000 - function_base
.word mbc2_2000 - function_base
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base

mbc3_offsets:
.word write_disable - function_base
.word write_disable - function_base
.word mbc3_2000 - function_base
.word mbc3_2000 - function_base
.word mbc3_4000 - function_base
.word mbc3_4000 - function_base
.word write_disable - function_base
.word write_disable - function_base

mbc5_offsets:
.word write_disable - function_base
.word write_disable - function_base
.word mbc5_2000 - function_base
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base

no_mbc_offsets:
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base
.word write_disable - function_base

function_base:
.word 0xffff | so functions start with offset of 2, as opposed to 0

| write16 stub
| move.l %a4, -(%a7)
| lea (WRITE16_OPCODE, %a5), %a4
| jmp (%a3, %d1.w)

| requires:
| upper byte of d2
| lower byte of d0
| d3
.global write16_finish
write16_finish:
	move.l (SAVE_EVENT_MEM16, %a5), (NEXT_EVENT, %a5)
	move.w (SAVE_COUNT_MEM16, %a5), %d4
	
	rol.w #8, %d2 | get proper byte in d2
	addq.b #1, %d0 | incr address
	bcc 0f
	addq.w #8, %d3 | crossed into next section
0:
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0 | get base pointer
	move.w (%a1), %d1 | get special function
	beq 0f
	jmp (%a3, %d1.w)
0:
	move.b %d2, (%a0, %d0.w) | no special function
	tst.w %d4
	NEXT_INSTRUCTION2 end_special_write16
end_special_write16:

| sets timer to the proper state (enabled or disabled)
.global reset_timer
reset_timer:
	tst.b (ENABLE_TIMER, %a5)
	beq disable_timer
	
	movea.l #(io_write_TAC - function_base), %a0
	move.w %a0, (io_write_table + TAC * 2)
	
	movea.l (MEM_TABLE+2040, %a5), %a0
	move.b (TAC, %a0), %d0
	btst #2, %d0
	beq reset_timer_off
	and.w #0x0003, %d0
	add.b %d0, %d0
	add.b %d0, %d0 | d0 *= 4
	lea timer_func_table, %a0
	movea.l (%a0, %d0.w), %a0 | a0 points to proper timer func
	lea timer_entry+2, %a1
	suba.l %a1, %a0 | now a0 is offset from timer_entry to timer func
	move.w %a0, (timer_entry) | patch in branch offset
	move.b #0x60, (timer_entry) | (timer_entry) = BRA
	
	lea timer_func_table, %a0
	movea.l (%a0, %d0.w), %a0 | a0 points to proper timer func
	lea timer_entry_off+2, %a1
	suba.l %a1, %a0 | now a0 is offset from timer_entry_off to timer func
	move.w %a0, (timer_entry_off+2) | patch in branch offset
	move.w #0x6000, (timer_entry_off) | (timer_entry) = BRA
	rts
reset_timer_off:
	move.w #0x4E71, (timer_entry) | (timer_entry) = NOP
	move.l #0x4E714E71, (timer_entry_off) | (timer_entry_off) = NOP; NOP
	rts
disable_timer:
	move.w #0x4E71, (timer_entry) | (timer_entry) = NOP
	move.l #0x4E714E71, (timer_entry_off) | (timer_entry_off) = NOP; NOP
	movea.l #(io_write_default - function_base), %a0
	move.w %a0, (io_write_table + TAC * 2)
	rts

/*.global write16_stack_finish
.global write16_stack_return
write16_stack_finish:
	rol.w #8, %d2 | get proper byte in d2
	addq.b #1, %d0 | incr address
	bcc 0f
	addq.w #8, %d3 | crossed into next section
0:
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0 | get base pointer
	move.w (%a1), %d1 | get special function
	beq 0f
	move.l #write16_stack_return, (NEXT_EVENT, %a5) | set return point
	jmp (%a3, %d1.w)
0:
	move.b %d2, (%a0, %d0.w) | no special function
write16_stack_return:
	move.l (%a7)+, %d2 | saved by push_PC
	move.l (SAVE_EVENT_MEM16, %a5), (NEXT_EVENT, %a5)
	move.w (SAVE_COUNT_MEM16, %a5), %d4
	rts | return (from push_PC)
*/

| io_write_P1 -->
| io_write_table + io_write_P1 - io_write_table -->
| (io_write_table) + (io_write_P1 - io_write_table) -->
| (pc + 2) + (io_write_P1 - io_write_table) -->
| (pc) + (2 + io_write_P1 - io_write_table) -->
| (pc) + (a1)
io_write:
	move.w %d0, %a1
	adda.w %a1, %a1
	move.w (io_write_table, %pc, %a1.w), %a1
	jmp (%a3, %a1.w)
io_write_table:
.word io_write_P1_89 - function_base	| 00 - P1
.word io_write_default - function_base	| 01 - SB
.word io_write_SC - function_base	| 02 - SC
.word io_write_default - function_base	| 03 - ??
.word io_write_DIV - function_base	| 04 - DIV
.word io_write_default - function_base	| 05 - TIMA
.word io_write_default - function_base	| 06 - TMA
.word io_write_TAC - function_base	| 07 - TAC
.word io_write_default - function_base	| 08 - ??
.word io_write_default - function_base	| 09 - ??
.word io_write_default - function_base	| 0A - ??
.word io_write_default - function_base	| 0B - ??
.word io_write_default - function_base	| 0C - ??
.word io_write_default - function_base	| 0D - ??
.word io_write_default - function_base	| 0E - ??
.word io_write_IF - function_base	| 0F - IF
.word io_write_default - function_base	| 10 - sound
.word io_write_default - function_base	| 11 - sound
.word io_write_default - function_base	| 12 - sound
.word io_write_default - function_base	| 13 - sound
.word io_write_default - function_base	| 14 - sound
.word io_write_default - function_base	| 15 - sound
.word io_write_default - function_base	| 16 - sound
.word io_write_default - function_base	| 17 - sound
.word io_write_default - function_base	| 18 - sound
.word io_write_default - function_base	| 19 - sound
.word io_write_default - function_base	| 1A - sound
.word io_write_default - function_base	| 1B - sound
.word io_write_default - function_base	| 1C - sound
.word io_write_default - function_base	| 1D - sound
.word io_write_default - function_base	| 1E - sound
.word io_write_default - function_base	| 1F - sound
.word io_write_default - function_base	| 20 - sound
.word io_write_default - function_base	| 21 - sound
.word io_write_default - function_base	| 22 - sound
.word io_write_default - function_base	| 23 - sound
.word io_write_default - function_base	| 24 - sound
.word io_write_default - function_base	| 25 - sound
.word io_write_default - function_base	| 26 - sound
.word io_write_default - function_base	| 27 - sound
.word io_write_default - function_base	| 28 - sound
.word io_write_default - function_base	| 29 - sound
.word io_write_default - function_base	| 2A - sound
.word io_write_default - function_base	| 2B - sound
.word io_write_default - function_base	| 2C - sound
.word io_write_default - function_base	| 2D - sound
.word io_write_default - function_base	| 2E - sound
.word io_write_default - function_base	| 2F - sound
.word io_write_default - function_base	| 30 - sound
.word io_write_default - function_base	| 31 - sound
.word io_write_default - function_base	| 32 - sound
.word io_write_default - function_base	| 33 - sound
.word io_write_default - function_base	| 34 - sound
.word io_write_default - function_base	| 35 - sound
.word io_write_default - function_base	| 36 - sound
.word io_write_default - function_base	| 37 - sound
.word io_write_default - function_base	| 38 - sound
.word io_write_default - function_base	| 39 - sound
.word io_write_default - function_base	| 3A - sound
.word io_write_default - function_base	| 3B - sound
.word io_write_default - function_base	| 3C - sound
.word io_write_default - function_base	| 3D - sound
.word io_write_default - function_base	| 3E - sound
.word io_write_default - function_base	| 3F - sound
.word io_write_LCDC - function_base	| 40 - LCDC
.word io_write_STAT - function_base	| 41 - STAT
.word io_write_default - function_base	| 42 - SCY
.word io_write_default - function_base	| 43 - SCX
.word io_write_LY - function_base	| 44 - LY
.word io_write_default - function_base	| 45 - LYC
.word io_write_DMA - function_base	| 46 - DMA
.word io_write_BGP - function_base	| 47 - BGP
.word io_write_OBP0 - function_base	| 48 - OBP0
.word io_write_OBP1 - function_base	| 49 - OBP1
.word io_write_default - function_base	| 4A - WY
.word io_write_default - function_base	| 4B - WX
.word io_write_default - function_base	| 4C - HRAM
.word io_write_default - function_base	| 4D - HRAM
.word io_write_default - function_base	| 4E - HRAM
.word io_write_default - function_base	| 4F - HRAM
.word io_write_default - function_base	| 50 - HRAM
.word io_write_default - function_base	| 51 - HRAM
.word io_write_default - function_base	| 52 - HRAM
.word io_write_default - function_base	| 53 - HRAM
.word io_write_default - function_base	| 54 - HRAM
.word io_write_default - function_base	| 55 - HRAM
.word io_write_default - function_base	| 56 - HRAM
.word io_write_default - function_base	| 57 - HRAM
.word io_write_default - function_base	| 58 - HRAM
.word io_write_default - function_base	| 59 - HRAM
.word io_write_default - function_base	| 5A - HRAM
.word io_write_default - function_base	| 5B - HRAM
.word io_write_default - function_base	| 5C - HRAM
.word io_write_default - function_base	| 5D - HRAM
.word io_write_default - function_base	| 5E - HRAM
.word io_write_default - function_base	| 5F - HRAM
.word io_write_default - function_base	| 60 - HRAM
.word io_write_default - function_base	| 61 - HRAM
.word io_write_default - function_base	| 62 - HRAM
.word io_write_default - function_base	| 63 - HRAM
.word io_write_default - function_base	| 64 - HRAM
.word io_write_default - function_base	| 65 - HRAM
.word io_write_default - function_base	| 66 - HRAM
.word io_write_default - function_base	| 67 - HRAM
.word io_write_default - function_base	| 68 - HRAM
.word io_write_default - function_base	| 69 - HRAM
.word io_write_default - function_base	| 6A - HRAM
.word io_write_default - function_base	| 6B - HRAM
.word io_write_default - function_base	| 6C - HRAM
.word io_write_default - function_base	| 6D - HRAM
.word io_write_default - function_base	| 6E - HRAM
.word io_write_default - function_base	| 6F - HRAM
.word io_write_default - function_base	| 70 - HRAM
.word io_write_default - function_base	| 71 - HRAM
.word io_write_default - function_base	| 72 - HRAM
.word io_write_default - function_base	| 73 - HRAM
.word io_write_default - function_base	| 74 - HRAM
.word io_write_default - function_base	| 75 - HRAM
.word io_write_default - function_base	| 76 - HRAM
.word io_write_default - function_base	| 77 - HRAM
.word io_write_default - function_base	| 78 - HRAM
.word io_write_default - function_base	| 79 - HRAM
.word io_write_default - function_base	| 7A - HRAM
.word io_write_default - function_base	| 7B - HRAM
.word io_write_default - function_base	| 7C - HRAM
.word io_write_default - function_base	| 7D - HRAM
.word io_write_default - function_base	| 7E - HRAM
.word io_write_default - function_base	| 7F - HRAM
.word io_write_default - function_base	| 80 - HRAM
.word io_write_default - function_base	| 81 - HRAM
.word io_write_default - function_base	| 82 - HRAM
.word io_write_default - function_base	| 83 - HRAM
.word io_write_default - function_base	| 84 - HRAM
.word io_write_default - function_base	| 85 - HRAM
.word io_write_default - function_base	| 86 - HRAM
.word io_write_default - function_base	| 87 - HRAM
.word io_write_default - function_base	| 88 - HRAM
.word io_write_default - function_base	| 89 - HRAM
.word io_write_default - function_base	| 8A - HRAM
.word io_write_default - function_base	| 8B - HRAM
.word io_write_default - function_base	| 8C - HRAM
.word io_write_default - function_base	| 8D - HRAM
.word io_write_default - function_base	| 8E - HRAM
.word io_write_default - function_base	| 8F - HRAM
.word io_write_default - function_base	| 90 - HRAM
.word io_write_default - function_base	| 91 - HRAM
.word io_write_default - function_base	| 92 - HRAM
.word io_write_default - function_base	| 93 - HRAM
.word io_write_default - function_base	| 94 - HRAM
.word io_write_default - function_base	| 95 - HRAM
.word io_write_default - function_base	| 96 - HRAM
.word io_write_default - function_base	| 97 - HRAM
.word io_write_default - function_base	| 98 - HRAM
.word io_write_default - function_base	| 99 - HRAM
.word io_write_default - function_base	| 9A - HRAM
.word io_write_default - function_base	| 9B - HRAM
.word io_write_default - function_base	| 9C - HRAM
.word io_write_default - function_base	| 9D - HRAM
.word io_write_default - function_base	| 9E - HRAM
.word io_write_default - function_base	| 9F - HRAM
.word io_write_default - function_base	| A0 - HRAM
.word io_write_default - function_base	| A1 - HRAM
.word io_write_default - function_base	| A2 - HRAM
.word io_write_default - function_base	| A3 - HRAM
.word io_write_default - function_base	| A4 - HRAM
.word io_write_default - function_base	| A5 - HRAM
.word io_write_default - function_base	| A6 - HRAM
.word io_write_default - function_base	| A7 - HRAM
.word io_write_default - function_base	| A8 - HRAM
.word io_write_default - function_base	| A9 - HRAM
.word io_write_default - function_base	| AA - HRAM
.word io_write_default - function_base	| AB - HRAM
.word io_write_default - function_base	| AC - HRAM
.word io_write_default - function_base	| AD - HRAM
.word io_write_default - function_base	| AE - HRAM
.word io_write_default - function_base	| AF - HRAM
.word io_write_default - function_base	| B0 - HRAM
.word io_write_default - function_base	| B1 - HRAM
.word io_write_default - function_base	| B2 - HRAM
.word io_write_default - function_base	| B3 - HRAM
.word io_write_default - function_base	| B4 - HRAM
.word io_write_default - function_base	| B5 - HRAM
.word io_write_default - function_base	| B6 - HRAM
.word io_write_default - function_base	| B7 - HRAM
.word io_write_default - function_base	| B8 - HRAM
.word io_write_default - function_base	| B9 - HRAM
.word io_write_default - function_base	| BA - HRAM
.word io_write_default - function_base	| BB - HRAM
.word io_write_default - function_base	| BC - HRAM
.word io_write_default - function_base	| BD - HRAM
.word io_write_default - function_base	| BE - HRAM
.word io_write_default - function_base	| BF - HRAM
.word io_write_default - function_base	| C0 - HRAM
.word io_write_default - function_base	| C1 - HRAM
.word io_write_default - function_base	| C2 - HRAM
.word io_write_default - function_base	| C3 - HRAM
.word io_write_default - function_base	| C4 - HRAM
.word io_write_default - function_base	| C5 - HRAM
.word io_write_default - function_base	| C6 - HRAM
.word io_write_default - function_base	| C7 - HRAM
.word io_write_default - function_base	| C8 - HRAM
.word io_write_default - function_base	| C9 - HRAM
.word io_write_default - function_base	| CA - HRAM
.word io_write_default - function_base	| CB - HRAM
.word io_write_default - function_base	| CC - HRAM
.word io_write_default - function_base	| CD - HRAM
.word io_write_default - function_base	| CE - HRAM
.word io_write_default - function_base	| CF - HRAM
.word io_write_default - function_base	| D0 - HRAM
.word io_write_default - function_base	| D1 - HRAM
.word io_write_default - function_base	| D2 - HRAM
.word io_write_default - function_base	| D3 - HRAM
.word io_write_default - function_base	| D4 - HRAM
.word io_write_default - function_base	| D5 - HRAM
.word io_write_default - function_base	| D6 - HRAM
.word io_write_default - function_base	| D7 - HRAM
.word io_write_default - function_base	| D8 - HRAM
.word io_write_default - function_base	| D9 - HRAM
.word io_write_default - function_base	| DA - HRAM
.word io_write_default - function_base	| DB - HRAM
.word io_write_default - function_base	| DC - HRAM
.word io_write_default - function_base	| DD - HRAM
.word io_write_default - function_base	| DE - HRAM
.word io_write_default - function_base	| DF - HRAM
.word io_write_default - function_base	| E0 - HRAM
.word io_write_default - function_base	| E1 - HRAM
.word io_write_default - function_base	| E2 - HRAM
.word io_write_default - function_base	| E3 - HRAM
.word io_write_default - function_base	| E4 - HRAM
.word io_write_default - function_base	| E5 - HRAM
.word io_write_default - function_base	| E6 - HRAM
.word io_write_default - function_base	| E7 - HRAM
.word io_write_default - function_base	| E8 - HRAM
.word io_write_default - function_base	| E9 - HRAM
.word io_write_default - function_base	| EA - HRAM
.word io_write_default - function_base	| EB - HRAM
.word io_write_default - function_base	| EC - HRAM
.word io_write_default - function_base	| ED - HRAM
.word io_write_default - function_base	| EE - HRAM
.word io_write_default - function_base	| EF - HRAM
.word io_write_default - function_base	| F0 - HRAM
.word io_write_default - function_base	| F1 - HRAM
.word io_write_default - function_base	| F2 - HRAM
.word io_write_default - function_base	| F3 - HRAM
.word io_write_default - function_base	| F4 - HRAM
.word io_write_default - function_base	| F5 - HRAM
.word io_write_default - function_base	| F6 - HRAM
.word io_write_default - function_base	| F7 - HRAM
.word io_write_default - function_base	| F8 - HRAM
.word io_write_default - function_base	| F9 - HRAM
.word io_write_default - function_base	| FA - HRAM
.word io_write_default - function_base	| FB - HRAM
.word io_write_default - function_base	| FC - HRAM
.word io_write_default - function_base	| FD - HRAM
.word io_write_default - function_base	| FE - HRAM
.word io_write_IE - function_base	| FF - IE

io_write_default:
	move.b %d2, (%a0, %d0.w)
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_default
end_io_write_default:

| d0 is keys from calc
| d1 is current bit
| d2 is keys written to GB
io_write_P1_89:
	move.w #0xfffe, 0x600018 | select row 0
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #5, %d2
	beq button_select_89
	btst #4, %d2
	bne keypad_disabled
	st %d2
	btst #0, %d1
	bne up_not_pressed_89
	bclr #2, %d2
up_not_pressed_89:
	btst #1, %d1
	bne left_not_pressed_89
	bclr #1, %d2
left_not_pressed_89:
	btst #2, %d1
	bne down_not_pressed_89
	bclr #3, %d2
down_not_pressed_89:
	btst #3, %d1
	bne keys_done
	bclr #0, %d2
keys_done:
	ori.b #0xf0, %d2
	move.b %d2, (P1, %a0)
	tst.w %d4
	NEXT_INSTRUCTION2 button_select_89
button_select_89:
	lsr.b #4, %d1
	ori.b #0xf0, %d1
	move.b %d1, (P1, %a0)
	tst.w %d4
	NEXT_INSTRUCTION2 keypad_disabled
keypad_disabled:
	st (P1, %a0)
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_P1_89
end_io_write_P1_89:

io_write_P1_92:
	move.w #0xfffe, 0x600018 | select row 0
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #5, %d2
	beq button_select_92
	btst #4, %d2
	bne keypad_disabled
	st %d2
	btst #5, %d1
	bne up_not_pressed_92
	bclr #2, %d2
up_not_pressed_92:
	btst #4, %d1
	bne left_not_pressed_92
	bclr #1, %d2
left_not_pressed_92:
	btst #7, %d1
	bne down_not_pressed_92
	bclr #3, %d2
down_not_pressed_92:
	btst #6, %d1
	bne keys_done
	bclr #0, %d2
	bra keys_done
button_select_92:
	st %d2
	cmp.b #3, (CALC_TYPE, %a5)
	beq button_select_v200
	move.w #~(1<<6), 0x600018 | select row 6
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #6, %d1
	bne start_not_pressed_92
	bclr #3, %d2
start_not_pressed_92:
	btst #4, %d1
	bne a_not_pressed_92
	bclr #0, %d2
a_not_pressed_92:
	move.w #~(1<<7), 0x600018 | select row 7
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #6, %d1
	bne select_not_pressed_92
	bclr #2, %d2
select_not_pressed_92:
	btst #4, %d1
	bne keys_done
	bclr #1, %d2
	bra keys_done
button_select_v200:
	btst #3, %d1
	bne a_not_pressed_v200
	bclr #0, %d2
a_not_pressed_v200:
	move.w #~(1<<9), 0x600018 | select row 9
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #3, %d1
	bne b_not_pressed_v200
	bclr #1, %d2
b_not_pressed_v200:
	move.w #~(1<<6), 0x600018 | select row 6
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #6, %d1
	bne start_not_pressed_v200
	bclr #3, %d2
start_not_pressed_v200:
	move.w #~(1<<7), 0x600018 | select row 7
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #6, %d1
	bne keys_done
	bclr #2, %d2
	bra keys_done
	
io_write_SC:
	btst #0, %d2 | don't generate int if using external clock
	beq 0f
	bclr #7, %d2 | if a transfer is requested, generate an int imediately
	beq 0f
	move.b #0xff, (SB, %a0) | no external gb present, default to 0xff
	bset #3, (IF, %a0)
	jbsr check_interrupts
0:
	move.b %d2, (SC, %a0)
	NEXT_INSTRUCTION2 end_io_write_SC
end_io_write_SC:
	
io_write_IF:
	move.b %d2, (IF, %a0)
	jbsr check_interrupts
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_IF
end_io_write_IF:

io_write_IE:
	move.b %d2, (IE, %a0)
	jbsr check_interrupts
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_IE
end_io_write_IE:

io_write_DIV:
	clr.b (DIV, %a0)
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_DIV
end_io_write_DIV:

io_write_TAC:
	move.b %d2, %d0
	or.b #0xf8, %d0
	move.b %d0, (TAC, %a0)
	btst #2, %d2
	beq timer_off
	and.w #0x0003, %d0
	add.b %d0, %d0
	add.b %d0, %d0 | d0 *= 4
	lea timer_func_table, %a0
	movea.l (%a0, %d0.w), %a0 | a0 points to proper timer func
	lea timer_entry+2, %a1
	suba.l %a1, %a0 | now a0 is offset from timer_entry to timer func
	move.w %a0, (timer_entry) | patch in branch offset
	move.b #0x60, (timer_entry) | (timer_entry) = BRA
	
	lea timer_func_table, %a0
	movea.l (%a0, %d0.w), %a0 | a0 points to proper timer func
	lea timer_entry_off+2, %a1
	suba.l %a1, %a0 | now a0 is offset from timer_entry_off to timer func
	move.w %a0, (timer_entry_off+2) | patch in branch offset
	move.w #0x6000, (timer_entry_off) | (timer_entry) = BRA
	
	bra 0f
timer_off:
	move.w #0x4E71, (timer_entry) | (timer_entry) = NOP
	move.l #0x4E714E71, (timer_entry_off) | (timer_entry_off) = NOP; NOP
0:
	NEXT_INSTRUCTION2 end_io_write_TAC
end_io_write_TAC:


io_write_LY:
	clr.b (LY, %a0)
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_LY
end_io_write_LY:

io_write_LCDC:
	move.b (LCDC, %a0), %d0
	move.b %d2, (LCDC, %a0)
	eor.b %d2, %d0
	moveq #7, %d1
	btst %d1, %d0
	beq no_lcdc_lcd_enable
| bit7 - lcd enable was changed
	moveq #-1, %d4
	btst %d1, %d2
	beq lcd_off
| LCD was turned on
	move.l #mode2_func, (NEXT_EVENT, %a5)
	bra no_lcdc_lcd_enable
lcd_off:
| LCD was turned off
	clr.b (LY, %a0)
	move.l #mode2_func_off, (NEXT_EVENT, %a5)
no_lcdc_lcd_enable:
	subq.b #1, %d1
	btst %d1, %d0
	beq no_lcdc_window_tilemap
| bit 6 - window tilemap was changed
	movea.l (MEM_TABLE+1024, %a5), %a0
	btst %d1, %d2
	beq window_tilemap0
	lea (%a0, TILEMAP1), %a0
	bra 0f
window_tilemap0:
	lea (%a0, TILEMAP0), %a0
0:
	move.l %a0, (WINDOW_TILEMAP, %a5)
no_lcdc_window_tilemap:
	subq.b #2, %d1
	btst %d1, %d0
	beq no_lcdc_bg_tiledata
| bit 4 - bg tiledata was chenged
	btst %d1, %d2
	beq bg_tiledata0
| TILEDATA1 (8000-8FFF)
	lea bg_next_tile, %a0
	lea window_next_tile, %a1
	move.w #0x4246, (%a0) | modify bg drawing code
	move.w (%a0)+, (%a1)+
	move.w #0x1C33, (%a0)
	move.w (%a0)+, (%a1)+
	move.w #0x3000, (%a0)
	move.w (%a0)+, (%a1)+
	lea (UPDATE_PAL, %a5), %a0
	move.l %a0, (BG_WINDOW_UPDATE_PAL, %a5)
	lea (BG_GFX, %a5), %a0
	move.l %a0, (BG_WINDOW_GFX, %a5)
	movea.l (MEM_TABLE+1024, %a5), %a0
	move.l %a0, (BG_WINDOW_TILEDATA, %a5)
	bra no_lcdc_bg_tiledata
bg_tiledata0:
| TILEDATA0 (8800-97FF)
	lea bg_next_tile, %a0
	lea window_next_tile, %a1
	move.w #0x1C33, (%a0) | modify bg drawing code
	move.w (%a0)+, (%a1)+
	move.w #0x3000, (%a0)
	move.w (%a0)+, (%a1)+
	move.w #0x4886, (%a0)
	move.w (%a0)+, (%a1)+
	lea (UPDATE_PAL+256, %a5), %a0
	move.l %a0, (BG_WINDOW_UPDATE_PAL, %a5)
	lea (BG_GFX+0x1000, %a5), %a0
	move.l %a0, (BG_WINDOW_GFX, %a5)
	movea.l (MEM_TABLE+1024, %a5), %a0
	lea (0x1000, %a0), %a0
	move.l %a0, (BG_WINDOW_TILEDATA, %a5)
no_lcdc_bg_tiledata:
	subq.b #1, %d1
	btst %d1, %d0
	beq no_lcdc_bg_tilemap
| bit 3 - bg tilemap was changed
	movea.l (MEM_TABLE+1024, %a5), %a0
	btst %d1, %d2
	beq bg_tilemap0
	lea (%a0, TILEMAP1), %a0
	bra 0f
bg_tilemap0:
	lea (%a0, TILEMAP0), %a0
0:
	move.l %a0, (BG_TILEMAP, %a5)
no_lcdc_bg_tilemap:
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_LCDC
end_io_write_LCDC:

io_write_STAT:
	andi.b #0x07, (STAT, %a0)
	andi.b #0xf8, %d2
	or.b %d2, (STAT, %a0)
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_STAT
end_io_write_STAT:

io_write_DMA:
	clr.w %d1
	move.b %d2, %d1
	lsl.w #3, %d1 | d2 *= 8
	movea.l (MEM_TABLE, %a5, %d1.w), %a0 | a0 is start of memory to transfer
	movea.l (MEM_TABLE+2032, %a5), %a1 | a1 is OAM
	moveq #39, %d1 | counter
dma_loop:
	move.l (%a0)+, (%a1)+
	dbf %d1, dma_loop
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_DMA
end_io_write_DMA:

io_write_BGP:
	move.b %d2, (BGP, %a0) | write data to IO
	lea (BG_PALETTE+8, %a5), %a0 | a0 is pointer to internal palette structure
	moveq #7, %d1 | d0 is counter
0:
	btst %d1, %d2
	sne -(%a0)
	dbf %d1, 0b

	move #95, %d0
	move.l #0xfefefefe, %d1
	lea (UPDATE_PAL, %a5), %a0
0:
	and.l %d1, (%a0)+
	dbf %d0, 0b
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_BGP
end_io_write_BGP:

io_write_OBP0:
	move.b %d2, (OBP0, %a0) | write data to IO
	lea (OB0_PALETTE, %a5), %a0 | a0 is pointer to internal palette structure
	moveq #2, %d0 | d0 is bit
	moveq #5, %d1 | d1 is counter
0:
	btst %d0, %d2
	sne (%a0)+
	addq.b #1, %d0
	dbf %d1, 0b

	move #95, %d0
	move.l #0xfdfdfdfd, %d1
	lea (UPDATE_PAL, %a5), %a0
0:
	and.l %d1, (%a0)+
	dbf %d0, 0b
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_OBP0
end_io_write_OBP0:

io_write_OBP1:
	move.b %d2, (OBP1, %a0) | write data to IO
	lea (OB1_PALETTE, %a5), %a0 | a0 is pointer to internal palette structure
	moveq #2, %d0 | d0 is bit
	moveq #5, %d1 | d1 is counter
0:
	btst %d0, %d2
	sne (%a0)+
	addq.b #1, %d0
	dbf %d1, 0b

	move #95, %d0
	move.l #0xfbfbfbfb, %d1
	lea (UPDATE_PAL, %a5), %a0
0:
	and.l %d1, (%a0)+
	dbf %d0, 0b
	tst.w %d4
	NEXT_INSTRUCTION2 end_io_write_OBP1
end_io_write_OBP1:

.macro BG_GFX_WRITE offset, lable
	move.b %d2, (%a0, %d0.w) | write to VRAM
	clr.w %d1
	move.b %d0, %d1
	lsr.b #4, %d1
	lea (UPDATE_PAL+\offset, %a5), %a0
	clr.b (%a0, %d1.w)
	tst.w %d4
	NEXT_INSTRUCTION2 \lable
.endm

bg_gfx_write00: BG_GFX_WRITE 0, bg_gfx_write01
bg_gfx_write01: BG_GFX_WRITE 16, bg_gfx_write02
bg_gfx_write02: BG_GFX_WRITE 32, bg_gfx_write03
bg_gfx_write03: BG_GFX_WRITE 48, bg_gfx_write04
bg_gfx_write04: BG_GFX_WRITE 64, bg_gfx_write05
bg_gfx_write05: BG_GFX_WRITE 80, bg_gfx_write06
bg_gfx_write06: BG_GFX_WRITE 96, bg_gfx_write07
bg_gfx_write07: BG_GFX_WRITE 112, bg_gfx_write08
bg_gfx_write08: BG_GFX_WRITE 128, bg_gfx_write09
bg_gfx_write09: BG_GFX_WRITE 144, bg_gfx_write0A
bg_gfx_write0A: BG_GFX_WRITE 160, bg_gfx_write0B
bg_gfx_write0B: BG_GFX_WRITE 176, bg_gfx_write0C
bg_gfx_write0C: BG_GFX_WRITE 192, bg_gfx_write0D
bg_gfx_write0D: BG_GFX_WRITE 208, bg_gfx_write0E
bg_gfx_write0E: BG_GFX_WRITE 224, bg_gfx_write0F
bg_gfx_write0F: BG_GFX_WRITE 240, bg_gfx_write10
bg_gfx_write10: BG_GFX_WRITE 256, bg_gfx_write11
bg_gfx_write11: BG_GFX_WRITE 272, bg_gfx_write12
bg_gfx_write12: BG_GFX_WRITE 288, bg_gfx_write13
bg_gfx_write13: BG_GFX_WRITE 304, bg_gfx_write14
bg_gfx_write14: BG_GFX_WRITE 320, bg_gfx_write15
bg_gfx_write15: BG_GFX_WRITE 336, bg_gfx_write16
bg_gfx_write16: BG_GFX_WRITE 352, bg_gfx_write17
bg_gfx_write17: BG_GFX_WRITE 368, end_bg_gfx_write
end_bg_gfx_write:

| bg_gfx: 8000 - 97FF
| blocks 128 - 151
| so d3 will range from 1024 - 1208
| each block has 16 tiles...
| tile_index = ((d3 - 1024) / 8) * 16 + d0 / 16
/*bg_gfx_write:
	move.b %d2, (%a0, %d0.w) | write to VRAM
	subi.w #1024, %d3
	add.w %d3, %d3 | d3 = (d3 - 1024) * 2
	andi.w #0x00ff, %d0
	lsr.b #4, %d0 | d0 /= 16
	add.w %d0, %d3 | d3 = tile_index
	addi.w #UPDATE_PAL, %d3
	clr.b (%a5, %d3.w) | clear byte to signify we must update this sprite
	tst.w %d4
	NEXT_INSTRUCTION*/

/*d3 will be in range of 0 - 1024 (mod 8)
000 - 0255 (00000000 11111111): 0000 - 1fff
256 - 0511 (00000001 11111111): 2000 - 3fff
512 - 0767 (00000010 11111111): 4000 - 5fff
768 - 1024 (00000011 11111111): 6000 - 7fff

2000 - 3fff: rom select (5 bit)
4000 - 5fff: ram select (2 bit)
*/

mbc1_2000: | rom select
	andi.b #0x1f, %d2 |d2 is bank we need
	seq %d1
	sub.b %d1, %d2 | add 1 if d2 is 0
	moveq #0, %d0
	move.b (CURRENT_ROM, %a5), %d0
	andi.b #0x60, %d0
	or.b %d2, %d0
	cmp.b (CURRENT_ROM, %a5), %d0
	bne rom_bank
	tst.w %d4
	NEXT_INSTRUCTION2 end_mbc1_2000
end_mbc1_2000:

mbc1_4000: | ram select/upper rom select
	andi.b #0x03, %d2
	tst.b (MBC_MODE, %a5)
	bne ram_bank
	lsl.b #5, %d2
	moveq #0, %d0
	move.b (CURRENT_ROM, %a5), %d0
	andi.b #0x1f, %d0
	or.b %d2, %d0
	cmp.b (CURRENT_ROM, %a5), %d0
	bne rom_bank
	tst.w %d4
	NEXT_INSTRUCTION2 end_mbc1_4000
end_mbc1_4000:

mbc1_6000: | mode select
	andi.b #0x01, %d2
	move.b %d2, (MBC_MODE, %a5)
	tst.w %d4
	NEXT_INSTRUCTION2 end_mbc1_6000
end_mbc1_6000:

mbc2_2000: | rom select
	andi.w #0x000f, %d2
	seq %d1
	sub.b %d1, %d2 | add 1 if d2 is 0
	moveq #0, %d0
	move.b %d2, %d0
	cmp.b (CURRENT_ROM, %a5), %d0
	bne rom_bank
	tst.w %d4
	NEXT_INSTRUCTION2 end_mbc2_2000
end_mbc2_2000:

mbc3_2000: | rom select
	move.b %d2, %d0
	andi.w #0x007f, %d0
	seq %d1
	sub.b %d1, %d0 | bank0 --> bank1
	cmp.b (CURRENT_ROM, %a5), %d0
	bne rom_bank
	tst.w %d4
	NEXT_INSTRUCTION2 end_mbc3_2000
end_mbc3_2000:

mbc3_4000: | ram bank / rtc select
	andi.b #0x03, %d2
	bra ram_bank
	
mbc5_2000: | rom select (bits 0 - 7)
	move.b %d2, %d0
	andi.w #0x00ff, %d0
	cmp.b (CURRENT_ROM, %a5), %d0
	bne rom_bank
	tst.w %d4
	NEXT_INSTRUCTION2 end_mbc5_2000
end_mbc5_2000:
	
rom_bank: |input - %d0, rom bank to switch to
	| convert PC relative to gb_mem	
	cmp.b (ROM_BANKS, %a5), %d0
	bge no_bank
	
	move.l %a3, -(%sp) | save a3

	move.l %a4, %d2
	move.w (PC_BASE, %a5), %d1
	lea (MEM_TABLE, %a5, %d1.w), %a0
	sub.l (%a0), %d2 | pc now relative to block
	move.l %a0, -(%sp)

	move.b %d0, (CURRENT_ROM, %a5)

	|movem.l  %d0-%d7/%a0-%a6, -(%a7)
	|jsr show_bank
	|movem.l  (%a7)+, %d0-%d7/%a0-%a6
	
	movea.l (BANK_TABLE, %a5), %a3
	add.w %d0, %d0
	add.w %d0, %d0 | d0 *= 4...size of BANK_HEADER
	lea (%a3, %d0.w), %a3 | a3 points to proper bank_table entry
	moveq #0, %d0
	move.b (%a3)+, %d0 | d0 is index of first file we want
	add.w %d0, %d0
	add.w %d0, %d0 | d0 *= 4
	lea (ROM_PTR, %a5), %a0 | a0 points to rom_ptr list
	movea.l (%a0, %d0.w), %a0 | a0 points to proper file
	moveq #0, %d0
	move.b (%a3)+, %d0 | now d0 is offset into file
	moveq #13, %d1
	lsl.l %d1, %d0 | d0 *= 0x2000 (size of 1 half bank)
	adda.l %d0, %a0 | a0 now points to proper rom bank
	lea (MEM_TABLE+512, %a5), %a1 | a1 points to proper mem_ptr
	moveq.l #31, %d0 | loop counter
	move.l #256, %d1
rom_bank_loop0:
	move.l %a0, (%a1)
	adda.l %d1, %a0 | a0 += 256
	addq.l #8, %a1
	dbf %d0, rom_bank_loop0
	
	| do the same thing for second half of bank
	moveq #0, %d0
	move.b (%a3)+, %d0 | d0 is index of first file we want
	add.w %d0, %d0
	add.w %d0, %d0 | d0 *= 4
	lea (ROM_PTR, %a5), %a0 | a0 points to rom_ptr list
	movea.l (%a0, %d0.w), %a0 | a0 points to proper file
	moveq #0, %d0
	move.b (%a3)+, %d0 | now d0 is offset into file
	moveq #13, %d1
	lsl.l %d1, %d0 | d0 *= 0x2000 (size of 1 half bank)
	adda.l %d0, %a0 | a0 now points to proper rom bank...a1 is valid from first loop
	moveq.l #31, %d0 | loop counter
	move.l #256, %d1
rom_bank_loop1:
	move.l %a0, (%a1)
	adda.l %d1, %a0 | a0 += 256
	addq.l #8, %a1
	dbf %d0, rom_bank_loop1
	

	| convert PC relative to 68k mem
	move.l (%sp)+, %a0
	movea.l (%a0), %a4 | pc points to start of block
	adda.l %d2, %a4 | now pc is correct
	|jbsr update_reg_indir
	move.l (%sp)+, %a3 | restore a3
	tst.w %d4
	NEXT_INSTRUCTION2 end_rom_bank
end_rom_bank:

ram_bank: |input %d2, ram bank to switch to
	cmp.b (CURRENT_RAM, %a5), %d2
	beq no_bank
	cmp.b (RAM_BANKS, %a5), %d2
	bge no_bank

	move.l %a4, %d3
	move.w (PC_BASE, %a5), %d0
	lea (MEM_TABLE, %a5, %d0.w), %a0
	sub.l (%a0), %d3 | pc now relative to block
	move.l %a0, -(%sp)

	move.b %d2, (CURRENT_RAM, %a5)
	and.l #0x000000ff, %d2
	moveq #13, %d1
	lsl.l %d1, %d2 | d2 *= 8192 (size of 1 bank)
	movea.l (GB_RAM, %a5), %a0
	lea (%a0, 0x4200), %a0 | skip to start of internal ram
	adda.l %d2, %a0 | a0 points to proper bank
	lea (MEM_TABLE+1280, %a5), %a1 | a1 points to proper mem_ptr
	moveq.l #31, %d0 | loop counter
	move.l #256, %d1
ram_bank_loop:
	move.l %a0, (%a1)
	adda.l %d1, %a0 | a0 += 256
	addq.l #8, %a1
	dbf %d0, ram_bank_loop
	
	move.l (%sp)+, %a0
	movea.l (%a0), %a4 | pc points to start of block
	adda.l %d3, %a4 | now pc is correct
	|jbsr update_reg_indir
no_bank:
	tst.w %d4
	NEXT_INSTRUCTION2 end_ram_bank
end_ram_bank:

/*update_reg_indir:
	clr.w %d3
	move.b (%a5), %d3
	lsl.w #3, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a2
	move.l (%a2)+, (HL_BASE, %a5)
	move.w (%a2), (HL_FUNC, %a5)

	clr.w %d3
	move.b (GB_SP, %a5), %d3
	lsl.w #3, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a2
	move.l (%a2)+, (SP_BASE, %a5)
	move.w (%a2), (SP_FUNC, %a5)
	rts*/

write_disable:
	tst.w %d4
	NEXT_INSTRUCTION2 end_write_disable
end_write_disable:







