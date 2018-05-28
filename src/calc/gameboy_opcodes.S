.global jump_table
.global opcode_table
.global jump_table2
.global suffix_table
.global size_table
.global cycles_table
.global event_table
.global generate_int
.global generate_int_event

.include "gbasm.h"

.data
opcode_start:
opcode0040:
opcode0040_end: | LD B, B
opcode0048:
	move.l %d2, %d0
	swap %d0
	move.b %d0, %d2
opcode0048_end: | LD C, B
opcode0050:
	move.l %d2, %d0
	move.b %d3, %d0
	move.l %d0, %d3
opcode0050_end: | LD D, B
opcode0058:
	swap %d2
	move.b %d2, %d3
	swap %d2
opcode0058_end: | LD E, B
opcode0060:
	move.l %d2, %d0
	move.b %d7, %d0
	move.l %d0, %d7
opcode0060_end: | LD H, B
opcode0068:
	swap %d2
	move.b %d2, %d7
	swap %d2
opcode0068_end: | LD L, B
opcode0070:
	moveq #0, %d0
	move.b %d7, %d0
	move.l %d2, %d1
	swap %d1
	swap %d7
	move.b %d7, (6f - opcode0070 + 2 + (28860), %a6)
	swap %d7
6:
	jmp (0x7f00, %a6)
opcode0070_end: | LD (HL), B
opcode0078:
	swap %d2
	move.b %d2, %d5
	swap %d2
opcode0078_end: | LD A, B
opcode0041:
	move.b %d2, %d0
	swap %d2
	move.b %d0, %d2
opcode0041_end: | LD B, C
opcode0049:
opcode0049_end: | LD C, C
opcode0051:
	swap %d3
	move.b %d2, %d3
	swap %d3
opcode0051_end: | LD D, C
opcode0059:
	move.b %d2, %d3
opcode0059_end: | LD E, C
opcode0061:
	swap %d7
	move.b %d2, %d7
	swap %d7
opcode0061_end: | LD H, C
opcode0069:
	move.b %d2, %d7
opcode0069_end: | LD L, C
opcode0071:
	moveq #0, %d0
	move.b %d7, %d0
	move.b %d2, %d1
	swap %d7
	move.b %d7, (6f - opcode0071 + 2 + (29116), %a6)
	swap %d7
6:
	jmp (0x7f00, %a6)
opcode0071_end: | LD (HL), C
opcode0079:
	move.b %d2, %d5
opcode0079_end: | LD A, C
opcode0042:
	move.l %d3, %d0
	move.b %d2, %d0
	move.l %d0, %d2
opcode0042_end: | LD B, D
opcode004A:
	swap %d3
	move.b %d3, %d2
	swap %d3
opcode004A_end: | LD C, D
opcode0052:
opcode0052_end: | LD D, D
opcode005A:
	move.l %d3, %d0
	swap %d0
	move.b %d0, %d3
opcode005A_end: | LD E, D
opcode0062:
	move.l %d3, %d0
	move.b %d7, %d0
	move.l %d0, %d7
opcode0062_end: | LD H, D
opcode006A:
	swap %d3
	move.b %d3, %d7
	swap %d3
opcode006A_end: | LD L, D
opcode0072:
	moveq #0, %d0
	move.b %d7, %d0
	move.l %d3, %d1
	swap %d1
	swap %d7
	move.b %d7, (6f - opcode0072 + 2 + (29372), %a6)
	swap %d7
6:
	jmp (0x7f00, %a6)
opcode0072_end: | LD (HL), D
opcode007A:
	swap %d3
	move.b %d3, %d5
	swap %d3
opcode007A_end: | LD A, D
opcode0043:
	swap %d2
	move.b %d3, %d2
	swap %d2
opcode0043_end: | LD B, E
opcode004B:
	move.b %d3, %d2
opcode004B_end: | LD C, E
opcode0053:
	move.b %d3, %d0
	swap %d3
	move.b %d0, %d3
opcode0053_end: | LD D, E
opcode005B:
opcode005B_end: | LD E, E
opcode0063:
	swap %d7
	move.b %d3, %d7
	swap %d7
opcode0063_end: | LD H, E
opcode006B:
	move.b %d3, %d7
opcode006B_end: | LD L, E
opcode0073:
	moveq #0, %d0
	move.b %d7, %d0
	move.b %d3, %d1
	swap %d7
	move.b %d7, (6f - opcode0073 + 2 + (29628), %a6)
	swap %d7
6:
	jmp (0x7f00, %a6)
opcode0073_end: | LD (HL), E
opcode007B:
	move.b %d3, %d5
opcode007B_end: | LD A, E
opcode0044:
	move.l %d7, %d0
	move.b %d2, %d0
	move.l %d0, %d2
opcode0044_end: | LD B, H
opcode004C:
	swap %d7
	move.b %d7, %d2
	swap %d7
opcode004C_end: | LD C, H
opcode0054:
	move.l %d7, %d0
	move.b %d3, %d0
	move.l %d0, %d3
opcode0054_end: | LD D, H
opcode005C:
	swap %d7
	move.b %d7, %d3
	swap %d7
opcode005C_end: | LD E, H
opcode0064:
opcode0064_end: | LD H, H
opcode006C:
	move.l %d7, %d0
	swap %d0
	move.b %d0, %d7
opcode006C_end: | LD L, H
opcode0074:
	moveq #0, %d0
	move.b %d7, %d0
	move.l %d7, %d1
	swap %d1
	swap %d7
	move.b %d7, (6f - opcode0074 + 2 + (29884), %a6)
	swap %d7
6:
	jmp (0x7f00, %a6)
opcode0074_end: | LD (HL), H
opcode007C:
	swap %d7
	move.b %d7, %d5
	swap %d7
opcode007C_end: | LD A, H
opcode0045:
	swap %d2
	move.b %d7, %d2
	swap %d2
opcode0045_end: | LD B, L
opcode004D:
	move.b %d7, %d2
opcode004D_end: | LD C, L
opcode0055:
	swap %d3
	move.b %d7, %d3
	swap %d3
opcode0055_end: | LD D, L
opcode005D:
	move.b %d7, %d3
opcode005D_end: | LD E, L
opcode0065:
	move.b %d7, %d0
	swap %d7
	move.b %d0, %d7
opcode0065_end: | LD H, L
opcode006D:
opcode006D_end: | LD L, L
opcode0075:
	moveq #0, %d0
	move.b %d7, %d0
	move.b %d7, %d1
	swap %d7
	move.b %d7, (6f - opcode0075 + 2 + (30140), %a6)
	swap %d7
6:
	jmp (0x7f00, %a6)
opcode0075_end: | LD (HL), L
opcode007D:
	move.b %d7, %d5
opcode007D_end: | LD A, L
opcode0046:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode0046 + 2 + (18108), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	swap %d2
	move.b (%a0, %d0.w), %d2
	swap %d2
opcode0046_end: | LD B, (HL)
opcode004E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode004E + 2 + (20156), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	move.b (%a0, %d0.w), %d2
opcode004E_end: | LD C, (HL)
opcode0056:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode0056 + 2 + (22204), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	swap %d3
	move.b (%a0, %d0.w), %d3
	swap %d3
opcode0056_end: | LD D, (HL)
opcode005E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode005E + 2 + (24252), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	move.b (%a0, %d0.w), %d3
opcode005E_end: | LD E, (HL)
opcode0066:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode0066 + 2 + (26300), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	swap %d7
	move.b (%a0, %d0.w), %d7
	swap %d7
opcode0066_end: | LD H, (HL)
opcode006E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode006E + 2 + (28348), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	move.b (%a0, %d0.w), %d7
opcode006E_end: | LD L, (HL)
opcode007E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode007E + 2 + (32444), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	move.b (%a0, %d0.w), %d5
opcode007E_end: | LD A, (HL)
opcode0047:
	swap %d2
	move.b %d5, %d2
	swap %d2
opcode0047_end: | LD B, A
opcode004F:
	move.b %d5, %d2
opcode004F_end: | LD C, A
opcode0057:
	swap %d3
	move.b %d5, %d3
	swap %d3
opcode0057_end: | LD D, A
opcode005F:
	move.b %d5, %d3
opcode005F_end: | LD E, A
opcode0067:
	swap %d7
	move.b %d5, %d7
	swap %d7
opcode0067_end: | LD H, A
opcode006F:
	move.b %d5, %d7
opcode006F_end: | LD L, A
opcode0077:
	moveq #0, %d0
	move.b %d7, %d0
	move.b %d5, %d1
	swap %d7
	move.b %d7, (6f - opcode0077 + 2 + (30652), %a6)
	swap %d7
6:
	jmp (0x7f00, %a6)
opcode0077_end: | LD (HL), A
opcode007F:
opcode007F_end: | LD A, A
opcode0006:
	swap %d2
	move.b (%a4)+, %d2
	swap %d2
opcode0006_end: | LD B, nn
opcode000E:
	move.b (%a4)+, %d2
opcode000E_end: | LD C, nn
opcode0016:
	swap %d3
	move.b (%a4)+, %d3
	swap %d3
opcode0016_end: | LD D, nn
opcode001E:
	move.b (%a4)+, %d3
opcode001E_end: | LD E, nn
opcode0026:
	swap %d7
	move.b (%a4)+, %d7
	swap %d7
opcode0026_end: | LD H, nn
opcode002E:
	move.b (%a4)+, %d7
opcode002E_end: | LD L, nn
opcode0036:
	moveq #0, %d0
	move.b %d7, %d0
	move.b (%a4)+, %d1
	swap %d7
	move.b %d7, (6f - opcode0036 + 2 + (14012), %a6)
	swap %d7
6:
	jmp (0x7f00, %a6)
opcode0036_end: | LD (HL), nn
opcode003E:
	move.b (%a4)+, %d5
opcode003E_end: | LD A, nn
opcode000A:
	moveq #0, %d0
	move.b %d2, %d0
	swap %d2
	move.b %d2, (6f - opcode000A + 2 + (2748), %a6)
	swap %d2
6:
	movea.l (0x7f02, %a6), %a0
	move.b (%a0, %d0.w), %d5
opcode000A_end: | LD A, (BC)
opcode001A:
	moveq #0, %d0
	move.b %d3, %d0
	swap %d3
	move.b %d3, (6f - opcode001A + 2 + (6844), %a6)
	swap %d3
6:
	movea.l (0x7f02, %a6), %a0
	move.b (%a0, %d0.w), %d5
opcode001A_end: | LD A, (DE)
opcode0002:
	moveq #0, %d0
	move.b %d2, %d0
	move.b %d5, %d1
	swap %d2
	move.b %d2, (6f - opcode0002 + 2 + (700), %a6)
	swap %d2
6:
	jmp (0x7f00, %a6)
opcode0002_end: | LD (BC), A
opcode0012:
	moveq #0, %d0
	move.b %d3, %d0
	move.b %d5, %d1
	swap %d3
	move.b %d3, (6f - opcode0012 + 2 + (4796), %a6)
	swap %d3
6:
	jmp (0x7f00, %a6)
opcode0012_end: | LD (DE), A
opcode0022:
	moveq #0, %d0
	move.b %d7, %d0
	move.b %d5, %d1
	swap %d7
	move.b %d7, (6f - opcode0022 + 2 + (8892), %a6)
	swap %d7
	ext.w %d7
	addq.l #1, %d7
6:
	jmp (0x7f00, %a6)
opcode0022_end: | LD (HL)+, A
opcode002A:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode002A + 2 + (10940), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	ext.w %d7
	addq.l #1, %d7
	move.b (%a0, %d0.w), %d5
opcode002A_end: | LD A, (HL)+
opcode0032:
	moveq #0, %d0
	move.b %d7, %d0
	move.b %d5, %d1
	swap %d7
	move.b %d7, (6f - opcode0032 + 2 + (12988), %a6)
	swap %d7
	ext.w %d7
	subq.l #1, %d7
6:
	jmp (0x7f00, %a6)
opcode0032_end: | LD (HL)-, A
opcode003A:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode003A + 2 + (15036), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	ext.w %d7
	subq.l #1, %d7
	move.b (%a0, %d0.w), %d5
opcode003A_end: | LD A, (HL)-
opcode00E0:
	moveq #0, %d0
	move.b (%a4)+, %d0
	movea.l (-1*256+2, %a6), %a0
	move.b %d5, %d1
	move.b %d0, (6f - opcode00E0 + 2 + (-8004), %a6)
6:
	jmp (0x7f42, %a6)
opcode00E0_end: | LD (FF00+nn), A
opcode00E2:
	moveq #0, %d0
	move.b %d2, %d0
	movea.l (-1*256+2, %a6), %a0
	move.b %d5, %d1
	move.b %d0, (6f - opcode00E2 + 2 + (-7492), %a6)
6:
	jmp (0x7f42, %a6)
opcode00E2_end: | LD (FF00+C), A
opcode00F0:
	moveq #0, %d0
	move.b (%a4)+, %d0
	movea.l (-1*256+2, %a6), %a0
	move.b (%a0, %d0.w), %d5
opcode00F0_end: | LD A, (FF00+nn)
opcode00F2:
	moveq #0, %d0
	move.b %d2, %d0
	movea.l (-1*256+2, %a6), %a0
	move.b (%a0, %d0.w), %d5
opcode00F2_end: | LD A, (FF00+C)
opcode00FA:
	moveq #0, %d0
	move.b (%a4)+, %d0
	move.b (%a4)+, (6f - opcode00FA + 2 + (-1348), %a6)
6:
	movea.l (0x7f02, %a6), %a0
	move.b (%a0, %d0.w), %d5
opcode00FA_end: | LD A, (nnnn)
opcode00EA:
	moveq #0, %d0
	move.b (%a4)+, %d0
	move.b %d5, %d1
	move.b (%a4)+, (6f - opcode00EA + 2 + (-5444), %a6)
6:
	jmp (0x7f00, %a6)
opcode00EA_end: | LD (nnnn), A
opcode0001:
	move.b (%a4)+, %d2
	swap %d2
	move.b (%a4)+, %d2
	swap %d2
opcode0001_end: | LD BC, nnnn
opcode0011:
	move.b (%a4)+, %d3
	swap %d3
	move.b (%a4)+, %d3
	swap %d3
opcode0011_end: | LD DE, nnnn
opcode0021:
	move.b (%a4)+, %d7
	swap %d7
	move.b (%a4)+, %d7
	swap %d7
opcode0021_end: | LD HL, nnnn
opcode0031:
	| new_SP_immd():
	moveq #0, %d0
	move.b (%a4)+, %d0
	move.b (%a4)+, %d1
	cmp.b #0xE0, %d1 | Hack for games with stack at top of RAM
	bne 0f
	subq.b #1, %d1
	move.w #0x100, %d0
0:
	move.b %d1, (SP_BASE, %a5)
	move.b %d1, (6f - opcode0031 + 2 + (12732), %a6)
6:
	movea.l (0x7f02, %a6), %a2
	adda.l %d0, %a2
opcode0031_end: | LD SP, nnnn
opcode00F9:
	| new_SP():
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (SP_BASE, %a5)
	move.b %d7, (6f - opcode00F9 + 2 + (-1604), %a6)
6:
	movea.l (0x7f02, %a6), %a2
	adda.l %d0, %a2
	swap %d7
opcode00F9_end: | LD SP, HL
opcode00C5:
	move.l %d2, %d0
	swap %d0
	move.b %d0, -(%a2)
	move.b %d2, -(%a2)
opcode00C5_end: | PUSH BC
opcode00D5:
	move.l %d3, %d0
	swap %d0
	move.b %d0, -(%a2)
	move.b %d3, -(%a2)
opcode00D5_end: | PUSH DE
opcode00E5:
	move.l %d7, %d0
	swap %d0
	move.b %d0, -(%a2)
	move.b %d7, -(%a2)
opcode00E5_end: | PUSH HL
opcode00F5:
	moveq #0, %d0
	btst #0, %d6
	beq 0f
	ori.b #0x10, %d0 | set gb carry
0:
	btst #2, %d6
	beq 0f
	ori.b #0x80, %d0 | set gb zero
0:
	move.b %d5, -(%a2)
	move.b %d0, -(%a2)
opcode00F5_end: | PUSH AF
opcode00C1:
	move.b (%a2)+, %d2
	swap %d2
	move.b (%a2)+, %d2
	swap %d2
opcode00C1_end: | POP BC
opcode00D1:
	move.b (%a2)+, %d3
	swap %d3
	move.b (%a2)+, %d3
	swap %d3
opcode00D1_end: | POP DE
opcode00E1:
	move.b (%a2)+, %d7
	swap %d7
	move.b (%a2)+, %d7
	swap %d7
opcode00E1_end: | POP HL
opcode00F1:
	move.b (%a2)+, %d0 | restore flags
	move.b (%a2)+, %d5
	moveq #0, %d6
	btst #7, %d0
	beq 0f
	ori #0x04, %d6 | set zero
0:
	btst #4, %d0
	beq 0f
	ori.b #0x01, %d6 | set carry
0:
opcode00F1_end: | POP AF
opcode0008:
	move.l %a2, %d1
	move.b (SP_BASE, %a5), (6f - opcode0008 + 2 + (2236), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | sp now relative to block
	add.l (SP_BLOCK, %a5), %d1 | sp is now correct
	moveq #0, %d0
	move.b (%a4)+, %d0
	move.b (%a4)+, (6f - opcode0008 + 2 + (2236), %a6)
6:
	movea.l (0x7f02, %a6), %a0
	move.b %d1, (%a0, %d0.w)
	rol.w #8, %d1
	move.b %d1, (1, %a0, %d0.w)
opcode0008_end: | LD (nnnn), SP
opcode00F8:
	move.l %a2, %d1
	move.b (SP_BASE, %a5), (6f - opcode00F8 + 2 + (-1860), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | sp now relative to block
	add.l (SP_BLOCK, %a5), %d1 | sp is now correct
	move.b (%a4)+, %d0
	ext.w %d0
	clr.w %d6
	add.w %d0, %d1
	addx.w %d6, %d6 | update carry, clear zero
	move.b %d1, %d7
	swap %d7
	rol.w #8, %d1
	move.b %d1, %d7
	swap %d7
opcode00F8_end: | LD HL, SP+nn
opcode0080:
	swap %d2
	move.b %d5, %d6
	swap %d6
	add.b %d2, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcode0080_end: | ADD A, B
opcode0081:
	move.b %d5, %d6
	swap %d6
	add.b %d2, %d5
	move.w %sr, %d6 | update zero, carry
opcode0081_end: | ADD A, C
opcode0082:
	swap %d3
	move.b %d5, %d6
	swap %d6
	add.b %d3, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcode0082_end: | ADD A, D
opcode0083:
	move.b %d5, %d6
	swap %d6
	add.b %d3, %d5
	move.w %sr, %d6 | update zero, carry
opcode0083_end: | ADD A, E
opcode0084:
	swap %d7
	move.b %d5, %d6
	swap %d6
	add.b %d7, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcode0084_end: | ADD A, H
opcode0085:
	move.b %d5, %d6
	swap %d6
	add.b %d7, %d5
	move.w %sr, %d6 | update zero, carry
opcode0085_end: | ADD A, L
opcode0086:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode0086 + 2 + (-31044), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	move.b %d5, %d6
	swap %d6
	add.b (%a0, %d0.w), %d5
	move.w %sr, %d6 | update zero, carry
opcode0086_end: | ADD A, (HL)
opcode0087:
	move.b %d5, %d6
	swap %d6
	add.b %d5, %d5
	move.w %sr, %d6 | update zero, carry
opcode0087_end: | ADD A, A
opcode00C6:
	move.b %d5, %d6
	swap %d6
	add.b (%a4)+, %d5
	move.w %sr, %d6 | update zero, carry
opcode00C6_end: | ADD A, nn
opcode0088:
	swap %d2
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | addx doesn't set zero flag, only clears it
	addx.b %d2, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcode0088_end: | ADC A, B
opcode0089:
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | addx doesn't set zero flag, only clears it
	addx.b %d2, %d5
	move.w %sr, %d6 | update zero, carry
opcode0089_end: | ADC A, C
opcode008A:
	swap %d3
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | addx doesn't set zero flag, only clears it
	addx.b %d3, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcode008A_end: | ADC A, D
opcode008B:
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | addx doesn't set zero flag, only clears it
	addx.b %d3, %d5
	move.w %sr, %d6 | update zero, carry
opcode008B_end: | ADC A, E
opcode008C:
	swap %d7
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | addx doesn't set zero flag, only clears it
	addx.b %d7, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcode008C_end: | ADC A, H
opcode008D:
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | addx doesn't set zero flag, only clears it
	addx.b %d7, %d5
	move.w %sr, %d6 | update zero, carry
opcode008D_end: | ADC A, L
opcode008E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode008E + 2 + (-28996), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	move.b (%a0, %d0.w), %d0
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | addx doesn't set zero flag, only clears it
	addx.b %d0, %d5
	move.w %sr, %d6 | update zero, carry
opcode008E_end: | ADC A, (HL)
opcode008F:
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | addx doesn't set zero flag, only clears it
	addx.b %d5, %d5
	move.w %sr, %d6 | update zero, carry
opcode008F_end: | ADC A, A
opcode00CE:
	move.b (%a4)+, %d0
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | addx doesn't set zero flag, only clears it
	addx.b %d0, %d5
	move.w %sr, %d6 | update zero, carry
opcode00CE_end: | ADC A, nn
opcode0090:
	swap %d2
	move.b %d5, %d6
	swap %d6
	sub.b %d2, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcode0090_end: | SUB A, B
opcode0091:
	move.b %d5, %d6
	swap %d6
	sub.b %d2, %d5
	move.w %sr, %d6 | update zero, carry
opcode0091_end: | SUB A, C
opcode0092:
	swap %d3
	move.b %d5, %d6
	swap %d6
	sub.b %d3, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcode0092_end: | SUB A, D
opcode0093:
	move.b %d5, %d6
	swap %d6
	sub.b %d3, %d5
	move.w %sr, %d6 | update zero, carry
opcode0093_end: | SUB A, E
opcode0094:
	swap %d7
	move.b %d5, %d6
	swap %d6
	sub.b %d7, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcode0094_end: | SUB A, H
opcode0095:
	move.b %d5, %d6
	swap %d6
	sub.b %d7, %d5
	move.w %sr, %d6 | update zero, carry
opcode0095_end: | SUB A, L
opcode0096:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode0096 + 2 + (-26948), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	move.b %d5, %d6
	swap %d6
	sub.b (%a0, %d0.w), %d5
	move.w %sr, %d6 | update zero, carry
opcode0096_end: | SUB A, (HL)
opcode0097:
	move.b %d5, %d6
	swap %d6
	sub.b %d5, %d5
	move.w %sr, %d6 | update zero, carry
opcode0097_end: | SUB A, A
opcode00D6:
	move.b %d5, %d6
	swap %d6
	sub.b (%a4)+, %d5
	move.w %sr, %d6 | update zero, carry
opcode00D6_end: | SUB A, nn
opcode0098:
	swap %d2
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | subx doesn't set zero flag, only clears it
	subx.b %d2, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcode0098_end: | SBC A, B
opcode0099:
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | subx doesn't set zero flag, only clears it
	subx.b %d2, %d5
	move.w %sr, %d6 | update zero, carry
opcode0099_end: | SBC A, C
opcode009A:
	swap %d3
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | subx doesn't set zero flag, only clears it
	subx.b %d3, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcode009A_end: | SBC A, D
opcode009B:
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | subx doesn't set zero flag, only clears it
	subx.b %d3, %d5
	move.w %sr, %d6 | update zero, carry
opcode009B_end: | SBC A, E
opcode009C:
	swap %d7
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | subx doesn't set zero flag, only clears it
	subx.b %d7, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcode009C_end: | SBC A, H
opcode009D:
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | subx doesn't set zero flag, only clears it
	subx.b %d7, %d5
	move.w %sr, %d6 | update zero, carry
opcode009D_end: | SBC A, L
opcode009E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode009E + 2 + (-24900), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	move.b (%a0, %d0.w), %d0
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | subx doesn't set zero flag, only clears it
	subx.b %d0, %d5
	move.w %sr, %d6 | update zero, carry
opcode009E_end: | SBC A, (HL)
opcode009F:
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | subx doesn't set zero flag, only clears it
	subx.b %d5, %d5
	move.w %sr, %d6 | update zero, carry
opcode009F_end: | SBC A, A
opcode00DE:
	move.b (%a4)+, %d0
	lsr.b #1, %d6 | copy carry to extend
	move.b %d5, %d6
	swap %d6
	eor.b %d1, %d1 | subx doesn't set zero flag, only clears it
	subx.b %d0, %d5
	move.w %sr, %d6 | update zero, carry
opcode00DE_end: | SBC A, nn
opcode00A0:
	swap %d2
	clr.w %d6
	and.b %d2, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d2
opcode00A0_end: | AND A, B
opcode00A1:
	clr.w %d6
	and.b %d2, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00A1_end: | AND A, C
opcode00A2:
	swap %d3
	clr.w %d6
	and.b %d3, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d3
opcode00A2_end: | AND A, D
opcode00A3:
	clr.w %d6
	and.b %d3, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00A3_end: | AND A, E
opcode00A4:
	swap %d7
	clr.w %d6
	and.b %d7, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d7
opcode00A4_end: | AND A, H
opcode00A5:
	clr.w %d6
	and.b %d7, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00A5_end: | AND A, L
opcode00A6:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode00A6 + 2 + (-22852), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	clr.w %d6
	and.b (%a0, %d0.w), %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00A6_end: | AND A, (HL)
opcode00A7:
	clr.w %d6
	and.b %d5, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00A7_end: | AND A, A
opcode00E6:
	clr.w %d6
	and.b (%a4)+, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00E6_end: | AND A, nn
opcode00B0:
	swap %d2
	clr.w %d6
	or.b %d2, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d2
opcode00B0_end: | OR A, B
opcode00B1:
	clr.w %d6
	or.b %d2, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00B1_end: | OR A, C
opcode00B2:
	swap %d3
	clr.w %d6
	or.b %d3, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d3
opcode00B2_end: | OR A, D
opcode00B3:
	clr.w %d6
	or.b %d3, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00B3_end: | OR A, E
opcode00B4:
	swap %d7
	clr.w %d6
	or.b %d7, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d7
opcode00B4_end: | OR A, H
opcode00B5:
	clr.w %d6
	or.b %d7, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00B5_end: | OR A, L
opcode00B6:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode00B6 + 2 + (-18756), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	clr.w %d6
	or.b (%a0, %d0.w), %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00B6_end: | OR A, (HL)
opcode00B7:
	clr.w %d6
	or.b %d5, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00B7_end: | OR A, A
opcode00F6:
	clr.w %d6
	or.b (%a4)+, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00F6_end: | OR A, nn
opcode00A8:
	swap %d2
	clr.w %d6
	eor.b %d2, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d2
opcode00A8_end: | XOR A, B
opcode00A9:
	clr.w %d6
	eor.b %d2, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00A9_end: | XOR A, C
opcode00AA:
	swap %d3
	clr.w %d6
	eor.b %d3, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d3
opcode00AA_end: | XOR A, D
opcode00AB:
	clr.w %d6
	eor.b %d3, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00AB_end: | XOR A, E
opcode00AC:
	swap %d7
	clr.w %d6
	eor.b %d7, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d7
opcode00AC_end: | XOR A, H
opcode00AD:
	clr.w %d6
	eor.b %d7, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00AD_end: | XOR A, L
opcode00AE:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode00AE + 2 + (-20804), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	move.b (%a0, %d0.w), %d0
	clr.w %d6
	eor.b %d0, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00AE_end: | XOR A, (HL)
opcode00AF:
	clr.b %d5
	move.w %sr, %d6 | update zero, carry
opcode00AF_end: | XOR A, A
opcode00EE:
	move.b (%a4)+, %d0
	clr.w %d6
	eor.b %d0, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcode00EE_end: | XOR A, nn
opcode00B8:
	swap %d2
	cmp.b %d2, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcode00B8_end: | CP A, B
opcode00B9:
	cmp.b %d2, %d5
	move.w %sr, %d6 | update zero, carry
opcode00B9_end: | CP A, C
opcode00BA:
	swap %d3
	cmp.b %d3, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcode00BA_end: | CP A, D
opcode00BB:
	cmp.b %d3, %d5
	move.w %sr, %d6 | update zero, carry
opcode00BB_end: | CP A, E
opcode00BC:
	swap %d7
	cmp.b %d7, %d5
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcode00BC_end: | CP A, H
opcode00BD:
	cmp.b %d7, %d5
	move.w %sr, %d6 | update zero, carry
opcode00BD_end: | CP A, L
opcode00BE:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode00BE + 2 + (-16708), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	cmp.b (%a0, %d0.w), %d5
	move.w %sr, %d6 | update zero, carry
opcode00BE_end: | CP A, (HL)
opcode00BF:
	cmp.b %d5, %d5
	move.w %sr, %d6 | update zero, carry
opcode00BF_end: | CP A, A
opcode00FE:
	cmp.b (%a4)+, %d5
	move.w %sr, %d6 | update zero, carry
opcode00FE_end: | CP A, nn
opcode0004:
	swap %d2
	or.b #0x04, %d6
	addq.b #1, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
	swap %d2
opcode0004_end: | INC B
opcode000C:
	or.b #0x04, %d6
	addq.b #1, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcode000C_end: | INC C
opcode0014:
	swap %d3
	or.b #0x04, %d6
	addq.b #1, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
	swap %d3
opcode0014_end: | INC D
opcode001C:
	or.b #0x04, %d6
	addq.b #1, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcode001C_end: | INC E
opcode0024:
	swap %d7
	or.b #0x04, %d6
	addq.b #1, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
	swap %d7
opcode0024_end: | INC H
opcode002C:
	or.b #0x04, %d6
	addq.b #1, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcode002C_end: | INC L
opcode0034:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode0034 + 2 + (13500), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	or.b #0x04, %d6
	addq.b #1, %d1
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
	jmp (%a1)
opcode0034_end: | INC (HL)
opcode003C:
	or.b #0x04, %d6
	addq.b #1, %d5
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcode003C_end: | INC A
opcode0005:
	swap %d2
	or.b #0x04, %d6
	subq.b #1, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
	swap %d2
opcode0005_end: | DEC B
opcode000D:
	or.b #0x04, %d6
	subq.b #1, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcode000D_end: | DEC C
opcode0015:
	swap %d3
	or.b #0x04, %d6
	subq.b #1, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
	swap %d3
opcode0015_end: | DEC D
opcode001D:
	or.b #0x04, %d6
	subq.b #1, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcode001D_end: | DEC E
opcode0025:
	swap %d7
	or.b #0x04, %d6
	subq.b #1, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
	swap %d7
opcode0025_end: | DEC H
opcode002D:
	or.b #0x04, %d6
	subq.b #1, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcode002D_end: | DEC L
opcode0035:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcode0035 + 2 + (13756), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	or.b #0x04, %d6
	subq.b #1, %d1
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
	jmp (%a1)
opcode0035_end: | DEC (HL)
opcode003D:
	or.b #0x04, %d6
	subq.b #1, %d5
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcode003D_end: | DEC A
opcode002F:
	not.b %d5
opcode002F_end: | CPL
opcode003F:
	eori.b #0x01, %d6
opcode003F_end: | CCF
opcode0037:
	ori.b #0x01, %d6
opcode0037_end: | SCF
opcode00F3:
	clr.b (IME, %a5)
opcode00F3_end: | DI
opcode00FB:
	jmp (ei_function-function_base, %a3)
opcode00FB_end: | EI
opcode0009:
	add.b %d2, %d7
	swap %d2
	swap %d7
	or.b #0x01, %d6
	addx.b %d2, %d7
	bcs 0f
	eor.b #0x01, %d6 | update carry
0:
	swap %d2
	swap %d7
opcode0009_end: | ADD HL, BC
opcode0019:
	add.b %d3, %d7
	swap %d3
	swap %d7
	or.b #0x01, %d6
	addx.b %d3, %d7
	bcs 0f
	eor.b #0x01, %d6 | update carry
0:
	swap %d3
	swap %d7
opcode0019_end: | ADD HL, DE
opcode0029:
	add.b %d7, %d7
	swap %d7
	or.b #0x01, %d6
	addx.b %d7, %d7
	bcs 0f
	eor.b #0x01, %d6 | update carry
0:
	swap %d7
opcode0029_end: | ADD HL, HL
opcode0039:
	move.l %a2, %d0
	move.b (SP_BASE, %a5), (6f - opcode0039 + 2 + (14780), %a6)
6:
	sub.l (0x7f02, %a6), %d0 | sp now relative to block
	add.l (SP_BLOCK, %a5), %d0 | sp is now correct
	add.b %d0, %d7
	swap %d7
	rol.w #8, %d0
	or.b #0x01, %d6
	addx.b %d0, %d7
	bcs 0f
	eor.b #0x01, %d6 | update carry
0:
	swap %d7
opcode0039_end: | ADD HL, SP
opcode00E8:
	move.b (%a4)+, %d0
	ext.w %d0
	adda.l %d0, %a2
opcode00E8_end: | ADD SP, nn
opcode0003:
	ext.w %d2
	addq.l #1, %d2
opcode0003_end: | INC BC
opcode0013:
	ext.w %d3
	addq.l #1, %d3
opcode0013_end: | INC DE
opcode0023:
	ext.w %d7
	addq.l #1, %d7
opcode0023_end: | INC HL
opcode0033:
	addq.l #1, %a2
opcode0033_end: | INC SP
opcode000B:
	ext.w %d2
	subq.l #1, %d2
opcode000B_end: | DEC BC
opcode001B:
	ext.w %d3
	subq.l #1, %d3
opcode001B_end: | DEC DE
opcode002B:
	ext.w %d7
	subq.l #1, %d7
opcode002B_end: | DEC HL
opcode003B:
	subq.l #1, %a2
opcode003B_end: | DEC SP
opcode0007:
	clr.w %d6
	rol.b #1, %d5
	bcc 0f
	ori.b #0x01, %d6 | update carry, clear zero
0:
opcode0007_end: | RLCA
opcode0017:
	lsr.b #1, %d6 | copy carry to extend
	clr.w %d6
	roxl.b #1, %d5
	addx.w %d6, %d6 | update carry, clear zero
opcode0017_end: | RLA
opcode000F:
	clr.w %d6
	ror.b #1, %d5
	bcc 0f
	ori.b #0x01, %d6 | update carry, clear zero
0:
opcode000F_end: | RRCA
opcode001F:
	lsr.b #1, %d6 | copy carry to extend
	clr.w %d6
	roxr.b #1, %d5
	addx.w %d6, %d6 | update carry, clear zero
opcode001F_end: | RRA
opcodeCB00:
	swap %d2
	rol.b #1, %d2
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcodeCB00_end: | RLC B
opcodeCB01:
	rol.b #1, %d2
	move.w %sr, %d6 | update zero, carry
opcodeCB01_end: | RLC C
opcodeCB02:
	swap %d3
	rol.b #1, %d3
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcodeCB02_end: | RLC D
opcodeCB03:
	rol.b #1, %d3
	move.w %sr, %d6 | update zero, carry
opcodeCB03_end: | RLC E
opcodeCB04:
	swap %d7
	rol.b #1, %d7
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcodeCB04_end: | RLC H
opcodeCB05:
	rol.b #1, %d7
	move.w %sr, %d6 | update zero, carry
opcodeCB05_end: | RLC L
opcodeCB06:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB06 + 2 + (1664), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	rol.b #1, %d1
	move.w %sr, %d6 | update zero, carry
	jmp (%a1)
opcodeCB06_end: | RLC (HL)
opcodeCB07:
	rol.b #1, %d5
	move.w %sr, %d6 | update zero, carry
opcodeCB07_end: | RLC A
opcodeCB10:
	swap %d2
	lsr.b #1, %d6 | copy carry to extend
	roxl.b #1, %d2
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcodeCB10_end: | RL B
opcodeCB11:
	lsr.b #1, %d6 | copy carry to extend
	roxl.b #1, %d2
	move.w %sr, %d6 | update zero, carry
opcodeCB11_end: | RL C
opcodeCB12:
	swap %d3
	lsr.b #1, %d6 | copy carry to extend
	roxl.b #1, %d3
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcodeCB12_end: | RL D
opcodeCB13:
	lsr.b #1, %d6 | copy carry to extend
	roxl.b #1, %d3
	move.w %sr, %d6 | update zero, carry
opcodeCB13_end: | RL E
opcodeCB14:
	swap %d7
	lsr.b #1, %d6 | copy carry to extend
	roxl.b #1, %d7
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcodeCB14_end: | RL H
opcodeCB15:
	lsr.b #1, %d6 | copy carry to extend
	roxl.b #1, %d7
	move.w %sr, %d6 | update zero, carry
opcodeCB15_end: | RL L
opcodeCB16:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB16 + 2 + (5760), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	lsr.b #1, %d6 | copy carry to extend
	roxl.b #1, %d1
	move.w %sr, %d6 | update zero, carry
	jmp (%a1)
opcodeCB16_end: | RL (HL)
opcodeCB17:
	lsr.b #1, %d6 | copy carry to extend
	roxl.b #1, %d5
	move.w %sr, %d6 | update zero, carry
opcodeCB17_end: | RL A
opcodeCB08:
	swap %d2
	ror.b #1, %d2
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcodeCB08_end: | RRC B
opcodeCB09:
	ror.b #1, %d2
	move.w %sr, %d6 | update zero, carry
opcodeCB09_end: | RRC C
opcodeCB0A:
	swap %d3
	ror.b #1, %d3
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcodeCB0A_end: | RRC D
opcodeCB0B:
	ror.b #1, %d3
	move.w %sr, %d6 | update zero, carry
opcodeCB0B_end: | RRC E
opcodeCB0C:
	swap %d7
	ror.b #1, %d7
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcodeCB0C_end: | RRC H
opcodeCB0D:
	ror.b #1, %d7
	move.w %sr, %d6 | update zero, carry
opcodeCB0D_end: | RRC L
opcodeCB0E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB0E + 2 + (3712), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	ror.b #1, %d1
	move.w %sr, %d6 | update zero, carry
	jmp (%a1)
opcodeCB0E_end: | RRC (HL)
opcodeCB0F:
	ror.b #1, %d5
	move.w %sr, %d6 | update zero, carry
opcodeCB0F_end: | RRC A
opcodeCB18:
	swap %d2
	lsr.b #1, %d6 | copy carry to extend
	roxr.b #1, %d2
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcodeCB18_end: | RR B
opcodeCB19:
	lsr.b #1, %d6 | copy carry to extend
	roxr.b #1, %d2
	move.w %sr, %d6 | update zero, carry
opcodeCB19_end: | RR C
opcodeCB1A:
	swap %d3
	lsr.b #1, %d6 | copy carry to extend
	roxr.b #1, %d3
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcodeCB1A_end: | RR D
opcodeCB1B:
	lsr.b #1, %d6 | copy carry to extend
	roxr.b #1, %d3
	move.w %sr, %d6 | update zero, carry
opcodeCB1B_end: | RR E
opcodeCB1C:
	swap %d7
	lsr.b #1, %d6 | copy carry to extend
	roxr.b #1, %d7
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcodeCB1C_end: | RR H
opcodeCB1D:
	lsr.b #1, %d6 | copy carry to extend
	roxr.b #1, %d7
	move.w %sr, %d6 | update zero, carry
opcodeCB1D_end: | RR L
opcodeCB1E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB1E + 2 + (7808), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	lsr.b #1, %d6 | copy carry to extend
	roxr.b #1, %d1
	move.w %sr, %d6 | update zero, carry
	jmp (%a1)
opcodeCB1E_end: | RR (HL)
opcodeCB1F:
	lsr.b #1, %d6 | copy carry to extend
	roxr.b #1, %d5
	move.w %sr, %d6 | update zero, carry
opcodeCB1F_end: | RR A
opcodeCB20:
	swap %d2
	asl.b #1, %d2
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcodeCB20_end: | SLA B
opcodeCB21:
	asl.b #1, %d2
	move.w %sr, %d6 | update zero, carry
opcodeCB21_end: | SLA C
opcodeCB22:
	swap %d3
	asl.b #1, %d3
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcodeCB22_end: | SLA D
opcodeCB23:
	asl.b #1, %d3
	move.w %sr, %d6 | update zero, carry
opcodeCB23_end: | SLA E
opcodeCB24:
	swap %d7
	asl.b #1, %d7
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcodeCB24_end: | SLA H
opcodeCB25:
	asl.b #1, %d7
	move.w %sr, %d6 | update zero, carry
opcodeCB25_end: | SLA L
opcodeCB26:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB26 + 2 + (9856), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	asl.b #1, %d1
	move.w %sr, %d6 | update zero, carry
	jmp (%a1)
opcodeCB26_end: | SLA (HL)
opcodeCB27:
	asl.b #1, %d5
	move.w %sr, %d6 | update zero, carry
opcodeCB27_end: | SLA A
opcodeCB28:
	swap %d2
	asr.b #1, %d2
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcodeCB28_end: | SRA B
opcodeCB29:
	asr.b #1, %d2
	move.w %sr, %d6 | update zero, carry
opcodeCB29_end: | SRA C
opcodeCB2A:
	swap %d3
	asr.b #1, %d3
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcodeCB2A_end: | SRA D
opcodeCB2B:
	asr.b #1, %d3
	move.w %sr, %d6 | update zero, carry
opcodeCB2B_end: | SRA E
opcodeCB2C:
	swap %d7
	asr.b #1, %d7
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcodeCB2C_end: | SRA H
opcodeCB2D:
	asr.b #1, %d7
	move.w %sr, %d6 | update zero, carry
opcodeCB2D_end: | SRA L
opcodeCB2E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB2E + 2 + (11904), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	asr.b #1, %d1
	move.w %sr, %d6 | update zero, carry
	jmp (%a1)
opcodeCB2E_end: | SRA (HL)
opcodeCB2F:
	asr.b #1, %d5
	move.w %sr, %d6 | update zero, carry
opcodeCB2F_end: | SRA A
opcodeCB38:
	swap %d2
	lsr.b #1, %d2
	move.w %sr, %d6 | update zero, carry
	swap %d2
opcodeCB38_end: | SRL B
opcodeCB39:
	lsr.b #1, %d2
	move.w %sr, %d6 | update zero, carry
opcodeCB39_end: | SRL C
opcodeCB3A:
	swap %d3
	lsr.b #1, %d3
	move.w %sr, %d6 | update zero, carry
	swap %d3
opcodeCB3A_end: | SRL D
opcodeCB3B:
	lsr.b #1, %d3
	move.w %sr, %d6 | update zero, carry
opcodeCB3B_end: | SRL E
opcodeCB3C:
	swap %d7
	lsr.b #1, %d7
	move.w %sr, %d6 | update zero, carry
	swap %d7
opcodeCB3C_end: | SRL H
opcodeCB3D:
	lsr.b #1, %d7
	move.w %sr, %d6 | update zero, carry
opcodeCB3D_end: | SRL L
opcodeCB3E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB3E + 2 + (16000), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	lsr.b #1, %d1
	move.w %sr, %d6 | update zero, carry
	jmp (%a1)
opcodeCB3E_end: | SRL (HL)
opcodeCB3F:
	lsr.b #1, %d5
	move.w %sr, %d6 | update zero, carry
opcodeCB3F_end: | SRL A
opcodeCB40:
	or.b #0x04, %d6
	btst #16, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB40_end: | BIT B, 0
opcodeCB41:
	or.b #0x04, %d6
	btst.b #0, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB41_end: | BIT C, 0
opcodeCB42:
	or.b #0x04, %d6
	btst #16, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB42_end: | BIT D, 0
opcodeCB43:
	or.b #0x04, %d6
	btst.b #0, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB43_end: | BIT E, 0
opcodeCB44:
	or.b #0x04, %d6
	btst #16, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB44_end: | BIT H, 0
opcodeCB45:
	or.b #0x04, %d6
	btst.b #0, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB45_end: | BIT L, 0
opcodeCB46:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB46 + 2 + (18048), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	or.b #0x04, %d6
	btst.b #0, (%a0, %d0.w)
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB46_end: | BIT (HL), 0
opcodeCB47:
	or.b #0x04, %d6
	btst.b #0, %d5
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB47_end: | BIT A, 0
opcodeCB48:
	or.b #0x04, %d6
	btst #17, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB48_end: | BIT B, 1
opcodeCB49:
	or.b #0x04, %d6
	btst.b #1, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB49_end: | BIT C, 1
opcodeCB4A:
	or.b #0x04, %d6
	btst #17, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB4A_end: | BIT D, 1
opcodeCB4B:
	or.b #0x04, %d6
	btst.b #1, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB4B_end: | BIT E, 1
opcodeCB4C:
	or.b #0x04, %d6
	btst #17, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB4C_end: | BIT H, 1
opcodeCB4D:
	or.b #0x04, %d6
	btst.b #1, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB4D_end: | BIT L, 1
opcodeCB4E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB4E + 2 + (20096), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	or.b #0x04, %d6
	btst.b #1, (%a0, %d0.w)
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB4E_end: | BIT (HL), 1
opcodeCB4F:
	or.b #0x04, %d6
	btst.b #1, %d5
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB4F_end: | BIT A, 1
opcodeCB50:
	or.b #0x04, %d6
	btst #18, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB50_end: | BIT B, 2
opcodeCB51:
	or.b #0x04, %d6
	btst.b #2, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB51_end: | BIT C, 2
opcodeCB52:
	or.b #0x04, %d6
	btst #18, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB52_end: | BIT D, 2
opcodeCB53:
	or.b #0x04, %d6
	btst.b #2, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB53_end: | BIT E, 2
opcodeCB54:
	or.b #0x04, %d6
	btst #18, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB54_end: | BIT H, 2
opcodeCB55:
	or.b #0x04, %d6
	btst.b #2, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB55_end: | BIT L, 2
opcodeCB56:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB56 + 2 + (22144), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	or.b #0x04, %d6
	btst.b #2, (%a0, %d0.w)
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB56_end: | BIT (HL), 2
opcodeCB57:
	or.b #0x04, %d6
	btst.b #2, %d5
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB57_end: | BIT A, 2
opcodeCB58:
	or.b #0x04, %d6
	btst #19, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB58_end: | BIT B, 3
opcodeCB59:
	or.b #0x04, %d6
	btst.b #3, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB59_end: | BIT C, 3
opcodeCB5A:
	or.b #0x04, %d6
	btst #19, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB5A_end: | BIT D, 3
opcodeCB5B:
	or.b #0x04, %d6
	btst.b #3, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB5B_end: | BIT E, 3
opcodeCB5C:
	or.b #0x04, %d6
	btst #19, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB5C_end: | BIT H, 3
opcodeCB5D:
	or.b #0x04, %d6
	btst.b #3, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB5D_end: | BIT L, 3
opcodeCB5E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB5E + 2 + (24192), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	or.b #0x04, %d6
	btst.b #3, (%a0, %d0.w)
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB5E_end: | BIT (HL), 3
opcodeCB5F:
	or.b #0x04, %d6
	btst.b #3, %d5
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB5F_end: | BIT A, 3
opcodeCB60:
	or.b #0x04, %d6
	btst #20, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB60_end: | BIT B, 4
opcodeCB61:
	or.b #0x04, %d6
	btst.b #4, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB61_end: | BIT C, 4
opcodeCB62:
	or.b #0x04, %d6
	btst #20, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB62_end: | BIT D, 4
opcodeCB63:
	or.b #0x04, %d6
	btst.b #4, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB63_end: | BIT E, 4
opcodeCB64:
	or.b #0x04, %d6
	btst #20, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB64_end: | BIT H, 4
opcodeCB65:
	or.b #0x04, %d6
	btst.b #4, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB65_end: | BIT L, 4
opcodeCB66:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB66 + 2 + (26240), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	or.b #0x04, %d6
	btst.b #4, (%a0, %d0.w)
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB66_end: | BIT (HL), 4
opcodeCB67:
	or.b #0x04, %d6
	btst.b #4, %d5
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB67_end: | BIT A, 4
opcodeCB68:
	or.b #0x04, %d6
	btst #21, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB68_end: | BIT B, 5
opcodeCB69:
	or.b #0x04, %d6
	btst.b #5, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB69_end: | BIT C, 5
opcodeCB6A:
	or.b #0x04, %d6
	btst #21, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB6A_end: | BIT D, 5
opcodeCB6B:
	or.b #0x04, %d6
	btst.b #5, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB6B_end: | BIT E, 5
opcodeCB6C:
	or.b #0x04, %d6
	btst #21, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB6C_end: | BIT H, 5
opcodeCB6D:
	or.b #0x04, %d6
	btst.b #5, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB6D_end: | BIT L, 5
opcodeCB6E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB6E + 2 + (28288), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	or.b #0x04, %d6
	btst.b #5, (%a0, %d0.w)
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB6E_end: | BIT (HL), 5
opcodeCB6F:
	or.b #0x04, %d6
	btst.b #5, %d5
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB6F_end: | BIT A, 5
opcodeCB70:
	or.b #0x04, %d6
	btst #22, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB70_end: | BIT B, 6
opcodeCB71:
	or.b #0x04, %d6
	btst.b #6, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB71_end: | BIT C, 6
opcodeCB72:
	or.b #0x04, %d6
	btst #22, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB72_end: | BIT D, 6
opcodeCB73:
	or.b #0x04, %d6
	btst.b #6, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB73_end: | BIT E, 6
opcodeCB74:
	or.b #0x04, %d6
	btst #22, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB74_end: | BIT H, 6
opcodeCB75:
	or.b #0x04, %d6
	btst.b #6, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB75_end: | BIT L, 6
opcodeCB76:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB76 + 2 + (30336), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	or.b #0x04, %d6
	btst.b #6, (%a0, %d0.w)
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB76_end: | BIT (HL), 6
opcodeCB77:
	or.b #0x04, %d6
	btst.b #6, %d5
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB77_end: | BIT A, 6
opcodeCB78:
	or.b #0x04, %d6
	btst #23, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB78_end: | BIT B, 7
opcodeCB79:
	or.b #0x04, %d6
	btst.b #7, %d2
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB79_end: | BIT C, 7
opcodeCB7A:
	or.b #0x04, %d6
	btst #23, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB7A_end: | BIT D, 7
opcodeCB7B:
	or.b #0x04, %d6
	btst.b #7, %d3
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB7B_end: | BIT E, 7
opcodeCB7C:
	or.b #0x04, %d6
	btst #23, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB7C_end: | BIT H, 7
opcodeCB7D:
	or.b #0x04, %d6
	btst.b #7, %d7
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB7D_end: | BIT L, 7
opcodeCB7E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB7E + 2 + (32384), %a6)
	swap %d7
6:
	movea.l (0x7f02, %a6), %a0
	or.b #0x04, %d6
	btst.b #7, (%a0, %d0.w)
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB7E_end: | BIT (HL), 7
opcodeCB7F:
	or.b #0x04, %d6
	btst.b #7, %d5
	beq 0f
	eor.b #0x04, %d6 | update zero
0:
opcodeCB7F_end: | BIT A, 7
opcodeCBC0:
	bset #16, %d2
opcodeCBC0_end: | SET B, 0
opcodeCBC1:
	ori.b #0x01, %d2
opcodeCBC1_end: | SET C, 0
opcodeCBC2:
	bset #16, %d3
opcodeCBC2_end: | SET D, 0
opcodeCBC3:
	ori.b #0x01, %d3
opcodeCBC3_end: | SET E, 0
opcodeCBC4:
	bset #16, %d7
opcodeCBC4_end: | SET H, 0
opcodeCBC5:
	ori.b #0x01, %d7
opcodeCBC5_end: | SET L, 0
opcodeCBC6:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBC6 + 2 + (-14720), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	ori.b #0x01, %d1
	jmp (%a1)
opcodeCBC6_end: | SET (HL), 0
opcodeCBC7:
	ori.b #0x01, %d5
opcodeCBC7_end: | SET A, 0
opcodeCBC8:
	bset #17, %d2
opcodeCBC8_end: | SET B, 1
opcodeCBC9:
	ori.b #0x02, %d2
opcodeCBC9_end: | SET C, 1
opcodeCBCA:
	bset #17, %d3
opcodeCBCA_end: | SET D, 1
opcodeCBCB:
	ori.b #0x02, %d3
opcodeCBCB_end: | SET E, 1
opcodeCBCC:
	bset #17, %d7
opcodeCBCC_end: | SET H, 1
opcodeCBCD:
	ori.b #0x02, %d7
opcodeCBCD_end: | SET L, 1
opcodeCBCE:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBCE + 2 + (-12672), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	ori.b #0x02, %d1
	jmp (%a1)
opcodeCBCE_end: | SET (HL), 1
opcodeCBCF:
	ori.b #0x02, %d5
opcodeCBCF_end: | SET A, 1
opcodeCBD0:
	bset #18, %d2
opcodeCBD0_end: | SET B, 2
opcodeCBD1:
	ori.b #0x04, %d2
opcodeCBD1_end: | SET C, 2
opcodeCBD2:
	bset #18, %d3
opcodeCBD2_end: | SET D, 2
opcodeCBD3:
	ori.b #0x04, %d3
opcodeCBD3_end: | SET E, 2
opcodeCBD4:
	bset #18, %d7
opcodeCBD4_end: | SET H, 2
opcodeCBD5:
	ori.b #0x04, %d7
opcodeCBD5_end: | SET L, 2
opcodeCBD6:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBD6 + 2 + (-10624), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	ori.b #0x04, %d1
	jmp (%a1)
opcodeCBD6_end: | SET (HL), 2
opcodeCBD7:
	ori.b #0x04, %d5
opcodeCBD7_end: | SET A, 2
opcodeCBD8:
	bset #19, %d2
opcodeCBD8_end: | SET B, 3
opcodeCBD9:
	ori.b #0x08, %d2
opcodeCBD9_end: | SET C, 3
opcodeCBDA:
	bset #19, %d3
opcodeCBDA_end: | SET D, 3
opcodeCBDB:
	ori.b #0x08, %d3
opcodeCBDB_end: | SET E, 3
opcodeCBDC:
	bset #19, %d7
opcodeCBDC_end: | SET H, 3
opcodeCBDD:
	ori.b #0x08, %d7
opcodeCBDD_end: | SET L, 3
opcodeCBDE:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBDE + 2 + (-8576), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	ori.b #0x08, %d1
	jmp (%a1)
opcodeCBDE_end: | SET (HL), 3
opcodeCBDF:
	ori.b #0x08, %d5
opcodeCBDF_end: | SET A, 3
opcodeCBE0:
	bset #20, %d2
opcodeCBE0_end: | SET B, 4
opcodeCBE1:
	ori.b #0x10, %d2
opcodeCBE1_end: | SET C, 4
opcodeCBE2:
	bset #20, %d3
opcodeCBE2_end: | SET D, 4
opcodeCBE3:
	ori.b #0x10, %d3
opcodeCBE3_end: | SET E, 4
opcodeCBE4:
	bset #20, %d7
opcodeCBE4_end: | SET H, 4
opcodeCBE5:
	ori.b #0x10, %d7
opcodeCBE5_end: | SET L, 4
opcodeCBE6:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBE6 + 2 + (-6528), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	ori.b #0x10, %d1
	jmp (%a1)
opcodeCBE6_end: | SET (HL), 4
opcodeCBE7:
	ori.b #0x10, %d5
opcodeCBE7_end: | SET A, 4
opcodeCBE8:
	bset #21, %d2
opcodeCBE8_end: | SET B, 5
opcodeCBE9:
	ori.b #0x20, %d2
opcodeCBE9_end: | SET C, 5
opcodeCBEA:
	bset #21, %d3
opcodeCBEA_end: | SET D, 5
opcodeCBEB:
	ori.b #0x20, %d3
opcodeCBEB_end: | SET E, 5
opcodeCBEC:
	bset #21, %d7
opcodeCBEC_end: | SET H, 5
opcodeCBED:
	ori.b #0x20, %d7
opcodeCBED_end: | SET L, 5
opcodeCBEE:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBEE + 2 + (-4480), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	ori.b #0x20, %d1
	jmp (%a1)
opcodeCBEE_end: | SET (HL), 5
opcodeCBEF:
	ori.b #0x20, %d5
opcodeCBEF_end: | SET A, 5
opcodeCBF0:
	bset #22, %d2
opcodeCBF0_end: | SET B, 6
opcodeCBF1:
	ori.b #0x40, %d2
opcodeCBF1_end: | SET C, 6
opcodeCBF2:
	bset #22, %d3
opcodeCBF2_end: | SET D, 6
opcodeCBF3:
	ori.b #0x40, %d3
opcodeCBF3_end: | SET E, 6
opcodeCBF4:
	bset #22, %d7
opcodeCBF4_end: | SET H, 6
opcodeCBF5:
	ori.b #0x40, %d7
opcodeCBF5_end: | SET L, 6
opcodeCBF6:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBF6 + 2 + (-2432), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	ori.b #0x40, %d1
	jmp (%a1)
opcodeCBF6_end: | SET (HL), 6
opcodeCBF7:
	ori.b #0x40, %d5
opcodeCBF7_end: | SET A, 6
opcodeCBF8:
	bset #23, %d2
opcodeCBF8_end: | SET B, 7
opcodeCBF9:
	ori.b #0x80, %d2
opcodeCBF9_end: | SET C, 7
opcodeCBFA:
	bset #23, %d3
opcodeCBFA_end: | SET D, 7
opcodeCBFB:
	ori.b #0x80, %d3
opcodeCBFB_end: | SET E, 7
opcodeCBFC:
	bset #23, %d7
opcodeCBFC_end: | SET H, 7
opcodeCBFD:
	ori.b #0x80, %d7
opcodeCBFD_end: | SET L, 7
opcodeCBFE:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBFE + 2 + (-384), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	ori.b #0x80, %d1
	jmp (%a1)
opcodeCBFE_end: | SET (HL), 7
opcodeCBFF:
	ori.b #0x80, %d5
opcodeCBFF_end: | SET A, 7
opcodeCB80:
	bclr #16, %d2
opcodeCB80_end: | RES B, 0
opcodeCB81:
	andi.b #0xFE, %d2
opcodeCB81_end: | RES C, 0
opcodeCB82:
	bclr #16, %d3
opcodeCB82_end: | RES D, 0
opcodeCB83:
	andi.b #0xFE, %d3
opcodeCB83_end: | RES E, 0
opcodeCB84:
	bclr #16, %d7
opcodeCB84_end: | RES H, 0
opcodeCB85:
	andi.b #0xFE, %d7
opcodeCB85_end: | RES L, 0
opcodeCB86:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB86 + 2 + (-31104), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	andi.b #0xFE, %d1
	jmp (%a1)
opcodeCB86_end: | RES (HL), 0
opcodeCB87:
	andi.b #0xFE, %d5
opcodeCB87_end: | RES A, 0
opcodeCB88:
	bclr #17, %d2
opcodeCB88_end: | RES B, 1
opcodeCB89:
	andi.b #0xFD, %d2
opcodeCB89_end: | RES C, 1
opcodeCB8A:
	bclr #17, %d3
opcodeCB8A_end: | RES D, 1
opcodeCB8B:
	andi.b #0xFD, %d3
opcodeCB8B_end: | RES E, 1
opcodeCB8C:
	bclr #17, %d7
opcodeCB8C_end: | RES H, 1
opcodeCB8D:
	andi.b #0xFD, %d7
opcodeCB8D_end: | RES L, 1
opcodeCB8E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB8E + 2 + (-29056), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	andi.b #0xFD, %d1
	jmp (%a1)
opcodeCB8E_end: | RES (HL), 1
opcodeCB8F:
	andi.b #0xFD, %d5
opcodeCB8F_end: | RES A, 1
opcodeCB90:
	bclr #18, %d2
opcodeCB90_end: | RES B, 2
opcodeCB91:
	andi.b #0xFB, %d2
opcodeCB91_end: | RES C, 2
opcodeCB92:
	bclr #18, %d3
opcodeCB92_end: | RES D, 2
opcodeCB93:
	andi.b #0xFB, %d3
opcodeCB93_end: | RES E, 2
opcodeCB94:
	bclr #18, %d7
opcodeCB94_end: | RES H, 2
opcodeCB95:
	andi.b #0xFB, %d7
opcodeCB95_end: | RES L, 2
opcodeCB96:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB96 + 2 + (-27008), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	andi.b #0xFB, %d1
	jmp (%a1)
opcodeCB96_end: | RES (HL), 2
opcodeCB97:
	andi.b #0xFB, %d5
opcodeCB97_end: | RES A, 2
opcodeCB98:
	bclr #19, %d2
opcodeCB98_end: | RES B, 3
opcodeCB99:
	andi.b #0xF7, %d2
opcodeCB99_end: | RES C, 3
opcodeCB9A:
	bclr #19, %d3
opcodeCB9A_end: | RES D, 3
opcodeCB9B:
	andi.b #0xF7, %d3
opcodeCB9B_end: | RES E, 3
opcodeCB9C:
	bclr #19, %d7
opcodeCB9C_end: | RES H, 3
opcodeCB9D:
	andi.b #0xF7, %d7
opcodeCB9D_end: | RES L, 3
opcodeCB9E:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB9E + 2 + (-24960), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	andi.b #0xF7, %d1
	jmp (%a1)
opcodeCB9E_end: | RES (HL), 3
opcodeCB9F:
	andi.b #0xF7, %d5
opcodeCB9F_end: | RES A, 3
opcodeCBA0:
	bclr #20, %d2
opcodeCBA0_end: | RES B, 4
opcodeCBA1:
	andi.b #0xEF, %d2
opcodeCBA1_end: | RES C, 4
opcodeCBA2:
	bclr #20, %d3
opcodeCBA2_end: | RES D, 4
opcodeCBA3:
	andi.b #0xEF, %d3
opcodeCBA3_end: | RES E, 4
opcodeCBA4:
	bclr #20, %d7
opcodeCBA4_end: | RES H, 4
opcodeCBA5:
	andi.b #0xEF, %d7
opcodeCBA5_end: | RES L, 4
opcodeCBA6:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBA6 + 2 + (-22912), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	andi.b #0xEF, %d1
	jmp (%a1)
opcodeCBA6_end: | RES (HL), 4
opcodeCBA7:
	andi.b #0xEF, %d5
opcodeCBA7_end: | RES A, 4
opcodeCBA8:
	bclr #21, %d2
opcodeCBA8_end: | RES B, 5
opcodeCBA9:
	andi.b #0xDF, %d2
opcodeCBA9_end: | RES C, 5
opcodeCBAA:
	bclr #21, %d3
opcodeCBAA_end: | RES D, 5
opcodeCBAB:
	andi.b #0xDF, %d3
opcodeCBAB_end: | RES E, 5
opcodeCBAC:
	bclr #21, %d7
opcodeCBAC_end: | RES H, 5
opcodeCBAD:
	andi.b #0xDF, %d7
opcodeCBAD_end: | RES L, 5
opcodeCBAE:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBAE + 2 + (-20864), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	andi.b #0xDF, %d1
	jmp (%a1)
opcodeCBAE_end: | RES (HL), 5
opcodeCBAF:
	andi.b #0xDF, %d5
opcodeCBAF_end: | RES A, 5
opcodeCBB0:
	bclr #22, %d2
opcodeCBB0_end: | RES B, 6
opcodeCBB1:
	andi.b #0xBF, %d2
opcodeCBB1_end: | RES C, 6
opcodeCBB2:
	bclr #22, %d3
opcodeCBB2_end: | RES D, 6
opcodeCBB3:
	andi.b #0xBF, %d3
opcodeCBB3_end: | RES E, 6
opcodeCBB4:
	bclr #22, %d7
opcodeCBB4_end: | RES H, 6
opcodeCBB5:
	andi.b #0xBF, %d7
opcodeCBB5_end: | RES L, 6
opcodeCBB6:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBB6 + 2 + (-18816), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	andi.b #0xBF, %d1
	jmp (%a1)
opcodeCBB6_end: | RES (HL), 6
opcodeCBB7:
	andi.b #0xBF, %d5
opcodeCBB7_end: | RES A, 6
opcodeCBB8:
	bclr #23, %d2
opcodeCBB8_end: | RES B, 7
opcodeCBB9:
	andi.b #0x7F, %d2
opcodeCBB9_end: | RES C, 7
opcodeCBBA:
	bclr #23, %d3
opcodeCBBA_end: | RES D, 7
opcodeCBBB:
	andi.b #0x7F, %d3
opcodeCBBB_end: | RES E, 7
opcodeCBBC:
	bclr #23, %d7
opcodeCBBC_end: | RES H, 7
opcodeCBBD:
	andi.b #0x7F, %d7
opcodeCBBD_end: | RES L, 7
opcodeCBBE:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCBBE + 2 + (-16768), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	andi.b #0x7F, %d1
	jmp (%a1)
opcodeCBBE_end: | RES (HL), 7
opcodeCBBF:
	andi.b #0x7F, %d5
opcodeCBBF_end: | RES A, 7
opcodeCB30:
	swap %d2
	clr.w %d6
	rol.b #4, %d2
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d2
opcodeCB30_end: | SWAP B
opcodeCB31:
	clr.w %d6
	rol.b #4, %d2
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcodeCB31_end: | SWAP C
opcodeCB32:
	swap %d3
	clr.w %d6
	rol.b #4, %d3
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d3
opcodeCB32_end: | SWAP D
opcodeCB33:
	clr.w %d6
	rol.b #4, %d3
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcodeCB33_end: | SWAP E
opcodeCB34:
	swap %d7
	clr.w %d6
	rol.b #4, %d7
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	swap %d7
opcodeCB34_end: | SWAP H
opcodeCB35:
	clr.w %d6
	rol.b #4, %d7
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcodeCB35_end: | SWAP L
opcodeCB36:
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (6f - opcodeCB36 + 2 + (13952), %a6)
	swap %d7
6:
	lea (0x7f02, %a6), %a1
	move.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	clr.w %d6
	rol.b #4, %d1
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
	jmp (%a1)
opcodeCB36_end: | SWAP (HL)
opcodeCB37:
	clr.w %d6
	rol.b #4, %d5
	bne 0f
	ori.b #0x04, %d6 | update zero, clear carry
0:
opcodeCB37_end: | SWAP A
opcode00C3:
	| new_PC_immd():
	moveq #0, %d0
	move.b (%a4)+, %d0
	move.b (%a4), %d1
	move.b %d1, (PC_BASE, %a5)
	move.b %d1, (6f - opcode00C3 + 2 + (-15430), %a6)
6:
	movea.l (0x7f02, %a6), %a4
	adda.l %d0, %a4
opcode00C3_end: | JP nnnn
opcode00E9:
	| new_PC_HL():
	moveq #0, %d0
	move.b %d7, %d0
	swap %d7
	move.b %d7, (PC_BASE, %a5)
	move.b %d7, (6f - opcode00E9 + 2 + (-5702), %a6)
6:
	movea.l (0x7f02, %a6), %a4
	adda.l %d0, %a4
	swap %d7
opcode00E9_end: | JP HL
opcode00C2:
	btst #2, %d6
5:
	beq opcode00C2 - 5b + (254)
	addq.l #2, %a4
opcode00C2_end: | JP NZ, nnnn
opcode00CA:
	btst #2, %d6
5:
	bne opcode00CA - 5b + (-1794)
	addq.l #2, %a4
opcode00CA_end: | JP Z, nnnn
opcode00D2:
	btst #0, %d6
5:
	beq opcode00D2 - 5b + (-3842)
	addq.l #2, %a4
opcode00D2_end: | JP NC, nnnn
opcode00DA:
	btst #0, %d6
5:
	bne opcode00DA - 5b + (-5890)
	addq.l #2, %a4
opcode00DA_end: | JP C, nnnn
opcode0018:
	move.b (%a4)+, %d1
	ext.w %d1
	adda.w %d1, %a4
opcode0018_end: | JR nn
opcode0020:
	btst #2, %d6
5:
	beq opcode0020 - 5b + (-2050)
	addq.l #1, %a4
opcode0020_end: | JR NZ, nn
opcode0028:
	btst #2, %d6
5:
	bne opcode0028 - 5b + (-4098)
	addq.l #1, %a4
opcode0028_end: | JR Z, nn
opcode0030:
	btst #0, %d6
5:
	beq opcode0030 - 5b + (-6146)
	addq.l #1, %a4
opcode0030_end: | JR NC, nn
opcode0038:
	btst #0, %d6
5:
	bne opcode0038 - 5b + (-8194)
	addq.l #1, %a4
opcode0038_end: | JR C, nn
opcode00CD:
	addq.l #2, %a4
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f - opcode00CD + 2 + (-12870), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	| new_PC_immd():
	moveq #0, %d0
	move.b -(%a4), %d1
	move.b -(%a4), %d0
	move.b %d1, (PC_BASE, %a5)
	move.b %d1, (6f - opcode00CD + 2 + (-12870), %a6)
6:
	movea.l (0x7f02, %a6), %a4
	adda.l %d0, %a4
opcode00CD_end: | CALL nnnn
opcode00C4:
	addq.l #2, %a4
	btst #2, %d6
5:
	beq opcode00C4 - 5b + (2304)
opcode00C4_end: | CALL NZ, nnnn
opcode00CC:
	addq.l #2, %a4
	btst #2, %d6
5:
	bne opcode00CC - 5b + (256)
opcode00CC_end: | CALL Z, nnnn
opcode00D4:
	addq.l #2, %a4
	btst #0, %d6
5:
	beq opcode00D4 - 5b + (-1792)
opcode00D4_end: | CALL NC, nnnn
opcode00DC:
	addq.l #2, %a4
	btst #0, %d6
5:
	bne opcode00DC - 5b + (-3840)
opcode00DC_end: | CALL C, nnnn
opcode00C9:
	moveq #0, %d0
	move.b (%a2)+, %d0
	move.b (%a2)+, %d1
	move.b %d1, (PC_BASE, %a5)
	move.b %d1, (6f - opcode00C9 + 2 + (-13894), %a6)
6:
	movea.l (0x7f02, %a6), %a4
	adda.l %d0, %a4
opcode00C9_end: | RET
opcode00D9:
	moveq #0, %d0
	move.b (%a2)+, %d0
	move.b (%a2)+, %d1
	move.b %d1, (PC_BASE, %a5)
	move.b %d1, (6f - opcode00D9 + 2 + (-9798), %a6)
6:
	movea.l (0x7f02, %a6), %a4
	adda.l %d0, %a4
	jmp (enable_intr_entry-function_base, %a3)
opcode00D9_end: | RETI
opcode00C0:
	subq.w #1, %d4
	btst #2, %d6
5:
	beq opcode00C0 - 5b + (2302)
opcode00C0_end: | RET NZ
opcode00C8:
	subq.w #1, %d4
	btst #2, %d6
5:
	bne opcode00C8 - 5b + (254)
opcode00C8_end: | RET Z
opcode00D0:
	subq.w #1, %d4
	btst #0, %d6
5:
	beq opcode00D0 - 5b + (-1794)
opcode00D0_end: | RET NC
opcode00D8:
	subq.w #1, %d4
	btst #0, %d6
5:
	bne opcode00D8 - 5b + (-3842)
opcode00D8_end: | RET C
opcode00C7:
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f - opcode00C7 + 2 + (-14406), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
opcode00C7_end: | RST 00
opcode00CF:
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f - opcode00CF + 2 + (-12358), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
	addq.l #8, %a4 | now pc is correct
opcode00CF_end: | RST 08
opcode00D7:
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f - opcode00D7 + 2 + (-10310), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
	lea (0x10, %a4), %a4 | now pc is correct
opcode00D7_end: | RST 10
opcode00DF:
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f - opcode00DF + 2 + (-8262), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
	lea (0x18, %a4), %a4 | now pc is correct
opcode00DF_end: | RST 18
opcode00E7:
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f - opcode00E7 + 2 + (-6214), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
	lea (0x20, %a4), %a4 | now pc is correct
opcode00E7_end: | RST 20
opcode00EF:
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f - opcode00EF + 2 + (-4166), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
	lea (0x28, %a4), %a4 | now pc is correct
opcode00EF_end: | RST 28
opcode00F7:
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f - opcode00F7 + 2 + (-2118), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
	lea (0x30, %a4), %a4 | now pc is correct
opcode00F7_end: | RST 30
opcode00FF:
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f - opcode00FF + 2 + (-70), %a6)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
	lea (0x38, %a4), %a4 | now pc is correct
opcode00FF_end: | RST 38
opcode0076:
	cmp.b #HALT_AFTER_EI, (CPU_HALT, %a5)
	bne 0f
	st (IME, %a5)
0:
	tst.b (IME, %a5)
	beq 1f
	moveq #-1, %d4
	move.b #HALT_ACTIVE, (CPU_HALT, %a5)
	bra 2f
1:
	move.b #HALT_PENDING, (CPU_HALT, %a5)
2:
opcode0076_end: | HALT
opcode0027:
	move.b %d5, %d0 | d0 is current a
	swap %d6 | d5 is old a
	move.b %d6, %d5 | d5 is old a
	btst #16, %d6
	beq no_carry
	sub.b %d5, %d0
	bcc daa_sub
daa_add: | current a was bigger...this means last instruction was add
	sub.b %d1, %d1 |set zero, clear extend
	abcd %d0, %d5 | redo operation in bcd
	move.w %sr, %d6 | update zero, carry
	bra 0f	
no_carry:
	sub.b %d5, %d0
	bcc daa_add
daa_sub:
	neg.b %d0
	sub.b %d1, %d1 |set zero, clear extend
	sbcd %d0, %d5 | redo operation in bcd
	move.w %sr, %d6 | update zero, carry
0:
opcode0027_end: | DAA
opcode0000:
opcode0000_end: | NOP
opcode00CB:
	move.b (%a4)+, (opcode00CB_end - opcode00CB + (-13382) - 2, %a6)
	jmp (0x7F7E, %a6)
opcode00CB_end:
opcode_illegal:
	move.w #1, (ERROR, %a5) | Illegal Opcode
	jmp (return-function_base, %a3)
generate_int: | input: %d0, number of int
	clr.b (IME, %a5) | disable interrupts
	clr.b (CPU_HALT, %a5)
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f-function_base+2, %a3)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
	adda.l %d0, %a4
	jmp (%a1)
generate_int_event: | input: %d0, number of int
	clr.b (IME, %a5) | disable interrupts
	clr.b (CPU_HALT, %a5)
	move.l %a4, %d1
	move.b (PC_BASE, %a5), (6f-function_base+2, %a3)
6:
	sub.l (0x7f02, %a6), %d1 | pc now relative to block
	add.l (PC_BLOCK, %a5), %d1 | pc is now correct
	subq.l #2, %a2
	move.b %d1, (%a2)
	rol.w #8, %d1
	move.b %d1, (%a2, 1)
	clr.b (PC_BASE, %a5)
	movea.l (%a6, 2), %a4
	adda.l %d0, %a4
	END_EVENT end_generate_int_event
end_generate_int_event:

jump_table:
.word opcode0000 - function_base
.word opcode0001 - function_base
.word opcode0002 - function_base
.word opcode0003 - function_base
.word opcode0004 - function_base
.word opcode0005 - function_base
.word opcode0006 - function_base
.word opcode0007 - function_base
.word opcode0008 - function_base
.word opcode0009 - function_base
.word opcode000A - function_base
.word opcode000B - function_base
.word opcode000C - function_base
.word opcode000D - function_base
.word opcode000E - function_base
.word opcode000F - function_base
.word opcode_illegal - function_base
.word opcode0011 - function_base
.word opcode0012 - function_base
.word opcode0013 - function_base
.word opcode0014 - function_base
.word opcode0015 - function_base
.word opcode0016 - function_base
.word opcode0017 - function_base
.word opcode0018 - function_base
.word opcode0019 - function_base
.word opcode001A - function_base
.word opcode001B - function_base
.word opcode001C - function_base
.word opcode001D - function_base
.word opcode001E - function_base
.word opcode001F - function_base
.word opcode0020 - function_base
.word opcode0021 - function_base
.word opcode0022 - function_base
.word opcode0023 - function_base
.word opcode0024 - function_base
.word opcode0025 - function_base
.word opcode0026 - function_base
.word opcode0027 - function_base
.word opcode0028 - function_base
.word opcode0029 - function_base
.word opcode002A - function_base
.word opcode002B - function_base
.word opcode002C - function_base
.word opcode002D - function_base
.word opcode002E - function_base
.word opcode002F - function_base
.word opcode0030 - function_base
.word opcode0031 - function_base
.word opcode0032 - function_base
.word opcode0033 - function_base
.word opcode0034 - function_base
.word opcode0035 - function_base
.word opcode0036 - function_base
.word opcode0037 - function_base
.word opcode0038 - function_base
.word opcode0039 - function_base
.word opcode003A - function_base
.word opcode003B - function_base
.word opcode003C - function_base
.word opcode003D - function_base
.word opcode003E - function_base
.word opcode003F - function_base
.word opcode0040 - function_base
.word opcode0041 - function_base
.word opcode0042 - function_base
.word opcode0043 - function_base
.word opcode0044 - function_base
.word opcode0045 - function_base
.word opcode0046 - function_base
.word opcode0047 - function_base
.word opcode0048 - function_base
.word opcode0049 - function_base
.word opcode004A - function_base
.word opcode004B - function_base
.word opcode004C - function_base
.word opcode004D - function_base
.word opcode004E - function_base
.word opcode004F - function_base
.word opcode0050 - function_base
.word opcode0051 - function_base
.word opcode0052 - function_base
.word opcode0053 - function_base
.word opcode0054 - function_base
.word opcode0055 - function_base
.word opcode0056 - function_base
.word opcode0057 - function_base
.word opcode0058 - function_base
.word opcode0059 - function_base
.word opcode005A - function_base
.word opcode005B - function_base
.word opcode005C - function_base
.word opcode005D - function_base
.word opcode005E - function_base
.word opcode005F - function_base
.word opcode0060 - function_base
.word opcode0061 - function_base
.word opcode0062 - function_base
.word opcode0063 - function_base
.word opcode0064 - function_base
.word opcode0065 - function_base
.word opcode0066 - function_base
.word opcode0067 - function_base
.word opcode0068 - function_base
.word opcode0069 - function_base
.word opcode006A - function_base
.word opcode006B - function_base
.word opcode006C - function_base
.word opcode006D - function_base
.word opcode006E - function_base
.word opcode006F - function_base
.word opcode0070 - function_base
.word opcode0071 - function_base
.word opcode0072 - function_base
.word opcode0073 - function_base
.word opcode0074 - function_base
.word opcode0075 - function_base
.word opcode0076 - function_base
.word opcode0077 - function_base
.word opcode0078 - function_base
.word opcode0079 - function_base
.word opcode007A - function_base
.word opcode007B - function_base
.word opcode007C - function_base
.word opcode007D - function_base
.word opcode007E - function_base
.word opcode007F - function_base
.word opcode0080 - function_base
.word opcode0081 - function_base
.word opcode0082 - function_base
.word opcode0083 - function_base
.word opcode0084 - function_base
.word opcode0085 - function_base
.word opcode0086 - function_base
.word opcode0087 - function_base
.word opcode0088 - function_base
.word opcode0089 - function_base
.word opcode008A - function_base
.word opcode008B - function_base
.word opcode008C - function_base
.word opcode008D - function_base
.word opcode008E - function_base
.word opcode008F - function_base
.word opcode0090 - function_base
.word opcode0091 - function_base
.word opcode0092 - function_base
.word opcode0093 - function_base
.word opcode0094 - function_base
.word opcode0095 - function_base
.word opcode0096 - function_base
.word opcode0097 - function_base
.word opcode0098 - function_base
.word opcode0099 - function_base
.word opcode009A - function_base
.word opcode009B - function_base
.word opcode009C - function_base
.word opcode009D - function_base
.word opcode009E - function_base
.word opcode009F - function_base
.word opcode00A0 - function_base
.word opcode00A1 - function_base
.word opcode00A2 - function_base
.word opcode00A3 - function_base
.word opcode00A4 - function_base
.word opcode00A5 - function_base
.word opcode00A6 - function_base
.word opcode00A7 - function_base
.word opcode00A8 - function_base
.word opcode00A9 - function_base
.word opcode00AA - function_base
.word opcode00AB - function_base
.word opcode00AC - function_base
.word opcode00AD - function_base
.word opcode00AE - function_base
.word opcode00AF - function_base
.word opcode00B0 - function_base
.word opcode00B1 - function_base
.word opcode00B2 - function_base
.word opcode00B3 - function_base
.word opcode00B4 - function_base
.word opcode00B5 - function_base
.word opcode00B6 - function_base
.word opcode00B7 - function_base
.word opcode00B8 - function_base
.word opcode00B9 - function_base
.word opcode00BA - function_base
.word opcode00BB - function_base
.word opcode00BC - function_base
.word opcode00BD - function_base
.word opcode00BE - function_base
.word opcode00BF - function_base
.word opcode00C0 - function_base
.word opcode00C1 - function_base
.word opcode00C2 - function_base
.word opcode00C3 - function_base
.word opcode00C4 - function_base
.word opcode00C5 - function_base
.word opcode00C6 - function_base
.word opcode00C7 - function_base
.word opcode00C8 - function_base
.word opcode00C9 - function_base
.word opcode00CA - function_base
.word opcode00CB - function_base
.word opcode00CC - function_base
.word opcode00CD - function_base
.word opcode00CE - function_base
.word opcode00CF - function_base
.word opcode00D0 - function_base
.word opcode00D1 - function_base
.word opcode00D2 - function_base
.word opcode_illegal - function_base
.word opcode00D4 - function_base
.word opcode00D5 - function_base
.word opcode00D6 - function_base
.word opcode00D7 - function_base
.word opcode00D8 - function_base
.word opcode00D9 - function_base
.word opcode00DA - function_base
.word opcode_illegal - function_base
.word opcode00DC - function_base
.word opcode_illegal - function_base
.word opcode00DE - function_base
.word opcode00DF - function_base
.word opcode00E0 - function_base
.word opcode00E1 - function_base
.word opcode00E2 - function_base
.word opcode_illegal - function_base
.word opcode_illegal - function_base
.word opcode00E5 - function_base
.word opcode00E6 - function_base
.word opcode00E7 - function_base
.word opcode00E8 - function_base
.word opcode00E9 - function_base
.word opcode00EA - function_base
.word opcode_illegal - function_base
.word opcode_illegal - function_base
.word opcode_illegal - function_base
.word opcode00EE - function_base
.word opcode00EF - function_base
.word opcode00F0 - function_base
.word opcode00F1 - function_base
.word opcode00F2 - function_base
.word opcode00F3 - function_base
.word opcode_illegal - function_base
.word opcode00F5 - function_base
.word opcode00F6 - function_base
.word opcode00F7 - function_base
.word opcode00F8 - function_base
.word opcode00F9 - function_base
.word opcode00FA - function_base
.word opcode00FB - function_base
.word opcode_illegal - function_base
.word opcode_illegal - function_base
.word opcode00FE - function_base
.word opcode00FF - function_base

jump_table2:
.word opcodeCB00 - function_base
.word opcodeCB01 - function_base
.word opcodeCB02 - function_base
.word opcodeCB03 - function_base
.word opcodeCB04 - function_base
.word opcodeCB05 - function_base
.word opcodeCB06 - function_base
.word opcodeCB07 - function_base
.word opcodeCB08 - function_base
.word opcodeCB09 - function_base
.word opcodeCB0A - function_base
.word opcodeCB0B - function_base
.word opcodeCB0C - function_base
.word opcodeCB0D - function_base
.word opcodeCB0E - function_base
.word opcodeCB0F - function_base
.word opcodeCB10 - function_base
.word opcodeCB11 - function_base
.word opcodeCB12 - function_base
.word opcodeCB13 - function_base
.word opcodeCB14 - function_base
.word opcodeCB15 - function_base
.word opcodeCB16 - function_base
.word opcodeCB17 - function_base
.word opcodeCB18 - function_base
.word opcodeCB19 - function_base
.word opcodeCB1A - function_base
.word opcodeCB1B - function_base
.word opcodeCB1C - function_base
.word opcodeCB1D - function_base
.word opcodeCB1E - function_base
.word opcodeCB1F - function_base
.word opcodeCB20 - function_base
.word opcodeCB21 - function_base
.word opcodeCB22 - function_base
.word opcodeCB23 - function_base
.word opcodeCB24 - function_base
.word opcodeCB25 - function_base
.word opcodeCB26 - function_base
.word opcodeCB27 - function_base
.word opcodeCB28 - function_base
.word opcodeCB29 - function_base
.word opcodeCB2A - function_base
.word opcodeCB2B - function_base
.word opcodeCB2C - function_base
.word opcodeCB2D - function_base
.word opcodeCB2E - function_base
.word opcodeCB2F - function_base
.word opcodeCB30 - function_base
.word opcodeCB31 - function_base
.word opcodeCB32 - function_base
.word opcodeCB33 - function_base
.word opcodeCB34 - function_base
.word opcodeCB35 - function_base
.word opcodeCB36 - function_base
.word opcodeCB37 - function_base
.word opcodeCB38 - function_base
.word opcodeCB39 - function_base
.word opcodeCB3A - function_base
.word opcodeCB3B - function_base
.word opcodeCB3C - function_base
.word opcodeCB3D - function_base
.word opcodeCB3E - function_base
.word opcodeCB3F - function_base
.word opcodeCB40 - function_base
.word opcodeCB41 - function_base
.word opcodeCB42 - function_base
.word opcodeCB43 - function_base
.word opcodeCB44 - function_base
.word opcodeCB45 - function_base
.word opcodeCB46 - function_base
.word opcodeCB47 - function_base
.word opcodeCB48 - function_base
.word opcodeCB49 - function_base
.word opcodeCB4A - function_base
.word opcodeCB4B - function_base
.word opcodeCB4C - function_base
.word opcodeCB4D - function_base
.word opcodeCB4E - function_base
.word opcodeCB4F - function_base
.word opcodeCB50 - function_base
.word opcodeCB51 - function_base
.word opcodeCB52 - function_base
.word opcodeCB53 - function_base
.word opcodeCB54 - function_base
.word opcodeCB55 - function_base
.word opcodeCB56 - function_base
.word opcodeCB57 - function_base
.word opcodeCB58 - function_base
.word opcodeCB59 - function_base
.word opcodeCB5A - function_base
.word opcodeCB5B - function_base
.word opcodeCB5C - function_base
.word opcodeCB5D - function_base
.word opcodeCB5E - function_base
.word opcodeCB5F - function_base
.word opcodeCB60 - function_base
.word opcodeCB61 - function_base
.word opcodeCB62 - function_base
.word opcodeCB63 - function_base
.word opcodeCB64 - function_base
.word opcodeCB65 - function_base
.word opcodeCB66 - function_base
.word opcodeCB67 - function_base
.word opcodeCB68 - function_base
.word opcodeCB69 - function_base
.word opcodeCB6A - function_base
.word opcodeCB6B - function_base
.word opcodeCB6C - function_base
.word opcodeCB6D - function_base
.word opcodeCB6E - function_base
.word opcodeCB6F - function_base
.word opcodeCB70 - function_base
.word opcodeCB71 - function_base
.word opcodeCB72 - function_base
.word opcodeCB73 - function_base
.word opcodeCB74 - function_base
.word opcodeCB75 - function_base
.word opcodeCB76 - function_base
.word opcodeCB77 - function_base
.word opcodeCB78 - function_base
.word opcodeCB79 - function_base
.word opcodeCB7A - function_base
.word opcodeCB7B - function_base
.word opcodeCB7C - function_base
.word opcodeCB7D - function_base
.word opcodeCB7E - function_base
.word opcodeCB7F - function_base
.word opcodeCB80 - function_base
.word opcodeCB81 - function_base
.word opcodeCB82 - function_base
.word opcodeCB83 - function_base
.word opcodeCB84 - function_base
.word opcodeCB85 - function_base
.word opcodeCB86 - function_base
.word opcodeCB87 - function_base
.word opcodeCB88 - function_base
.word opcodeCB89 - function_base
.word opcodeCB8A - function_base
.word opcodeCB8B - function_base
.word opcodeCB8C - function_base
.word opcodeCB8D - function_base
.word opcodeCB8E - function_base
.word opcodeCB8F - function_base
.word opcodeCB90 - function_base
.word opcodeCB91 - function_base
.word opcodeCB92 - function_base
.word opcodeCB93 - function_base
.word opcodeCB94 - function_base
.word opcodeCB95 - function_base
.word opcodeCB96 - function_base
.word opcodeCB97 - function_base
.word opcodeCB98 - function_base
.word opcodeCB99 - function_base
.word opcodeCB9A - function_base
.word opcodeCB9B - function_base
.word opcodeCB9C - function_base
.word opcodeCB9D - function_base
.word opcodeCB9E - function_base
.word opcodeCB9F - function_base
.word opcodeCBA0 - function_base
.word opcodeCBA1 - function_base
.word opcodeCBA2 - function_base
.word opcodeCBA3 - function_base
.word opcodeCBA4 - function_base
.word opcodeCBA5 - function_base
.word opcodeCBA6 - function_base
.word opcodeCBA7 - function_base
.word opcodeCBA8 - function_base
.word opcodeCBA9 - function_base
.word opcodeCBAA - function_base
.word opcodeCBAB - function_base
.word opcodeCBAC - function_base
.word opcodeCBAD - function_base
.word opcodeCBAE - function_base
.word opcodeCBAF - function_base
.word opcodeCBB0 - function_base
.word opcodeCBB1 - function_base
.word opcodeCBB2 - function_base
.word opcodeCBB3 - function_base
.word opcodeCBB4 - function_base
.word opcodeCBB5 - function_base
.word opcodeCBB6 - function_base
.word opcodeCBB7 - function_base
.word opcodeCBB8 - function_base
.word opcodeCBB9 - function_base
.word opcodeCBBA - function_base
.word opcodeCBBB - function_base
.word opcodeCBBC - function_base
.word opcodeCBBD - function_base
.word opcodeCBBE - function_base
.word opcodeCBBF - function_base
.word opcodeCBC0 - function_base
.word opcodeCBC1 - function_base
.word opcodeCBC2 - function_base
.word opcodeCBC3 - function_base
.word opcodeCBC4 - function_base
.word opcodeCBC5 - function_base
.word opcodeCBC6 - function_base
.word opcodeCBC7 - function_base
.word opcodeCBC8 - function_base
.word opcodeCBC9 - function_base
.word opcodeCBCA - function_base
.word opcodeCBCB - function_base
.word opcodeCBCC - function_base
.word opcodeCBCD - function_base
.word opcodeCBCE - function_base
.word opcodeCBCF - function_base
.word opcodeCBD0 - function_base
.word opcodeCBD1 - function_base
.word opcodeCBD2 - function_base
.word opcodeCBD3 - function_base
.word opcodeCBD4 - function_base
.word opcodeCBD5 - function_base
.word opcodeCBD6 - function_base
.word opcodeCBD7 - function_base
.word opcodeCBD8 - function_base
.word opcodeCBD9 - function_base
.word opcodeCBDA - function_base
.word opcodeCBDB - function_base
.word opcodeCBDC - function_base
.word opcodeCBDD - function_base
.word opcodeCBDE - function_base
.word opcodeCBDF - function_base
.word opcodeCBE0 - function_base
.word opcodeCBE1 - function_base
.word opcodeCBE2 - function_base
.word opcodeCBE3 - function_base
.word opcodeCBE4 - function_base
.word opcodeCBE5 - function_base
.word opcodeCBE6 - function_base
.word opcodeCBE7 - function_base
.word opcodeCBE8 - function_base
.word opcodeCBE9 - function_base
.word opcodeCBEA - function_base
.word opcodeCBEB - function_base
.word opcodeCBEC - function_base
.word opcodeCBED - function_base
.word opcodeCBEE - function_base
.word opcodeCBEF - function_base
.word opcodeCBF0 - function_base
.word opcodeCBF1 - function_base
.word opcodeCBF2 - function_base
.word opcodeCBF3 - function_base
.word opcodeCBF4 - function_base
.word opcodeCBF5 - function_base
.word opcodeCBF6 - function_base
.word opcodeCBF7 - function_base
.word opcodeCBF8 - function_base
.word opcodeCBF9 - function_base
.word opcodeCBFA - function_base
.word opcodeCBFB - function_base
.word opcodeCBFC - function_base
.word opcodeCBFD - function_base
.word opcodeCBFE - function_base
.word opcodeCBFF - function_base

size_table:
.byte opcode0000_end - opcode0000
.byte opcode0001_end - opcode0001
.byte opcode0002_end - opcode0002
.byte opcode0003_end - opcode0003
.byte opcode0004_end - opcode0004
.byte opcode0005_end - opcode0005
.byte opcode0006_end - opcode0006
.byte opcode0007_end - opcode0007
.byte opcode0008_end - opcode0008
.byte opcode0009_end - opcode0009
.byte opcode000A_end - opcode000A
.byte opcode000B_end - opcode000B
.byte opcode000C_end - opcode000C
.byte opcode000D_end - opcode000D
.byte opcode000E_end - opcode000E
.byte opcode000F_end - opcode000F
.byte -1
.byte opcode0011_end - opcode0011
.byte opcode0012_end - opcode0012
.byte opcode0013_end - opcode0013
.byte opcode0014_end - opcode0014
.byte opcode0015_end - opcode0015
.byte opcode0016_end - opcode0016
.byte opcode0017_end - opcode0017
.byte opcode0018_end - opcode0018
.byte opcode0019_end - opcode0019
.byte opcode001A_end - opcode001A
.byte opcode001B_end - opcode001B
.byte opcode001C_end - opcode001C
.byte opcode001D_end - opcode001D
.byte opcode001E_end - opcode001E
.byte opcode001F_end - opcode001F
.byte opcode0020_end - opcode0020
.byte opcode0021_end - opcode0021
.byte opcode0022_end - opcode0022
.byte opcode0023_end - opcode0023
.byte opcode0024_end - opcode0024
.byte opcode0025_end - opcode0025
.byte opcode0026_end - opcode0026
.byte opcode0027_end - opcode0027
.byte opcode0028_end - opcode0028
.byte opcode0029_end - opcode0029
.byte opcode002A_end - opcode002A
.byte opcode002B_end - opcode002B
.byte opcode002C_end - opcode002C
.byte opcode002D_end - opcode002D
.byte opcode002E_end - opcode002E
.byte opcode002F_end - opcode002F
.byte opcode0030_end - opcode0030
.byte opcode0031_end - opcode0031
.byte opcode0032_end - opcode0032
.byte opcode0033_end - opcode0033
.byte opcode0034_end - opcode0034
.byte opcode0035_end - opcode0035
.byte opcode0036_end - opcode0036
.byte opcode0037_end - opcode0037
.byte opcode0038_end - opcode0038
.byte opcode0039_end - opcode0039
.byte opcode003A_end - opcode003A
.byte opcode003B_end - opcode003B
.byte opcode003C_end - opcode003C
.byte opcode003D_end - opcode003D
.byte opcode003E_end - opcode003E
.byte opcode003F_end - opcode003F
.byte opcode0040_end - opcode0040
.byte opcode0041_end - opcode0041
.byte opcode0042_end - opcode0042
.byte opcode0043_end - opcode0043
.byte opcode0044_end - opcode0044
.byte opcode0045_end - opcode0045
.byte opcode0046_end - opcode0046
.byte opcode0047_end - opcode0047
.byte opcode0048_end - opcode0048
.byte opcode0049_end - opcode0049
.byte opcode004A_end - opcode004A
.byte opcode004B_end - opcode004B
.byte opcode004C_end - opcode004C
.byte opcode004D_end - opcode004D
.byte opcode004E_end - opcode004E
.byte opcode004F_end - opcode004F
.byte opcode0050_end - opcode0050
.byte opcode0051_end - opcode0051
.byte opcode0052_end - opcode0052
.byte opcode0053_end - opcode0053
.byte opcode0054_end - opcode0054
.byte opcode0055_end - opcode0055
.byte opcode0056_end - opcode0056
.byte opcode0057_end - opcode0057
.byte opcode0058_end - opcode0058
.byte opcode0059_end - opcode0059
.byte opcode005A_end - opcode005A
.byte opcode005B_end - opcode005B
.byte opcode005C_end - opcode005C
.byte opcode005D_end - opcode005D
.byte opcode005E_end - opcode005E
.byte opcode005F_end - opcode005F
.byte opcode0060_end - opcode0060
.byte opcode0061_end - opcode0061
.byte opcode0062_end - opcode0062
.byte opcode0063_end - opcode0063
.byte opcode0064_end - opcode0064
.byte opcode0065_end - opcode0065
.byte opcode0066_end - opcode0066
.byte opcode0067_end - opcode0067
.byte opcode0068_end - opcode0068
.byte opcode0069_end - opcode0069
.byte opcode006A_end - opcode006A
.byte opcode006B_end - opcode006B
.byte opcode006C_end - opcode006C
.byte opcode006D_end - opcode006D
.byte opcode006E_end - opcode006E
.byte opcode006F_end - opcode006F
.byte opcode0070_end - opcode0070
.byte opcode0071_end - opcode0071
.byte opcode0072_end - opcode0072
.byte opcode0073_end - opcode0073
.byte opcode0074_end - opcode0074
.byte opcode0075_end - opcode0075
.byte opcode0076_end - opcode0076
.byte opcode0077_end - opcode0077
.byte opcode0078_end - opcode0078
.byte opcode0079_end - opcode0079
.byte opcode007A_end - opcode007A
.byte opcode007B_end - opcode007B
.byte opcode007C_end - opcode007C
.byte opcode007D_end - opcode007D
.byte opcode007E_end - opcode007E
.byte opcode007F_end - opcode007F
.byte opcode0080_end - opcode0080
.byte opcode0081_end - opcode0081
.byte opcode0082_end - opcode0082
.byte opcode0083_end - opcode0083
.byte opcode0084_end - opcode0084
.byte opcode0085_end - opcode0085
.byte opcode0086_end - opcode0086
.byte opcode0087_end - opcode0087
.byte opcode0088_end - opcode0088
.byte opcode0089_end - opcode0089
.byte opcode008A_end - opcode008A
.byte opcode008B_end - opcode008B
.byte opcode008C_end - opcode008C
.byte opcode008D_end - opcode008D
.byte opcode008E_end - opcode008E
.byte opcode008F_end - opcode008F
.byte opcode0090_end - opcode0090
.byte opcode0091_end - opcode0091
.byte opcode0092_end - opcode0092
.byte opcode0093_end - opcode0093
.byte opcode0094_end - opcode0094
.byte opcode0095_end - opcode0095
.byte opcode0096_end - opcode0096
.byte opcode0097_end - opcode0097
.byte opcode0098_end - opcode0098
.byte opcode0099_end - opcode0099
.byte opcode009A_end - opcode009A
.byte opcode009B_end - opcode009B
.byte opcode009C_end - opcode009C
.byte opcode009D_end - opcode009D
.byte opcode009E_end - opcode009E
.byte opcode009F_end - opcode009F
.byte opcode00A0_end - opcode00A0
.byte opcode00A1_end - opcode00A1
.byte opcode00A2_end - opcode00A2
.byte opcode00A3_end - opcode00A3
.byte opcode00A4_end - opcode00A4
.byte opcode00A5_end - opcode00A5
.byte opcode00A6_end - opcode00A6
.byte opcode00A7_end - opcode00A7
.byte opcode00A8_end - opcode00A8
.byte opcode00A9_end - opcode00A9
.byte opcode00AA_end - opcode00AA
.byte opcode00AB_end - opcode00AB
.byte opcode00AC_end - opcode00AC
.byte opcode00AD_end - opcode00AD
.byte opcode00AE_end - opcode00AE
.byte opcode00AF_end - opcode00AF
.byte opcode00B0_end - opcode00B0
.byte opcode00B1_end - opcode00B1
.byte opcode00B2_end - opcode00B2
.byte opcode00B3_end - opcode00B3
.byte opcode00B4_end - opcode00B4
.byte opcode00B5_end - opcode00B5
.byte opcode00B6_end - opcode00B6
.byte opcode00B7_end - opcode00B7
.byte opcode00B8_end - opcode00B8
.byte opcode00B9_end - opcode00B9
.byte opcode00BA_end - opcode00BA
.byte opcode00BB_end - opcode00BB
.byte opcode00BC_end - opcode00BC
.byte opcode00BD_end - opcode00BD
.byte opcode00BE_end - opcode00BE
.byte opcode00BF_end - opcode00BF
.byte opcode00C0_end - opcode00C0
.byte opcode00C1_end - opcode00C1
.byte opcode00C2_end - opcode00C2
.byte opcode00C3_end - opcode00C3
.byte opcode00C4_end - opcode00C4
.byte opcode00C5_end - opcode00C5
.byte opcode00C6_end - opcode00C6
.byte opcode00C7_end - opcode00C7
.byte opcode00C8_end - opcode00C8
.byte opcode00C9_end - opcode00C9
.byte opcode00CA_end - opcode00CA
.byte -1
.byte opcode00CC_end - opcode00CC
.byte opcode00CD_end - opcode00CD
.byte opcode00CE_end - opcode00CE
.byte opcode00CF_end - opcode00CF
.byte opcode00D0_end - opcode00D0
.byte opcode00D1_end - opcode00D1
.byte opcode00D2_end - opcode00D2
.byte -1
.byte opcode00D4_end - opcode00D4
.byte opcode00D5_end - opcode00D5
.byte opcode00D6_end - opcode00D6
.byte opcode00D7_end - opcode00D7
.byte opcode00D8_end - opcode00D8
.byte opcode00D9_end - opcode00D9
.byte opcode00DA_end - opcode00DA
.byte -1
.byte opcode00DC_end - opcode00DC
.byte -1
.byte opcode00DE_end - opcode00DE
.byte opcode00DF_end - opcode00DF
.byte opcode00E0_end - opcode00E0
.byte opcode00E1_end - opcode00E1
.byte opcode00E2_end - opcode00E2
.byte -1
.byte -1
.byte opcode00E5_end - opcode00E5
.byte opcode00E6_end - opcode00E6
.byte opcode00E7_end - opcode00E7
.byte opcode00E8_end - opcode00E8
.byte opcode00E9_end - opcode00E9
.byte opcode00EA_end - opcode00EA
.byte -1
.byte -1
.byte -1
.byte opcode00EE_end - opcode00EE
.byte opcode00EF_end - opcode00EF
.byte opcode00F0_end - opcode00F0
.byte opcode00F1_end - opcode00F1
.byte opcode00F2_end - opcode00F2
.byte opcode00F3_end - opcode00F3
.byte -1
.byte opcode00F5_end - opcode00F5
.byte opcode00F6_end - opcode00F6
.byte opcode00F7_end - opcode00F7
.byte opcode00F8_end - opcode00F8
.byte opcode00F9_end - opcode00F9
.byte opcode00FA_end - opcode00FA
.byte opcode00FB_end - opcode00FB
.byte -1
.byte -1
.byte opcode00FE_end - opcode00FE
.byte opcode00FF_end - opcode00FF
.byte opcodeCB00_end - opcodeCB00
.byte opcodeCB01_end - opcodeCB01
.byte opcodeCB02_end - opcodeCB02
.byte opcodeCB03_end - opcodeCB03
.byte opcodeCB04_end - opcodeCB04
.byte opcodeCB05_end - opcodeCB05
.byte opcodeCB06_end - opcodeCB06
.byte opcodeCB07_end - opcodeCB07
.byte opcodeCB08_end - opcodeCB08
.byte opcodeCB09_end - opcodeCB09
.byte opcodeCB0A_end - opcodeCB0A
.byte opcodeCB0B_end - opcodeCB0B
.byte opcodeCB0C_end - opcodeCB0C
.byte opcodeCB0D_end - opcodeCB0D
.byte opcodeCB0E_end - opcodeCB0E
.byte opcodeCB0F_end - opcodeCB0F
.byte opcodeCB10_end - opcodeCB10
.byte opcodeCB11_end - opcodeCB11
.byte opcodeCB12_end - opcodeCB12
.byte opcodeCB13_end - opcodeCB13
.byte opcodeCB14_end - opcodeCB14
.byte opcodeCB15_end - opcodeCB15
.byte opcodeCB16_end - opcodeCB16
.byte opcodeCB17_end - opcodeCB17
.byte opcodeCB18_end - opcodeCB18
.byte opcodeCB19_end - opcodeCB19
.byte opcodeCB1A_end - opcodeCB1A
.byte opcodeCB1B_end - opcodeCB1B
.byte opcodeCB1C_end - opcodeCB1C
.byte opcodeCB1D_end - opcodeCB1D
.byte opcodeCB1E_end - opcodeCB1E
.byte opcodeCB1F_end - opcodeCB1F
.byte opcodeCB20_end - opcodeCB20
.byte opcodeCB21_end - opcodeCB21
.byte opcodeCB22_end - opcodeCB22
.byte opcodeCB23_end - opcodeCB23
.byte opcodeCB24_end - opcodeCB24
.byte opcodeCB25_end - opcodeCB25
.byte opcodeCB26_end - opcodeCB26
.byte opcodeCB27_end - opcodeCB27
.byte opcodeCB28_end - opcodeCB28
.byte opcodeCB29_end - opcodeCB29
.byte opcodeCB2A_end - opcodeCB2A
.byte opcodeCB2B_end - opcodeCB2B
.byte opcodeCB2C_end - opcodeCB2C
.byte opcodeCB2D_end - opcodeCB2D
.byte opcodeCB2E_end - opcodeCB2E
.byte opcodeCB2F_end - opcodeCB2F
.byte opcodeCB30_end - opcodeCB30
.byte opcodeCB31_end - opcodeCB31
.byte opcodeCB32_end - opcodeCB32
.byte opcodeCB33_end - opcodeCB33
.byte opcodeCB34_end - opcodeCB34
.byte opcodeCB35_end - opcodeCB35
.byte opcodeCB36_end - opcodeCB36
.byte opcodeCB37_end - opcodeCB37
.byte opcodeCB38_end - opcodeCB38
.byte opcodeCB39_end - opcodeCB39
.byte opcodeCB3A_end - opcodeCB3A
.byte opcodeCB3B_end - opcodeCB3B
.byte opcodeCB3C_end - opcodeCB3C
.byte opcodeCB3D_end - opcodeCB3D
.byte opcodeCB3E_end - opcodeCB3E
.byte opcodeCB3F_end - opcodeCB3F
.byte opcodeCB40_end - opcodeCB40
.byte opcodeCB41_end - opcodeCB41
.byte opcodeCB42_end - opcodeCB42
.byte opcodeCB43_end - opcodeCB43
.byte opcodeCB44_end - opcodeCB44
.byte opcodeCB45_end - opcodeCB45
.byte opcodeCB46_end - opcodeCB46
.byte opcodeCB47_end - opcodeCB47
.byte opcodeCB48_end - opcodeCB48
.byte opcodeCB49_end - opcodeCB49
.byte opcodeCB4A_end - opcodeCB4A
.byte opcodeCB4B_end - opcodeCB4B
.byte opcodeCB4C_end - opcodeCB4C
.byte opcodeCB4D_end - opcodeCB4D
.byte opcodeCB4E_end - opcodeCB4E
.byte opcodeCB4F_end - opcodeCB4F
.byte opcodeCB50_end - opcodeCB50
.byte opcodeCB51_end - opcodeCB51
.byte opcodeCB52_end - opcodeCB52
.byte opcodeCB53_end - opcodeCB53
.byte opcodeCB54_end - opcodeCB54
.byte opcodeCB55_end - opcodeCB55
.byte opcodeCB56_end - opcodeCB56
.byte opcodeCB57_end - opcodeCB57
.byte opcodeCB58_end - opcodeCB58
.byte opcodeCB59_end - opcodeCB59
.byte opcodeCB5A_end - opcodeCB5A
.byte opcodeCB5B_end - opcodeCB5B
.byte opcodeCB5C_end - opcodeCB5C
.byte opcodeCB5D_end - opcodeCB5D
.byte opcodeCB5E_end - opcodeCB5E
.byte opcodeCB5F_end - opcodeCB5F
.byte opcodeCB60_end - opcodeCB60
.byte opcodeCB61_end - opcodeCB61
.byte opcodeCB62_end - opcodeCB62
.byte opcodeCB63_end - opcodeCB63
.byte opcodeCB64_end - opcodeCB64
.byte opcodeCB65_end - opcodeCB65
.byte opcodeCB66_end - opcodeCB66
.byte opcodeCB67_end - opcodeCB67
.byte opcodeCB68_end - opcodeCB68
.byte opcodeCB69_end - opcodeCB69
.byte opcodeCB6A_end - opcodeCB6A
.byte opcodeCB6B_end - opcodeCB6B
.byte opcodeCB6C_end - opcodeCB6C
.byte opcodeCB6D_end - opcodeCB6D
.byte opcodeCB6E_end - opcodeCB6E
.byte opcodeCB6F_end - opcodeCB6F
.byte opcodeCB70_end - opcodeCB70
.byte opcodeCB71_end - opcodeCB71
.byte opcodeCB72_end - opcodeCB72
.byte opcodeCB73_end - opcodeCB73
.byte opcodeCB74_end - opcodeCB74
.byte opcodeCB75_end - opcodeCB75
.byte opcodeCB76_end - opcodeCB76
.byte opcodeCB77_end - opcodeCB77
.byte opcodeCB78_end - opcodeCB78
.byte opcodeCB79_end - opcodeCB79
.byte opcodeCB7A_end - opcodeCB7A
.byte opcodeCB7B_end - opcodeCB7B
.byte opcodeCB7C_end - opcodeCB7C
.byte opcodeCB7D_end - opcodeCB7D
.byte opcodeCB7E_end - opcodeCB7E
.byte opcodeCB7F_end - opcodeCB7F
.byte opcodeCB80_end - opcodeCB80
.byte opcodeCB81_end - opcodeCB81
.byte opcodeCB82_end - opcodeCB82
.byte opcodeCB83_end - opcodeCB83
.byte opcodeCB84_end - opcodeCB84
.byte opcodeCB85_end - opcodeCB85
.byte opcodeCB86_end - opcodeCB86
.byte opcodeCB87_end - opcodeCB87
.byte opcodeCB88_end - opcodeCB88
.byte opcodeCB89_end - opcodeCB89
.byte opcodeCB8A_end - opcodeCB8A
.byte opcodeCB8B_end - opcodeCB8B
.byte opcodeCB8C_end - opcodeCB8C
.byte opcodeCB8D_end - opcodeCB8D
.byte opcodeCB8E_end - opcodeCB8E
.byte opcodeCB8F_end - opcodeCB8F
.byte opcodeCB90_end - opcodeCB90
.byte opcodeCB91_end - opcodeCB91
.byte opcodeCB92_end - opcodeCB92
.byte opcodeCB93_end - opcodeCB93
.byte opcodeCB94_end - opcodeCB94
.byte opcodeCB95_end - opcodeCB95
.byte opcodeCB96_end - opcodeCB96
.byte opcodeCB97_end - opcodeCB97
.byte opcodeCB98_end - opcodeCB98
.byte opcodeCB99_end - opcodeCB99
.byte opcodeCB9A_end - opcodeCB9A
.byte opcodeCB9B_end - opcodeCB9B
.byte opcodeCB9C_end - opcodeCB9C
.byte opcodeCB9D_end - opcodeCB9D
.byte opcodeCB9E_end - opcodeCB9E
.byte opcodeCB9F_end - opcodeCB9F
.byte opcodeCBA0_end - opcodeCBA0
.byte opcodeCBA1_end - opcodeCBA1
.byte opcodeCBA2_end - opcodeCBA2
.byte opcodeCBA3_end - opcodeCBA3
.byte opcodeCBA4_end - opcodeCBA4
.byte opcodeCBA5_end - opcodeCBA5
.byte opcodeCBA6_end - opcodeCBA6
.byte opcodeCBA7_end - opcodeCBA7
.byte opcodeCBA8_end - opcodeCBA8
.byte opcodeCBA9_end - opcodeCBA9
.byte opcodeCBAA_end - opcodeCBAA
.byte opcodeCBAB_end - opcodeCBAB
.byte opcodeCBAC_end - opcodeCBAC
.byte opcodeCBAD_end - opcodeCBAD
.byte opcodeCBAE_end - opcodeCBAE
.byte opcodeCBAF_end - opcodeCBAF
.byte opcodeCBB0_end - opcodeCBB0
.byte opcodeCBB1_end - opcodeCBB1
.byte opcodeCBB2_end - opcodeCBB2
.byte opcodeCBB3_end - opcodeCBB3
.byte opcodeCBB4_end - opcodeCBB4
.byte opcodeCBB5_end - opcodeCBB5
.byte opcodeCBB6_end - opcodeCBB6
.byte opcodeCBB7_end - opcodeCBB7
.byte opcodeCBB8_end - opcodeCBB8
.byte opcodeCBB9_end - opcodeCBB9
.byte opcodeCBBA_end - opcodeCBBA
.byte opcodeCBBB_end - opcodeCBBB
.byte opcodeCBBC_end - opcodeCBBC
.byte opcodeCBBD_end - opcodeCBBD
.byte opcodeCBBE_end - opcodeCBBE
.byte opcodeCBBF_end - opcodeCBBF
.byte opcodeCBC0_end - opcodeCBC0
.byte opcodeCBC1_end - opcodeCBC1
.byte opcodeCBC2_end - opcodeCBC2
.byte opcodeCBC3_end - opcodeCBC3
.byte opcodeCBC4_end - opcodeCBC4
.byte opcodeCBC5_end - opcodeCBC5
.byte opcodeCBC6_end - opcodeCBC6
.byte opcodeCBC7_end - opcodeCBC7
.byte opcodeCBC8_end - opcodeCBC8
.byte opcodeCBC9_end - opcodeCBC9
.byte opcodeCBCA_end - opcodeCBCA
.byte opcodeCBCB_end - opcodeCBCB
.byte opcodeCBCC_end - opcodeCBCC
.byte opcodeCBCD_end - opcodeCBCD
.byte opcodeCBCE_end - opcodeCBCE
.byte opcodeCBCF_end - opcodeCBCF
.byte opcodeCBD0_end - opcodeCBD0
.byte opcodeCBD1_end - opcodeCBD1
.byte opcodeCBD2_end - opcodeCBD2
.byte opcodeCBD3_end - opcodeCBD3
.byte opcodeCBD4_end - opcodeCBD4
.byte opcodeCBD5_end - opcodeCBD5
.byte opcodeCBD6_end - opcodeCBD6
.byte opcodeCBD7_end - opcodeCBD7
.byte opcodeCBD8_end - opcodeCBD8
.byte opcodeCBD9_end - opcodeCBD9
.byte opcodeCBDA_end - opcodeCBDA
.byte opcodeCBDB_end - opcodeCBDB
.byte opcodeCBDC_end - opcodeCBDC
.byte opcodeCBDD_end - opcodeCBDD
.byte opcodeCBDE_end - opcodeCBDE
.byte opcodeCBDF_end - opcodeCBDF
.byte opcodeCBE0_end - opcodeCBE0
.byte opcodeCBE1_end - opcodeCBE1
.byte opcodeCBE2_end - opcodeCBE2
.byte opcodeCBE3_end - opcodeCBE3
.byte opcodeCBE4_end - opcodeCBE4
.byte opcodeCBE5_end - opcodeCBE5
.byte opcodeCBE6_end - opcodeCBE6
.byte opcodeCBE7_end - opcodeCBE7
.byte opcodeCBE8_end - opcodeCBE8
.byte opcodeCBE9_end - opcodeCBE9
.byte opcodeCBEA_end - opcodeCBEA
.byte opcodeCBEB_end - opcodeCBEB
.byte opcodeCBEC_end - opcodeCBEC
.byte opcodeCBED_end - opcodeCBED
.byte opcodeCBEE_end - opcodeCBEE
.byte opcodeCBEF_end - opcodeCBEF
.byte opcodeCBF0_end - opcodeCBF0
.byte opcodeCBF1_end - opcodeCBF1
.byte opcodeCBF2_end - opcodeCBF2
.byte opcodeCBF3_end - opcodeCBF3
.byte opcodeCBF4_end - opcodeCBF4
.byte opcodeCBF5_end - opcodeCBF5
.byte opcodeCBF6_end - opcodeCBF6
.byte opcodeCBF7_end - opcodeCBF7
.byte opcodeCBF8_end - opcodeCBF8
.byte opcodeCBF9_end - opcodeCBF9
.byte opcodeCBFA_end - opcodeCBFA
.byte opcodeCBFB_end - opcodeCBFB
.byte opcodeCBFC_end - opcodeCBFC
.byte opcodeCBFD_end - opcodeCBFD
.byte opcodeCBFE_end - opcodeCBFE
.byte opcodeCBFF_end - opcodeCBFF

cycles_table:
.byte 1
.byte 3
.byte 2
.byte 2
.byte 1
.byte 1
.byte 2
.byte 1
.byte 5
.byte 2
.byte 2
.byte 2
.byte 1
.byte 1
.byte 2
.byte 1
.byte 0
.byte 3
.byte 2
.byte 2
.byte 1
.byte 1
.byte 2
.byte 1
.byte 3
.byte 2
.byte 2
.byte 2
.byte 1
.byte 1
.byte 2
.byte 1
.byte 2
.byte 3
.byte 2
.byte 2
.byte 1
.byte 1
.byte 2
.byte 1
.byte 2
.byte 2
.byte 2
.byte 2
.byte 1
.byte 1
.byte 2
.byte 1
.byte 2
.byte 3
.byte 2
.byte 2
.byte 3
.byte 3
.byte 3
.byte 1
.byte 2
.byte 2
.byte 2
.byte 2
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 1
.byte 2
.byte 1
.byte 1
.byte 3
.byte 3
.byte 4
.byte 3
.byte 4
.byte 2
.byte 4
.byte 1
.byte 4
.byte 3
.byte 0
.byte 3
.byte 6
.byte 2
.byte 4
.byte 1
.byte 3
.byte 3
.byte 0
.byte 3
.byte 4
.byte 2
.byte 4
.byte 1
.byte 4
.byte 3
.byte 0
.byte 3
.byte 0
.byte 2
.byte 4
.byte 3
.byte 3
.byte 2
.byte 0
.byte 0
.byte 4
.byte 2
.byte 4
.byte 4
.byte 1
.byte 4
.byte 0
.byte 0
.byte 0
.byte 2
.byte 4
.byte 3
.byte 3
.byte 2
.byte 1
.byte 0
.byte 4
.byte 2
.byte 4
.byte 3
.byte 2
.byte 4
.byte 1
.byte 0
.byte 0
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 3
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 3
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 3
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 3
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 3
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 3
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 3
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 3
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 2
.byte 4
.byte 2

event_table:
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1
.byte 0
.byte 1
.byte 1
.byte 1
.byte 0
.byte 0
.byte 1
.byte 1
.byte 1
.byte 1
.byte 0
.byte 1
.byte 1
.byte 0
.byte 1
.byte 1
.byte 0
.byte 1
.byte 0
.byte 1
.byte 0
.byte 0
.byte 1
.byte 1
.byte 1
.byte 1
.byte 0
.byte 1
.byte 0
.byte 0
.byte 1
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1
.byte 0
.byte 1
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 0
.byte 1

.if GB_DEBUG

opcode_table:
.byte 0, 0, 0
.byte 1, 9, 41
.byte 1, 13, 1
.byte 12, 9, 0
.byte 12, 2, 0
.byte 13, 2, 0
.byte 1, 2, 40
.byte 23, 0, 0
.byte 1, 42, 12
.byte 4, 11, 9
.byte 1, 1, 13
.byte 13, 9, 0
.byte 12, 3, 0
.byte 13, 3, 0
.byte 1, 3, 40
.byte 25, 0, 0
.byte 0, 0, 0
.byte 1, 10, 41
.byte 1, 14, 1
.byte 12, 10, 0
.byte 12, 4, 0
.byte 13, 4, 0
.byte 1, 4, 40
.byte 24, 0, 0
.byte 38, 40, 0
.byte 4, 11, 10
.byte 1, 1, 14
.byte 13, 10, 0
.byte 12, 5, 0
.byte 13, 5, 0
.byte 1, 5, 40
.byte 26, 0, 0
.byte 38, 28, 40
.byte 1, 11, 41
.byte 1, 17, 1
.byte 12, 11, 0
.byte 12, 6, 0
.byte 13, 6, 0
.byte 1, 6, 40
.byte 14, 0, 0
.byte 38, 29, 40
.byte 4, 11, 11
.byte 1, 1, 17
.byte 13, 11, 0
.byte 12, 7, 0
.byte 13, 7, 0
.byte 1, 7, 40
.byte 15, 0, 0
.byte 38, 30, 40
.byte 1, 12, 41
.byte 1, 18, 1
.byte 12, 12, 0
.byte 12, 15, 0
.byte 13, 15, 0
.byte 1, 15, 40
.byte 17, 0, 0
.byte 38, 31, 40
.byte 4, 11, 12
.byte 1, 1, 18
.byte 13, 12, 0
.byte 12, 1, 0
.byte 13, 1, 0
.byte 1, 1, 40
.byte 16, 0, 0
.byte 1, 2, 2
.byte 1, 2, 3
.byte 1, 2, 4
.byte 1, 2, 5
.byte 1, 2, 6
.byte 1, 2, 7
.byte 1, 2, 15
.byte 1, 2, 1
.byte 1, 3, 2
.byte 1, 3, 3
.byte 1, 3, 4
.byte 1, 3, 5
.byte 1, 3, 6
.byte 1, 3, 7
.byte 1, 3, 15
.byte 1, 3, 1
.byte 1, 4, 2
.byte 1, 4, 3
.byte 1, 4, 4
.byte 1, 4, 5
.byte 1, 4, 6
.byte 1, 4, 7
.byte 1, 4, 15
.byte 1, 4, 1
.byte 1, 5, 2
.byte 1, 5, 3
.byte 1, 5, 4
.byte 1, 5, 5
.byte 1, 5, 6
.byte 1, 5, 7
.byte 1, 5, 15
.byte 1, 5, 1
.byte 1, 6, 2
.byte 1, 6, 3
.byte 1, 6, 4
.byte 1, 6, 5
.byte 1, 6, 6
.byte 1, 6, 7
.byte 1, 6, 15
.byte 1, 6, 1
.byte 1, 7, 2
.byte 1, 7, 3
.byte 1, 7, 4
.byte 1, 7, 5
.byte 1, 7, 6
.byte 1, 7, 7
.byte 1, 7, 15
.byte 1, 7, 1
.byte 1, 15, 2
.byte 1, 15, 3
.byte 1, 15, 4
.byte 1, 15, 5
.byte 1, 15, 6
.byte 1, 15, 7
.byte 18, 15, 15
.byte 1, 15, 1
.byte 1, 1, 2
.byte 1, 1, 3
.byte 1, 1, 4
.byte 1, 1, 5
.byte 1, 1, 6
.byte 1, 1, 7
.byte 1, 1, 15
.byte 1, 1, 1
.byte 4, 1, 2
.byte 4, 1, 3
.byte 4, 1, 4
.byte 4, 1, 5
.byte 4, 1, 6
.byte 4, 1, 7
.byte 4, 1, 15
.byte 4, 1, 1
.byte 5, 1, 2
.byte 5, 1, 3
.byte 5, 1, 4
.byte 5, 1, 5
.byte 5, 1, 6
.byte 5, 1, 7
.byte 5, 1, 15
.byte 5, 1, 1
.byte 6, 1, 2
.byte 6, 1, 3
.byte 6, 1, 4
.byte 6, 1, 5
.byte 6, 1, 6
.byte 6, 1, 7
.byte 6, 1, 15
.byte 6, 1, 1
.byte 7, 1, 2
.byte 7, 1, 3
.byte 7, 1, 4
.byte 7, 1, 5
.byte 7, 1, 6
.byte 7, 1, 7
.byte 7, 1, 15
.byte 7, 1, 1
.byte 8, 1, 2
.byte 8, 1, 3
.byte 8, 1, 4
.byte 8, 1, 5
.byte 8, 1, 6
.byte 8, 1, 7
.byte 8, 1, 15
.byte 8, 1, 1
.byte 10, 1, 2
.byte 10, 1, 3
.byte 10, 1, 4
.byte 10, 1, 5
.byte 10, 1, 6
.byte 10, 1, 7
.byte 10, 1, 15
.byte 10, 1, 1
.byte 9, 1, 2
.byte 9, 1, 3
.byte 9, 1, 4
.byte 9, 1, 5
.byte 9, 1, 6
.byte 9, 1, 7
.byte 9, 1, 15
.byte 9, 1, 1
.byte 11, 1, 2
.byte 11, 1, 3
.byte 11, 1, 4
.byte 11, 1, 5
.byte 11, 1, 6
.byte 11, 1, 7
.byte 11, 1, 15
.byte 11, 1, 1
.byte 40, 28, 0
.byte 3, 9, 0
.byte 37, 28, 41
.byte 37, 41, 0
.byte 39, 28, 41
.byte 2, 9, 0
.byte 4, 1, 40
.byte 42, 32, 0
.byte 40, 29, 0
.byte 40, 0, 0
.byte 37, 29, 41
.byte 0, 0, 0
.byte 39, 29, 41
.byte 39, 41, 0
.byte 5, 1, 40
.byte 42, 33, 0
.byte 40, 30, 0
.byte 3, 10, 0
.byte 37, 30, 41
.byte 0, 0, 0
.byte 39, 30, 41
.byte 2, 10, 0
.byte 6, 1, 40
.byte 42, 34, 0
.byte 40, 31, 0
.byte 41, 0, 0
.byte 37, 31, 41
.byte 0, 0, 0
.byte 39, 31, 41
.byte 0, 0, 0
.byte 7, 1, 40
.byte 42, 35, 0
.byte 1, 43, 1
.byte 3, 11, 0
.byte 1, 19, 1
.byte 0, 0, 0
.byte 0, 0, 0
.byte 2, 11, 0
.byte 8, 1, 40
.byte 42, 36, 0
.byte 4, 12, 40
.byte 37, 11, 0
.byte 1, 42, 1
.byte 0, 0, 0
.byte 0, 0, 0
.byte 0, 0, 0
.byte 10, 1, 40
.byte 42, 37, 0
.byte 1, 1, 43
.byte 3, 8, 0
.byte 1, 1, 19
.byte 19, 0, 0
.byte 0, 0, 0
.byte 2, 8, 0
.byte 9, 1, 40
.byte 42, 38, 0
.byte 1, 11, 44
.byte 1, 12, 11
.byte 1, 1, 42
.byte 20, 0, 0
.byte 0, 0, 0
.byte 0, 0, 0
.byte 11, 1, 40
.byte 42, 39, 0

suffix_table:
.byte 27, 2, 0
.byte 27, 3, 0
.byte 27, 4, 0
.byte 27, 5, 0
.byte 27, 6, 0
.byte 27, 7, 0
.byte 27, 15, 0
.byte 27, 1, 0
.byte 29, 2, 0
.byte 29, 3, 0
.byte 29, 4, 0
.byte 29, 5, 0
.byte 29, 6, 0
.byte 29, 7, 0
.byte 29, 15, 0
.byte 29, 1, 0
.byte 28, 2, 0
.byte 28, 3, 0
.byte 28, 4, 0
.byte 28, 5, 0
.byte 28, 6, 0
.byte 28, 7, 0
.byte 28, 15, 0
.byte 28, 1, 0
.byte 30, 2, 0
.byte 30, 3, 0
.byte 30, 4, 0
.byte 30, 5, 0
.byte 30, 6, 0
.byte 30, 7, 0
.byte 30, 15, 0
.byte 30, 1, 0
.byte 31, 2, 0
.byte 31, 3, 0
.byte 31, 4, 0
.byte 31, 5, 0
.byte 31, 6, 0
.byte 31, 7, 0
.byte 31, 15, 0
.byte 31, 1, 0
.byte 32, 2, 0
.byte 32, 3, 0
.byte 32, 4, 0
.byte 32, 5, 0
.byte 32, 6, 0
.byte 32, 7, 0
.byte 32, 15, 0
.byte 32, 1, 0
.byte 22, 2, 0
.byte 22, 3, 0
.byte 22, 4, 0
.byte 22, 5, 0
.byte 22, 6, 0
.byte 22, 7, 0
.byte 22, 15, 0
.byte 22, 1, 0
.byte 33, 2, 0
.byte 33, 3, 0
.byte 33, 4, 0
.byte 33, 5, 0
.byte 33, 6, 0
.byte 33, 7, 0
.byte 33, 15, 0
.byte 33, 1, 0
.byte 34, 2, 20
.byte 34, 3, 20
.byte 34, 4, 20
.byte 34, 5, 20
.byte 34, 6, 20
.byte 34, 7, 20
.byte 34, 15, 20
.byte 34, 1, 20
.byte 34, 2, 21
.byte 34, 3, 21
.byte 34, 4, 21
.byte 34, 5, 21
.byte 34, 6, 21
.byte 34, 7, 21
.byte 34, 15, 21
.byte 34, 1, 21
.byte 34, 2, 22
.byte 34, 3, 22
.byte 34, 4, 22
.byte 34, 5, 22
.byte 34, 6, 22
.byte 34, 7, 22
.byte 34, 15, 22
.byte 34, 1, 22
.byte 34, 2, 23
.byte 34, 3, 23
.byte 34, 4, 23
.byte 34, 5, 23
.byte 34, 6, 23
.byte 34, 7, 23
.byte 34, 15, 23
.byte 34, 1, 23
.byte 34, 2, 24
.byte 34, 3, 24
.byte 34, 4, 24
.byte 34, 5, 24
.byte 34, 6, 24
.byte 34, 7, 24
.byte 34, 15, 24
.byte 34, 1, 24
.byte 34, 2, 25
.byte 34, 3, 25
.byte 34, 4, 25
.byte 34, 5, 25
.byte 34, 6, 25
.byte 34, 7, 25
.byte 34, 15, 25
.byte 34, 1, 25
.byte 34, 2, 26
.byte 34, 3, 26
.byte 34, 4, 26
.byte 34, 5, 26
.byte 34, 6, 26
.byte 34, 7, 26
.byte 34, 15, 26
.byte 34, 1, 26
.byte 34, 2, 27
.byte 34, 3, 27
.byte 34, 4, 27
.byte 34, 5, 27
.byte 34, 6, 27
.byte 34, 7, 27
.byte 34, 15, 27
.byte 34, 1, 27
.byte 36, 2, 20
.byte 36, 3, 20
.byte 36, 4, 20
.byte 36, 5, 20
.byte 36, 6, 20
.byte 36, 7, 20
.byte 36, 15, 20
.byte 36, 1, 20
.byte 36, 2, 21
.byte 36, 3, 21
.byte 36, 4, 21
.byte 36, 5, 21
.byte 36, 6, 21
.byte 36, 7, 21
.byte 36, 15, 21
.byte 36, 1, 21
.byte 36, 2, 22
.byte 36, 3, 22
.byte 36, 4, 22
.byte 36, 5, 22
.byte 36, 6, 22
.byte 36, 7, 22
.byte 36, 15, 22
.byte 36, 1, 22
.byte 36, 2, 23
.byte 36, 3, 23
.byte 36, 4, 23
.byte 36, 5, 23
.byte 36, 6, 23
.byte 36, 7, 23
.byte 36, 15, 23
.byte 36, 1, 23
.byte 36, 2, 24
.byte 36, 3, 24
.byte 36, 4, 24
.byte 36, 5, 24
.byte 36, 6, 24
.byte 36, 7, 24
.byte 36, 15, 24
.byte 36, 1, 24
.byte 36, 2, 25
.byte 36, 3, 25
.byte 36, 4, 25
.byte 36, 5, 25
.byte 36, 6, 25
.byte 36, 7, 25
.byte 36, 15, 25
.byte 36, 1, 25
.byte 36, 2, 26
.byte 36, 3, 26
.byte 36, 4, 26
.byte 36, 5, 26
.byte 36, 6, 26
.byte 36, 7, 26
.byte 36, 15, 26
.byte 36, 1, 26
.byte 36, 2, 27
.byte 36, 3, 27
.byte 36, 4, 27
.byte 36, 5, 27
.byte 36, 6, 27
.byte 36, 7, 27
.byte 36, 15, 27
.byte 36, 1, 27
.byte 35, 2, 20
.byte 35, 3, 20
.byte 35, 4, 20
.byte 35, 5, 20
.byte 35, 6, 20
.byte 35, 7, 20
.byte 35, 15, 20
.byte 35, 1, 20
.byte 35, 2, 21
.byte 35, 3, 21
.byte 35, 4, 21
.byte 35, 5, 21
.byte 35, 6, 21
.byte 35, 7, 21
.byte 35, 15, 21
.byte 35, 1, 21
.byte 35, 2, 22
.byte 35, 3, 22
.byte 35, 4, 22
.byte 35, 5, 22
.byte 35, 6, 22
.byte 35, 7, 22
.byte 35, 15, 22
.byte 35, 1, 22
.byte 35, 2, 23
.byte 35, 3, 23
.byte 35, 4, 23
.byte 35, 5, 23
.byte 35, 6, 23
.byte 35, 7, 23
.byte 35, 15, 23
.byte 35, 1, 23
.byte 35, 2, 24
.byte 35, 3, 24
.byte 35, 4, 24
.byte 35, 5, 24
.byte 35, 6, 24
.byte 35, 7, 24
.byte 35, 15, 24
.byte 35, 1, 24
.byte 35, 2, 25
.byte 35, 3, 25
.byte 35, 4, 25
.byte 35, 5, 25
.byte 35, 6, 25
.byte 35, 7, 25
.byte 35, 15, 25
.byte 35, 1, 25
.byte 35, 2, 26
.byte 35, 3, 26
.byte 35, 4, 26
.byte 35, 5, 26
.byte 35, 6, 26
.byte 35, 7, 26
.byte 35, 15, 26
.byte 35, 1, 26
.byte 35, 2, 27
.byte 35, 3, 27
.byte 35, 4, 27
.byte 35, 5, 27
.byte 35, 6, 27
.byte 35, 7, 27
.byte 35, 15, 27
.byte 35, 1, 27

.endif
| 498 opcode functions generated
