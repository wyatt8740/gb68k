| Assembly Source File
| Created 8/5/2004; 5:06:11 PM

.global emulate_entry
.global return
.global check_interrupts

.global mode0_func
.global mode1_func
.global mode2_func
.global mode3_func
.global mode1_func_continue
.global mode2_func_off

| these locations are patched whenever stat changes
| all are either ori.b 0x00, (...) OR ori.b 0x02, (...)
.global stat_patch_mode2_coincidence
.global stat_patch_mode0_int
.global stat_patch_mode1_int
.global stat_patch_mode2_int

.global stat_patch_mode2_coincidence_halt
.global stat_patch_mode0_int_halt
.global stat_patch_mode1_int_halt
.global stat_patch_mode2_int_halt

.include "gbasm.h"

.even
.global next_instruction_size
next_instruction_size:
.byte next_instruction_end - next_instruction

.global next_instruction1_size
next_instruction1_size:
.byte next_instruction1_end - next_instruction1

.global write_default_size
write_default_size:
.byte next_instruction1_end - write_default

.even
.global opcode_block
opcode_block:
.long 0

/*
Cyclic events:
update DIV every 256 clks
update TIMA every 16-1024 clks


mode2 - 80 clks
	inc LY
	check for LYC
	set bits in STAT
	check for mode2 int
	ns = mode3
mode3 - 172 clks
	set bits in STAT
	ns = mode0
mode0 - 204 clks
	set bits in STAT
	check for mode0 int
	X-inc LY
	X-check for LYC int
	if(LY == 144) ns = mode1
	else ns = mode2
mode1 - 456 clks
	set bits in STAT
	check for mode1 int
	set V-Blank int
	inc LY
	check for LYC int
	if(LY == 154) ns = mode2
	else ns = mode1
	
	mode2
	80...
	mode3
	172...
	mode0
	4...
	TIMA
	200...
	mode2
	56...
	TIMA
	34...
	mode3
	172...
	mode0
	50...
	TIMA
	154...	
*/

.even
.global write_default_offset
write_default_offset:
.word write_default-function_base

.global next_instruction
next_instruction:
.if GB_DEBUG
	jmp (debugger_entry-function_base, %a3)
.else
	| tst.w %d4 OR subq.w #X, %d4 (proper instruction is patched in)
	bmi.b 0f
	move.b (%a4)+, (0x7fff, %a6)
	jmp (0x7f00+6+MEM_WRITE_SIZE+IO_WRITE_SIZE+PREFIX_OPCODE_SIZE, %a6)
0:
	move.w (NEXT_EVENT, %a5), %d1
	jmp (%a3, %d1.w)
.endif
next_instruction_end:

.global next_instruction1
write_default:
	move.b %d1, (%a0, %d0.w)
next_instruction1:
.if GB_DEBUG
	jmp (debugger_entry-function_base, %a3)
.else
	move.b (%a4)+, (0x7fff, %a6)
	jmp (0x7f00+6+MEM_WRITE_SIZE+IO_WRITE_SIZE+PREFIX_OPCODE_SIZE, %a6)
.endif
next_instruction1_end:

.macro CHECK_INTR
	|moveq #0, %d0
	move.b (IF, %a0), %d0
	and.b (IE, %a0), %d0
	and.b (IME, %a5), %d0
	beq 0f
	add.b %d0, %d0
	lea (intr_table-function_base, %a3), %a1
	move.w (%a1, %d0.w), %d1
	jmp (%a3, %d1.w)
0:
.endm

.macro GENERATE_INTR
	clr.b (IME, %a5) | disable interrupts
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f-function_base+2, %a3)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	move.w %d1, -(%a7)
	move.b (%a7)+, -(%a2)
	move.b %d1, -(%a2)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
.endm

|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
| while LCD is off, LCD will cycle between mode 2, 3, and 0, without changing LY (hopefully this is right...)
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

mode2_func_off:
	movea.l (-1*256+2, %a6) ,%a0
	move.b (STAT, %a0), %d0
	addi.w #20, %d4
	andi.b #0xfc, %d0
	addq.b #0x02, %d0 | set mode 2
	move.b %d0, (STAT, %a0)
	btst #5, %d0 | check to see if mode2 ints are enabled
	beq no_mode2_int_off
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
no_mode2_int_off:
	move.w #mode3_func_off-function_base, (NEXT_EVENT, %a5)
	jsr process_input_89
	bra check_interrupts

.global timer_entry_off

mode3_func_off:
	addi.w #41, %d4
	movea.l (-1*256+2, %a6) ,%a0
	addq.b #1, (STAT, %a0) | from mode 2 to mode 3
	move.w #mode0_func_off-function_base, (NEXT_EVENT, %a5)
	addq.b #1, (DIV, %a0) | For now...
timer_entry_off: |will be patched with BRA (word) by io handler
	nop
	nop
	NEXT_INSTRUCTION2 end_mode3_func_off
end_mode3_func_off:

mode0_func_off:
	addi.w #53, %d4
	movea.l (-1*256+2, %a6) ,%a0
	move.b (STAT, %a0), %d0
	andi.b #0xfc, %d0 | set mode 0
	btst #3, %d0 | check to see if mode0 ints are enabled
	beq no_mode0_int_off
	ori.b #(1<<1), (IF, %a0)
no_mode0_int_off:
	move.b %d0, (STAT, %a0)
	move.w #mode2_func_off-function_base, (NEXT_EVENT, %a5)
	jra check_interrupts
	
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
| HALT FUNCTIONS
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
.global timer_entry_halt

mode2_func_halt:
	clr.b (LY, %a0)
	bra 0f
mode2_func_continue_halt:
	addq.b #1, (LY, %a0)
0:
	move.b (LY, %a0), %d1
	andi.b #~(1<<2), %d0| clear coincidence flag
	cmp.b (LYC, %a0), %d1
	bne mode2_no_lyc_int_halt
	ori.b #(1<<2), %d0 | set coincidence flag
stat_patch_mode2_coincidence_halt:
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
mode2_no_lyc_int_halt:
	moveq #20, %d4
	andi.b #0xfc, %d0
	addq.b #0x02, %d0 | set mode 2
	move.b (STAT, %a0), %d0
	move.b %d0, (STAT, %a0)
stat_patch_mode2_int_halt:
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
	move.w #mode3_func-function_base, (NEXT_EVENT, %a5)
	cmp.b #67, %d1
	bne 0f
	jsr draw_screen
0:
	cmp.b (HALT_LY_CHECK, %a5), %d1
	beq halt_break
	CHECK_INTR
timer_entry_halt:
	nop
	nop
	| FALL THROUGH
	
mode0_func_halt:
	moveq #53, %d4
	move.b (STAT, %a0), %d0
	andi.b #0xfc, %d0 | set mode 0
stat_patch_mode0_int_halt:
	ori.b #(1<<1), (IF, %a0)
	move.b %d0, (STAT, %a0)
	move.w #mode2_func_continue-function_base, (NEXT_EVENT, %a5)
	CHECK_INTR
	cmpi.b #143, (LY, %a0)
	bcs mode2_func_continue_halt
	| FALL THROUGH
	
mode1_func_halt:
	addq.b #1, (STAT, %a0) | from mode 0 to mode 1
stat_patch_mode1_int_halt:
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
	ori.b #(1<<0), (IF, %a0) | set int for vblank
	moveq #114, %d4
	addq.b #1, (DIV, %a0) | For now... (maybe should inc timer here too...if any games needs it)
	addq.b #1, (LY, %a0)
	move.w #mode1_func_continue-function_base, (NEXT_EVENT, %a5)
	CHECK_INTR
	move.b #1, (HALT_LY_CHECK, %a5)
	bra mode2_func_halt

| d1 has LY
halt_break:
	move.b #0x90, %d0 | d0 is value of LY to break at
	btst #6, (STAT, %a0)
	beq 0f
	btst #1, (IE, %a0)
	beq 0f
	| coinc intr is enabled
	cmp.b (LYC, %a0), %d1
	bcc 0f
	| we will hit coinc intr before next vblank
	move.b (LYC, %a0), %d0
0:
	btst #2, (TAC, %a0)
	beq 0f
	btst #2, (IE, %a0)
	beq 0f
	tst.b (ENABLE_TIMER, %a5)
	beq 0f
	| timer is enabled
	move.w %d0, -(%a7)
	|moveq #0, %d0
	move.w #0x0100, %d1
	move.b (TIMA, %a0), %d0
	sub.w %d0, %d1 | how many ticks till overflow?
	| scale based on timer speed
	lsl.w #2, %d1
	move.b (TIMER_SHIFT, %a5), %d0
	lsr.w %d0, %d1
	move.b (LY, %a0), %d0
	add.w %d0, %d1 | value of LY when timer will overflow
	move.w (%a7)+, %d0
	cmp.w #0x90, %d1 | don't bother doing the byte compare if d1.w is too big
	bge 0f
	cmp.b %d0, %d1
	bhi 0f
	| timer intr will occur next
	move.b (TMA, %a0), (TIMA, %a0)
	clr.b (TIMER_COUNTER, %a5)
	| draw screen if we cross from LY < 67 to LY > 67
	move.b (LY, %a0), %d0
	cmp.b #67, %d0
	bgt 1f
	cmp.b #67, %d1
	blt 1f
	jsr draw_screen
1:	
	move.b %d1, (LY, %a0)
	jmp generate_intr_50
0:
	cmp.b #0x90, %d0
	beq 0f
	| coinc intr will occur next
	bset #2, (STAT, %a0) | set coincidence flag
	| draw screen if we cross from LY < 67 to LY > 67
	move.b (LY, %a0), %d1
	cmp.b #67, %d1
	bgt 1f
	cmp.b #67, %d0
	blt 1f
	jsr draw_screen
1:	
	| timer stuff
	move.w %d0, -(%a7)
	sub.b %d1, %d0 | how many ticks are we skipping?
	| scale based on timer speed
	move.b (TIMER_SHIFT, %a5), %d1
	lsl.b %d1, %d0
	lsr.b #2, %d0
	add.b %d0, (TIMA, %a5) | inc timer
	move.w (%a7)+, %d0
	| end timer stuff
	move.b %d0, (LY, %a0)	
	jmp generate_intr_48
0:
	| vblank will occur next
	move.b (LY, %a0), %d0
	cmp.b #67, %d0
	bgt 1f
	jsr draw_screen
1:	
	| timer stuff
	move.w %d0, -(%a7)
	sub.b %d1, %d0 | how many ticks are we skipping?
	| scale based on timer speed
	move.b (TIMER_SHIFT, %a5), %d1
	lsl.b %d1, %d0
	lsr.b #2, %d0
	add.b %d0, (TIMA, %a5) | inc timer
	move.w (%a7)+, %d0
	| end timer stuff
	move.b #143, (LY, %a0)
	andi.b #0xfc, (STAT, %a0)
	bra mode1_func_halt

.global halt_function
halt_function:
	cmp.b #HALT_AFTER_EI, (CPU_HALT, %a5)
	bne 0f
	st (IME, %a5)
0:
	tst.b (IME, %a5)
	beq 1f
	clr.b (CPU_HALT, %a5)
	movea.l (-1*256+2, %a6) ,%a0
	move.b (LY, %a0), %d1
	addq.b #2, %d1
	move.b %d1, (HALT_LY_CHECK, %a5)
	move.w (NEXT_EVENT, %a5), %d1
	move.w (-2, %a3, %d1.w), %d1
	jmp (%a3, %d1.w)
1:
	move.b #HALT_PENDING, (CPU_HALT, %a5)
	NEXT_INSTRUCTION2 end_halt_function
end_halt_function:
	
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
| NORMAL FUNCTIONS
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
.word mode2_func_halt-function_base
mode2_func:
	movea.l (-1*256+2, %a6) ,%a0
	clr.b (LY, %a0)
	bra 0f
.word mode2_func_continue_halt-function_base
mode2_func_continue:
	movea.l (-1*256+2, %a6) ,%a0
	addq.b #1, (LY, %a0)
0:
	move.b (STAT, %a0), %d0
	move.b (LY, %a0), %d1
	andi.b #~(1<<2), %d0| clear coincidence flag
	cmp.b (LYC, %a0), %d1
	bne mode2_no_lyc_int
	ori.b #(1<<2), %d0 | set coincidence flag
stat_patch_mode2_coincidence:
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr 
mode2_no_lyc_int:	
	addi.w #20, %d4
	andi.b #0xfc, %d0
	addq.b #0x02, %d0 | set mode 2
	move.b %d0, (STAT, %a0)
stat_patch_mode2_int:
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
	move.w #mode3_func-function_base, (NEXT_EVENT, %a5)
	
	cmp.b #67, %d1
	bne check_interrupts
	jsr draw_screen
	bra check_interrupts

.global timer_func_base_jsr
.global timer_func_halt_jsr
.global timer_speed_table

timer_func_base_jsr:
	jmp (timer_func_base-function_base, %a3)
timer_func_halt_jsr:
	jmp (timer_func_halt-function_base, %a3)
timer_speed_table:
	.byte 1
	.byte 64
	.byte 16
	.byte 4
timer_shift_table:
	.byte 0
	.byte 6
	.byte 4
	.byte 2
	
.global timer_entry
	
.word mode0_func_halt-function_base
mode3_func:
	addi.w #41, %d4
	movea.l (-1*256+2, %a6) ,%a0
	addq.b #1, (STAT, %a0) | from mode 2 to mode 3
	move.w #mode0_func-function_base, (NEXT_EVENT, %a5)
	addq.b #1, (DIV, %a0) | For now...
timer_entry:
	nop | will be replaced by jump to timer handler by io handler
	nop
0:
	NEXT_INSTRUCTION2 end_mode3_func
end_mode3_func:

.macro TIMER_FUNC
	move.b (TIMER_SPEED, %a5), %d0
	move.b (TIMER_COUNTER, %a5), %d1
	add.b %d0, %d1
	cmp.b #4, %d1
	blt 0f
2:
	subq #4, %d1
	addq.b #1, (TIMA, %a0)
	bcc 1f
	move.b (TMA, %a0), (TIMA, %a0)
	or.b #(1<<2), (IF, %a0)
1:
	cmp.b #4, %d1
	bge 2b
0:
	move.b %d1, (TIMER_COUNTER, %a5)
.endm

timer_func_base:
	TIMER_FUNC
	bra check_interrupts
timer_func_halt:
	TIMER_FUNC
	CHECK_INTR
	bra mode0_func_halt

.word mode0_func_halt-function_base
mode0_func:
	addi.w #53, %d4
	movea.l (-1*256+2, %a6) ,%a0
	move.b (STAT, %a0), %d0
	andi.b #0xfc, %d0 | set mode 0
stat_patch_mode0_int:
	ori.b #(1<<1), (IF, %a0)
	move.b %d0, (STAT, %a0)
	cmpi.b #143, (LY, %a0)
	bcs no_vblank
	move.w #mode1_func-function_base, (NEXT_EVENT, %a5)
	jra check_interrupts
no_vblank:
	move.w #mode2_func_continue-function_base, (NEXT_EVENT, %a5)
	jra check_interrupts

.word mode1_func_halt-function_base
mode1_func:
	movea.l (-1*256+2, %a6) ,%a0
	addq.b #1, (STAT, %a0) | from mode 0 to mode 1
stat_patch_mode1_int:
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
	ori.b #(1<<0), (IF, %a0) | set int for vblank
	bra 0f
.word mode2_func_halt-function_base
mode1_func_continue:
	movea.l (-1*256+2, %a6) ,%a0
0:
	addi.w #114, %d4
	addq.b #1, (DIV, %a0) | For now... (maybe should inc timer here too...if any games needs it)
	addq.b #1, (LY, %a0)
	cmpi.b #153, (LY, %a0)
	bcs no_ly_overflow
	move.w #mode2_func-function_base, (NEXT_EVENT, %a5)
	jra check_interrupts
no_ly_overflow:
	move.w #mode1_func_continue-function_base, (NEXT_EVENT, %a5)
	jra check_interrupts
	
.global ei_function
.global enable_intr_entry
ei_function:
	move.b (%a4), %d0 | next instruction
	cmp.b #0xf3, %d0
	beq skip_ei | ignore ei followed by di
	cmp.b #0xfb, %d0
	beq skip_ei
	cmp.b #0x76, %d0
	bne enable_intr_entry | delay ei until halt
	move.b #HALT_AFTER_EI, (CPU_HALT, %a5)
	bra skip_ei
enable_intr_entry:
	st (IME, %a5) | enable interrupts
	movea.l (-1*256+2, %a6) ,%a0
	cmp.b #HALT_PENDING, (CPU_HALT, %a5) | was a halt pending?
	bne 0f
	clr.b (CPU_HALT, %a5)
	move.b (IF, %a0), %d0
	and.b (IE, %a0), %d0
	bne 0f | don't bother halting if there's an intr waiting
	move.w (NEXT_EVENT, %a5), %d1
	move.w (-2, %a3, %d1.w), %d1
	jmp (%a3, %d1.w)
0:
	jmp check_interrupts
skip_ei:
	NEXT_INSTRUCTION2 end_ei_function
end_ei_function:

|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
| INTERRUPT FUNCTIONS
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

intr_table:
.word 0x00 | 0000
.word generate_intr_40 - function_base | 0001
.word generate_intr_48 - function_base | 0010
.word generate_intr_40 - function_base | 0011
.word generate_intr_50 - function_base | 0100
.word generate_intr_40 - function_base | 0101
.word generate_intr_48 - function_base | 0110
.word generate_intr_40 - function_base | 0111
.word generate_intr_58 - function_base | 1000
.word generate_intr_40 - function_base | 1001
.word generate_intr_48 - function_base | 1010
.word generate_intr_40 - function_base | 1011
.word generate_intr_50 - function_base | 1100
.word generate_intr_40 - function_base | 1101
.word generate_intr_48 - function_base | 1110
.word generate_intr_40 - function_base | 1111

generate_intr_40:
	GENERATE_INTR
	bclr #0, (IF, %a0)
	lea (0x40, %a4), %a4
	NEXT_INSTRUCTION2 end_generate_intr_40
end_generate_intr_40:
	
generate_intr_48:
	GENERATE_INTR
	bclr #1, (IF, %a0)
	lea (0x48, %a4), %a4
	NEXT_INSTRUCTION2 end_generate_intr_48
end_generate_intr_48:
	

generate_intr_50:
	GENERATE_INTR
	bclr #2, (IF, %a0)
	lea (0x50, %a4), %a4
	NEXT_INSTRUCTION2 end_generate_intr_50
end_generate_intr_50:

generate_intr_58:
	GENERATE_INTR
	bclr #3, (IF, %a0)
	lea (0x58, %a4), %a4
	NEXT_INSTRUCTION2 end_generate_intr_58
end_generate_intr_58:

check_interrupts:
	CHECK_INTR
	NEXT_INSTRUCTION2 check_interrupts_end
check_interrupts_end:

.global process_input_89
process_input_89:
	tst.b (ON_PRESSED, %a5)
	beq 0f
	addq.l #4, %a7 | kill return on stack
	bra return
0:
	tst.b (CALC_TYPE, %a5)
	bne process_input_92
	move.w #0xffbf, 0x600018
	moveq #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	not.b %d0
	beq no_quit_89
	st (QUIT, %a5)
	addq.l #4, %a7 | kill return on stack
	bra return
no_quit_89:
	move.w #0xfffd, 0x600018 | select row 1
	moveq #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	btst #1, %d0
	beq inc_y_offset
	btst #2, %d0
	beq dec_y_offset
	btst #3, %d0
	bne 0f
	move.b #44, (Y_OFFSET, %a5)
	rts	
0:
	btst #4, %d0
	beq zero_y_offset
	rts
process_input_92:
	move.w #0xfeff, 0x600018
	moveq #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	btst #6, %d0
	bne no_quit_92
	|lea (60, %a7), %a7 | kill 15 regs on the stack
	st (QUIT, %a5)
	addq.l #4, %a7 | kill return on stack
	bra return
no_quit_92:
	btst #4, %d0 | check +
	beq inc_y_offset
	move.w #0xfdff, 0x600018 | select row 1
	moveq #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	btst #0, %d0 | check -
	beq dec_y_offset
	
	move.w #~(1<<5), 0x600018 | select row 5
	moveq #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	btst #0, %d0 | check /
	beq zero_y_offset
	
	move.w #~(1<<7), 0x600018 | select row 7
	moveq #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	btst #7, %d0 | check *
	bne 0f
	move.b #16, (Y_OFFSET, %a5)
0:
	rts
inc_y_offset:
	move.b (Y_OFFSET, %a5), %d0
	moveq #16, %d1
	tst.b (CALC_TYPE, %a5) | determine max y_offset based on calc model
	bne 0f
	moveq #44, %d1
0:
	cmp.b %d1, %d0
	beq 0f
	addq.b #4, %d0
	move.b %d0, (Y_OFFSET, %a5)
	rts
dec_y_offset:
	move.b (Y_OFFSET, %a5), %d0
	beq 0f
	subq.b #4, %d0
	move.b %d0, (Y_OFFSET, %a5)
0:
	rts
zero_y_offset:
	clr.b (Y_OFFSET, %a5)
	rts

.if GB_DEBUG
.global debugger_entry
debugger_entry:
	tst.w %d4
	bmi cyclic_events
	
	movea.l (ROM_PTR, %a5), %a0
	adda.l #0xc8, %a0 |843
	
	|movea.l (ROM_PTR+4, %a5), %a0
	|adda.l #0xA000+0x1984, %a0 |843
	
	
	cmpa.l %a0, %a4
	beq break
	tst.b (BREAKPOINT, %a5)
	bne continue_break
0:
	move.b (%a4)+, (break-function_base-2, %a3)
	jmp (0x7f00+6+MEM_WRITE_SIZE+IO_WRITE_SIZE+PREFIX_OPCODE_SIZE, %a6)
break:
	|cmp.b #0x2, (GB_BC, %a5)
	|bne 0b
	
continue_break:
	|add.b #1, (BREAK_COUNTER, %a5)
	|cmp.b #2, (BREAK_COUNTER, %a5)
	|bne 0b

	st (BREAKPOINT, %a5)
	jmp return
.endif

emulate_entry:
	movem.l %d0-%d7/%a0-%a6,-(%a7)
	
	movea.l (MEM_BASE, %a5), %a3
	jsr reset_timer
	jsr create_opcode_block
	tst.w %d0
	beq init_error
	movea.l (opcode_block), %a6
	adda.l #0x8000, %a6
	move.b (HW_VERSION, %a5), %d0
	cmp.b #2, %d0 | skip ghost space if not HW2
	bne 0f
	adda.l #0x40000, %a6
0:
	jsr reset_banks
	jsr reset_stat
	jsr reset_LCDC
	jsr reset_palette
	| reload data into registers				
	move.b (GB_A, %a5), %d5
	move.b (GB_F, %a5), %d6
	
	move.b (GB_HL, %a5), %d7
	swap %d7
	move.b (GB_HL+1, %a5), %d7
	
	move.b (GB_BC, %a5), %d2
	swap %d2
	move.b (GB_BC+1, %a5), %d2
	
	move.b (GB_DE, %a5), %d3
	swap %d3
	move.b (GB_DE+1, %a5), %d3
	
	move.w (EVENT_COUNTER, %a5), %d4
	| construct PC
	moveq #0, %d0
	move.b (GB_PC+1, %a5), %d0
	move.b (GB_PC, %a5), %d1
	move.b %d1, (PC_BASE, %a5)
	move.b %d1, (6f-function_base-2, %a3)
	movea.l (0x7f02, %a6), %a4
6:
	adda.l %d0, %a4
	| construct SP
	moveq #0, %d0
	move.b (GB_SP+1, %a5), %d0
	move.b (GB_SP, %a5), %d1
	move.b %d1, (SP_BASE, %a5)
	move.b %d1, (6f-function_base-2, %a3)
	movea.l (0x7f02, %a6), %a2
6:
	adda.l %d0, %a2
	
	move.b (%a4)+, (emulate_entry_end-function_base-2, %a3)
	jmp (0x7f00+6+MEM_WRITE_SIZE+IO_WRITE_SIZE+PREFIX_OPCODE_SIZE, %a6)
emulate_entry_end:

| interrupt handlers
.global gb_data_store
gb_data_store:
.long 0
.global on_handler
.global hw1_tick
.global hw2_tick

on_handler:
|	move.w #0x2700, %sr
	move.l %a0, -(%a7)
	move.l gb_data_store, %a0
	st (ON_PRESSED, %a0)
	movea.l (%a7)+, %a0
	rte

hw1_tick:
|	move.w #0x2700, %sr
	addq.w #1, counter
	cmp.w #350, counter
	bne 0f
	clr.w counter
	jmp tick_process
0:
	rte
hw2_tick:
|	move.w #0x2700, %sr
tick_process:
	move.w frames, current_fps
	clr.w frames
	move.l %a5, -(%a7)
	move.l gb_data_store, %a5
	btst #6, (RTC_CURRENT+RTC_DH, %a5)
	bne 0f | clock disabled
	add.b #1, (RTC_CURRENT+RTC_S, %a5)
	cmp.b #60, (RTC_CURRENT+RTC_S, %a5)
	bne 0f
	clr.b (RTC_CURRENT+RTC_S, %a5)
	add.b #1, (RTC_CURRENT+RTC_M, %a5)
	cmp.b #60, (RTC_CURRENT+RTC_M, %a5)
	bne 0f
	clr.b (RTC_CURRENT+RTC_M, %a5)
	add.b #1, (RTC_CURRENT+RTC_H, %a5)
	cmp.b #24, (RTC_CURRENT+RTC_H, %a5)
	bne 0f
	clr.b (RTC_CURRENT+RTC_H, %a5)
	add.b #1, (RTC_CURRENT+RTC_DL, %a5)
	bcc 0f | did we overflow?
	add.b #1, (RTC_CURRENT+RTC_DH, %a5) | if so, add 1 to high bit
	bclr #1, (RTC_CURRENT+RTC_DH, %a5) | check to see if we overflowed ( > 511)
	beq 0f
	bset #7, (RTC_CURRENT+RTC_DH, %a5) | set overflow bit
0:
	move.l (%a7)+, %a5
	rte

return:
	| put registers into memory
	move.b %d5, (GB_A, %a5)
	move.b %d6, (GB_F, %a5)
	
	move.b %d7, (GB_HL+1, %a5)
	swap %d7
	move.b %d7, (GB_HL, %a5)
	
	move.b %d2, (GB_BC+1, %a5)
	swap %d2
	move.b %d2, (GB_BC, %a5)
	
	move.b %d3, (GB_DE+1, %a5)
	swap %d3
	move.b %d3, (GB_DE, %a5)
	
	move.l %a3, (MEM_BASE, %a5)
	move.w %d4, (EVENT_COUNTER, %a5)
	| construct pc
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f-function_base-2, %a3)
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
6:
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	move.w %d1, (GB_PC, %a5)
	| construct sp
	move.l %a2, %d1
	move.b (SP_BASE, %a5), (6f-function_base-2, %a3)
	sub.l (0x7f02, %a6), %d1 | sp now relative to block
6:
	add.l (SP_BLOCK, %a5), %d1 | sp is now correct
	move.w %d1, (GB_SP, %a5)
init_error:	
	movem.l (%a7)+, %d0-%d7/%a0-%a6
	rts

/*.global calculate_half_carry
calculate_half_carry: | puts half carry flag in bit 5 of %d2
	move.b (LAST_SRC, %a5), %d0
	move.b (LAST_DST, %a5), %d1
	moveq #0x0f, %d3
	and.w %d3, %d0 | mask out bits
	and.w %d3, %d1
	btst #7, %d7
	bne use_carry_flag
	clr.b %d3 | don't use carry flag
	bra 0f
use_carry_flag:
	move.b (LAST_FLAG, %a5), %d3 | use carry flag
0:
	btst #5, %d7
	beq 0f
	add.b %d3, %d3 | carry --> extend
	subx.b %d0, %d1
	bra 1f
0:
	add.b %d3, %d3 | carry --> extend
	addx.b %d0, %d1
1:
	andi.b #0xf0, %d1 | did we carry into upper nibble?
	beq 0f
	ori.b #(1<<5), %d2 | yes!
	rts
0:
	andi.b #~(1<<5), %d2 | no...
	rts
	*/
/*	move.w (LAST_SRC, %a5), %d0
	move.w (LAST_DST, %a5), %d1
	move.w #0x0f00, %d3
	btst #6, %d7
	sne %d3
	and.w %d3, %d0 | mask out bits
	and.w %d3, %d1
	btst #7, %d7
	bne use_carry_flag
	clr.b %d3 | don't use carry flag
	bra 0f
use_carry_flag:
	move.b (LAST_FLAG, %a5), %d3 | use carry flag
0:
	btst #5, %d7
	beq 0f
	add.b %d3, %d3 | carry --> extend
	subx.w %d0, %d1
	bra 1f
0:
	add.b %d3, %d3 | carry --> extend
	addx.w %d0, %d1
1:
	andi.w #0xf000, %d1 | did we carry into upper nibble?
	beq 0f
	ori.b #(1<<5), %d2 | yes!
	rts
0:
	andi.b #~(1<<5), %d2 | no...
	rts*/
	
	
.if 0

LD A, (HL)

	moveq #0, %d0
	move.b (1, %a5), %d0
	move.b (%a5), (NEXT, %d6)
	movea.l (0xff00, %a6), %a0
	move.b (%a0, %d0.w), %d5
	sub #blah, %d4
	
OR
	move.b (%a5), (0f+2-function_base, %d6)
0:
	movea.l (0xff00, %a6), %a0
	move.b (1, %a5), (0f+3-function_base, %d6)
0:
	move.b (0x00ff, %a0), %d5
	sub #blah, %d4

LD (HL), A	
	moveq #0, %d0
	move.b (1, %a5), %d0
	move.b (%a5), (NEXT, %d6)
	lea (0xff00, %a6), %a0
	move.l (%a0)+, %a0
	move.w (%a0), %d0
	beq 0f
		
0:
	move.b %d5, (%a0, %d0.w)
	sub #blah, %d4

	
	
OR
	sub #blah, %d4
	moveq #0, %d0
	move.b (1, %a5), %d0
	move.b %d5, %d1
	move.b (%a5), (NEXT, %d6)
	jmp (0x0F04, %a6)
		
write_handle:
	move.l (%pc, -6), %a0
	move.b %d1, (%a0, %d0.w)
	

6, 18/20
vs
16, 6/14

| A - 10
move.w %sr, %d6
move.w %d6, %d7
| B - 6
move.w %sr, %d6
| C - 16
move.w %sr, %d6
swap %d6
move.w %sr, %d6


| A - 6
move.w %sr, %d6 OR move.w %sr %d7
| B - 22/28 OR 24 OR 18/20
moveq #n, %d0
bset %d0, %d6
| operation
bcc 0f
bchg %d0, %d6
0:

OR

scc %d1
moveq #n, %d0
and.b %d0, %d1
not.b %d0
and.b %d0, %d6
or.b %d1, %d6

OR

moveq #mask, %d0
or.b %d0, %d6
| operation
bcc 0f
eor %d0, %d6
0:

| C - 6 OR 14
move.w %sr,%d6 
OR
swap %d6
move.w %sr, %d6
swap %d6
	

	move.b %d5, %d0 | d0 is current a
	move.b (LAST_DST, %a5), %d5 | d5 is old a
	btst #0, %d6
	beq no_carry
/*
	so the carry flag was set after the last operation...
	either an add overflowed, or a sub underflowed
	if last operation was an add...
		d5 will be smaller than d0 (carry will be clear)
		d0 will be operand to last operation
	if it was subtract...
		d5 will be bigger (carry will be set)
		d0 will be negative operand to last operation
*/
	sub.b %d5, %d0
	bcc daa_sub
daa_add: | current a was bigger...this means last instruction was add
	sub.b %d1, %d1 |set zero, clear extend			
	abcd %d0, %d5 | redo operation in bcd
	move %sr, %d6
	move %sr, %d7
	bra 0f	
no_carry:
	sub.b %d5, %d0
	bcc daa_add
daa_sub:
	neg.b %d0
	sub.b %d1, %d1 |set zero, clear extend
	sbcd %d0, %d5 | redo operation in bcd
	move %sr, %d6
	move %sr, %d7
0:

mode2:
	coinc lcdc
	mode2 lcdc
mode3:
	timer
mode0:
	mode0 lcdc
mode1:
	vblank
	coinc lcdc
	mode1 lcdc
	
if(mode
	



.endif






