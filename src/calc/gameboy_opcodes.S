.global jump_table
.global opcode_table
.global jump_table2
.global suffix_table
.global size_table
.global generate_int

.extern io_read
.extern io_write

.include "gbasm.h"

.data
opcode_start:
opcode0048:
	move.b (%a5, 2), (%a5, 3)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0048_end - opcode0048 + (18432)
opcode0048_end: | LD C, B
opcode0050:
	move.b (%a5, 2), (%a5, 4)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0050_end - opcode0050 + (20480)
opcode0050_end: | LD D, B
opcode0058:
	move.b (%a5, 2), (%a5, 5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0058_end - opcode0058 + (22528)
opcode0058_end: | LD E, B
opcode0060:
	move.b (%a5, 2), (%a5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0060_end - opcode0060 + (24576)
opcode0060_end: | LD H, B
opcode0068:
	move.b (%a5, 2), (%a5, 1)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0068_end - opcode0068 + (26624)
opcode0068_end: | LD L, B
opcode0070:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0000
	move.b (%a5, 2), %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable0000:
	move.b (%a5, 2), (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0070_end - opcode0070 + (28672)
opcode0070_end: | LD (HL), B
opcode0078:
	move.b (%a5, 2), %d5
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0078_end - opcode0078 + (30720)
opcode0078_end: | LD A, B
opcode0041:
	move.b (%a5, 3), (%a5, 2)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0041_end - opcode0041 + (16640)
opcode0041_end: | LD B, C
opcode0051:
	move.b (%a5, 3), (%a5, 4)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0051_end - opcode0051 + (20736)
opcode0051_end: | LD D, C
opcode0059:
	move.b (%a5, 3), (%a5, 5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0059_end - opcode0059 + (22784)
opcode0059_end: | LD E, C
opcode0061:
	move.b (%a5, 3), (%a5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0061_end - opcode0061 + (24832)
opcode0061_end: | LD H, C
opcode0069:
	move.b (%a5, 3), (%a5, 1)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0069_end - opcode0069 + (26880)
opcode0069_end: | LD L, C
opcode0071:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0001
	move.b (%a5, 3), %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable0001:
	move.b (%a5, 3), (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0071_end - opcode0071 + (28928)
opcode0071_end: | LD (HL), C
opcode0079:
	move.b (%a5, 3), %d5
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0079_end - opcode0079 + (30976)
opcode0079_end: | LD A, C
opcode0042:
	move.b (%a5, 4), (%a5, 2)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0042_end - opcode0042 + (16896)
opcode0042_end: | LD B, D
opcode004A:
	move.b (%a5, 4), (%a5, 3)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode004A_end - opcode004A + (18944)
opcode004A_end: | LD C, D
opcode005A:
	move.b (%a5, 4), (%a5, 5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode005A_end - opcode005A + (23040)
opcode005A_end: | LD E, D
opcode0062:
	move.b (%a5, 4), (%a5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0062_end - opcode0062 + (25088)
opcode0062_end: | LD H, D
opcode006A:
	move.b (%a5, 4), (%a5, 1)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode006A_end - opcode006A + (27136)
opcode006A_end: | LD L, D
opcode0072:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0002
	move.b (%a5, 4), %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable0002:
	move.b (%a5, 4), (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0072_end - opcode0072 + (29184)
opcode0072_end: | LD (HL), D
opcode007A:
	move.b (%a5, 4), %d5
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode007A_end - opcode007A + (31232)
opcode007A_end: | LD A, D
opcode0043:
	move.b (%a5, 5), (%a5, 2)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0043_end - opcode0043 + (17152)
opcode0043_end: | LD B, E
opcode004B:
	move.b (%a5, 5), (%a5, 3)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode004B_end - opcode004B + (19200)
opcode004B_end: | LD C, E
opcode0053:
	move.b (%a5, 5), (%a5, 4)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0053_end - opcode0053 + (21248)
opcode0053_end: | LD D, E
opcode0063:
	move.b (%a5, 5), (%a5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0063_end - opcode0063 + (25344)
opcode0063_end: | LD H, E
opcode006B:
	move.b (%a5, 5), (%a5, 1)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode006B_end - opcode006B + (27392)
opcode006B_end: | LD L, E
opcode0073:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0003
	move.b (%a5, 5), %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable0003:
	move.b (%a5, 5), (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0073_end - opcode0073 + (29440)
opcode0073_end: | LD (HL), E
opcode007B:
	move.b (%a5, 5), %d5
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode007B_end - opcode007B + (31488)
opcode007B_end: | LD A, E
opcode0044:
	move.b (%a5), (%a5, 2)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0044_end - opcode0044 + (17408)
opcode0044_end: | LD B, H
opcode004C:
	move.b (%a5), (%a5, 3)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode004C_end - opcode004C + (19456)
opcode004C_end: | LD C, H
opcode0054:
	move.b (%a5), (%a5, 4)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0054_end - opcode0054 + (21504)
opcode0054_end: | LD D, H
opcode005C:
	move.b (%a5), (%a5, 5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode005C_end - opcode005C + (23552)
opcode005C_end: | LD E, H
opcode006C:
	move.b (%a5), (%a5, 1)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode006C_end - opcode006C + (27648)
opcode006C_end: | LD L, H
opcode0074:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0004
	move.b (%a5), %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable0004:
	move.b (%a5), (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0074_end - opcode0074 + (29696)
opcode0074_end: | LD (HL), H
opcode007C:
	move.b (%a5), %d5
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode007C_end - opcode007C + (31744)
opcode007C_end: | LD A, H
opcode0045:
	move.b (%a5, 1), (%a5, 2)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0045_end - opcode0045 + (17664)
opcode0045_end: | LD B, L
opcode004D:
	move.b (%a5, 1), (%a5, 3)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode004D_end - opcode004D + (19712)
opcode004D_end: | LD C, L
opcode0055:
	move.b (%a5, 1), (%a5, 4)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0055_end - opcode0055 + (21760)
opcode0055_end: | LD D, L
opcode005D:
	move.b (%a5, 1), (%a5, 5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode005D_end - opcode005D + (23808)
opcode005D_end: | LD E, L
opcode0065:
	move.b (%a5, 1), (%a5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0065_end - opcode0065 + (25856)
opcode0065_end: | LD H, L
opcode0075:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0005
	move.b (%a5, 1), %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable0005:
	move.b (%a5, 1), (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0075_end - opcode0075 + (29952)
opcode0075_end: | LD (HL), L
opcode007D:
	move.b (%a5, 1), %d5
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode007D_end - opcode007D + (32000)
opcode007D_end: | LD A, L
opcode0046:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0046_end - opcode0046 + (17920)
opcode0046_end: | LD B, (HL)
opcode004E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode004E_end - opcode004E + (19968)
opcode004E_end: | LD C, (HL)
opcode0056:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0056_end - opcode0056 + (22016)
opcode0056_end: | LD D, (HL)
opcode005E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode005E_end - opcode005E + (24064)
opcode005E_end: | LD E, (HL)
opcode0066:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0066_end - opcode0066 + (26112)
opcode0066_end: | LD H, (HL)
opcode006E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode006E_end - opcode006E + (28160)
opcode006E_end: | LD L, (HL)
opcode007E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode007E_end - opcode007E + (32256)
opcode007E_end: | LD A, (HL)
opcode0047:
	move.b %d5, (%a5, 2)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0047_end - opcode0047 + (18176)
opcode0047_end: | LD B, A
opcode004F:
	move.b %d5, (%a5, 3)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode004F_end - opcode004F + (20224)
opcode004F_end: | LD C, A
opcode0057:
	move.b %d5, (%a5, 4)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0057_end - opcode0057 + (22272)
opcode0057_end: | LD D, A
opcode005F:
	move.b %d5, (%a5, 5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode005F_end - opcode005F + (24320)
opcode005F_end: | LD E, A
opcode0067:
	move.b %d5, (%a5)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0067_end - opcode0067 + (26368)
opcode0067_end: | LD H, A
opcode006F:
	move.b %d5, (%a5, 1)
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode006F_end - opcode006F + (28416)
opcode006F_end: | LD L, A
opcode0077:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0006
	move.b %d5, %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable0006:
	move.b %d5, (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0077_end - opcode0077 + (30464)
opcode0077_end: | LD (HL), A
opcode0006:
	move.b (%a4)+, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0006_end - opcode0006 + (1536)
opcode0006_end: | LD B, nn
opcode000E:
	move.b (%a4)+, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode000E_end - opcode000E + (3584)
opcode000E_end: | LD C, nn
opcode0016:
	move.b (%a4)+, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0016_end - opcode0016 + (5632)
opcode0016_end: | LD D, nn
opcode001E:
	move.b (%a4)+, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode001E_end - opcode001E + (7680)
opcode001E_end: | LD E, nn
opcode0026:
	move.b (%a4)+, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0026_end - opcode0026 + (9728)
opcode0026_end: | LD H, nn
opcode002E:
	move.b (%a4)+, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode002E_end - opcode002E + (11776)
opcode002E_end: | LD L, nn
opcode0036:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0007
	move.b (%a4)+, %d2
	subq.w #3, %d4
	jmp (%a3, %d1.w)
_lable0007:
	move.b (%a4)+, (%a0, %d0.w)
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode0036_end - opcode0036 + (13824)
opcode0036_end: | LD (HL), nn
opcode003E:
	move.b (%a4)+, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode003E_end - opcode003E + (15872)
opcode003E_end: | LD A, nn
opcode000A:
	move.w (%a5, 2), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode000A_end - opcode000A + (2560)
opcode000A_end: | LD A, (BC)
opcode001A:
	move.w (%a5, 4), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode001A_end - opcode001A + (6656)
opcode001A_end: | LD A, (DE)
opcode0002:
	move.w (%a5, 2), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0008
	move.b %d5, %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable0008:
	move.b %d5, (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0002_end - opcode0002 + (512)
opcode0002_end: | LD (BC), A
opcode0012:
	move.w (%a5, 4), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0009
	move.b %d5, %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable0009:
	move.b %d5, (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0012_end - opcode0012 + (4608)
opcode0012_end: | LD (DE), A
opcode0022:
	move.w (%a5), %d3
	addq.w #1, (%a5)
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable000A
	move.b %d5, %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable000A:
	move.b %d5, (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0022_end - opcode0022 + (8704)
opcode0022_end: | LD (HL)+, A
opcode002A:
	move.w (%a5), %d3
	addq.w #1, (%a5)
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode002A_end - opcode002A + (10752)
opcode002A_end: | LD A, (HL)+
opcode0032:
	move.w (%a5), %d3
	subq.w #1, (%a5)
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable000B
	move.b %d5, %d2
	subq.w #2, %d4
	jmp (%a3, %d1.w)
_lable000B:
	move.b %d5, (%a0, %d0.w)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0032_end - opcode0032 + (12800)
opcode0032_end: | LD (HL)-, A
opcode003A:
	move.w (%a5), %d3
	subq.w #1, (%a5)
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode003A_end - opcode003A + (14848)
opcode003A_end: | LD A, (HL)-
opcode00E0:
	clr.w %d0
	move.b (%a4)+, %d0
	movea.l (MEM_TABLE+2040, %a5), %a0
	subq.w #3, %d4
	move.b %d5, %d2
	move.w %d0, %d1
	add.w %d1, %d1
	lea io_write_table:l, %a1
	movea.w (%a1, %d1.w), %a1
	jmp (%a3, %a1.w)
opcode00E0_end: | LD (FF00+nn), A
opcode00E2:
	clr.w %d0
	move.b (%a5, 3), %d0
	movea.l (MEM_TABLE+2040, %a5), %a0
	subq.w #2, %d4
	move.b %d5, %d2
	move.w %d0, %d1
	add.w %d1, %d1
	lea io_write_table:l, %a1
	movea.w (%a1, %d1.w), %a1
	jmp (%a3, %a1.w)
opcode00E2_end: | LD (FF00+C), A
opcode00F0:
	clr.w %d0
	move.b (%a4)+, %d0
	movea.l (MEM_TABLE+2040, %a5), %a0
	move.b (%a0, %d0.w), %d5
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00F0_end - opcode00F0 + (-4096)
opcode00F0_end: | LD A, (FF00+nn)
opcode00F2:
	clr.w %d0
	move.b (%a5, 3), %d0
	movea.l (MEM_TABLE+2040, %a5), %a0
	move.b (%a0, %d0.w), %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00F2_end - opcode00F2 + (-3584)
opcode00F2_end: | LD A, (FF00+C)
opcode00FA:
	clr.w %d0
	clr.w %d3
	move.b (%a4)+, %d0
	move.b (%a4)+, %d3
	lsl.w #3, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d5
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00FA_end - opcode00FA + (-1536)
opcode00FA_end: | LD A, (nnnn)
opcode00EA:
	clr.w %d0
	clr.w %d3
	move.b (%a4)+, %d0
	move.b (%a4)+, %d3
	lsl.w #3, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable000C
	move.b %d5, %d2
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable000C:
	move.b %d5, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00EA_end - opcode00EA + (-5632)
opcode00EA_end: | LD (nnnn), A
opcode0001:
	move.b (%a4)+, (%a5, 3)
	move.b (%a4)+, (%a5, 2)
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode0001_end - opcode0001 + (256)
opcode0001_end: | LD BC, nnnn
opcode0011:
	move.b (%a4)+, (%a5, 5)
	move.b (%a4)+, (%a5, 4)
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode0011_end - opcode0011 + (4352)
opcode0011_end: | LD DE, nnnn
opcode0021:
	move.b (%a4)+, (%a5, 1)
	move.b (%a4)+, (%a5)
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode0021_end - opcode0021 + (8448)
opcode0021_end: | LD HL, nnnn
opcode0031:
	moveq.l #0, %d0
	moveq.l #0, %d2
	move.b (%a4)+, %d0
	move.b (%a4)+, %d2
	cmp.b #0xE0, %d2 | Hack for games with stack at top of RAM
	bne 0f
	subq.b #1, %d2
	move.w #0x100, %d0
0:
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (SP_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a2 | sp points to start of block
	adda.l %d0, %a2 | now sp is correct
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode0031_end - opcode0031 + (12544)
opcode0031_end: | LD SP, nnnn
opcode00F9:
	move.w (%a5), %d2
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | get block index * 8
	move.w %d2, (SP_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a2 | sp points to start of block
	adda.l %d0, %a2 | now sp is correct
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00F9_end - opcode00F9 + (-1792)
opcode00F9_end: | LD SP, HL
opcode00C5:
	move.b (%a5, 2), -(%a2)
	move.b (%a5, 3), -(%a2)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00C5_end - opcode00C5 + (-15104)
opcode00C5_end: | PUSH BC
opcode00D5:
	move.b (%a5, 4), -(%a2)
	move.b (%a5, 5), -(%a2)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00D5_end - opcode00D5 + (-11008)
opcode00D5_end: | PUSH DE
opcode00E5:
	move.b (%a5), -(%a2)
	move.b (%a5, 1), -(%a2)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00E5_end - opcode00E5 + (-6912)
opcode00E5_end: | PUSH HL
opcode00F5:
	clr.b %d2
	btst.b #0, %d6
	beq _lable000D
	bset #4, %d2 | set gb carry
_lable000D:
	btst.b #2, %d7
	beq _lable000E
	bset #7, %d2 | set gb zero
_lable000E:
	btst.b #5, %d7
	beq _lable000F
	bset #6, %d2 | set gb subtract
_lable000F:
	move.b %d5, -(%a2)
	move.b %d2, -(%a2)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00F5_end - opcode00F5 + (-2816)
opcode00F5_end: | PUSH AF
opcode00C1:
	move.b (%a2)+, (%a5, 3)
	move.b (%a2)+, (%a5, 2)
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00C1_end - opcode00C1 + (-16128)
opcode00C1_end: | POP BC
opcode00D1:
	move.b (%a2)+, (%a5, 5)
	move.b (%a2)+, (%a5, 4)
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00D1_end - opcode00D1 + (-12032)
opcode00D1_end: | POP DE
opcode00E1:
	move.b (%a2)+, (%a5, 1)
	move.b (%a2)+, (%a5)
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00E1_end - opcode00E1 + (-7936)
opcode00E1_end: | POP HL
opcode00F1:
	move.b (%a2)+, %d2 | restore flags
	move.b (%a2)+, %d5
	btst.l #4, %d2
	sne %d1
	add.b %d1, %d1
	move.w %sr, %d6
_lable0011:
	btst.l #7, %d2
	seq %d1
	tst.b %d1
	move.w %sr, %d7
	btst.l #6, %d2
	beq _lable0012
	ori.b #0x20, %d7 | set subtract
_lable0012:
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00F1_end - opcode00F1 + (-3840)
opcode00F1_end: | POP AF
opcode0008:
	move.l %a2, %d2
	move.w (SP_BASE, %a5), %d0
	lea (MEM_TABLE, %a5, %d0.w), %a1
	sub.l (%a1), %d2 | sp now relative to block
	lsl.w #5, %d0 | d0 is now block index * 256
	add.l %d0, %d2 | sp is now correct
	clr.w %d0
	clr.w %d3
	move.b (%a4)+, %d0
	move.b (%a4)+, %d3
	lsl.w #3, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.w (%a1), %d1
	beq _lable0013
	subq.w #5, %d4
	move.l (NEXT_EVENT, %a5), (SAVE_EVENT_MEM16, %a5)
	move.w %d4, (SAVE_COUNT_MEM16, %a5)
	move.l #write16_finish, (NEXT_EVENT, %a5)
	moveq #-1, %d4
	jmp (%a3, %d1.w)
_lable0013:
	move.b %d2, (%a0, %d0.w)
	rol.w #8, %d2
	move.b %d2, (1, %a0, %d0.w)
	subq.w #5, %d4
	NEXT_INSTRUCTION opcode0008_end - opcode0008 + (2048)
opcode0008_end: | LD (nnnn), SP
opcode00F8:
	move.l %a2, %d2
	move.w (SP_BASE, %a5), %d0
	lea (MEM_TABLE, %a5, %d0.w), %a1
	sub.l (%a1), %d2 | sp now relative to block
	lsl.w #5, %d0 | d0 is now block index * 256
	add.l %d0, %d2 | sp is now correct
	move.b (%a4)+, %d1
	ext.w %d1
	move.w %d1, (LAST_SRC, %a5)
	move.w %d2, (LAST_DST, %a5)
	add.w %d1, %d2
	move.w %sr, %d6 | update carry
	move.b #0x40, %d7 | set 16 bit add, clear subtract/zero flag
	move.w %d2, (%a5)
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00F8_end - opcode00F8 + (-2048)
opcode00F8_end: | LD HL, SP+nn
opcode0080:
	move.b (%a5, 2), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	add.b (%a5, 2), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION 20+NEXT_INSTRUCTION_SIZE + (-32768)
opcode0080_end: | ADD A, B
opcode0081:
	move.b (%a5, 3), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	add.b (%a5, 3), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0081_end - opcode0081 + (-32512)
opcode0081_end: | ADD A, C
opcode0082:
	move.b (%a5, 4), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	add.b (%a5, 4), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0082_end - opcode0082 + (-32256)
opcode0082_end: | ADD A, D
opcode0083:
	move.b (%a5, 5), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	add.b (%a5, 5), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0083_end - opcode0083 + (-32000)
opcode0083_end: | ADD A, E
opcode0084:
	move.b (%a5), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	add.b (%a5), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0084_end - opcode0084 + (-31744)
opcode0084_end: | ADD A, H
opcode0085:
	move.b (%a5, 1), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	add.b (%a5, 1), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0085_end - opcode0085 + (-31488)
opcode0085_end: | ADD A, L
opcode0086:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	add.b (%a0, %d0.w), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0086_end - opcode0086 + (-31232)
opcode0086_end: | ADD A, (HL)
opcode0087:
	move.b %d5, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	add.b %d5, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0087_end - opcode0087 + (-30976)
opcode0087_end: | ADD A, A
opcode00C6:
	move.b (%a4), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	add.b (%a4)+, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00C6_end - opcode00C6 + (-14848)
opcode00C6_end: | ADD A, nn
opcode0088:
	move.b (%a5, 2), %d0
	btst #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	addx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x80, %d7
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0088_end - opcode0088 + (-30720)
opcode0088_end: | ADC A, B
opcode0089:
	move.b (%a5, 3), %d0
	btst #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	addx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x80, %d7
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0089_end - opcode0089 + (-30464)
opcode0089_end: | ADC A, C
opcode008A:
	move.b (%a5, 4), %d0
	btst #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	addx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x80, %d7
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode008A_end - opcode008A + (-30208)
opcode008A_end: | ADC A, D
opcode008B:
	move.b (%a5, 5), %d0
	btst #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	addx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x80, %d7
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode008B_end - opcode008B + (-29952)
opcode008B_end: | ADC A, E
opcode008C:
	move.b (%a5), %d0
	btst #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	addx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x80, %d7
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode008C_end - opcode008C + (-29696)
opcode008C_end: | ADC A, H
opcode008D:
	move.b (%a5, 1), %d0
	btst #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	addx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x80, %d7
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode008D_end - opcode008D + (-29440)
opcode008D_end: | ADC A, L
opcode008E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d0
	btst #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	addx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x80, %d7
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode008E_end - opcode008E + (-29184)
opcode008E_end: | ADC A, (HL)
opcode008F:
	move.b %d5, %d0
	btst #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	addx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x80, %d7
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode008F_end - opcode008F + (-28928)
opcode008F_end: | ADC A, A
opcode00CE:
	move.b (%a4)+, %d0
	btst #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	addx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x80, %d7
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00CE_end - opcode00CE + (-12800)
opcode00CE_end: | ADC A, nn
opcode0090:
	move.b (%a5, 2), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	sub.b (%a5, 2), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x20, %d7 | set subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0090_end - opcode0090 + (-28672)
opcode0090_end: | SUB A, B
opcode0091:
	move.b (%a5, 3), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	sub.b (%a5, 3), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x20, %d7 | set subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0091_end - opcode0091 + (-28416)
opcode0091_end: | SUB A, C
opcode0092:
	move.b (%a5, 4), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	sub.b (%a5, 4), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x20, %d7 | set subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0092_end - opcode0092 + (-28160)
opcode0092_end: | SUB A, D
opcode0093:
	move.b (%a5, 5), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	sub.b (%a5, 5), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x20, %d7 | set subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0093_end - opcode0093 + (-27904)
opcode0093_end: | SUB A, E
opcode0094:
	move.b (%a5), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	sub.b (%a5), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x20, %d7 | set subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0094_end - opcode0094 + (-27648)
opcode0094_end: | SUB A, H
opcode0095:
	move.b (%a5, 1), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	sub.b (%a5, 1), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x20, %d7 | set subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0095_end - opcode0095 + (-27392)
opcode0095_end: | SUB A, L
opcode0096:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	sub.b (%a0, %d0.w), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x20, %d7 | set subtract
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0096_end - opcode0096 + (-27136)
opcode0096_end: | SUB A, (HL)
opcode0097:
	move.b %d5, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	sub.b %d5, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x20, %d7 | set subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0097_end - opcode0097 + (-26880)
opcode0097_end: | SUB A, A
opcode00D6:
	move.b (%a4), (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	sub.b (%a4)+, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0x20, %d7 | set subtract
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00D6_end - opcode00D6 + (-10752)
opcode00D6_end: | SUB A, nn
opcode0098:
	move.b (%a5, 2), %d0
	btst.b #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	subx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0xA0, %d7 | set subtract, specify carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0098_end - opcode0098 + (-26624)
opcode0098_end: | SBC A, B
opcode0099:
	move.b (%a5, 3), %d0
	btst.b #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	subx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0xA0, %d7 | set subtract, specify carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0099_end - opcode0099 + (-26368)
opcode0099_end: | SBC A, C
opcode009A:
	move.b (%a5, 4), %d0
	btst.b #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	subx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0xA0, %d7 | set subtract, specify carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode009A_end - opcode009A + (-26112)
opcode009A_end: | SBC A, D
opcode009B:
	move.b (%a5, 5), %d0
	btst.b #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	subx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0xA0, %d7 | set subtract, specify carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode009B_end - opcode009B + (-25856)
opcode009B_end: | SBC A, E
opcode009C:
	move.b (%a5), %d0
	btst.b #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	subx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0xA0, %d7 | set subtract, specify carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode009C_end - opcode009C + (-25600)
opcode009C_end: | SBC A, H
opcode009D:
	move.b (%a5, 1), %d0
	btst.b #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	subx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0xA0, %d7 | set subtract, specify carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode009D_end - opcode009D + (-25344)
opcode009D_end: | SBC A, L
opcode009E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d0
	btst.b #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	subx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0xA0, %d7 | set subtract, specify carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode009E_end - opcode009E + (-25088)
opcode009E_end: | SBC A, (HL)
opcode009F:
	move.b %d5, %d0
	btst.b #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	subx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0xA0, %d7 | set subtract, specify carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode009F_end - opcode009F + (-24832)
opcode009F_end: | SBC A, A
opcode00DE:
	move.b (%a4)+, %d0
	btst.b #0, %d6
	sne %d1
	move.b %d0, (LAST_SRC, %a5)
	move.b %d5, (LAST_DST, %a5)
	move.b %d1, (LAST_FLAG, %a5)
	add.b %d1, %d1 | carry to extend
	subx.b %d0, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	ori.b #0xA0, %d7 | set subtract, specify carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00DE_end - opcode00DE + (-8704)
opcode00DE_end: | SBC A, nn
opcode00A0:
	and.b (%a5, 2), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00A0_end - opcode00A0 + (-24576)
opcode00A0_end: | AND A, B
opcode00A1:
	and.b (%a5, 3), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00A1_end - opcode00A1 + (-24320)
opcode00A1_end: | AND A, C
opcode00A2:
	and.b (%a5, 4), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00A2_end - opcode00A2 + (-24064)
opcode00A2_end: | AND A, D
opcode00A3:
	and.b (%a5, 5), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00A3_end - opcode00A3 + (-23808)
opcode00A3_end: | AND A, E
opcode00A4:
	and.b (%a5), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00A4_end - opcode00A4 + (-23552)
opcode00A4_end: | AND A, H
opcode00A5:
	and.b (%a5, 1), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00A5_end - opcode00A5 + (-23296)
opcode00A5_end: | AND A, L
opcode00A6:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	and.b (%a0, %d0.w), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00A6_end - opcode00A6 + (-23040)
opcode00A6_end: | AND A, (HL)
opcode00A7:
	and.b %d5, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00A7_end - opcode00A7 + (-22784)
opcode00A7_end: | AND A, A
opcode00E6:
	and.b (%a4)+, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00E6_end - opcode00E6 + (-6656)
opcode00E6_end: | AND A, nn
opcode00B0:
	or.b (%a5, 2), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00B0_end - opcode00B0 + (-20480)
opcode00B0_end: | OR A, B
opcode00B1:
	or.b (%a5, 3), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00B1_end - opcode00B1 + (-20224)
opcode00B1_end: | OR A, C
opcode00B2:
	or.b (%a5, 4), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00B2_end - opcode00B2 + (-19968)
opcode00B2_end: | OR A, D
opcode00B3:
	or.b (%a5, 5), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00B3_end - opcode00B3 + (-19712)
opcode00B3_end: | OR A, E
opcode00B4:
	or.b (%a5), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00B4_end - opcode00B4 + (-19456)
opcode00B4_end: | OR A, H
opcode00B5:
	or.b (%a5, 1), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00B5_end - opcode00B5 + (-19200)
opcode00B5_end: | OR A, L
opcode00B6:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	or.b (%a0, %d0.w), %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00B6_end - opcode00B6 + (-18944)
opcode00B6_end: | OR A, (HL)
opcode00B7:
	or.b %d5, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00B7_end - opcode00B7 + (-18688)
opcode00B7_end: | OR A, A
opcode00F6:
	or.b (%a4)+, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00F6_end - opcode00F6 + (-2560)
opcode00F6_end: | OR A, nn
opcode00A8:
	move.b (%a5, 2), %d1
	eor.b %d1, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00A8_end - opcode00A8 + (-22528)
opcode00A8_end: | XOR A, B
opcode00A9:
	move.b (%a5, 3), %d1
	eor.b %d1, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00A9_end - opcode00A9 + (-22272)
opcode00A9_end: | XOR A, C
opcode00AA:
	move.b (%a5, 4), %d1
	eor.b %d1, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00AA_end - opcode00AA + (-22016)
opcode00AA_end: | XOR A, D
opcode00AB:
	move.b (%a5, 5), %d1
	eor.b %d1, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00AB_end - opcode00AB + (-21760)
opcode00AB_end: | XOR A, E
opcode00AC:
	move.b (%a5), %d1
	eor.b %d1, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00AC_end - opcode00AC + (-21504)
opcode00AC_end: | XOR A, H
opcode00AD:
	move.b (%a5, 1), %d1
	eor.b %d1, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00AD_end - opcode00AD + (-21248)
opcode00AD_end: | XOR A, L
opcode00AE:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d1
	eor.b %d1, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00AE_end - opcode00AE + (-20992)
opcode00AE_end: | XOR A, (HL)
opcode00AF:
	eor.b %d5, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00AF_end - opcode00AF + (-20736)
opcode00AF_end: | XOR A, A
opcode00EE:
	move.b (%a4)+, %d1
	eor.b %d1, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00EE_end - opcode00EE + (-4608)
opcode00EE_end: | XOR A, nn
opcode00B8:
	cmp.b (%a5, 2), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00B8_end - opcode00B8 + (-18432)
opcode00B8_end: | CP A, B
opcode00B9:
	cmp.b (%a5, 3), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00B9_end - opcode00B9 + (-18176)
opcode00B9_end: | CP A, C
opcode00BA:
	cmp.b (%a5, 4), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00BA_end - opcode00BA + (-17920)
opcode00BA_end: | CP A, D
opcode00BB:
	cmp.b (%a5, 5), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00BB_end - opcode00BB + (-17664)
opcode00BB_end: | CP A, E
opcode00BC:
	cmp.b (%a5), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00BC_end - opcode00BC + (-17408)
opcode00BC_end: | CP A, H
opcode00BD:
	cmp.b (%a5, 1), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00BD_end - opcode00BD + (-17152)
opcode00BD_end: | CP A, L
opcode00BE:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	cmp.b (%a0, %d0.w), %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00BE_end - opcode00BE + (-16896)
opcode00BE_end: | CP A, (HL)
opcode00BF:
	cmp.b %d5, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00BF_end - opcode00BF + (-16640)
opcode00BF_end: | CP A, A
opcode00FE:
	cmp.b (%a4)+, %d5
	move.w %sr, %d7 | update zero
	move.w %sr, %d6 | update carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00FE_end - opcode00FE + (-512)
opcode00FE_end: | CP A, nn
opcode0004:
	addq.b #1, (%a5, 2)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0004_end - opcode0004 + (1024)
opcode0004_end: | INC B
opcode000C:
	addq.b #1, (%a5, 3)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode000C_end - opcode000C + (3072)
opcode000C_end: | INC C
opcode0014:
	addq.b #1, (%a5, 4)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0014_end - opcode0014 + (5120)
opcode0014_end: | INC D
opcode001C:
	addq.b #1, (%a5, 5)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode001C_end - opcode001C + (7168)
opcode001C_end: | INC E
opcode0024:
	addq.b #1, (%a5)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0024_end - opcode0024 + (9216)
opcode0024_end: | INC H
opcode002C:
	addq.b #1, (%a5, 1)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode002C_end - opcode002C + (11264)
opcode002C_end: | INC L
opcode0034:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	addq.b #1, %d2
	move.w %sr, %d7 | update zero
	move.w (%a1), %d1
	beq _lable0014
	subq.w #3, %d4
	jmp (%a3, %d1.w)
_lable0014:
	move.b %d2, (%a0, %d0.w)
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode0034_end - opcode0034 + (13312)
opcode0034_end: | INC (HL)
opcode003C:
	addq.b #1, %d5
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode003C_end - opcode003C + (15360)
opcode003C_end: | INC A
opcode0005:
	subq.b #1, (%a5, 2)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0005_end - opcode0005 + (1280)
opcode0005_end: | DEC B
opcode000D:
	subq.b #1, (%a5, 3)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode000D_end - opcode000D + (3328)
opcode000D_end: | DEC C
opcode0015:
	subq.b #1, (%a5, 4)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0015_end - opcode0015 + (5376)
opcode0015_end: | DEC D
opcode001D:
	subq.b #1, (%a5, 5)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode001D_end - opcode001D + (7424)
opcode001D_end: | DEC E
opcode0025:
	subq.b #1, (%a5)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0025_end - opcode0025 + (9472)
opcode0025_end: | DEC H
opcode002D:
	subq.b #1, (%a5, 1)
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode002D_end - opcode002D + (11520)
opcode002D_end: | DEC L
opcode0035:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	subq.b #1, %d2
	move.w %sr, %d7 | update zero
	move.w (%a1), %d1
	beq _lable0015
	subq.w #3, %d4
	jmp (%a3, %d1.w)
_lable0015:
	move.b %d2, (%a0, %d0.w)
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode0035_end - opcode0035 + (13568)
opcode0035_end: | DEC (HL)
opcode003D:
	subq.b #1, %d5
	move.w %sr, %d7 | update zero
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode003D_end - opcode003D + (15616)
opcode003D_end: | DEC A
opcode002F:
	not.b %d5
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode002F_end - opcode002F + (12032)
opcode002F_end: | CPL
opcode003F:
	not.b %d6
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode003F_end - opcode003F + (16128)
opcode003F_end: | CCF
opcode0037:
	st %d6
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0037_end - opcode0037 + (14080)
opcode0037_end: | SCF
opcode00F3:
	bclr #31, %d7
	move.l (NEXT_EVENT, %a5), %a0
	cmpa.l #enable_intr_func, %a0
	bne 0f
	move.l (SAVE_EVENT_EI, %a5), (NEXT_EVENT, %a5)
	move.w (SAVE_COUNT_EI, %a5), %d4
0:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00F3_end - opcode00F3 + (-3328)
opcode00F3_end: | DI
opcode00FB:
	subq.w #1, %d4
	movea.l (NEXT_EVENT, %a5), %a0
	cmpa.l #enable_intr_func, %a0
	bne _lable0016
	tst.w %d4
	NEXT_INSTRUCTION _lable0016 - opcode00FB + (-1280)
_lable0016:
	move.w %d4, (SAVE_COUNT_EI, %a5)
	move.l (NEXT_EVENT, %a5), (SAVE_EVENT_EI, %a5)
	move.l #enable_intr_func, (NEXT_EVENT, %a5)
	moveq #0, %d4
	NEXT_INSTRUCTION opcode00FB_end - opcode00FB + (-1280)
opcode00FB_end: | EI
opcode0009:
	move.w (%a5, 2), %d1
	add.w %d1, (%a5)
	move.w %sr, %d6 | update carry
	ori #0x40, %d7 | set 16bit add
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0009_end - opcode0009 + (2304)
opcode0009_end: | ADD HL, BC
opcode0019:
	move.w (%a5, 4), %d1
	add.w %d1, (%a5)
	move.w %sr, %d6 | update carry
	ori #0x40, %d7 | set 16bit add
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0019_end - opcode0019 + (6400)
opcode0019_end: | ADD HL, DE
opcode0029:
	move.w (%a5), %d1
	add.w %d1, (%a5)
	move.w %sr, %d6 | update carry
	ori #0x40, %d7 | set 16bit add
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0029_end - opcode0029 + (10496)
opcode0029_end: | ADD HL, HL
opcode0039:
	move.l %a2, %d1
	move.w (SP_BASE, %a5), %d0
	lea (MEM_TABLE, %a5, %d0.w), %a1
	sub.l (%a1), %d1 | sp now relative to block
	lsl.w #5, %d0 | d0 is now block index * 256
	add.l %d0, %d1 | sp is now correct
	add.w %d1, (%a5)
	move.w %sr, %d6 | update carry
	ori #0x40, %d7 | set 16bit add
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0039_end - opcode0039 + (14592)
opcode0039_end: | ADD HL, SP
opcode00E8:
	move.b (%a4)+, %d0
	ext.w %d0
	ext.l %d0
	adda.l %d0, %a2
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00E8_end - opcode00E8 + (-6144)
opcode00E8_end: | ADD SP, nn
opcode0003:
	addq.w #1, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0003_end - opcode0003 + (768)
opcode0003_end: | INC BC
opcode0013:
	addq.w #1, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0013_end - opcode0013 + (4864)
opcode0013_end: | INC DE
opcode0023:
	addq.w #1, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0023_end - opcode0023 + (8960)
opcode0023_end: | INC HL
opcode0033:
	adda.l #1, %a2
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0033_end - opcode0033 + (13056)
opcode0033_end: | INC SP
opcode000B:
	subq.w #1, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode000B_end - opcode000B + (2816)
opcode000B_end: | DEC BC
opcode001B:
	subq.w #1, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode001B_end - opcode001B + (6912)
opcode001B_end: | DEC DE
opcode002B:
	subq.w #1, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode002B_end - opcode002B + (11008)
opcode002B_end: | DEC HL
opcode003B:
	suba.l #1, %a2
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode003B_end - opcode003B + (15104)
opcode003B_end: | DEC SP
opcode0007:
	rol.b #1, %d5
	move.w %sr, %d6 | update carry
	clr.b %d7 | clear zero/subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0007_end - opcode0007 + (1792)
opcode0007_end: | RLCA
opcode0017:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	roxl.b #1, %d5
	move.w %sr, %d6 | update carry
	clr.b %d7 | clear zero/subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0017_end - opcode0017 + (5888)
opcode0017_end: | RLA
opcode000F:
	ror.b #1, %d5
	move.w %sr, %d6 | update carry
	clr.b %d7 | clear zero/subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode000F_end - opcode000F + (3840)
opcode000F_end: | RRCA
opcode001F:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	roxr.b #1, %d5
	move.w %sr, %d6 | update carry
	clr.b %d7 | clear zero/subtract
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode001F_end - opcode001F + (7936)
opcode001F_end: | RRA
opcodeCB00:
	move.b (%a5, 2), %d2
	rol.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB00_end - opcodeCB00 + (180)
opcodeCB00_end: | RLC B
opcodeCB01:
	move.b (%a5, 3), %d2
	rol.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB01_end - opcodeCB01 + (436)
opcodeCB01_end: | RLC C
opcodeCB02:
	move.b (%a5, 4), %d2
	rol.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB02_end - opcodeCB02 + (692)
opcodeCB02_end: | RLC D
opcodeCB03:
	move.b (%a5, 5), %d2
	rol.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB03_end - opcodeCB03 + (948)
opcodeCB03_end: | RLC E
opcodeCB04:
	move.b (%a5), %d2
	rol.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB04_end - opcodeCB04 + (1204)
opcodeCB04_end: | RLC H
opcodeCB05:
	move.b (%a5, 1), %d2
	rol.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB05_end - opcodeCB05 + (1460)
opcodeCB05_end: | RLC L
opcodeCB06:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	rol.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.w (%a1), %d1
	beq _lable0017
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0017:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB06_end - opcodeCB06 + (1716)
opcodeCB06_end: | RLC (HL)
opcodeCB07:
	rol.b #1, %d5
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB07_end - opcodeCB07 + (1972)
opcodeCB07_end: | RLC A
opcodeCB10:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5, 2), %d2
	roxl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB10_end - opcodeCB10 + (4276)
opcodeCB10_end: | RL B
opcodeCB11:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5, 3), %d2
	roxl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB11_end - opcodeCB11 + (4532)
opcodeCB11_end: | RL C
opcodeCB12:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5, 4), %d2
	roxl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB12_end - opcodeCB12 + (4788)
opcodeCB12_end: | RL D
opcodeCB13:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5, 5), %d2
	roxl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB13_end - opcodeCB13 + (5044)
opcodeCB13_end: | RL E
opcodeCB14:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5), %d2
	roxl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB14_end - opcodeCB14 + (5300)
opcodeCB14_end: | RL H
opcodeCB15:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5, 1), %d2
	roxl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB15_end - opcodeCB15 + (5556)
opcodeCB15_end: | RL L
opcodeCB16:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	roxl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.w (%a1), %d1
	beq _lable0018
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0018:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB16_end - opcodeCB16 + (5812)
opcodeCB16_end: | RL (HL)
opcodeCB17:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	roxl.b #1, %d5
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB17_end - opcodeCB17 + (6068)
opcodeCB17_end: | RL A
opcodeCB08:
	move.b (%a5, 2), %d2
	ror.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB08_end - opcodeCB08 + (2228)
opcodeCB08_end: | RRC B
opcodeCB09:
	move.b (%a5, 3), %d2
	ror.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB09_end - opcodeCB09 + (2484)
opcodeCB09_end: | RRC C
opcodeCB0A:
	move.b (%a5, 4), %d2
	ror.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB0A_end - opcodeCB0A + (2740)
opcodeCB0A_end: | RRC D
opcodeCB0B:
	move.b (%a5, 5), %d2
	ror.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB0B_end - opcodeCB0B + (2996)
opcodeCB0B_end: | RRC E
opcodeCB0C:
	move.b (%a5), %d2
	ror.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB0C_end - opcodeCB0C + (3252)
opcodeCB0C_end: | RRC H
opcodeCB0D:
	move.b (%a5, 1), %d2
	ror.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB0D_end - opcodeCB0D + (3508)
opcodeCB0D_end: | RRC L
opcodeCB0E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	ror.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.w (%a1), %d1
	beq _lable0019
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0019:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB0E_end - opcodeCB0E + (3764)
opcodeCB0E_end: | RRC (HL)
opcodeCB0F:
	ror.b #1, %d5
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB0F_end - opcodeCB0F + (4020)
opcodeCB0F_end: | RRC A
opcodeCB18:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5, 2), %d2
	roxr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB18_end - opcodeCB18 + (6324)
opcodeCB18_end: | RR B
opcodeCB19:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5, 3), %d2
	roxr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB19_end - opcodeCB19 + (6580)
opcodeCB19_end: | RR C
opcodeCB1A:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5, 4), %d2
	roxr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB1A_end - opcodeCB1A + (6836)
opcodeCB1A_end: | RR D
opcodeCB1B:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5, 5), %d2
	roxr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB1B_end - opcodeCB1B + (7092)
opcodeCB1B_end: | RR E
opcodeCB1C:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5), %d2
	roxr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB1C_end - opcodeCB1C + (7348)
opcodeCB1C_end: | RR H
opcodeCB1D:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	move.b (%a5, 1), %d2
	roxr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB1D_end - opcodeCB1D + (7604)
opcodeCB1D_end: | RR L
opcodeCB1E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	roxr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.w (%a1), %d1
	beq _lable001A
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable001A:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB1E_end - opcodeCB1E + (7860)
opcodeCB1E_end: | RR (HL)
opcodeCB1F:
	btst.b #0, %d6 | copy carry to extend
	sne %d1
	add.b %d1, %d1
	roxr.b #1, %d5
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB1F_end - opcodeCB1F + (8116)
opcodeCB1F_end: | RR A
opcodeCB20:
	move.b (%a5, 2), %d2
	asl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB20_end - opcodeCB20 + (8372)
opcodeCB20_end: | SLA B
opcodeCB21:
	move.b (%a5, 3), %d2
	asl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB21_end - opcodeCB21 + (8628)
opcodeCB21_end: | SLA C
opcodeCB22:
	move.b (%a5, 4), %d2
	asl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB22_end - opcodeCB22 + (8884)
opcodeCB22_end: | SLA D
opcodeCB23:
	move.b (%a5, 5), %d2
	asl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB23_end - opcodeCB23 + (9140)
opcodeCB23_end: | SLA E
opcodeCB24:
	move.b (%a5), %d2
	asl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB24_end - opcodeCB24 + (9396)
opcodeCB24_end: | SLA H
opcodeCB25:
	move.b (%a5, 1), %d2
	asl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB25_end - opcodeCB25 + (9652)
opcodeCB25_end: | SLA L
opcodeCB26:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	asl.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.w (%a1), %d1
	beq _lable001B
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable001B:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB26_end - opcodeCB26 + (9908)
opcodeCB26_end: | SLA (HL)
opcodeCB27:
	asl.b #1, %d5
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB27_end - opcodeCB27 + (10164)
opcodeCB27_end: | SLA A
opcodeCB28:
	move.b (%a5, 2), %d2
	asr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB28_end - opcodeCB28 + (10420)
opcodeCB28_end: | SRA B
opcodeCB29:
	move.b (%a5, 3), %d2
	asr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB29_end - opcodeCB29 + (10676)
opcodeCB29_end: | SRA C
opcodeCB2A:
	move.b (%a5, 4), %d2
	asr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB2A_end - opcodeCB2A + (10932)
opcodeCB2A_end: | SRA D
opcodeCB2B:
	move.b (%a5, 5), %d2
	asr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB2B_end - opcodeCB2B + (11188)
opcodeCB2B_end: | SRA E
opcodeCB2C:
	move.b (%a5), %d2
	asr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB2C_end - opcodeCB2C + (11444)
opcodeCB2C_end: | SRA H
opcodeCB2D:
	move.b (%a5, 1), %d2
	asr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB2D_end - opcodeCB2D + (11700)
opcodeCB2D_end: | SRA L
opcodeCB2E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	asr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.w (%a1), %d1
	beq _lable001C
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable001C:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB2E_end - opcodeCB2E + (11956)
opcodeCB2E_end: | SRA (HL)
opcodeCB2F:
	asr.b #1, %d5
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB2F_end - opcodeCB2F + (12212)
opcodeCB2F_end: | SRA A
opcodeCB38:
	move.b (%a5, 2), %d2
	lsr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB38_end - opcodeCB38 + (14516)
opcodeCB38_end: | SRL B
opcodeCB39:
	move.b (%a5, 3), %d2
	lsr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB39_end - opcodeCB39 + (14772)
opcodeCB39_end: | SRL C
opcodeCB3A:
	move.b (%a5, 4), %d2
	lsr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB3A_end - opcodeCB3A + (15028)
opcodeCB3A_end: | SRL D
opcodeCB3B:
	move.b (%a5, 5), %d2
	lsr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB3B_end - opcodeCB3B + (15284)
opcodeCB3B_end: | SRL E
opcodeCB3C:
	move.b (%a5), %d2
	lsr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB3C_end - opcodeCB3C + (15540)
opcodeCB3C_end: | SRL H
opcodeCB3D:
	move.b (%a5, 1), %d2
	lsr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.b %d2, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB3D_end - opcodeCB3D + (15796)
opcodeCB3D_end: | SRL L
opcodeCB3E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	lsr.b #1, %d2
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	move.w (%a1), %d1
	beq _lable001D
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable001D:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB3E_end - opcodeCB3E + (16052)
opcodeCB3E_end: | SRL (HL)
opcodeCB3F:
	lsr.b #1, %d5
	move.w %sr, %d6 | update carry
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB3F_end - opcodeCB3F + (16308)
opcodeCB3F_end: | SRL A
opcodeCB40:
	btst.b #0, (%a5, 2)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB40_end - opcodeCB40 + (16564)
opcodeCB40_end: | BIT B, 0
opcodeCB41:
	btst.b #0, (%a5, 3)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB41_end - opcodeCB41 + (16820)
opcodeCB41_end: | BIT C, 0
opcodeCB42:
	btst.b #0, (%a5, 4)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB42_end - opcodeCB42 + (17076)
opcodeCB42_end: | BIT D, 0
opcodeCB43:
	btst.b #0, (%a5, 5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB43_end - opcodeCB43 + (17332)
opcodeCB43_end: | BIT E, 0
opcodeCB44:
	btst.b #0, (%a5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB44_end - opcodeCB44 + (17588)
opcodeCB44_end: | BIT H, 0
opcodeCB45:
	btst.b #0, (%a5, 1)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB45_end - opcodeCB45 + (17844)
opcodeCB45_end: | BIT L, 0
opcodeCB46:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	btst.b #0, (%a0, %d0.w)
	move.w %sr, %d7 | update zero
	subq.w #3, %d4
	NEXT_INSTRUCTION opcodeCB46_end - opcodeCB46 + (18100)
opcodeCB46_end: | BIT (HL), 0
opcodeCB47:
	btst.b #0, %d5
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB47_end - opcodeCB47 + (18356)
opcodeCB47_end: | BIT A, 0
opcodeCB48:
	btst.b #1, (%a5, 2)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB48_end - opcodeCB48 + (18612)
opcodeCB48_end: | BIT B, 1
opcodeCB49:
	btst.b #1, (%a5, 3)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB49_end - opcodeCB49 + (18868)
opcodeCB49_end: | BIT C, 1
opcodeCB4A:
	btst.b #1, (%a5, 4)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB4A_end - opcodeCB4A + (19124)
opcodeCB4A_end: | BIT D, 1
opcodeCB4B:
	btst.b #1, (%a5, 5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB4B_end - opcodeCB4B + (19380)
opcodeCB4B_end: | BIT E, 1
opcodeCB4C:
	btst.b #1, (%a5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB4C_end - opcodeCB4C + (19636)
opcodeCB4C_end: | BIT H, 1
opcodeCB4D:
	btst.b #1, (%a5, 1)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB4D_end - opcodeCB4D + (19892)
opcodeCB4D_end: | BIT L, 1
opcodeCB4E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	btst.b #1, (%a0, %d0.w)
	move.w %sr, %d7 | update zero
	subq.w #3, %d4
	NEXT_INSTRUCTION opcodeCB4E_end - opcodeCB4E + (20148)
opcodeCB4E_end: | BIT (HL), 1
opcodeCB4F:
	btst.b #1, %d5
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB4F_end - opcodeCB4F + (20404)
opcodeCB4F_end: | BIT A, 1
opcodeCB50:
	btst.b #2, (%a5, 2)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB50_end - opcodeCB50 + (20660)
opcodeCB50_end: | BIT B, 2
opcodeCB51:
	btst.b #2, (%a5, 3)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB51_end - opcodeCB51 + (20916)
opcodeCB51_end: | BIT C, 2
opcodeCB52:
	btst.b #2, (%a5, 4)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB52_end - opcodeCB52 + (21172)
opcodeCB52_end: | BIT D, 2
opcodeCB53:
	btst.b #2, (%a5, 5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB53_end - opcodeCB53 + (21428)
opcodeCB53_end: | BIT E, 2
opcodeCB54:
	btst.b #2, (%a5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB54_end - opcodeCB54 + (21684)
opcodeCB54_end: | BIT H, 2
opcodeCB55:
	btst.b #2, (%a5, 1)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB55_end - opcodeCB55 + (21940)
opcodeCB55_end: | BIT L, 2
opcodeCB56:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	btst.b #2, (%a0, %d0.w)
	move.w %sr, %d7 | update zero
	subq.w #3, %d4
	NEXT_INSTRUCTION opcodeCB56_end - opcodeCB56 + (22196)
opcodeCB56_end: | BIT (HL), 2
opcodeCB57:
	btst.b #2, %d5
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB57_end - opcodeCB57 + (22452)
opcodeCB57_end: | BIT A, 2
opcodeCB58:
	btst.b #3, (%a5, 2)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB58_end - opcodeCB58 + (22708)
opcodeCB58_end: | BIT B, 3
opcodeCB59:
	btst.b #3, (%a5, 3)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB59_end - opcodeCB59 + (22964)
opcodeCB59_end: | BIT C, 3
opcodeCB5A:
	btst.b #3, (%a5, 4)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB5A_end - opcodeCB5A + (23220)
opcodeCB5A_end: | BIT D, 3
opcodeCB5B:
	btst.b #3, (%a5, 5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB5B_end - opcodeCB5B + (23476)
opcodeCB5B_end: | BIT E, 3
opcodeCB5C:
	btst.b #3, (%a5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB5C_end - opcodeCB5C + (23732)
opcodeCB5C_end: | BIT H, 3
opcodeCB5D:
	btst.b #3, (%a5, 1)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB5D_end - opcodeCB5D + (23988)
opcodeCB5D_end: | BIT L, 3
opcodeCB5E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	btst.b #3, (%a0, %d0.w)
	move.w %sr, %d7 | update zero
	subq.w #3, %d4
	NEXT_INSTRUCTION opcodeCB5E_end - opcodeCB5E + (24244)
opcodeCB5E_end: | BIT (HL), 3
opcodeCB5F:
	btst.b #3, %d5
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB5F_end - opcodeCB5F + (24500)
opcodeCB5F_end: | BIT A, 3
opcodeCB60:
	btst.b #4, (%a5, 2)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB60_end - opcodeCB60 + (24756)
opcodeCB60_end: | BIT B, 4
opcodeCB61:
	btst.b #4, (%a5, 3)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB61_end - opcodeCB61 + (25012)
opcodeCB61_end: | BIT C, 4
opcodeCB62:
	btst.b #4, (%a5, 4)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB62_end - opcodeCB62 + (25268)
opcodeCB62_end: | BIT D, 4
opcodeCB63:
	btst.b #4, (%a5, 5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB63_end - opcodeCB63 + (25524)
opcodeCB63_end: | BIT E, 4
opcodeCB64:
	btst.b #4, (%a5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB64_end - opcodeCB64 + (25780)
opcodeCB64_end: | BIT H, 4
opcodeCB65:
	btst.b #4, (%a5, 1)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB65_end - opcodeCB65 + (26036)
opcodeCB65_end: | BIT L, 4
opcodeCB66:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	btst.b #4, (%a0, %d0.w)
	move.w %sr, %d7 | update zero
	subq.w #3, %d4
	NEXT_INSTRUCTION opcodeCB66_end - opcodeCB66 + (26292)
opcodeCB66_end: | BIT (HL), 4
opcodeCB67:
	btst.b #4, %d5
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB67_end - opcodeCB67 + (26548)
opcodeCB67_end: | BIT A, 4
opcodeCB68:
	btst.b #5, (%a5, 2)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB68_end - opcodeCB68 + (26804)
opcodeCB68_end: | BIT B, 5
opcodeCB69:
	btst.b #5, (%a5, 3)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB69_end - opcodeCB69 + (27060)
opcodeCB69_end: | BIT C, 5
opcodeCB6A:
	btst.b #5, (%a5, 4)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB6A_end - opcodeCB6A + (27316)
opcodeCB6A_end: | BIT D, 5
opcodeCB6B:
	btst.b #5, (%a5, 5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB6B_end - opcodeCB6B + (27572)
opcodeCB6B_end: | BIT E, 5
opcodeCB6C:
	btst.b #5, (%a5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB6C_end - opcodeCB6C + (27828)
opcodeCB6C_end: | BIT H, 5
opcodeCB6D:
	btst.b #5, (%a5, 1)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB6D_end - opcodeCB6D + (28084)
opcodeCB6D_end: | BIT L, 5
opcodeCB6E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	btst.b #5, (%a0, %d0.w)
	move.w %sr, %d7 | update zero
	subq.w #3, %d4
	NEXT_INSTRUCTION opcodeCB6E_end - opcodeCB6E + (28340)
opcodeCB6E_end: | BIT (HL), 5
opcodeCB6F:
	btst.b #5, %d5
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB6F_end - opcodeCB6F + (28596)
opcodeCB6F_end: | BIT A, 5
opcodeCB70:
	btst.b #6, (%a5, 2)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB70_end - opcodeCB70 + (28852)
opcodeCB70_end: | BIT B, 6
opcodeCB71:
	btst.b #6, (%a5, 3)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB71_end - opcodeCB71 + (29108)
opcodeCB71_end: | BIT C, 6
opcodeCB72:
	btst.b #6, (%a5, 4)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB72_end - opcodeCB72 + (29364)
opcodeCB72_end: | BIT D, 6
opcodeCB73:
	btst.b #6, (%a5, 5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB73_end - opcodeCB73 + (29620)
opcodeCB73_end: | BIT E, 6
opcodeCB74:
	btst.b #6, (%a5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB74_end - opcodeCB74 + (29876)
opcodeCB74_end: | BIT H, 6
opcodeCB75:
	btst.b #6, (%a5, 1)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB75_end - opcodeCB75 + (30132)
opcodeCB75_end: | BIT L, 6
opcodeCB76:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	btst.b #6, (%a0, %d0.w)
	move.w %sr, %d7 | update zero
	subq.w #3, %d4
	NEXT_INSTRUCTION opcodeCB76_end - opcodeCB76 + (30388)
opcodeCB76_end: | BIT (HL), 6
opcodeCB77:
	btst.b #6, %d5
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB77_end - opcodeCB77 + (30644)
opcodeCB77_end: | BIT A, 6
opcodeCB78:
	btst.b #7, (%a5, 2)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB78_end - opcodeCB78 + (30900)
opcodeCB78_end: | BIT B, 7
opcodeCB79:
	btst.b #7, (%a5, 3)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB79_end - opcodeCB79 + (31156)
opcodeCB79_end: | BIT C, 7
opcodeCB7A:
	btst.b #7, (%a5, 4)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB7A_end - opcodeCB7A + (31412)
opcodeCB7A_end: | BIT D, 7
opcodeCB7B:
	btst.b #7, (%a5, 5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB7B_end - opcodeCB7B + (31668)
opcodeCB7B_end: | BIT E, 7
opcodeCB7C:
	btst.b #7, (%a5)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB7C_end - opcodeCB7C + (31924)
opcodeCB7C_end: | BIT H, 7
opcodeCB7D:
	btst.b #7, (%a5, 1)
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB7D_end - opcodeCB7D + (32180)
opcodeCB7D_end: | BIT L, 7
opcodeCB7E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	btst.b #7, (%a0, %d0.w)
	move.w %sr, %d7 | update zero
	subq.w #3, %d4
	NEXT_INSTRUCTION opcodeCB7E_end - opcodeCB7E + (32436)
opcodeCB7E_end: | BIT (HL), 7
opcodeCB7F:
	btst.b #7, %d5
	move.w %sr, %d7 | update zero
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB7F_end - opcodeCB7F + (32692)
opcodeCB7F_end: | BIT A, 7
opcodeCBC0:
	bset.b #0, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBC0_end - opcodeCBC0 + (-16204)
opcodeCBC0_end: | SET B, 0
opcodeCBC1:
	bset.b #0, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBC1_end - opcodeCBC1 + (-15948)
opcodeCBC1_end: | SET C, 0
opcodeCBC2:
	bset.b #0, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBC2_end - opcodeCBC2 + (-15692)
opcodeCBC2_end: | SET D, 0
opcodeCBC3:
	bset.b #0, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBC3_end - opcodeCBC3 + (-15436)
opcodeCBC3_end: | SET E, 0
opcodeCBC4:
	bset.b #0, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBC4_end - opcodeCBC4 + (-15180)
opcodeCBC4_end: | SET H, 0
opcodeCBC5:
	bset.b #0, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBC5_end - opcodeCBC5 + (-14924)
opcodeCBC5_end: | SET L, 0
opcodeCBC6:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bset.b #0, %d2
	move.w (%a1), %d1
	beq _lable001E
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable001E:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBC6_end - opcodeCBC6 + (-14668)
opcodeCBC6_end: | SET (HL), 0
opcodeCBC7:
	bset.b #0, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBC7_end - opcodeCBC7 + (-14412)
opcodeCBC7_end: | SET A, 0
opcodeCBC8:
	bset.b #1, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBC8_end - opcodeCBC8 + (-14156)
opcodeCBC8_end: | SET B, 1
opcodeCBC9:
	bset.b #1, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBC9_end - opcodeCBC9 + (-13900)
opcodeCBC9_end: | SET C, 1
opcodeCBCA:
	bset.b #1, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBCA_end - opcodeCBCA + (-13644)
opcodeCBCA_end: | SET D, 1
opcodeCBCB:
	bset.b #1, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBCB_end - opcodeCBCB + (-13388)
opcodeCBCB_end: | SET E, 1
opcodeCBCC:
	bset.b #1, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBCC_end - opcodeCBCC + (-13132)
opcodeCBCC_end: | SET H, 1
opcodeCBCD:
	bset.b #1, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBCD_end - opcodeCBCD + (-12876)
opcodeCBCD_end: | SET L, 1
opcodeCBCE:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bset.b #1, %d2
	move.w (%a1), %d1
	beq _lable001F
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable001F:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBCE_end - opcodeCBCE + (-12620)
opcodeCBCE_end: | SET (HL), 1
opcodeCBCF:
	bset.b #1, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBCF_end - opcodeCBCF + (-12364)
opcodeCBCF_end: | SET A, 1
opcodeCBD0:
	bset.b #2, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBD0_end - opcodeCBD0 + (-12108)
opcodeCBD0_end: | SET B, 2
opcodeCBD1:
	bset.b #2, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBD1_end - opcodeCBD1 + (-11852)
opcodeCBD1_end: | SET C, 2
opcodeCBD2:
	bset.b #2, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBD2_end - opcodeCBD2 + (-11596)
opcodeCBD2_end: | SET D, 2
opcodeCBD3:
	bset.b #2, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBD3_end - opcodeCBD3 + (-11340)
opcodeCBD3_end: | SET E, 2
opcodeCBD4:
	bset.b #2, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBD4_end - opcodeCBD4 + (-11084)
opcodeCBD4_end: | SET H, 2
opcodeCBD5:
	bset.b #2, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBD5_end - opcodeCBD5 + (-10828)
opcodeCBD5_end: | SET L, 2
opcodeCBD6:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bset.b #2, %d2
	move.w (%a1), %d1
	beq _lable0020
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0020:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBD6_end - opcodeCBD6 + (-10572)
opcodeCBD6_end: | SET (HL), 2
opcodeCBD7:
	bset.b #2, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBD7_end - opcodeCBD7 + (-10316)
opcodeCBD7_end: | SET A, 2
opcodeCBD8:
	bset.b #3, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBD8_end - opcodeCBD8 + (-10060)
opcodeCBD8_end: | SET B, 3
opcodeCBD9:
	bset.b #3, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBD9_end - opcodeCBD9 + (-9804)
opcodeCBD9_end: | SET C, 3
opcodeCBDA:
	bset.b #3, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBDA_end - opcodeCBDA + (-9548)
opcodeCBDA_end: | SET D, 3
opcodeCBDB:
	bset.b #3, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBDB_end - opcodeCBDB + (-9292)
opcodeCBDB_end: | SET E, 3
opcodeCBDC:
	bset.b #3, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBDC_end - opcodeCBDC + (-9036)
opcodeCBDC_end: | SET H, 3
opcodeCBDD:
	bset.b #3, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBDD_end - opcodeCBDD + (-8780)
opcodeCBDD_end: | SET L, 3
opcodeCBDE:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bset.b #3, %d2
	move.w (%a1), %d1
	beq _lable0021
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0021:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBDE_end - opcodeCBDE + (-8524)
opcodeCBDE_end: | SET (HL), 3
opcodeCBDF:
	bset.b #3, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBDF_end - opcodeCBDF + (-8268)
opcodeCBDF_end: | SET A, 3
opcodeCBE0:
	bset.b #4, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBE0_end - opcodeCBE0 + (-8012)
opcodeCBE0_end: | SET B, 4
opcodeCBE1:
	bset.b #4, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBE1_end - opcodeCBE1 + (-7756)
opcodeCBE1_end: | SET C, 4
opcodeCBE2:
	bset.b #4, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBE2_end - opcodeCBE2 + (-7500)
opcodeCBE2_end: | SET D, 4
opcodeCBE3:
	bset.b #4, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBE3_end - opcodeCBE3 + (-7244)
opcodeCBE3_end: | SET E, 4
opcodeCBE4:
	bset.b #4, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBE4_end - opcodeCBE4 + (-6988)
opcodeCBE4_end: | SET H, 4
opcodeCBE5:
	bset.b #4, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBE5_end - opcodeCBE5 + (-6732)
opcodeCBE5_end: | SET L, 4
opcodeCBE6:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bset.b #4, %d2
	move.w (%a1), %d1
	beq _lable0022
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0022:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBE6_end - opcodeCBE6 + (-6476)
opcodeCBE6_end: | SET (HL), 4
opcodeCBE7:
	bset.b #4, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBE7_end - opcodeCBE7 + (-6220)
opcodeCBE7_end: | SET A, 4
opcodeCBE8:
	bset.b #5, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBE8_end - opcodeCBE8 + (-5964)
opcodeCBE8_end: | SET B, 5
opcodeCBE9:
	bset.b #5, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBE9_end - opcodeCBE9 + (-5708)
opcodeCBE9_end: | SET C, 5
opcodeCBEA:
	bset.b #5, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBEA_end - opcodeCBEA + (-5452)
opcodeCBEA_end: | SET D, 5
opcodeCBEB:
	bset.b #5, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBEB_end - opcodeCBEB + (-5196)
opcodeCBEB_end: | SET E, 5
opcodeCBEC:
	bset.b #5, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBEC_end - opcodeCBEC + (-4940)
opcodeCBEC_end: | SET H, 5
opcodeCBED:
	bset.b #5, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBED_end - opcodeCBED + (-4684)
opcodeCBED_end: | SET L, 5
opcodeCBEE:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bset.b #5, %d2
	move.w (%a1), %d1
	beq _lable0023
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0023:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBEE_end - opcodeCBEE + (-4428)
opcodeCBEE_end: | SET (HL), 5
opcodeCBEF:
	bset.b #5, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBEF_end - opcodeCBEF + (-4172)
opcodeCBEF_end: | SET A, 5
opcodeCBF0:
	bset.b #6, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBF0_end - opcodeCBF0 + (-3916)
opcodeCBF0_end: | SET B, 6
opcodeCBF1:
	bset.b #6, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBF1_end - opcodeCBF1 + (-3660)
opcodeCBF1_end: | SET C, 6
opcodeCBF2:
	bset.b #6, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBF2_end - opcodeCBF2 + (-3404)
opcodeCBF2_end: | SET D, 6
opcodeCBF3:
	bset.b #6, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBF3_end - opcodeCBF3 + (-3148)
opcodeCBF3_end: | SET E, 6
opcodeCBF4:
	bset.b #6, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBF4_end - opcodeCBF4 + (-2892)
opcodeCBF4_end: | SET H, 6
opcodeCBF5:
	bset.b #6, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBF5_end - opcodeCBF5 + (-2636)
opcodeCBF5_end: | SET L, 6
opcodeCBF6:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bset.b #6, %d2
	move.w (%a1), %d1
	beq _lable0024
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0024:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBF6_end - opcodeCBF6 + (-2380)
opcodeCBF6_end: | SET (HL), 6
opcodeCBF7:
	bset.b #6, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBF7_end - opcodeCBF7 + (-2124)
opcodeCBF7_end: | SET A, 6
opcodeCBF8:
	bset.b #7, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBF8_end - opcodeCBF8 + (-1868)
opcodeCBF8_end: | SET B, 7
opcodeCBF9:
	bset.b #7, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBF9_end - opcodeCBF9 + (-1612)
opcodeCBF9_end: | SET C, 7
opcodeCBFA:
	bset.b #7, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBFA_end - opcodeCBFA + (-1356)
opcodeCBFA_end: | SET D, 7
opcodeCBFB:
	bset.b #7, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBFB_end - opcodeCBFB + (-1100)
opcodeCBFB_end: | SET E, 7
opcodeCBFC:
	bset.b #7, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBFC_end - opcodeCBFC + (-844)
opcodeCBFC_end: | SET H, 7
opcodeCBFD:
	bset.b #7, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBFD_end - opcodeCBFD + (-588)
opcodeCBFD_end: | SET L, 7
opcodeCBFE:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bset.b #7, %d2
	move.w (%a1), %d1
	beq _lable0025
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0025:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBFE_end - opcodeCBFE + (-332)
opcodeCBFE_end: | SET (HL), 7
opcodeCBFF:
	bset.b #7, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBFF_end - opcodeCBFF + (-76)
opcodeCBFF_end: | SET A, 7
opcodeCB80:
	bclr.b #0, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB80_end - opcodeCB80 + (-32588)
opcodeCB80_end: | RES B, 0
opcodeCB81:
	bclr.b #0, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB81_end - opcodeCB81 + (-32332)
opcodeCB81_end: | RES C, 0
opcodeCB82:
	bclr.b #0, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB82_end - opcodeCB82 + (-32076)
opcodeCB82_end: | RES D, 0
opcodeCB83:
	bclr.b #0, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB83_end - opcodeCB83 + (-31820)
opcodeCB83_end: | RES E, 0
opcodeCB84:
	bclr.b #0, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB84_end - opcodeCB84 + (-31564)
opcodeCB84_end: | RES H, 0
opcodeCB85:
	bclr.b #0, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB85_end - opcodeCB85 + (-31308)
opcodeCB85_end: | RES L, 0
opcodeCB86:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bclr.b #0, %d2
	move.w (%a1), %d1
	beq _lable0026
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0026:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB86_end - opcodeCB86 + (-31052)
opcodeCB86_end: | RES (HL), 0
opcodeCB87:
	bclr.b #0, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB87_end - opcodeCB87 + (-30796)
opcodeCB87_end: | RES A, 0
opcodeCB88:
	bclr.b #1, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB88_end - opcodeCB88 + (-30540)
opcodeCB88_end: | RES B, 1
opcodeCB89:
	bclr.b #1, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB89_end - opcodeCB89 + (-30284)
opcodeCB89_end: | RES C, 1
opcodeCB8A:
	bclr.b #1, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB8A_end - opcodeCB8A + (-30028)
opcodeCB8A_end: | RES D, 1
opcodeCB8B:
	bclr.b #1, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB8B_end - opcodeCB8B + (-29772)
opcodeCB8B_end: | RES E, 1
opcodeCB8C:
	bclr.b #1, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB8C_end - opcodeCB8C + (-29516)
opcodeCB8C_end: | RES H, 1
opcodeCB8D:
	bclr.b #1, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB8D_end - opcodeCB8D + (-29260)
opcodeCB8D_end: | RES L, 1
opcodeCB8E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bclr.b #1, %d2
	move.w (%a1), %d1
	beq _lable0027
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0027:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB8E_end - opcodeCB8E + (-29004)
opcodeCB8E_end: | RES (HL), 1
opcodeCB8F:
	bclr.b #1, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB8F_end - opcodeCB8F + (-28748)
opcodeCB8F_end: | RES A, 1
opcodeCB90:
	bclr.b #2, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB90_end - opcodeCB90 + (-28492)
opcodeCB90_end: | RES B, 2
opcodeCB91:
	bclr.b #2, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB91_end - opcodeCB91 + (-28236)
opcodeCB91_end: | RES C, 2
opcodeCB92:
	bclr.b #2, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB92_end - opcodeCB92 + (-27980)
opcodeCB92_end: | RES D, 2
opcodeCB93:
	bclr.b #2, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB93_end - opcodeCB93 + (-27724)
opcodeCB93_end: | RES E, 2
opcodeCB94:
	bclr.b #2, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB94_end - opcodeCB94 + (-27468)
opcodeCB94_end: | RES H, 2
opcodeCB95:
	bclr.b #2, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB95_end - opcodeCB95 + (-27212)
opcodeCB95_end: | RES L, 2
opcodeCB96:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bclr.b #2, %d2
	move.w (%a1), %d1
	beq _lable0028
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0028:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB96_end - opcodeCB96 + (-26956)
opcodeCB96_end: | RES (HL), 2
opcodeCB97:
	bclr.b #2, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB97_end - opcodeCB97 + (-26700)
opcodeCB97_end: | RES A, 2
opcodeCB98:
	bclr.b #3, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB98_end - opcodeCB98 + (-26444)
opcodeCB98_end: | RES B, 3
opcodeCB99:
	bclr.b #3, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB99_end - opcodeCB99 + (-26188)
opcodeCB99_end: | RES C, 3
opcodeCB9A:
	bclr.b #3, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB9A_end - opcodeCB9A + (-25932)
opcodeCB9A_end: | RES D, 3
opcodeCB9B:
	bclr.b #3, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB9B_end - opcodeCB9B + (-25676)
opcodeCB9B_end: | RES E, 3
opcodeCB9C:
	bclr.b #3, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB9C_end - opcodeCB9C + (-25420)
opcodeCB9C_end: | RES H, 3
opcodeCB9D:
	bclr.b #3, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB9D_end - opcodeCB9D + (-25164)
opcodeCB9D_end: | RES L, 3
opcodeCB9E:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bclr.b #3, %d2
	move.w (%a1), %d1
	beq _lable0029
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable0029:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB9E_end - opcodeCB9E + (-24908)
opcodeCB9E_end: | RES (HL), 3
opcodeCB9F:
	bclr.b #3, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB9F_end - opcodeCB9F + (-24652)
opcodeCB9F_end: | RES A, 3
opcodeCBA0:
	bclr.b #4, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBA0_end - opcodeCBA0 + (-24396)
opcodeCBA0_end: | RES B, 4
opcodeCBA1:
	bclr.b #4, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBA1_end - opcodeCBA1 + (-24140)
opcodeCBA1_end: | RES C, 4
opcodeCBA2:
	bclr.b #4, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBA2_end - opcodeCBA2 + (-23884)
opcodeCBA2_end: | RES D, 4
opcodeCBA3:
	bclr.b #4, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBA3_end - opcodeCBA3 + (-23628)
opcodeCBA3_end: | RES E, 4
opcodeCBA4:
	bclr.b #4, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBA4_end - opcodeCBA4 + (-23372)
opcodeCBA4_end: | RES H, 4
opcodeCBA5:
	bclr.b #4, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBA5_end - opcodeCBA5 + (-23116)
opcodeCBA5_end: | RES L, 4
opcodeCBA6:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bclr.b #4, %d2
	move.w (%a1), %d1
	beq _lable002A
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable002A:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBA6_end - opcodeCBA6 + (-22860)
opcodeCBA6_end: | RES (HL), 4
opcodeCBA7:
	bclr.b #4, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBA7_end - opcodeCBA7 + (-22604)
opcodeCBA7_end: | RES A, 4
opcodeCBA8:
	bclr.b #5, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBA8_end - opcodeCBA8 + (-22348)
opcodeCBA8_end: | RES B, 5
opcodeCBA9:
	bclr.b #5, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBA9_end - opcodeCBA9 + (-22092)
opcodeCBA9_end: | RES C, 5
opcodeCBAA:
	bclr.b #5, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBAA_end - opcodeCBAA + (-21836)
opcodeCBAA_end: | RES D, 5
opcodeCBAB:
	bclr.b #5, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBAB_end - opcodeCBAB + (-21580)
opcodeCBAB_end: | RES E, 5
opcodeCBAC:
	bclr.b #5, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBAC_end - opcodeCBAC + (-21324)
opcodeCBAC_end: | RES H, 5
opcodeCBAD:
	bclr.b #5, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBAD_end - opcodeCBAD + (-21068)
opcodeCBAD_end: | RES L, 5
opcodeCBAE:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bclr.b #5, %d2
	move.w (%a1), %d1
	beq _lable002B
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable002B:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBAE_end - opcodeCBAE + (-20812)
opcodeCBAE_end: | RES (HL), 5
opcodeCBAF:
	bclr.b #5, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBAF_end - opcodeCBAF + (-20556)
opcodeCBAF_end: | RES A, 5
opcodeCBB0:
	bclr.b #6, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBB0_end - opcodeCBB0 + (-20300)
opcodeCBB0_end: | RES B, 6
opcodeCBB1:
	bclr.b #6, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBB1_end - opcodeCBB1 + (-20044)
opcodeCBB1_end: | RES C, 6
opcodeCBB2:
	bclr.b #6, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBB2_end - opcodeCBB2 + (-19788)
opcodeCBB2_end: | RES D, 6
opcodeCBB3:
	bclr.b #6, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBB3_end - opcodeCBB3 + (-19532)
opcodeCBB3_end: | RES E, 6
opcodeCBB4:
	bclr.b #6, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBB4_end - opcodeCBB4 + (-19276)
opcodeCBB4_end: | RES H, 6
opcodeCBB5:
	bclr.b #6, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBB5_end - opcodeCBB5 + (-19020)
opcodeCBB5_end: | RES L, 6
opcodeCBB6:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bclr.b #6, %d2
	move.w (%a1), %d1
	beq _lable002C
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable002C:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBB6_end - opcodeCBB6 + (-18764)
opcodeCBB6_end: | RES (HL), 6
opcodeCBB7:
	bclr.b #6, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBB7_end - opcodeCBB7 + (-18508)
opcodeCBB7_end: | RES A, 6
opcodeCBB8:
	bclr.b #7, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBB8_end - opcodeCBB8 + (-18252)
opcodeCBB8_end: | RES B, 7
opcodeCBB9:
	bclr.b #7, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBB9_end - opcodeCBB9 + (-17996)
opcodeCBB9_end: | RES C, 7
opcodeCBBA:
	bclr.b #7, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBBA_end - opcodeCBBA + (-17740)
opcodeCBBA_end: | RES D, 7
opcodeCBBB:
	bclr.b #7, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBBB_end - opcodeCBBB + (-17484)
opcodeCBBB_end: | RES E, 7
opcodeCBBC:
	bclr.b #7, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBBC_end - opcodeCBBC + (-17228)
opcodeCBBC_end: | RES H, 7
opcodeCBBD:
	bclr.b #7, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBBD_end - opcodeCBBD + (-16972)
opcodeCBBD_end: | RES L, 7
opcodeCBBE:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	bclr.b #7, %d2
	move.w (%a1), %d1
	beq _lable002D
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable002D:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCBBE_end - opcodeCBBE + (-16716)
opcodeCBBE_end: | RES (HL), 7
opcodeCBBF:
	bclr.b #7, %d5
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCBBF_end - opcodeCBBF + (-16460)
opcodeCBBF_end: | RES A, 7
opcodeCB30:
	move.b (%a5, 2), %d2
	rol.b #4, %d2
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	move.b %d2, (%a5, 2)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB30_end - opcodeCB30 + (12468)
opcodeCB30_end: | SWAP B
opcodeCB31:
	move.b (%a5, 3), %d2
	rol.b #4, %d2
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	move.b %d2, (%a5, 3)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB31_end - opcodeCB31 + (12724)
opcodeCB31_end: | SWAP C
opcodeCB32:
	move.b (%a5, 4), %d2
	rol.b #4, %d2
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	move.b %d2, (%a5, 4)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB32_end - opcodeCB32 + (12980)
opcodeCB32_end: | SWAP D
opcodeCB33:
	move.b (%a5, 5), %d2
	rol.b #4, %d2
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	move.b %d2, (%a5, 5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB33_end - opcodeCB33 + (13236)
opcodeCB33_end: | SWAP E
opcodeCB34:
	move.b (%a5), %d2
	rol.b #4, %d2
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	move.b %d2, (%a5)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB34_end - opcodeCB34 + (13492)
opcodeCB34_end: | SWAP H
opcodeCB35:
	move.b (%a5, 1), %d2
	rol.b #4, %d2
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	move.b %d2, (%a5, 1)
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB35_end - opcodeCB35 + (13748)
opcodeCB35_end: | SWAP L
opcodeCB36:
	move.w (%a5), %d3
	clr.w %d0
	move.b %d3, %d0
	clr.b %d3
	lsr.w #5, %d3
	lea (MEM_TABLE, %a5, %d3.w), %a1
	movea.l (%a1)+, %a0
	move.b (%a0, %d0.w), %d2
	rol.b #4, %d2
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	move.w (%a1), %d1
	beq _lable002E
	subq.w #4, %d4
	jmp (%a3, %d1.w)
_lable002E:
	move.b %d2, (%a0, %d0.w)
	subq.w #4, %d4
	NEXT_INSTRUCTION opcodeCB36_end - opcodeCB36 + (14004)
opcodeCB36_end: | SWAP (HL)
opcodeCB37:
	rol.b #4, %d5
	move.w %sr, %d7 | update zero
	clr.b %d6 | clear carry
	subq.w #2, %d4
	NEXT_INSTRUCTION opcodeCB37_end - opcodeCB37 + (14260)
opcodeCB37_end: | SWAP A
opcode00C3:
	moveq.l #0, %d0
	clr.w %d2
	move.b (%a4)+, %d0
	move.b (%a4)+, %d2
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00C3_end - opcode00C3 + (-15616)
opcode00C3_end: | JP nnnn
opcode00E9:
	clr.l %d2
	move.w (%a5), %d2
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00E9_end - opcode00E9 + (-5888)
opcode00E9_end: | JP HL
opcode00C2:
	move.w %d7, %ccr
	beq _lable002F
	moveq.l #0, %d0
	clr.w %d2
	move.b (%a4)+, %d0
	move.b (%a4)+, %d2
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION _lable002F - opcode00C2 + (-15872)
_lable002F:
	lea (2, %a4), %a4
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00C2_end - opcode00C2 + (-15872)
opcode00C2_end: | JP NZ, nnnn
opcode00CA:
	move.w %d7, %ccr
	bne _lable0030
	moveq.l #0, %d0
	clr.w %d2
	move.b (%a4)+, %d0
	move.b (%a4)+, %d2
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION _lable0030 - opcode00CA + (-13824)
_lable0030:
	lea (2, %a4), %a4
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00CA_end - opcode00CA + (-13824)
opcode00CA_end: | JP Z, nnnn
opcode00D2:
	move.w %d6, %ccr
	bcs _lable0031
	moveq.l #0, %d0
	clr.w %d2
	move.b (%a4)+, %d0
	move.b (%a4)+, %d2
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION _lable0031 - opcode00D2 + (-11776)
_lable0031:
	lea (2, %a4), %a4
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00D2_end - opcode00D2 + (-11776)
opcode00D2_end: | JP NC, nnnn
opcode00DA:
	move.w %d6, %ccr
	bcc _lable0032
	moveq.l #0, %d0
	clr.w %d2
	move.b (%a4)+, %d0
	move.b (%a4)+, %d2
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION _lable0032 - opcode00DA + (-9728)
_lable0032:
	lea (2, %a4), %a4
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00DA_end - opcode00DA + (-9728)
opcode00DA_end: | JP C, nnnn
opcode0018:
	move.b (%a4)+, %d1
	ext.w %d1
	ext.l %d1
	adda.l %d1, %a4
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode0018_end - opcode0018 + (6144)
opcode0018_end: | JR nn
opcode0020:
	move.w %d7, %ccr
	beq _lable0033
	move.b (%a4)+, %d1
	ext.w %d1
	ext.l %d1
	adda.l %d1, %a4
	subq.w #3, %d4
	NEXT_INSTRUCTION _lable0033 - opcode0020 + (8192)
_lable0033:
	addq.l #1, %a4
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0020_end - opcode0020 + (8192)
opcode0020_end: | JR NZ, nn
opcode0028:
	move.w %d7, %ccr
	bne _lable0034
	move.b (%a4)+, %d1
	ext.w %d1
	ext.l %d1
	adda.l %d1, %a4
	subq.w #3, %d4
	NEXT_INSTRUCTION _lable0034 - opcode0028 + (10240)
_lable0034:
	addq.l #1, %a4
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0028_end - opcode0028 + (10240)
opcode0028_end: | JR Z, nn
opcode0030:
	move.w %d6, %ccr
	bcs _lable0035
	move.b (%a4)+, %d1
	ext.w %d1
	ext.l %d1
	adda.l %d1, %a4
	subq.w #3, %d4
	NEXT_INSTRUCTION _lable0035 - opcode0030 + (12288)
_lable0035:
	addq.l #1, %a4
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0030_end - opcode0030 + (12288)
opcode0030_end: | JR NC, nn
opcode0038:
	move.w %d6, %ccr
	bcc _lable0036
	move.b (%a4)+, %d1
	ext.w %d1
	ext.l %d1
	adda.l %d1, %a4
	subq.w #3, %d4
	NEXT_INSTRUCTION _lable0036 - opcode0038 + (14336)
_lable0036:
	addq.l #1, %a4
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode0038_end - opcode0038 + (14336)
opcode0038_end: | JR C, nn
opcode00CD:
	lea (2, %a4), %a4
	jsr push_PC :l
	moveq.l #0, %d0
	clr.w %d2
	move.b -(%a4), %d2
	move.b -(%a4), %d0
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #6, %d4
	NEXT_INSTRUCTION opcode00CD_end - opcode00CD + (-13056)
opcode00CD_end: | CALL nnnn
opcode00C4:
	lea (2, %a4), %a4
	move.w %d7, %ccr
	beq _lable0037
	jsr push_PC :l
	moveq.l #0, %d0
	clr.w %d2
	move.b -(%a4), %d2
	move.b -(%a4), %d0
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #6, %d4
	NEXT_INSTRUCTION _lable0037 - opcode00C4 + (-15360)
_lable0037:
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00C4_end - opcode00C4 + (-15360)
opcode00C4_end: | CALL NZ, nnnn
opcode00CC:
	lea (2, %a4), %a4
	move.w %d7, %ccr
	bne _lable0038
	jsr push_PC :l
	moveq.l #0, %d0
	clr.w %d2
	move.b -(%a4), %d2
	move.b -(%a4), %d0
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #6, %d4
	NEXT_INSTRUCTION _lable0038 - opcode00CC + (-13312)
_lable0038:
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00CC_end - opcode00CC + (-13312)
opcode00CC_end: | CALL Z, nnnn
opcode00D4:
	lea (2, %a4), %a4
	move.w %d6, %ccr
	bcs _lable0039
	jsr push_PC :l
	moveq.l #0, %d0
	clr.w %d2
	move.b -(%a4), %d2
	move.b -(%a4), %d0
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #6, %d4
	NEXT_INSTRUCTION _lable0039 - opcode00D4 + (-11264)
_lable0039:
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00D4_end - opcode00D4 + (-11264)
opcode00D4_end: | CALL NC, nnnn
opcode00DC:
	lea (2, %a4), %a4
	move.w %d6, %ccr
	bcc _lable003A
	jsr push_PC :l
	moveq.l #0, %d0
	clr.w %d2
	move.b -(%a4), %d2
	move.b -(%a4), %d0
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #6, %d4
	NEXT_INSTRUCTION _lable003A - opcode00DC + (-9216)
_lable003A:
	subq.w #3, %d4
	NEXT_INSTRUCTION opcode00DC_end - opcode00DC + (-9216)
opcode00DC_end: | CALL C, nnnn
opcode00C9:
	jsr pop_PC :l
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00C9_end - opcode00C9 + (-14080)
opcode00C9_end: | RET
opcode00D9:
	jsr pop_PC :l
	movea.l (MEM_TABLE+2040, %a5) ,%a0
	bset #31, %d7 | enable interrupts
	cmp.b #1, (CPU_HALT, %a5)
	bne 0f
	move.b (IF, %a0), %d0
	and.b (IE, %a0), %d0
	bne 0f
	moveq #-1, %d4
	move.b #-1, (CPU_HALT, %a5)
0:
	jsr check_interrupts
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00D9_end - opcode00D9 + (-9984)
opcode00D9_end: | RETI
opcode00C0:
	move.w %d7, %ccr
	beq _lable003B
	jsr pop_PC :l
	subq.w #5, %d4
	NEXT_INSTRUCTION _lable003B - opcode00C0 + (-16384)
_lable003B:
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00C0_end - opcode00C0 + (-16384)
opcode00C0_end: | RET NZ
opcode00C8:
	move.w %d7, %ccr
	bne _lable003C
	jsr pop_PC :l
	subq.w #5, %d4
	NEXT_INSTRUCTION _lable003C - opcode00C8 + (-14336)
_lable003C:
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00C8_end - opcode00C8 + (-14336)
opcode00C8_end: | RET Z
opcode00D0:
	move.w %d6, %ccr
	bcs _lable003D
	jsr pop_PC :l
	subq.w #5, %d4
	NEXT_INSTRUCTION _lable003D - opcode00D0 + (-12288)
_lable003D:
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00D0_end - opcode00D0 + (-12288)
opcode00D0_end: | RET NC
opcode00D8:
	move.w %d6, %ccr
	bcc _lable003E
	jsr pop_PC :l
	subq.w #5, %d4
	NEXT_INSTRUCTION _lable003E - opcode00D8 + (-10240)
_lable003E:
	subq.w #2, %d4
	NEXT_INSTRUCTION opcode00D8_end - opcode00D8 + (-10240)
opcode00D8_end: | RET C
opcode00C7:
	jsr push_PC :l
	moveq.l #0x00, %d2
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00C7_end - opcode00C7 + (-14592)
opcode00C7_end: | RST 00
opcode00CF:
	jsr push_PC :l
	moveq.l #0x08, %d2
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00CF_end - opcode00CF + (-12544)
opcode00CF_end: | RST 08
opcode00D7:
	jsr push_PC :l
	moveq.l #0x10, %d2
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00D7_end - opcode00D7 + (-10496)
opcode00D7_end: | RST 10
opcode00DF:
	jsr push_PC :l
	moveq.l #0x18, %d2
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00DF_end - opcode00DF + (-8448)
opcode00DF_end: | RST 18
opcode00E7:
	jsr push_PC :l
	moveq.l #0x20, %d2
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00E7_end - opcode00E7 + (-6400)
opcode00E7_end: | RST 20
opcode00EF:
	jsr push_PC :l
	moveq.l #0x28, %d2
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00EF_end - opcode00EF + (-4352)
opcode00EF_end: | RST 28
opcode00F7:
	jsr push_PC :l
	moveq.l #0x30, %d2
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00F7_end - opcode00F7 + (-2304)
opcode00F7_end: | RST 30
opcode00FF:
	jsr push_PC :l
	moveq.l #0x38, %d2
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	subq.w #4, %d4
	NEXT_INSTRUCTION opcode00FF_end - opcode00FF + (-256)
opcode00FF_end: | RST 38
opcode0076:
	btst #31, %d7
	beq 0f
	moveq #-1, %d4
	move.b #-1, (CPU_HALT, %a5)
	bra 1f
0:
	move.b #1, (CPU_HALT, %a5)
1:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0076_end - opcode0076 + (30208)
opcode0076_end: | HALT
opcode0027:
	cmpi.b #0x99, %d5
	bhi 0f
	btst #0, %d6
	bne 0f
	moveq #0x00, %d0
	bclr #0, %d6
	bra 1f
0:
	moveq #0x60, %d0
	bset #0, %d6
1:
	move.b %d5, %d1
	andi.b #0x0f, %d1
	cmpi.b #0x9, %d1
	bhi 0f
	moveq #0, %d2
	move.l %d0, -(%a7)
	jsr calculate_half_carry :l
	move.l (%a7)+, %d0
	btst #5, %d2
	beq 1f
0:
	ori.b #0x06, %d0
1:
	move.b %d5, (LAST_DST, %a5)
	move.b %d0, (LAST_SRC, %a5)
	btst #5, %d7
	beq 0f
	sub.b %d0, %d5
	move.w %sr, %d7 | update zero
	ori.b #0x20, %d7 | set subtract
	bra 1f
0:
	add.b %d0, %d5
	move.w %sr, %d7 | update zero
1:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0027_end - opcode0027 + (9984)
opcode0027_end: | DAA
opcode00CB:
	move.b (%a4)+, (opcode00CB_end - opcode00CB + (-13568) - 2, %a6)
	jmp (0x0FB4, %a6)
opcode00CB_end:
opcode0000:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0000_end - opcode0000 + (0)
opcode0000_end:
opcode0010:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0010_end - opcode0010 + (4096)
opcode0010_end:
opcode0040:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0040_end - opcode0040 + (16384)
opcode0040_end:
opcode0049:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0049_end - opcode0049 + (18688)
opcode0049_end:
opcode0052:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0052_end - opcode0052 + (20992)
opcode0052_end:
opcode005B:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode005B_end - opcode005B + (23296)
opcode005B_end:
opcode0064:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode0064_end - opcode0064 + (25600)
opcode0064_end:
opcode006D:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode006D_end - opcode006D + (27904)
opcode006D_end:
opcode007F:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode007F_end - opcode007F + (32512)
opcode007F_end:
opcode00D3:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00D3_end - opcode00D3 + (-11520)
opcode00D3_end:
opcode00DB:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00DB_end - opcode00DB + (-9472)
opcode00DB_end:
opcode00DD:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00DD_end - opcode00DD + (-8960)
opcode00DD_end:
opcode00E3:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00E3_end - opcode00E3 + (-7424)
opcode00E3_end:
opcode00E4:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00E4_end - opcode00E4 + (-7168)
opcode00E4_end:
opcode00EB:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00EB_end - opcode00EB + (-5376)
opcode00EB_end:
opcode00EC:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00EC_end - opcode00EC + (-5120)
opcode00EC_end:
opcode00ED:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00ED_end - opcode00ED + (-4864)
opcode00ED_end:
opcode00F4:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00F4_end - opcode00F4 + (-3072)
opcode00F4_end:
opcode00FC:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00FC_end - opcode00FC + (-1024)
opcode00FC_end:
opcode00FD:
	subq.w #1, %d4
	NEXT_INSTRUCTION opcode00FD_end - opcode00FD + (-768)
opcode00FD_end:
push_PC:
	move.l %d2, -(%sp)
	move.l %a4, %d2
	move.w (PC_BASE, %a5), %d0
	lea (MEM_TABLE, %a5, %d0.w), %a1
	sub.l (%a1), %d2 | pc now relative to block
	lsl.w #5, %d0 | d0 is now block index * 256
	add.l %d0, %d2 | pc is now correct
	lea (-2, %a2), %a2
	move.b %d2, (%a2)
	rol.w #8, %d2
	move.b %d2, (%a2, 1)
	move.l (%sp)+, %d2
	rts
pop_PC:
	moveq.l #0, %d0
	clr.w %d2
	move.b (%a2)+, %d0
	move.b (%a2)+, %d2
	lsl.w #3, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	rts
generate_int: | input: %d2, number of int
	bclr #31, %d7 | disable interrupts
	clr.b (CPU_HALT, %a5)
	jsr push_PC
	moveq.l #0, %d0
	move.b %d2, %d0 | d0 is offset
	clr.b %d2
	lsr.w #5, %d2 | d2 is block index * 8
	move.w %d2, (PC_BASE, %a5) | store block index
	lea (MEM_TABLE, %a5, %d2.w), %a1
	movea.l (%a1), %a4 | pc points to start of block
	adda.l %d0, %a4 | now pc is correct
	rts

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
.word opcode0010 - function_base
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
.word opcode00D3 - function_base
.word opcode00D4 - function_base
.word opcode00D5 - function_base
.word opcode00D6 - function_base
.word opcode00D7 - function_base
.word opcode00D8 - function_base
.word opcode00D9 - function_base
.word opcode00DA - function_base
.word opcode00DB - function_base
.word opcode00DC - function_base
.word opcode00DD - function_base
.word opcode00DE - function_base
.word opcode00DF - function_base
.word opcode00E0 - function_base
.word opcode00E1 - function_base
.word opcode00E2 - function_base
.word opcode00E3 - function_base
.word opcode00E4 - function_base
.word opcode00E5 - function_base
.word opcode00E6 - function_base
.word opcode00E7 - function_base
.word opcode00E8 - function_base
.word opcode00E9 - function_base
.word opcode00EA - function_base
.word opcode00EB - function_base
.word opcode00EC - function_base
.word opcode00ED - function_base
.word opcode00EE - function_base
.word opcode00EF - function_base
.word opcode00F0 - function_base
.word opcode00F1 - function_base
.word opcode00F2 - function_base
.word opcode00F3 - function_base
.word opcode00F4 - function_base
.word opcode00F5 - function_base
.word opcode00F6 - function_base
.word opcode00F7 - function_base
.word opcode00F8 - function_base
.word opcode00F9 - function_base
.word opcode00FA - function_base
.word opcode00FB - function_base
.word opcode00FC - function_base
.word opcode00FD - function_base
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

.if SIZE_TABLE

size_table:
.word opcode0000_end - opcode0000
.word opcode0001_end - opcode0001
.word opcode0002_end - opcode0002
.word opcode0003_end - opcode0003
.word opcode0004_end - opcode0004
.word opcode0005_end - opcode0005
.word opcode0006_end - opcode0006
.word opcode0007_end - opcode0007
.word opcode0008_end - opcode0008
.word opcode0009_end - opcode0009
.word opcode000A_end - opcode000A
.word opcode000B_end - opcode000B
.word opcode000C_end - opcode000C
.word opcode000D_end - opcode000D
.word opcode000E_end - opcode000E
.word opcode000F_end - opcode000F
.word opcode0010_end - opcode0010
.word opcode0011_end - opcode0011
.word opcode0012_end - opcode0012
.word opcode0013_end - opcode0013
.word opcode0014_end - opcode0014
.word opcode0015_end - opcode0015
.word opcode0016_end - opcode0016
.word opcode0017_end - opcode0017
.word opcode0018_end - opcode0018
.word opcode0019_end - opcode0019
.word opcode001A_end - opcode001A
.word opcode001B_end - opcode001B
.word opcode001C_end - opcode001C
.word opcode001D_end - opcode001D
.word opcode001E_end - opcode001E
.word opcode001F_end - opcode001F
.word opcode0020_end - opcode0020
.word opcode0021_end - opcode0021
.word opcode0022_end - opcode0022
.word opcode0023_end - opcode0023
.word opcode0024_end - opcode0024
.word opcode0025_end - opcode0025
.word opcode0026_end - opcode0026
.word opcode0027_end - opcode0027
.word opcode0028_end - opcode0028
.word opcode0029_end - opcode0029
.word opcode002A_end - opcode002A
.word opcode002B_end - opcode002B
.word opcode002C_end - opcode002C
.word opcode002D_end - opcode002D
.word opcode002E_end - opcode002E
.word opcode002F_end - opcode002F
.word opcode0030_end - opcode0030
.word opcode0031_end - opcode0031
.word opcode0032_end - opcode0032
.word opcode0033_end - opcode0033
.word opcode0034_end - opcode0034
.word opcode0035_end - opcode0035
.word opcode0036_end - opcode0036
.word opcode0037_end - opcode0037
.word opcode0038_end - opcode0038
.word opcode0039_end - opcode0039
.word opcode003A_end - opcode003A
.word opcode003B_end - opcode003B
.word opcode003C_end - opcode003C
.word opcode003D_end - opcode003D
.word opcode003E_end - opcode003E
.word opcode003F_end - opcode003F
.word opcode0040_end - opcode0040
.word opcode0041_end - opcode0041
.word opcode0042_end - opcode0042
.word opcode0043_end - opcode0043
.word opcode0044_end - opcode0044
.word opcode0045_end - opcode0045
.word opcode0046_end - opcode0046
.word opcode0047_end - opcode0047
.word opcode0048_end - opcode0048
.word opcode0049_end - opcode0049
.word opcode004A_end - opcode004A
.word opcode004B_end - opcode004B
.word opcode004C_end - opcode004C
.word opcode004D_end - opcode004D
.word opcode004E_end - opcode004E
.word opcode004F_end - opcode004F
.word opcode0050_end - opcode0050
.word opcode0051_end - opcode0051
.word opcode0052_end - opcode0052
.word opcode0053_end - opcode0053
.word opcode0054_end - opcode0054
.word opcode0055_end - opcode0055
.word opcode0056_end - opcode0056
.word opcode0057_end - opcode0057
.word opcode0058_end - opcode0058
.word opcode0059_end - opcode0059
.word opcode005A_end - opcode005A
.word opcode005B_end - opcode005B
.word opcode005C_end - opcode005C
.word opcode005D_end - opcode005D
.word opcode005E_end - opcode005E
.word opcode005F_end - opcode005F
.word opcode0060_end - opcode0060
.word opcode0061_end - opcode0061
.word opcode0062_end - opcode0062
.word opcode0063_end - opcode0063
.word opcode0064_end - opcode0064
.word opcode0065_end - opcode0065
.word opcode0066_end - opcode0066
.word opcode0067_end - opcode0067
.word opcode0068_end - opcode0068
.word opcode0069_end - opcode0069
.word opcode006A_end - opcode006A
.word opcode006B_end - opcode006B
.word opcode006C_end - opcode006C
.word opcode006D_end - opcode006D
.word opcode006E_end - opcode006E
.word opcode006F_end - opcode006F
.word opcode0070_end - opcode0070
.word opcode0071_end - opcode0071
.word opcode0072_end - opcode0072
.word opcode0073_end - opcode0073
.word opcode0074_end - opcode0074
.word opcode0075_end - opcode0075
.word opcode0076_end - opcode0076
.word opcode0077_end - opcode0077
.word opcode0078_end - opcode0078
.word opcode0079_end - opcode0079
.word opcode007A_end - opcode007A
.word opcode007B_end - opcode007B
.word opcode007C_end - opcode007C
.word opcode007D_end - opcode007D
.word opcode007E_end - opcode007E
.word opcode007F_end - opcode007F
.word opcode0080_end - opcode0080
.word opcode0081_end - opcode0081
.word opcode0082_end - opcode0082
.word opcode0083_end - opcode0083
.word opcode0084_end - opcode0084
.word opcode0085_end - opcode0085
.word opcode0086_end - opcode0086
.word opcode0087_end - opcode0087
.word opcode0088_end - opcode0088
.word opcode0089_end - opcode0089
.word opcode008A_end - opcode008A
.word opcode008B_end - opcode008B
.word opcode008C_end - opcode008C
.word opcode008D_end - opcode008D
.word opcode008E_end - opcode008E
.word opcode008F_end - opcode008F
.word opcode0090_end - opcode0090
.word opcode0091_end - opcode0091
.word opcode0092_end - opcode0092
.word opcode0093_end - opcode0093
.word opcode0094_end - opcode0094
.word opcode0095_end - opcode0095
.word opcode0096_end - opcode0096
.word opcode0097_end - opcode0097
.word opcode0098_end - opcode0098
.word opcode0099_end - opcode0099
.word opcode009A_end - opcode009A
.word opcode009B_end - opcode009B
.word opcode009C_end - opcode009C
.word opcode009D_end - opcode009D
.word opcode009E_end - opcode009E
.word opcode009F_end - opcode009F
.word opcode00A0_end - opcode00A0
.word opcode00A1_end - opcode00A1
.word opcode00A2_end - opcode00A2
.word opcode00A3_end - opcode00A3
.word opcode00A4_end - opcode00A4
.word opcode00A5_end - opcode00A5
.word opcode00A6_end - opcode00A6
.word opcode00A7_end - opcode00A7
.word opcode00A8_end - opcode00A8
.word opcode00A9_end - opcode00A9
.word opcode00AA_end - opcode00AA
.word opcode00AB_end - opcode00AB
.word opcode00AC_end - opcode00AC
.word opcode00AD_end - opcode00AD
.word opcode00AE_end - opcode00AE
.word opcode00AF_end - opcode00AF
.word opcode00B0_end - opcode00B0
.word opcode00B1_end - opcode00B1
.word opcode00B2_end - opcode00B2
.word opcode00B3_end - opcode00B3
.word opcode00B4_end - opcode00B4
.word opcode00B5_end - opcode00B5
.word opcode00B6_end - opcode00B6
.word opcode00B7_end - opcode00B7
.word opcode00B8_end - opcode00B8
.word opcode00B9_end - opcode00B9
.word opcode00BA_end - opcode00BA
.word opcode00BB_end - opcode00BB
.word opcode00BC_end - opcode00BC
.word opcode00BD_end - opcode00BD
.word opcode00BE_end - opcode00BE
.word opcode00BF_end - opcode00BF
.word opcode00C0_end - opcode00C0
.word opcode00C1_end - opcode00C1
.word opcode00C2_end - opcode00C2
.word opcode00C3_end - opcode00C3
.word opcode00C4_end - opcode00C4
.word opcode00C5_end - opcode00C5
.word opcode00C6_end - opcode00C6
.word opcode00C7_end - opcode00C7
.word opcode00C8_end - opcode00C8
.word opcode00C9_end - opcode00C9
.word opcode00CA_end - opcode00CA
.word 0
.word opcode00CC_end - opcode00CC
.word opcode00CD_end - opcode00CD
.word opcode00CE_end - opcode00CE
.word opcode00CF_end - opcode00CF
.word opcode00D0_end - opcode00D0
.word opcode00D1_end - opcode00D1
.word opcode00D2_end - opcode00D2
.word opcode00D3_end - opcode00D3
.word opcode00D4_end - opcode00D4
.word opcode00D5_end - opcode00D5
.word opcode00D6_end - opcode00D6
.word opcode00D7_end - opcode00D7
.word opcode00D8_end - opcode00D8
.word opcode00D9_end - opcode00D9
.word opcode00DA_end - opcode00DA
.word opcode00DB_end - opcode00DB
.word opcode00DC_end - opcode00DC
.word opcode00DD_end - opcode00DD
.word opcode00DE_end - opcode00DE
.word opcode00DF_end - opcode00DF
.word opcode00E0_end - opcode00E0
.word opcode00E1_end - opcode00E1
.word opcode00E2_end - opcode00E2
.word opcode00E3_end - opcode00E3
.word opcode00E4_end - opcode00E4
.word opcode00E5_end - opcode00E5
.word opcode00E6_end - opcode00E6
.word opcode00E7_end - opcode00E7
.word opcode00E8_end - opcode00E8
.word opcode00E9_end - opcode00E9
.word opcode00EA_end - opcode00EA
.word opcode00EB_end - opcode00EB
.word opcode00EC_end - opcode00EC
.word opcode00ED_end - opcode00ED
.word opcode00EE_end - opcode00EE
.word opcode00EF_end - opcode00EF
.word opcode00F0_end - opcode00F0
.word opcode00F1_end - opcode00F1
.word opcode00F2_end - opcode00F2
.word opcode00F3_end - opcode00F3
.word opcode00F4_end - opcode00F4
.word opcode00F5_end - opcode00F5
.word opcode00F6_end - opcode00F6
.word opcode00F7_end - opcode00F7
.word opcode00F8_end - opcode00F8
.word opcode00F9_end - opcode00F9
.word opcode00FA_end - opcode00FA
.word opcode00FB_end - opcode00FB
.word opcode00FC_end - opcode00FC
.word opcode00FD_end - opcode00FD
.word opcode00FE_end - opcode00FE
.word opcode00FF_end - opcode00FF
.word opcodeCB00_end - opcodeCB00
.word opcodeCB01_end - opcodeCB01
.word opcodeCB02_end - opcodeCB02
.word opcodeCB03_end - opcodeCB03
.word opcodeCB04_end - opcodeCB04
.word opcodeCB05_end - opcodeCB05
.word opcodeCB06_end - opcodeCB06
.word opcodeCB07_end - opcodeCB07
.word opcodeCB08_end - opcodeCB08
.word opcodeCB09_end - opcodeCB09
.word opcodeCB0A_end - opcodeCB0A
.word opcodeCB0B_end - opcodeCB0B
.word opcodeCB0C_end - opcodeCB0C
.word opcodeCB0D_end - opcodeCB0D
.word opcodeCB0E_end - opcodeCB0E
.word opcodeCB0F_end - opcodeCB0F
.word opcodeCB10_end - opcodeCB10
.word opcodeCB11_end - opcodeCB11
.word opcodeCB12_end - opcodeCB12
.word opcodeCB13_end - opcodeCB13
.word opcodeCB14_end - opcodeCB14
.word opcodeCB15_end - opcodeCB15
.word opcodeCB16_end - opcodeCB16
.word opcodeCB17_end - opcodeCB17
.word opcodeCB18_end - opcodeCB18
.word opcodeCB19_end - opcodeCB19
.word opcodeCB1A_end - opcodeCB1A
.word opcodeCB1B_end - opcodeCB1B
.word opcodeCB1C_end - opcodeCB1C
.word opcodeCB1D_end - opcodeCB1D
.word opcodeCB1E_end - opcodeCB1E
.word opcodeCB1F_end - opcodeCB1F
.word opcodeCB20_end - opcodeCB20
.word opcodeCB21_end - opcodeCB21
.word opcodeCB22_end - opcodeCB22
.word opcodeCB23_end - opcodeCB23
.word opcodeCB24_end - opcodeCB24
.word opcodeCB25_end - opcodeCB25
.word opcodeCB26_end - opcodeCB26
.word opcodeCB27_end - opcodeCB27
.word opcodeCB28_end - opcodeCB28
.word opcodeCB29_end - opcodeCB29
.word opcodeCB2A_end - opcodeCB2A
.word opcodeCB2B_end - opcodeCB2B
.word opcodeCB2C_end - opcodeCB2C
.word opcodeCB2D_end - opcodeCB2D
.word opcodeCB2E_end - opcodeCB2E
.word opcodeCB2F_end - opcodeCB2F
.word opcodeCB30_end - opcodeCB30
.word opcodeCB31_end - opcodeCB31
.word opcodeCB32_end - opcodeCB32
.word opcodeCB33_end - opcodeCB33
.word opcodeCB34_end - opcodeCB34
.word opcodeCB35_end - opcodeCB35
.word opcodeCB36_end - opcodeCB36
.word opcodeCB37_end - opcodeCB37
.word opcodeCB38_end - opcodeCB38
.word opcodeCB39_end - opcodeCB39
.word opcodeCB3A_end - opcodeCB3A
.word opcodeCB3B_end - opcodeCB3B
.word opcodeCB3C_end - opcodeCB3C
.word opcodeCB3D_end - opcodeCB3D
.word opcodeCB3E_end - opcodeCB3E
.word opcodeCB3F_end - opcodeCB3F
.word opcodeCB40_end - opcodeCB40
.word opcodeCB41_end - opcodeCB41
.word opcodeCB42_end - opcodeCB42
.word opcodeCB43_end - opcodeCB43
.word opcodeCB44_end - opcodeCB44
.word opcodeCB45_end - opcodeCB45
.word opcodeCB46_end - opcodeCB46
.word opcodeCB47_end - opcodeCB47
.word opcodeCB48_end - opcodeCB48
.word opcodeCB49_end - opcodeCB49
.word opcodeCB4A_end - opcodeCB4A
.word opcodeCB4B_end - opcodeCB4B
.word opcodeCB4C_end - opcodeCB4C
.word opcodeCB4D_end - opcodeCB4D
.word opcodeCB4E_end - opcodeCB4E
.word opcodeCB4F_end - opcodeCB4F
.word opcodeCB50_end - opcodeCB50
.word opcodeCB51_end - opcodeCB51
.word opcodeCB52_end - opcodeCB52
.word opcodeCB53_end - opcodeCB53
.word opcodeCB54_end - opcodeCB54
.word opcodeCB55_end - opcodeCB55
.word opcodeCB56_end - opcodeCB56
.word opcodeCB57_end - opcodeCB57
.word opcodeCB58_end - opcodeCB58
.word opcodeCB59_end - opcodeCB59
.word opcodeCB5A_end - opcodeCB5A
.word opcodeCB5B_end - opcodeCB5B
.word opcodeCB5C_end - opcodeCB5C
.word opcodeCB5D_end - opcodeCB5D
.word opcodeCB5E_end - opcodeCB5E
.word opcodeCB5F_end - opcodeCB5F
.word opcodeCB60_end - opcodeCB60
.word opcodeCB61_end - opcodeCB61
.word opcodeCB62_end - opcodeCB62
.word opcodeCB63_end - opcodeCB63
.word opcodeCB64_end - opcodeCB64
.word opcodeCB65_end - opcodeCB65
.word opcodeCB66_end - opcodeCB66
.word opcodeCB67_end - opcodeCB67
.word opcodeCB68_end - opcodeCB68
.word opcodeCB69_end - opcodeCB69
.word opcodeCB6A_end - opcodeCB6A
.word opcodeCB6B_end - opcodeCB6B
.word opcodeCB6C_end - opcodeCB6C
.word opcodeCB6D_end - opcodeCB6D
.word opcodeCB6E_end - opcodeCB6E
.word opcodeCB6F_end - opcodeCB6F
.word opcodeCB70_end - opcodeCB70
.word opcodeCB71_end - opcodeCB71
.word opcodeCB72_end - opcodeCB72
.word opcodeCB73_end - opcodeCB73
.word opcodeCB74_end - opcodeCB74
.word opcodeCB75_end - opcodeCB75
.word opcodeCB76_end - opcodeCB76
.word opcodeCB77_end - opcodeCB77
.word opcodeCB78_end - opcodeCB78
.word opcodeCB79_end - opcodeCB79
.word opcodeCB7A_end - opcodeCB7A
.word opcodeCB7B_end - opcodeCB7B
.word opcodeCB7C_end - opcodeCB7C
.word opcodeCB7D_end - opcodeCB7D
.word opcodeCB7E_end - opcodeCB7E
.word opcodeCB7F_end - opcodeCB7F
.word opcodeCB80_end - opcodeCB80
.word opcodeCB81_end - opcodeCB81
.word opcodeCB82_end - opcodeCB82
.word opcodeCB83_end - opcodeCB83
.word opcodeCB84_end - opcodeCB84
.word opcodeCB85_end - opcodeCB85
.word opcodeCB86_end - opcodeCB86
.word opcodeCB87_end - opcodeCB87
.word opcodeCB88_end - opcodeCB88
.word opcodeCB89_end - opcodeCB89
.word opcodeCB8A_end - opcodeCB8A
.word opcodeCB8B_end - opcodeCB8B
.word opcodeCB8C_end - opcodeCB8C
.word opcodeCB8D_end - opcodeCB8D
.word opcodeCB8E_end - opcodeCB8E
.word opcodeCB8F_end - opcodeCB8F
.word opcodeCB90_end - opcodeCB90
.word opcodeCB91_end - opcodeCB91
.word opcodeCB92_end - opcodeCB92
.word opcodeCB93_end - opcodeCB93
.word opcodeCB94_end - opcodeCB94
.word opcodeCB95_end - opcodeCB95
.word opcodeCB96_end - opcodeCB96
.word opcodeCB97_end - opcodeCB97
.word opcodeCB98_end - opcodeCB98
.word opcodeCB99_end - opcodeCB99
.word opcodeCB9A_end - opcodeCB9A
.word opcodeCB9B_end - opcodeCB9B
.word opcodeCB9C_end - opcodeCB9C
.word opcodeCB9D_end - opcodeCB9D
.word opcodeCB9E_end - opcodeCB9E
.word opcodeCB9F_end - opcodeCB9F
.word opcodeCBA0_end - opcodeCBA0
.word opcodeCBA1_end - opcodeCBA1
.word opcodeCBA2_end - opcodeCBA2
.word opcodeCBA3_end - opcodeCBA3
.word opcodeCBA4_end - opcodeCBA4
.word opcodeCBA5_end - opcodeCBA5
.word opcodeCBA6_end - opcodeCBA6
.word opcodeCBA7_end - opcodeCBA7
.word opcodeCBA8_end - opcodeCBA8
.word opcodeCBA9_end - opcodeCBA9
.word opcodeCBAA_end - opcodeCBAA
.word opcodeCBAB_end - opcodeCBAB
.word opcodeCBAC_end - opcodeCBAC
.word opcodeCBAD_end - opcodeCBAD
.word opcodeCBAE_end - opcodeCBAE
.word opcodeCBAF_end - opcodeCBAF
.word opcodeCBB0_end - opcodeCBB0
.word opcodeCBB1_end - opcodeCBB1
.word opcodeCBB2_end - opcodeCBB2
.word opcodeCBB3_end - opcodeCBB3
.word opcodeCBB4_end - opcodeCBB4
.word opcodeCBB5_end - opcodeCBB5
.word opcodeCBB6_end - opcodeCBB6
.word opcodeCBB7_end - opcodeCBB7
.word opcodeCBB8_end - opcodeCBB8
.word opcodeCBB9_end - opcodeCBB9
.word opcodeCBBA_end - opcodeCBBA
.word opcodeCBBB_end - opcodeCBBB
.word opcodeCBBC_end - opcodeCBBC
.word opcodeCBBD_end - opcodeCBBD
.word opcodeCBBE_end - opcodeCBBE
.word opcodeCBBF_end - opcodeCBBF
.word opcodeCBC0_end - opcodeCBC0
.word opcodeCBC1_end - opcodeCBC1
.word opcodeCBC2_end - opcodeCBC2
.word opcodeCBC3_end - opcodeCBC3
.word opcodeCBC4_end - opcodeCBC4
.word opcodeCBC5_end - opcodeCBC5
.word opcodeCBC6_end - opcodeCBC6
.word opcodeCBC7_end - opcodeCBC7
.word opcodeCBC8_end - opcodeCBC8
.word opcodeCBC9_end - opcodeCBC9
.word opcodeCBCA_end - opcodeCBCA
.word opcodeCBCB_end - opcodeCBCB
.word opcodeCBCC_end - opcodeCBCC
.word opcodeCBCD_end - opcodeCBCD
.word opcodeCBCE_end - opcodeCBCE
.word opcodeCBCF_end - opcodeCBCF
.word opcodeCBD0_end - opcodeCBD0
.word opcodeCBD1_end - opcodeCBD1
.word opcodeCBD2_end - opcodeCBD2
.word opcodeCBD3_end - opcodeCBD3
.word opcodeCBD4_end - opcodeCBD4
.word opcodeCBD5_end - opcodeCBD5
.word opcodeCBD6_end - opcodeCBD6
.word opcodeCBD7_end - opcodeCBD7
.word opcodeCBD8_end - opcodeCBD8
.word opcodeCBD9_end - opcodeCBD9
.word opcodeCBDA_end - opcodeCBDA
.word opcodeCBDB_end - opcodeCBDB
.word opcodeCBDC_end - opcodeCBDC
.word opcodeCBDD_end - opcodeCBDD
.word opcodeCBDE_end - opcodeCBDE
.word opcodeCBDF_end - opcodeCBDF
.word opcodeCBE0_end - opcodeCBE0
.word opcodeCBE1_end - opcodeCBE1
.word opcodeCBE2_end - opcodeCBE2
.word opcodeCBE3_end - opcodeCBE3
.word opcodeCBE4_end - opcodeCBE4
.word opcodeCBE5_end - opcodeCBE5
.word opcodeCBE6_end - opcodeCBE6
.word opcodeCBE7_end - opcodeCBE7
.word opcodeCBE8_end - opcodeCBE8
.word opcodeCBE9_end - opcodeCBE9
.word opcodeCBEA_end - opcodeCBEA
.word opcodeCBEB_end - opcodeCBEB
.word opcodeCBEC_end - opcodeCBEC
.word opcodeCBED_end - opcodeCBED
.word opcodeCBEE_end - opcodeCBEE
.word opcodeCBEF_end - opcodeCBEF
.word opcodeCBF0_end - opcodeCBF0
.word opcodeCBF1_end - opcodeCBF1
.word opcodeCBF2_end - opcodeCBF2
.word opcodeCBF3_end - opcodeCBF3
.word opcodeCBF4_end - opcodeCBF4
.word opcodeCBF5_end - opcodeCBF5
.word opcodeCBF6_end - opcodeCBF6
.word opcodeCBF7_end - opcodeCBF7
.word opcodeCBF8_end - opcodeCBF8
.word opcodeCBF9_end - opcodeCBF9
.word opcodeCBFA_end - opcodeCBFA
.word opcodeCBFB_end - opcodeCBFB
.word opcodeCBFC_end - opcodeCBFC
.word opcodeCBFD_end - opcodeCBFD
.word opcodeCBFE_end - opcodeCBFE
.word opcodeCBFF_end - opcodeCBFF

.endif

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
| 491 opcode functions generated
