| Header File
| Created 8/2/2004; 2:57:42 PM

.equ GB_DEBUG, 0
|.equ GB_DEBUG, 1
.equ SIZE_TABLE, 0
|.equ SIZE_TABLE, 1

| GB_DATA
.equ GB_HL, 0
.equ GB_BC, 2
.equ GB_DE, 4
.equ LAST_SRC, (GB_DE+2)
.equ LAST_DST, (LAST_SRC+2)
.equ PC_BASE, (LAST_DST+2)
.equ SP_BASE, (PC_BASE+2)
.equ FRAME_COUNTER, (SP_BASE+2)
.equ CPU_HALT, (FRAME_COUNTER+1)
.equ NEXT_EVENT, (CPU_HALT+1)
.equ SAVE_EVENT_EI, (NEXT_EVENT+4)
.equ SAVE_EVENT_MEM16, (SAVE_EVENT_EI+4)
.equ SAVE_COUNT_EI, (SAVE_EVENT_MEM16+4)
.equ SAVE_COUNT_MEM16, (SAVE_COUNT_EI+2)
.equ ERROR, (SAVE_COUNT_MEM16+2)
.equ MEM_TABLE, (ERROR+2)
.equ GB_RAM, (MEM_TABLE+2048)
.equ ROM_PTR, (GB_RAM+4)
.equ BG_TILEMAP, (ROM_PTR+43*4)
.equ WINDOW_TILEMAP, (BG_TILEMAP+4)
.equ BG_WINDOW_GFX, (WINDOW_TILEMAP+4)
.equ BG_WINDOW_TILEDATA, (BG_WINDOW_GFX+4)
.equ BG_WINDOW_UPDATE_PAL, (BG_WINDOW_TILEDATA+4)
.equ BANK_TABLE, (BG_WINDOW_UPDATE_PAL+4)
.equ BG_PALETTE, (BANK_TABLE+4)
.equ OB0_PALETTE, (BG_PALETTE+8)
.equ OB1_PALETTE, (OB0_PALETTE+6)
.equ UPDATE_PAL, (OB1_PALETTE+6)
.equ BG_GFX, (UPDATE_PAL+384)
.equ OBP0_GFX, (BG_GFX+384*16)
.equ OBP1_GFX, (OBP0_GFX+256*16)
.equ MASK_GFX, (OBP1_GFX+256*16)
.equ QUIT, (MASK_GFX+384*8)
.equ BREAKPOINT, (QUIT+1)
.equ LAST_FLAG, (BREAKPOINT+1)
.equ CART_TYPE, (LAST_FLAG+1)
.equ CURRENT_ROM, (CART_TYPE+1)
.equ ROM_BANKS, (CURRENT_ROM+1)
.equ CURRENT_RAM, (ROM_BANKS+1)
.equ RAM_BANKS, (CURRENT_RAM+1)
.equ MBC_MODE, (RAM_BANKS+1)
.equ Y_OFFSET, (MBC_MODE+1)
.equ BREAK_COUNTER, (Y_OFFSET+1)
.equ TIMER_COUNTER, (BREAK_COUNTER+1)
.equ FRAME_SKIP, (TIMER_COUNTER+1)
.equ SHOW_FPS, (FRAME_SKIP+1)
.equ ARCHIVE_SRAM, (SHOW_FPS+1)
.equ ENABLE_TIMER, (ARCHIVE_SRAM+1)
.equ VTI, (ENABLE_TIMER+1)
.equ HW_VERSION, (VTI+1)
.equ CALC_TYPE, (HW_VERSION+1)

| VIDEO RAM
.equ TILEMAP0, 0x1800
.equ TILEMAP1, 0x1C00
.equ TILEDATA0, 0x1000
.equ TILEDATA1, 0x0000

| IO PORTS
.equ LCDC, 0x40
.equ STAT, 0x41
.equ SCX, 0x43
.equ SCY, 0x42
.equ WX, 0x4B
.equ WY, 0x4A
.equ LY, 0x44
.equ LYC, 0x45
.equ DIV, 0x04
.equ TIMA, 0x05
.equ TMA, 0x06
.equ TAC, 0x07
.equ IF, 0x0F
.equ IE, 0xFF
.equ P1, 0x00
.equ SB, 0x01
.equ SC, 0x02
.equ BGP, 0x47
.equ OBP0, 0x48
.equ OBP1, 0x49

.extern generate_int

/*.macro NEXT_INSTRUCTION
	bmi cyclic_events		| 12
	|jsr debugger_entry
	clr.w %d1			| 4
	move.b (%a4)+, %d1		| 8
	add.w %d1, %d1			| 4
	move.w (%a6, %d1.w), %d1	| 14
	jmp (%a3, %d1.w)		| 14
.endm*/					| 56

.macro END_EVENT offset
	tst.b (CPU_HALT, %a5)
	bpl.b 0f
	moveq #-1, %d4
	bra cyclic_events
0:
	/*clr.w %d0
	move.b (%a4)+, %d0
	add.w %d0, %d0
	move.w (%a6, %d0.w), %d0
	jmp (%a3, %d0.w)*/
.if GB_DEBUG
	jsr debugger_entry
.endif
	move.b (%a4)+, (\offset-function_base-2, %a3)
	jmp (0x0F00.w, %a6)
.endm

.if GB_DEBUG
.equ NEXT_INSTRUCTION_SIZE, 22
.else
.equ NEXT_INSTRUCTION_SIZE, 16
.endif

.macro NEXT_INSTRUCTION offset
	bmi.b 0f			| 8
.if GB_DEBUG
	jsr debugger_entry
.endif
	move.b (%a4)+, (\offset-8, %a6)	| 16
	jmp (0x0F00.w, %a6)		| 10
0:
	movea.l (NEXT_EVENT, %a5), %a0
	jmp (%a0)
.endm					| 34

.macro NEXT_INSTRUCTION2 offset
	bmi cyclic_events
.if GB_DEBUG
	jsr debugger_entry
.endif
	move.b (%a4)+, (\offset-function_base-2, %a3)
	jmp (0x0F00.w, %a6)
.endm



