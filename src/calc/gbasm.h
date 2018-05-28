| Header File
| Created 8/2/2004; 2:57:42 PM

.equ GB_DEBUG, 0
|.equ GB_DEBUG, 1

.include "OS.h"

.equ OPCODE_SIZE, 70
.equ PREFIX_OPCODE_SIZE, 60
.equ IO_WRITE_SIZE, 60
.equ MEM_WRITE_SIZE, 60

| GB_DATA
.equ PC_BLOCK, (0)
.equ SP_BLOCK, (PC_BLOCK+4)
.equ PC_BASE, (PC_BLOCK+2)
.equ SP_BASE, (SP_BLOCK+2)

.equ FRAME_COUNTER, (SP_BLOCK+4)
.equ CPU_HALT, (FRAME_COUNTER+1)
|.equ EI_SAVE_PTR, (CPU_HALT+1)
|.equ EI_SAVE_NEXT, (EI_SAVE_PTR+4)
.equ NEXT_EVENT, (CPU_HALT+1)
|.equ SAVE_EVENT_EI, (NEXT_EVENT+4)
|.equ SAVE_EVENT_MEM16, (NEXT_EVENT+4)
|.equ SAVE_COUNT_EI, (SAVE_EVENT_MEM16+4)
|.equ SAVE_COUNT_MEM16, (SAVE_EVENT_MEM16+4)
|.equ MEM_WRITE16_BASE, (NEXT_EVENT+4)
.equ ERROR, (NEXT_EVENT+4)

.equ GB_PC, (ERROR+2)
.equ GB_SP, (GB_PC+2)
.equ EVENT_COUNTER, (GB_SP+2)
.equ MEM_BASE, (EVENT_COUNTER+2)
.equ GB_A, (MEM_BASE+4)
.equ GB_F, (GB_A+1)
.equ GB_HL, (GB_F+1)
.equ GB_BC, (GB_HL+2)
.equ GB_DE, (GB_BC+2)

.equ GB_RAM, (GB_DE+2)
.equ ROM_PTR, (GB_RAM+4)
.equ BG_TILEMAP, (ROM_PTR+43*4)
.equ WINDOW_TILEMAP, (BG_TILEMAP+4)
.equ BG_WINDOW_GFX, (WINDOW_TILEMAP+4)
.equ BG_WINDOW_TILEDATA, (BG_WINDOW_GFX+4)
.equ BG_WINDOW_UPDATE_PAL, (BG_WINDOW_TILEDATA+4)
.equ BANK_TABLE, (BG_WINDOW_UPDATE_PAL+4)
.equ RTC_BLOCK, (BANK_TABLE+4)
.equ ROM_NAME, (RTC_BLOCK+4)
.equ BG_PALETTE, (ROM_NAME+4)
.equ OB0_PALETTE, (BG_PALETTE+8)
.equ OB1_PALETTE, (OB0_PALETTE+6)
.equ UPDATE_PAL, (OB1_PALETTE+6)
.equ BG_GFX, (UPDATE_PAL+384)
.equ OBP0_GFX, (BG_GFX+384*16)
.equ OBP1_GFX, (OBP0_GFX+256*16)
.equ MASK_GFX, (OBP1_GFX+256*16)
.equ IME, (MASK_GFX+384*8)
.equ RTC_ENABLE, (IME+1)
.equ RTC_LATCH, (RTC_ENABLE+1)
.equ RTC_CURRENT, (RTC_LATCH+1)
.equ RTC_LATCHED, (RTC_CURRENT+5)
.equ QUIT, (RTC_LATCHED+5)
.equ BREAKPOINT, (QUIT+1)
.equ CART_TYPE, (BREAKPOINT+1)
.equ CURRENT_ROM, (CART_TYPE+1)
.equ ROM_BANKS, (CURRENT_ROM+1)
.equ CURRENT_RAM, (ROM_BANKS+1)
.equ RAM_BANKS, (CURRENT_RAM+1)
.equ RAM_BLOCKS, (RAM_BANKS+1)
.equ RAM_ENABLE, (RAM_BLOCKS+1)
.equ MBC_MODE, (RAM_ENABLE+1)
.equ Y_OFFSET, (MBC_MODE+1)
.equ BREAK_COUNTER, (Y_OFFSET+1)
.equ TIMER_COUNTER, (BREAK_COUNTER+1)
.equ FRAME_SKIP, (TIMER_COUNTER+1)
.equ SHOW_FPS, (FRAME_SKIP+1)
.equ ARCHIVE_SRAM, (SHOW_FPS+1)
.equ ENABLE_TIMER, (ARCHIVE_SRAM+1)
.equ ENABLE_SERIAL, (ENABLE_TIMER+1)
.equ SRAM_SAVESTATE, (ENABLE_SERIAL+1)
.equ VTI, (SRAM_SAVESTATE+1)
.equ AMS207, (VTI+1)
.equ HW_VERSION, (AMS207+1)
.equ CALC_TYPE, (HW_VERSION+1)
.equ INT3_ENABLED, (CALC_TYPE+1)
.equ INTS_REDIRECTED, (INT3_ENABLED+1)
.equ OLD_INT, (INTS_REDIRECTED+1)

| RTC Regs
.equ RTC_S, 0
.equ RTC_M, 1
.equ RTC_H, 2
.equ RTC_DL, 3
.equ RTC_DH, 4

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

| HALT STATES
.equ HALT_NONE, 0
.equ HALT_PENDING, 1
.equ HALT_ACTIVE, -1
.equ HALT_AFTER_EI, 2

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
	jmp debugger_entry
.else
	move.b (%a4)+, (\offset-function_base-2, %a3)
	jmp (0x7f00+6+MEM_WRITE_SIZE+IO_WRITE_SIZE+PREFIX_OPCODE_SIZE, %a6)
.endif
.endm

|.if GB_DEBUG
|.equ NEXT_INSTRUCTION_SIZE, 22
|.else
|.equ NEXT_INSTRUCTION_SIZE, 16
|.endif

/*.macro NEXT_INSTRUCTION offset
	bmi.b 0f			| 8
.if GB_DEBUG
	jsr debugger_entry
.endif
	move.b (%a4)+, (\offset-8, %a6)	| 16
	jmp (0x0F06.w, %a6)		| 10
0:
	movea.l (NEXT_EVENT, %a5), %a0
	jmp (%a0)
.endm					| 34

| maybe add this someday for instructions that take 1 cycle
.macro NEXT_INSTRUCTION1 offset
	dbf %d4, 0f
	movea.l (NEXT_EVENT, %a5), %a0
	jmp (%a0)
0:
.if GB_DEBUG
	jsr debugger_entry
.endif
	move.b (%a4)+, (\offset-2, %a6)	| 16
	jmp (0x0F06.w, %a6)		| 10
.endm*/
	
	

.macro NEXT_INSTRUCTION2 offset
.if GB_DEBUG
	jmp debugger_entry
.else
	move.b (%a4)+, (\offset-function_base-2, %a3)
	jmp (0x7f00+6+MEM_WRITE_SIZE+IO_WRITE_SIZE+PREFIX_OPCODE_SIZE, %a6)
.endif
.endm



