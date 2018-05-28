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
.global stat_patch_mode1_coincidence
.global stat_patch_mode0_int
.global stat_patch_mode1_int
.global stat_patch_mode2_int

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
	movea.l (NEXT_EVENT, %a5), %a0
	jmp (%a0)
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

| while LCD is off, LCD will cycle between mode 2, 3, and 0, without changing LY (hopefully this is right...)
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
	move.l #mode3_func_off, (NEXT_EVENT, %a5)
	
	tst.b (CALC_TYPE, %a5)
	beq process_input_89
	bra process_input_92

.global timer_entry_off

mode3_func_off:
	addi.w #41, %d4
	movea.l (-1*256+2, %a6) ,%a0
	addq.b #1, (STAT, %a0) | from mode 2 to mode 3
	move.l #mode0_func_off, (NEXT_EVENT, %a5)
	addq.b #1, (DIV, %a0) | For now...
timer_entry_off: |will be patched with BRA (word) by io handler
	nop
	nop
	END_EVENT end_mode3_func_off
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
	move.l #mode2_func_off, (NEXT_EVENT, %a5)
	jra check_interrupts_event


mode2_func:
	movea.l (-1*256+2, %a6) ,%a0
	clr.b (LY, %a0)
	bra 0f
mode2_func_continue:
	movea.l (-1*256+2, %a6) ,%a0
	addq.b #1, (LY, %a0)
0:
	move.b (STAT, %a0), %d0
	move.b (LY, %a0), %d1
	andi #~(1<<2), %d0| clear coincidence flag
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
	move.l #mode3_func, (NEXT_EVENT, %a5)
	
	cmp.b #67, %d1
	bne check_interrupts_event
	subq.b #1, (FRAME_COUNTER, %a5)
	bpl check_interrupts_event
	move.b (FRAME_SKIP, %a5), (FRAME_COUNTER, %a5)
	jbsr draw_screen
	tst.b (CALC_TYPE, %a5)
	beq process_input_89
	bra process_input_92

.global timer_entry
.global timer_func_table

timer_func_table:
	.long timer_func00
	.long timer_func01
	.long timer_func10
	.long timer_func11

mode3_func:
	addi.w #41, %d4
	movea.l (-1*256+2, %a6) ,%a0
	addq.b #1, (STAT, %a0) | from mode 2 to mode 3
	move.l #mode0_func, (NEXT_EVENT, %a5)
	addq.b #1, (DIV, %a0) | For now...
timer_entry:
	nop | will be replaced by jump to timer handler by io handler
0:
	END_EVENT end_mode3_func
end_mode3_func:

timer_func00:
	subq.b #1, (TIMER_COUNTER, %a5)
	bne 0b
	move.b #3, (TIMER_COUNTER, %a5) | timer incs every 4 calls
	addq.b #1, (TIMA, %a0)
	bcc 0b
	move.b (TMA, %a0), (TIMA, %a0)
	or.b #(1<<2), (IF, %a0)
	jra check_interrupts_event
timer_func01:
	add.b #16, (TIMA, %a0)
	bcc 0b
	move.b (TMA, %a0), (TIMA, %a0)
	or.b #(1<<2), (IF, %a0)
	jra check_interrupts_event
timer_func10:
	addq.b #4, (TIMA, %a0)
	bcc 0b
	move.b (TMA, %a0), (TIMA, %a0)
	or.b #(1<<2), (IF, %a0)
	jra check_interrupts_event
timer_func11:
	addq.b #1, (TIMA, %a0)
	bcc 0b
	move.b (TMA, %a0), (TIMA, %a0)
	or.b #(1<<2), (IF, %a0)
	jra check_interrupts_event

mode0_func:
	addi.w #53, %d4
	movea.l (-1*256+2, %a6) ,%a0
	move.b (STAT, %a0), %d0
	andi.b #0xfc, %d0 | set mode 0
stat_patch_mode0_int:
	ori.b #(1<<1), (IF, %a0)
	move.b %d0, (STAT, %a0)
	cmpi.b #143, (LY, %a0)
	bne no_vblank
	move.l #mode1_func, (NEXT_EVENT, %a5)
	jra check_interrupts_event
no_vblank:
	move.l #mode2_func_continue, (NEXT_EVENT, %a5)
	jra check_interrupts_event

mode1_func:
	movea.l (-1*256+2, %a6) ,%a0
	move.b (STAT, %a0), %d0
	addq.b #1, %d0 | from mode 0 to mode 1
stat_patch_mode1_int:
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
	ori.b #(1<<0), (IF, %a0) | set int for vblank
	bra 0f
mode1_func_continue:
	movea.l (-1*256+2, %a6) ,%a0
	move.b (STAT, %a0), %d0
0:
	addi.w #114, %d4
	addq.b #1, (DIV, %a0) | For now... (maybe should inc timer here too...if any games needs it)
	andi.b #~(1<<2), %d0 | clear coincidence flag
	addq.b #1, (LY, %a0)
	move.b (LY, %a0), %d1
	cmp.b (LYC, %a0), %d1
	bne mode1_no_lyc_int
	ori.b #(1<<2), %d0 | set coincidence flag
stat_patch_mode1_coincidence:
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
mode1_no_lyc_int:
	move.b %d0, (STAT, %a0) | rewrite value
	cmpi.b #153, %d1
	bne no_ly_overflow
	move.l #mode2_func, (NEXT_EVENT, %a5)
	jra check_interrupts_event
no_ly_overflow:
	move.l #mode1_func_continue, (NEXT_EVENT, %a5)
	jra check_interrupts_event

|enable_intr_jump:
|	jmp (enable_intr_func-function_base, %a3)	
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
	moveq #-1, %d4
	move.b #HALT_ACTIVE, (CPU_HALT, %a5)
	bra cyclic_events
0:
	lea (skip_ei, %pc), %a1
	jmp check_interrupts
skip_ei:
	NEXT_INSTRUCTION2 end_ei_function
end_ei_function:
	
/*	moveq #0, %d0
	moveq #0, %d1
	move.b (%a4), %d0
	cmp.b #0xF3, %d0 | ignore ei followed by di
	beq skip_ei
	cmp.b #0xCB, %d0
	beq prefix
	move.b %d0, (6f - function_base + 2, %a3)
6:
	lea (0x7f00+6+MEM_WRITE_SIZE+IO_WRITE_SIZE+PREFIX_OPCODE_SIZE, %a6), %a0
	bra 0f
prefix:
	move.b (%a4, 1), %d0
	move.b %d0, (6f - function_base + 2, %a3)
6:
	lea (0x7f00+6+MEM_WRITE_SIZE+IO_WRITE_SIZE, %a6), %a0
	add.w #256, %d0
0:
	lea (size_table, %pc), %a1
	move.b (%a1, %d0.w), %d1 | size of next instruction
	adda.l %d1, %a0 | where to put the next_instruction
	addq.l #6, %a0
	move.l -(%a0), -(%a7)
	move.l %a0, -(%a7)
	lea (enable_intr_jump, %pc), %a1
	move.l (%a1)+, (%a0)+
skip_ei:
	NEXT_INSTRUCTION2 end_ei_function
end_ei_function:

.global enable_intr_entry
.global enable_intr_func
enable_intr_func:
	movea.l (%a7)+, %a0
	move.l (%a7)+, (%a0)+

enable_intr_entry:	
	movea.l (-1*256+2, %a6) ,%a0
	st (IME, %a5) | enable interrupts
	cmp.b #1, (CPU_HALT, %a5) | was a halt pending?
	bne 0f
	clr.b (CPU_HALT, %a5)
	move.b (IF, %a0), %d0
	and.b (IE, %a0), %d0
	bne 0f | don't bother halting if there's an intr waiting
	moveq #-1, %d4
	move.b #-1, (CPU_HALT, %a5)
	bra cyclic_events
0:
	lea (1f, %pc), %a1
	jmp check_interrupts
1:
	tst.w %d4
	bmi cyclic_events
	END_EVENT end_enable_intr_func
	|NEXT_INSTRUCTION2 end_enable_intr_func
end_enable_intr_func:*/

/*.global patch_next_instruction
patch_next_instruction:
	moveq #0, %d0
	moveq #0, %d1
	move.b (%a4), %d0
	cmp.b #0xCB, %d0
	beq prefix
	move.b %d0, (5f-function_base-2, %a3)
	lea (0x0F06.w, %a6), %a0
5:
	bra 0f
prefix:
	move.b (%a4, 1), %d0
	move.b %d0, (5f-function_base-2, %a3)
	lea (0x0F74, %a6), %a0 | THIS MUST CHANGE IF ISIZE CHANGES
5:
	add.w #256, %d0
0:
	lea size_table, %a1
	move.b (%a1, %d0.w), %d1 | size of next instruction
	adda.l %d1, %a0 | where to put the next_instruction
	|lea (EI_SAVE_PTR, %a5), %a1
	addq #6, %a0
	move.w -(%a0), -(%a7)
	move.l -(%a0), -(%a7)
	move.l %a0, -(%a7)
	
	lea next_instruction2, %a1
	move.l (%a1)+, (%a0)+
	move.w (%a1), (%a0)
	rts*/
	
	
	
| assumes a0 is IO base
check_interrupts:
	move.b (IF, %a0), %d0
	and.b (IE, %a0), %d0
	and.b (IME, %a5), %d0
	beq no_interrupt
	moveq #0, %d1
	btst %d1, %d0
	beq no_vblank_intr
	bchg %d1, (IF, %a0)
	moveq #0x40, %d0
	jmp generate_int
no_vblank_intr:
	moveq #1, %d1
	btst %d1, %d0
	beq no_stat_intr
	bchg %d1, (IF, %a0)
	moveq #0x48, %d0
	jmp generate_int
no_stat_intr:
	moveq #2, %d1
	btst %d1, %d0
	beq no_timer_int
	bchg %d1, (IF, %a0)
	moveq #0x50, %d0
	jmp generate_int
no_timer_int:
	moveq #3, %d1
	btst %d1, %d0
	beq no_interrupt
	bchg %d1, (IF, %a0)
	moveq #0x58, %d0
	jmp generate_int
no_interrupt:
	jmp (%a1)

check_interrupts_event:
	move.b (IF, %a0), %d0
	and.b (IE, %a0), %d0
	and.b (IME, %a5), %d0
	beq no_interrupt2
	moveq #0, %d1
	btst %d1, %d0
	beq no_vblank_intr2
	bchg %d1, (IF, %a0)
	moveq #0x40, %d0
	jmp generate_int_event
no_vblank_intr2:
	moveq #1, %d1
	btst %d1, %d0
	beq no_stat_intr2
	bchg %d1, (IF, %a0)
	moveq #0x48, %d0
	jmp generate_int_event
no_stat_intr2:
	moveq #2, %d1
	btst %d1, %d0
	beq no_timer_intr2
	bchg %d1, (IF, %a0)
	moveq #0x50, %d0
	jmp generate_int_event
no_timer_intr2:
	moveq #3, %d1
	btst %d1, %d0
	beq no_interrupt2
	bchg %d1, (IF, %a0)
	moveq #0x58, %d0
	jmp generate_int_event
no_interrupt2:
	END_EVENT end_check_interrupts
end_check_interrupts:

process_input_89:
	move.w #0xffbf, 0x600018
	moveq #24, %d0
0:
	dbra %d0, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	not.b %d0
	beq no_quit_89
	|lea (60, %a7), %a7 | kill 15 regs on the stack
	st (QUIT, %a5)
	jra return
no_quit_89:
	move.w #0xfffd, 0x600018 | select row 1
	move.w #24, %d0
0:
	dbra %d0, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	btst #1, %d0
	beq inc_y_offset
	btst #2, %d0
	beq dec_y_offset
	btst #3, %d0
	bne 0f
	move.b #44, (Y_OFFSET, %a5)
	jra check_interrupts_event	
0:
	btst #4, %d0
	beq zero_y_offset
	jra check_interrupts_event	
process_input_92:
	move.w #0xfeff, 0x600018
	moveq #24, %d0
0:
	dbra %d0, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	btst #6, %d0
	bne no_quit_92
	|lea (60, %a7), %a7 | kill 15 regs on the stack
	st (QUIT, %a5)
	jra return
no_quit_92:
	btst #4, %d0 | check +
	beq inc_y_offset
	move.w #0xfdff, 0x600018 | select row 1
	move.w #24, %d0
0:
	dbra %d0, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	btst #0, %d0 | check -
	beq dec_y_offset
	
	move.w #~(1<<5), 0x600018 | select row 5
	move.w #24, %d0
0:
	dbra %d0, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	btst #0, %d0 | check /
	beq zero_y_offset
	
	move.w #~(1<<7), 0x600018 | select row 7
	move.w #24, %d0
0:
	dbra %d0, 0b | wait
	move.b 0x60001B, %d0 | read keys from port
	btst #7, %d0 | check *
	bne check_interrupts_event
	move.b #16, (Y_OFFSET, %a5)
	jra check_interrupts_event
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
	jra check_interrupts_event
dec_y_offset:
	move.b (Y_OFFSET, %a5), %d0
	beq 0f
	subq.b #4, %d0
	move.b %d0, (Y_OFFSET, %a5)
0:
	jra check_interrupts_event
zero_y_offset:
	clr.b (Y_OFFSET, %a5)
	jra check_interrupts_event

| halt = 0 : cpu operates as normal
| halt = (-1) : cpu is halted
| halt = 1 : cpu will halt once ints are enabled

/*emulate_step:
	movem.l %d2-%d3/%a2-%a3/%a6,-(%a7)
	lea jump_table, %a6

	clr.w %d0
	move.b (%a4)+, %d0
	add.w %d0, %d0
	move.w (%a6, %d0.w), %d0
	jsr (%a3, %d0.w)

	tst.w %d4
	bpl step_done
step_cyclic_events:
	movea.l (NEXT_EVENT, %a5), %a0
	jsr (%a0)
	tst.b (CPU_HALT, %a5)
	beq step_done
	moveq #-1, %d4
	bra step_cyclic_events
step_done:
	movem.l (%a7)+, %d2-%d3/%a2-%a3/%a6
	rts*/
.if GB_DEBUG
.global debugger_entry
debugger_entry:
	tst.w %d4
	bmi cyclic_events
	
	movea.l (ROM_PTR, %a5), %a0
	adda.l #0x26a4, %a0 |843
	
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

.global gb_data_store
gb_data_store:
.long 0
.global hw1_tick
.global hw2_tick
hw1_tick:
	move.w #0x2700, %sr
	addq.w #1, counter
	cmp.w #350, counter
	bne 0f
	clr.w counter
	jmp tick_process
0:
	rte
hw2_tick:
	move.w #0x2700, %sr
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

.global cyclic_events
cyclic_events:
	movea.l (NEXT_EVENT, %a5), %a0
	jmp (%a0)
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
.endif






