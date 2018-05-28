| Assembly Source File
| Created 8/5/2004; 5:06:11 PM

.global emulate_frame
.global emulate_step
.global check_interrupts

.global mode0_func
.global mode1_func
.global mode2_func
.global mode3_func
.global mode1_func_continue
.global mode2_func_off;

.extern _draw_screen
.extern generate_int

.include "gbasm.h"

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
| while LCD is off, LCD will cycle between mode 2, 3, and 0, without changing LY
mode2_func_off:
	movea.l (MEM_TABLE+2040, %a5) ,%a0
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
	|ADD_EVENT #mode3_func
	
	tst.b (CALC_TYPE, %a5)
	beq process_input_89
	bra process_input_92

.global timer_entry_off

mode3_func_off:
	addi.w #41, %d4
	movea.l (MEM_TABLE+2040, %a5) ,%a0
	addq.b #1, (STAT, %a0) | from mode 2 to mode 3
	move.l #mode0_func_off, (NEXT_EVENT, %a5)
	addq.b #1, (DIV, %a0) | For now...
timer_entry_off: |will be patched with BRA (word) by io handler
	nop
	nop
	|ADD_EVENT2 #mode0_func
	END_EVENT end_mode3_func_off
end_mode3_func_off:

mode0_func_off:
	addi.w #53, %d4
	movea.l (MEM_TABLE+2040, %a5) ,%a0
	move.b (STAT, %a0), %d0
	andi.b #0xfc, %d0 | set mode 0
	btst #3, %d0 | check to see if mode0 ints are enabled
	beq no_mode0_int_off
	ori.b #(1<<1), (IF, %a0)
no_mode0_int_off:
	move.b %d0, (STAT, %a0)
	move.l #mode2_func_off, (NEXT_EVENT, %a5)
	|ADD_EVENT #mode2_func_continue
	jra check_interrupts_event


mode2_func:
	movea.l (MEM_TABLE+2040, %a5) ,%a0
	move.b (STAT, %a0), %d0
	moveq #0, %d1
	bra 0f
mode2_func_continue:
	movea.l (MEM_TABLE+2040, %a5) ,%a0
	move.b (STAT, %a0), %d0
	move.b (LY, %a0), %d1
	addq.b #1, %d1
0:
	move.b %d1, (LY, %a0)
	andi #~(1<<2), %d0| clear coincidence flag
	cmp.b (LYC, %a0), %d1
	bne mode2_no_lyc_int
	ori.b #(1<<2), %d0 | set coincidence flag
	btst #6, %d0
	beq mode2_no_lyc_int
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr 
mode2_no_lyc_int:	
	addi.w #20, %d4
	andi.b #0xfc, %d0
	addq.b #0x02, %d0 | set mode 2
	move.b %d0, (STAT, %a0)
	btst #5, %d0 | check to see if mode2 ints are enabled
	beq no_mode2_int
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
no_mode2_int:
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
	|ADD_EVENT #mode3_func
	|jra check_interrupts_event

.global timer_entry
.global timer_func_table

timer_func_table:
	.long timer_func00
	.long timer_func01
	.long timer_func10
	.long timer_func11

mode3_func:
	addi.w #41, %d4
	movea.l (MEM_TABLE+2040, %a5) ,%a0
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
	movea.l (MEM_TABLE+2040, %a5) ,%a0
	move.b (STAT, %a0), %d0
	andi.b #0xfc, %d0 | set mode 0
	btst #3, %d0 | check to see if mode0 ints are enabled
	beq no_mode0_int
	ori.b #(1<<1), (IF, %a0)
no_mode0_int:
	move.b %d0, (STAT, %a0)
	cmpi.b #143, (LY, %a0)
	bne no_vblank
	move.l #mode1_func, (NEXT_EVENT, %a5)
	|ADD_EVENT #mode1_func
	jra check_interrupts_event
no_vblank:
	move.l #mode2_func_continue, (NEXT_EVENT, %a5)
	|ADD_EVENT #mode2_func_continue
	jra check_interrupts_event

mode1_func:
	movea.l (MEM_TABLE+2040, %a5) ,%a0
	move.b (STAT, %a0), %d0
	addq.b #1, %d0 | from mode 0 to mode 1
	btst #4, %d0
	beq no_mode1_int
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
no_mode1_int:
	ori.b #(1<<0), (IF, %a0) | set int for vblank
	bra 0f
mode1_func_continue:
	movea.l (MEM_TABLE+2040, %a5) ,%a0
	move.b (STAT, %a0), %d0
0:
	addi.w #114, %d4
	addq.b #1, (DIV, %a0) | For now...
	andi.b #~(1<<2), %d0 | clear coincidence flag
	move.b (LY, %a0), %d1
	addq.b #1, %d1
	move.b %d1, (LY, %a0)
	cmp.b (LYC, %a0), %d1
	bne mode1_no_lyc_int
	ori.b #(1<<2), %d0 | set coincidence flag
	btst #6, %d0
	beq mode1_no_lyc_int
	ori.b #(1<<1), (IF, %a0) | set flag for LCDC intr
mode1_no_lyc_int:
	move.b %d0, (STAT, %a0) | rewrite value
	cmpi.b #153, %d1
	bne no_ly_overflow
	move.l #mode2_func, (NEXT_EVENT, %a5)
	|ADD_EVENT #mode2_func
	jra check_interrupts_event
no_ly_overflow:
	move.l #mode1_func_continue, (NEXT_EVENT, %a5)
	|ADD_EVENT #mode1_func_continue
	jra check_interrupts_event

.global enable_intr_func
enable_intr_func:
	move.l (SAVE_EVENT_EI, %a5), (NEXT_EVENT, %a5) | put back proper event
	move.w (SAVE_COUNT_EI, %a5), %d0
	add.w %d4, %d0
	move.w %d0, %d4 | restore proper counter
	movea.l (MEM_TABLE+2040, %a5) ,%a0
	bset #31, %d7 | enable interrupts
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
	jbsr check_interrupts
	tst.w %d4
	bmi cyclic_events
	END_EVENT end_enable_intr_func
	|NEXT_INSTRUCTION2 end_enable_intr_func
end_enable_intr_func:
	
| assumes a0 is IO base
check_interrupts:
	btst #31, %d7
	beq no_interrupt
	move.b (IF, %a0), %d0
	and.b (IE, %a0), %d0
	beq no_interrupt
	moveq #0, %d1
	btst %d1, %d0
	beq no_vblank_intr
	bclr %d1, (IF, %a0)
	moveq #0x40, %d2
	jbsr generate_int
	rts
no_vblank_intr:
	addq.b #1, %d1
	btst %d1, %d0
	beq no_stat_intr
	bclr %d1, (IF, %a0)
	moveq #0x48, %d2
	jbsr generate_int
	rts
no_stat_intr:
	addq.b #1, %d1
	btst %d1, %d0
	beq no_timer_int
	bclr %d1, (IF, %a0)
	moveq #0x50, %d2
	jbsr generate_int
	rts
no_timer_int:
	addq.b #1, %d1
	btst %d1, %d0
	beq no_interrupt
	bclr %d1, (IF, %a0)
	moveq #0x58, %d2
	jbsr generate_int
no_interrupt:
	rts

check_interrupts_event:
	btst #31, %d7
	beq no_interrupt2
	move.b (IF, %a0), %d0
	and.b (IE, %a0), %d0
	beq no_interrupt2
	moveq #0, %d1
	btst %d1, %d0
	beq no_vblank_intr2
	bclr %d1, (IF, %a0)
	moveq #0x40, %d2
	jbsr generate_int
	jra no_interrupt2
no_vblank_intr2:
	addq.b #1, %d1
	btst %d1, %d0
	beq no_stat_intr2
	bclr %d1, (IF, %a0)
	moveq #0x48, %d2
	jbsr generate_int
	jra no_interrupt2
no_stat_intr2:
	addq.b #1, %d1
	btst %d1, %d0
	beq no_timer_intr2
	bclr %d1, (IF, %a0)
	moveq #0x50, %d2
	jbsr generate_int
	jra no_interrupt2
no_timer_intr2:
	addq.b #1, %d1
	btst %d1, %d0
	beq no_interrupt2
	bclr %d1, (IF, %a0)
	moveq #0x58, %d2
	jbsr generate_int
no_interrupt2:
	END_EVENT end_check_interrupts
end_check_interrupts:

process_input_89:
	move.w #0xffbf, 0x600018
	moveq #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	not.b %d1
	beq no_quit_89
	|lea (60, %a7), %a7 | kill 15 regs on the stack
	st (QUIT, %a5)
	jra return
no_quit_89:
	move.w #0xfffd, 0x600018 | select row 1
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #1, %d1
	beq inc_y_offset
	btst #2, %d1
	beq dec_y_offset
	btst #3, %d1
	bne 0f
	move.b #44, (Y_OFFSET, %a5)
	jra check_interrupts_event	
0:
	btst #4, %d1
	beq zero_y_offset
	jra check_interrupts_event	
process_input_92:
	move.w #0xfeff, 0x600018
	moveq #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #6, %d1
	bne no_quit_92
	|lea (60, %a7), %a7 | kill 15 regs on the stack
	st (QUIT, %a5)
	jra return
no_quit_92:
	btst #4, %d1 | check +
	beq inc_y_offset
	move.w #0xfdff, 0x600018 | select row 1
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #0, %d1 | check -
	beq dec_y_offset
	
	move.w #~(1<<5), 0x600018 | select row 5
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #0, %d1 | check /
	beq zero_y_offset
	
	move.w #~(1<<7), 0x600018 | select row 7
	move.w #24, %d1
0:
	dbra %d1, 0b | wait
	move.b 0x60001B, %d1 | read keys from port
	btst #7, %d1 | check *
	bne check_interrupts_event
	move.b #16, (Y_OFFSET, %a5)
	jra check_interrupts_event
inc_y_offset:
	move.b (Y_OFFSET, %a5), %d1
	moveq #16, %d2
	tst.b (CALC_TYPE, %a5) | determine max y_offset based on calc model
	bne 0f
	moveq #44, %d2
0:
	cmp.b %d2, %d1
	beq 0f
	addq.b #4, %d1
	move.b %d1, (Y_OFFSET, %a5)
	jra check_interrupts_event
dec_y_offset:
	move.b (Y_OFFSET, %a5), %d1
	beq 0f
	subq.b #4, %d1
	move.b %d1, (Y_OFFSET, %a5)
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
.global debugger_entry
debugger_entry:
	movea.l (ROM_PTR, %a5), %a0
	adda.l #0x1B3, %a0
	|movea.l (GB_RAM, %a5), %a0
	|adda.l #0x4189, %a0
	|adda.l #(6 * 0x2000 + 0x19), %a0
	cmpa.l %a0, %a4
	beq break
	tst.b (BREAKPOINT, %a5)
	bne break
0:
	rts
break:
	|cmp.b #3, %d5
	|bne 0b
	| don't break in the middle of a 16 bit special write
	move.l (NEXT_EVENT, %a5), %a0
	cmpa.l #write16_finish, %a0
	beq 0b
	/*move.l (NEXT_EVENT, %a5), %a0
	cmpa.l #write16_stack_finish, %a0
	beq 0b
	move.l (NEXT_EVENT, %a5), %a0
	cmpa.l #write16_stack_return, %a0
	beq 0b*/
	
	|add.b #1, (BREAK_COUNTER, %a5)
	|cmp.b #2, (BREAK_COUNTER, %a5)
	|bne 0b

	st (BREAKPOINT, %a5)
	lea (4, %a7), %a7 | kill return on stack
	jra return

emulate_step:
	movem.l %d2-%d3/%a3/%a6,-(%a7)

	movea.l (opcode_block), %a6
	adda.l #0x8000, %a6
	move.b (HW_VERSION, %a5), %d0
	cmp.b #2, %d0 | skip ghost space if not HW2
	bne 0f
	adda.l #0x40000, %a6
0:
	move.b (%a4)+, (emulate_step_end-2)
	jmp (0x0F00.w, %a6)
emulate_step_end:

emulate_frame:
	movem.l %d2-%d3/%a3/%a6,-(%a7)

	movea.l (opcode_block), %a6
	adda.l #0x8000, %a6
	move.b (HW_VERSION, %a5), %d0
	cmp.b #2, %d0 | skip ghost space if not HW2
	bne 0f
	adda.l #0x40000, %a6
0:
	move.l #mode2_func, (NEXT_EVENT, %a5)
	|move.l #timer0_func, (QUEUE_EVENT, %a5)
	|move.w #246, (QUEUE_COUNT, %a5)
	moveq #50, %d4

	moveq #LCDC, %d0
	move #~0x91, %d2
	movea.l (MEM_TABLE+2040, %a5), %a0
	move.b %d2, (%a0, %d0.w)
	not.b %d2
	jra io_write

.global cyclic_events
cyclic_events:
	movea.l (NEXT_EVENT, %a5), %a0
	jmp (%a0)
return:
	movem.l (%a7)+, %d2-%d3/%a3/%a6
	rts

.global calculate_half_carry
calculate_half_carry: | puts half carry flag in bit 5 of %d2
	move.w (LAST_SRC, %a5), %d0
	move.w (LAST_DST, %a5), %d1
	move.w #0x0f00, %d3
	btst #6, %d7
	sne %d3
/*	beq 0f
	move.w #0x0fff, %d3 | 16 bit add
	bra 1f
0:
	move.w #0x0f00, %d3 | 8 bit operation
1:*/
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
	rts

