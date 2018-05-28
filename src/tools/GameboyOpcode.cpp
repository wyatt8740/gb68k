#include <stdio.h>
#include <string.h>

/*
things to check
OR/XOR opcodes
JR displacement
*/

typedef struct _OPCODE {
	char func_name[32];
	unsigned char opcode_name;
	unsigned char dst_name;
	unsigned char src_name;
	unsigned char gb_cycles;
} OPCODE_HEADER;

typedef struct _SPECIAL_BIT {
	int pos;
	int num;
	char type[5];
} SPECIAL_BIT;

enum {
	BIT_R = 0,
	BIT_Q,
	SPECIAL_BIT_NUMBER,
};

#define MAX_LINE_LENGTH 5096
#define NONE -1
	
OPCODE_HEADER opcode_table[256];
OPCODE_HEADER suffix_table[256];
FILE *in, *func_out, *table_out;
unsigned char opcode_index;
unsigned char prefix;
unsigned char cycles;
int opcode_count;

//disassembly info
enum OPCODE_NAMES { //40 totla...6 bits
	OP_NOP, OP_LD, OP_PUSH, OP_POP, OP_ADD, OP_ADC, OP_SUB, OP_SBC, OP_AND, OP_OR, OP_XOR, OP_CP, OP_INC, OP_DEC,
	OP_DAA, OP_CPL, OP_CCF, OP_SCF, OP_HALT, OP_DI, OP_EI, OP_STOP, OP_SWAP,
	OP_RLCA, OP_RLA, OP_RRCA, OP_RRA, OP_RLC, OP_RL, OP_RRC, OP_RR, OP_SLA, OP_SRA, OP_SRL,
	OP_BIT, OP_SET, OP_RES, OP_JP, OP_JR, OP_CALL, OP_RET, OP_RETI, OP_RST,
};

const char *opcode_names[] = {
	"NOP", "LD", "PUSH", "POP", "ADD", "ADC", "SUB", "SBC", "AND", "OR", "XOR", "CP", "INC", "DEC",
	"DAA", "CPL", "CCF", "SCF", "HALT", "DI", "EI", "STOP", "SWAP",
	"RLCA", "RLA", "RRCA", "RRA", "RLC", "RL", "RRC", "RR", "SLA", "SRA", "SRL",
	"BIT", "SET", "RES", "JP", "JR", "CALL", "RET", "RETI", "RST",
};

enum OPERAND_NAMES {
	OP_NONE, OP_A, OP_B, OP_C, OP_D, OP_E, OP_H, OP_L, OP_AF, OP_BC, OP_DE, OP_HL, OP_SP,
	OP_BC_INDIR, OP_DE_INDIR, OP_HL_INDIR, OP_SP_INDIR, OP_HL_INC, OP_HL_DEC,
	OP_FF00_C, OP_0, OP_1, OP_2, OP_3, OP_4, OP_5, OP_6, OP_7, OP_FNZ, OP_FZ, OP_FNC, OP_FC,
	OP_R00, OP_R08, OP_R10, OP_R18, OP_R20, OP_R28, OP_R30, OP_R38,
	OP_IMMD8, OP_IMMD16, OP_IMMD_INDIR, OP_FF00_IMMD, OP_SP_IMMD,
};

const char *operand_names[] = {
	0, "A", "B", "C", "D", "E", "H", "L", "AF", "BC", "DE", "HL", "SP",
	"(BC)", "(DE)", "(HL)", "(SP)", "(HL)+", "(HL)-",
	"(FF00+C)", "0", "1", "2", "3", "4", "5", "6", "7", "NZ", "Z", "NC", "C",
	"00", "08", "10", "18", "20", "28", "30", "38",
	"nn", "nnnn", "(nnnn)", "(FF00+nn)", "SP+nn",
};

void get_lable(char *s)
{
	static int i = 0;

	sprintf(s, "_lable%04X", i);
	i++;
}

/*
CASES FOR LD8 (using A in reg, HL, BC, DE in memory)
ra -> rb
	move.b gb_A, (gb_data, dst_index)					; 12
	move.b (gb_data, src_index), gb_A					; 12
	move.b (gb_data, src_index), (gb_data, dst_index)	; 20
(ra) -> A
	move.w (gb_data, src_index), dt0					; 12
	move.b (gb_mem, dt0), gb_A							; 14
A -> (rb)
	move.w (gb_data, dst_index), dt0					; 12
	btst #15, dt0										; 10
	be _skip											; 10
	jmp memory_control
_skip:
	move.b gb_A, (gb_mem, dt0)							; 14
*/

enum ARG_SIZES {
	SIZE8,
	SIZE16,
	SIZE16_STACK,
};
	

typedef struct _ARG_FORMAT {
	int tag;
	int prefix_tag;
	int prefix;
	int special;
	char name;
	char size;
	bool dst;
} ARG_FORMAT;

//last_src and last_dst are the last operands used in add/sub operation
//used to generate half carry flag when needed

//gb_data: hl, bc, de, sp, last_src (word), last_dst (word)

//gb_pc - %a4
//gb_data - %a5
//gb_mem - %a3
//gb_A %d5
//gb_F0 %d6 
//gb_F1 %d7
//temp - %d0

//FLAG FORMAT
//F0[0] - carry flag
//F1[2] - zero flag
//F1[31] - iff
//F1[5] - add/subtract flag
//F1[6] - if add, a 1 here signifies a 16 bit add
//F1[7] - 1 specifies carry operation

/*char *reg_base[] = {
	"",
	"",
	"",
	"",
	"",
	"(HL_BASE, %a5)",
	"",
	"(SP_BASE, %a5)",
};*/

/*char *reg_func_base[] = {
	"",
	"",
	"",
	"",
	"",
	"(HL_FUNC, %a5)",
	"",
	"(SP_FUNC, %a5)",
};*/

char *arg_table[] = {
	"%d5",			//A
	"(%a5, 2)",		//B
	"(%a5, 3)",		//C
	"(%a5, 4)",		//D
	"(%a5, 5)",		//E
	"(%a5)",		//H
	"(%a5, 1)",		//L
	"(%a5, 6)",		//SP
	"(%a5, 7)",		//P
	"%d0",			//DT0
	"%d1",			//DT1
	"%d2",			//DT2
	"%d3",			//DT3
	"(%a0, %d0.w)",	//(MEM)
	"(%a4)+",		//immd8
	"#0", "#1", "#2", "#3", "#4", "#5", "#6", "#7",
	"#0x00", "#0x08", "#0x10", "#0x18", "#0x20", "#0x28", "#0x30", "#0x38",
};

char *arg_table_static[] = {
	"%d5",			//A
	"(%a5, 2)",		//B
	"(%a5, 3)",		//C
	"(%a5, 4)",		//D
	"(%a5, 5)",		//E
	"(%a5)",		//H
	"(%a5, 1)",		//L
	"(%a5, 6)",		//SP
	"(%a5, 7)",		//P
	"%d0",			//DT0
	"%d1",			//DT1
	"%d2",			//DT2
	"%d3",			//DT3
	"(%a0, %d0.w)",	//MEM
	"(%a4)",		//immd8
	"#0", "#1", "#2", "#3", "#4", "#5", "#6", "#7",
	"#0x00", "#0x08", "#0x10", "#0x18", "#0x20", "#0x28", "#0x30", "#0x38",
};

enum OPCODE_TYPES {
	TYPE_LD8,
	TYPE_LD16,

	TYPE_INC,
	TYPE_DEC,
	TYPE_RLC,
	TYPE_RL,
	TYPE_RRC,
	TYPE_RR,
	TYPE_SLA,
	TYPE_SRA,
	TYPE_SRL,
	TYPE_SET,
	TYPE_RES,
	TYPE_SWAP,
};

enum ARG_TAGS {
	ARG_A,
	ARG_B,
	ARG_C,
	ARG_D,
	ARG_E,
	ARG_H,
	ARG_L,
	ARG_SP,
	ARG_P,
	ARG_DT0,
	ARG_DT1,
	ARG_DT2,
	ARG_DT3,
	ARG_MEM,
	ARG_IMMD8,
	ARG_0, ARG_1, ARG_2, ARG_3, ARG_4, ARG_5, ARG_6, ARG_7,
	ARG_R00, ARG_R08, ARG_R10, ARG_R18, ARG_R20, ARG_R28, ARG_R30, ARG_R38,
	ARG_FNZ,
	ARG_FZ,
	ARG_FNC,
	ARG_FC,
};

enum ARG_PREFIX {
	PREFIX_MEM_REG_INDIR,
	PREFIX_MEM_IMMD_INDIR,
	PREFIX_MEM_FF00,
	PREFIX_SP_IMMD,
	PREFIX_GET_IMMD16,
	PREFIX_GET_AF,
	PREFIX_GET_SP,
};

enum ARG_SPECIAL {
	SPECIAL_INC_HL,
	SPECIAL_DEC_HL,
	//SPECIAL_INC_SP,
	//SPECIAL_DEC_SP,
};

void next_instruction2(char *lable)
{
	int offset;

	if(opcode_index < 128) offset = 256 * opcode_index;
	else offset = -(256-opcode_index) * 256;
	if(prefix == 0xCB) offset += 180;
	
	//hack to get around stupid assembler
	if(prefix == 0x00 && opcode_index == 0x80)
		fprintf(func_out, "\tNEXT_INSTRUCTION 20+NEXT_INSTRUCTION_SIZE + (%d)\n",
		offset);
	else
		fprintf(func_out, "\tNEXT_INSTRUCTION %s - opcode%02X%02X + (%d)\n",
		lable, prefix, opcode_index, offset);
}

void next_instruction()
{
	char lable[1024];
	sprintf(lable, "opcode%02X%02X_end", prefix, opcode_index);
	next_instruction2(lable);
}


void write_prefix(ARG_FORMAT *arg, ARG_FORMAT *other, bool read_modify, int opcode_type);

void clear_half_carry_flag()
{
#ifdef ACCURATE_HALF_CARRY
	fprintf(func_out, "\tclr.l (LAST_SRC, %%a5) | clear half carry\n");
#endif
}

void set_half_carry_flag()
{
#ifdef ACCURATE_HALF_CARRY
	fprintf(func_out, "\tmoveq #-1, %%d1 | set half carry\n");
	fprintf(func_out, "\tmove.l %%d1, (LAST_SRC, %%a5)\n");
#endif
}

//update_zero_flag also clears subtract and clears 16bit
void update_carry_flag() { fprintf(func_out, "\tmove.w %%sr, %%d6 | update carry\n"); }
void update_zero_flag() { fprintf(func_out, "\tmove.w %%sr, %%d7 | update zero\n"); }
void set_subtract_flag() { fprintf(func_out, "\tori.b #0x20, %%d7 | set subtract\n"); }
void clear_subtract_flag() { fprintf(func_out, "\tandi.b #~0x20, %%d7 | clear subtract\n"); }
void clear_carry_flag() { fprintf(func_out, "\tclr.b %%d6 | clear carry\n"); }
void clear_zero_flag() { fprintf(func_out, "\tclr.b %%d7 | clear zero\n"); }

void carry_to_extend()
{
	fprintf(func_out, "\tbtst.b #0, %%d6 | copy carry to extend\n");
	fprintf(func_out, "\tsne %%d1\n"); //Z clear - 0xff, Z set - 0x00
	fprintf(func_out, "\tadd.b %%d1, %%d1\n"); //set extend flag with 0xff+0xff, clear with 0+0
}

void calculate_half_carry()
{
	char add16[1024], add8[1024], no_flag[1024];
	get_lable(add16); get_lable(add8); get_lable(no_flag);
	
	fprintf(func_out, "calculate_half_carry: | puts half carry flag in bit 5 of %%d2\n");
	fprintf(func_out, "\tbtst #6, %%d7\n");
	fprintf(func_out, "\tbne %s\n", add16);
	
	fprintf(func_out, "\tmove.b (LAST_SRC, %%a5), %%d0\n"); //src
	fprintf(func_out, "\tmove.b (LAST_DST, %%a5), %%d1\n"); //dst
	fprintf(func_out, "\tmove.b %%d1, %%d3\n"); //dst

	fprintf(func_out, "\tbtst #5, %%d7\n");
	fprintf(func_out, "\tbeq %s\n", add8);

	fprintf(func_out, "\tsub.b %%d0, %%d1\n");
	fprintf(func_out, "\teor.b %%d0, %%d3\n");
	fprintf(func_out, "\teor.b %%d1, %%d3\n");
	fprintf(func_out, "\tbtst #4, %%d3\n");
	fprintf(func_out, "\tbeq %s\n", no_flag);
	fprintf(func_out, "\tbset #5, %%d2\n");
	fprintf(func_out, "\trts\n");

	fprintf(func_out, "%s:\n", add8);
	fprintf(func_out, "\tadd.b %%d0, %%d1\n");
	fprintf(func_out, "\teor.b %%d0, %%d3\n");
	fprintf(func_out, "\teor.b %%d1, %%d3\n");
	fprintf(func_out, "\tbtst #4, %%d3\n");
	fprintf(func_out, "\tbeq %s\n", no_flag);
	fprintf(func_out, "\tbset #5, %%d2\n");
	fprintf(func_out, "\trts\n");

	fprintf(func_out, "%s:\n", add16);
	fprintf(func_out, "\tmove.w (LAST_SRC, %%a5), %%d0\n"); //src
	fprintf(func_out, "\tmove.w (LAST_DST, %%a5), %%d1\n"); //dst
	fprintf(func_out, "\tmove.w %%d1, %%d3\n"); //dst
	fprintf(func_out, "\tadd.w %%d0, %%d1\n");
	fprintf(func_out, "\teor.w %%d0, %%d3\n");
	fprintf(func_out, "\teor.w %%d1, %%d3\n");
	fprintf(func_out, "\tbtst #12, %%d3\n");
	fprintf(func_out, "\tbeq %s\n", no_flag);
	fprintf(func_out, "\tbset #5, %%d2\n");
	fprintf(func_out, "%s:\n", no_flag);
	fprintf(func_out, "\trts\n");
}

//returns gb relative SP in loc
void get_SP(short loc)
{
	fprintf(func_out, "\tmove.l %%a2, %s\n", arg_table[loc]);
	fprintf(func_out, "\tmove.w (SP_BASE, %%a5), %%d0\n");
	fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d0.w), %%a1\n");
	fprintf(func_out, "\tsub.l (%%a1), %s | sp now relative to block\n", arg_table[loc]);
	fprintf(func_out, "\tlsl.w #5, %%d0 | d0 is now block index * 256\n");
	fprintf(func_out, "\tadd.l %%d0, %s | sp is now correct\n", arg_table[loc]);
}

void new_SP(short loc)
{
	// RELATIVE SP --> ABSOULTE SP (in a2)
	fprintf(func_out, "\tmoveq.l #0, %%d0\n");
	fprintf(func_out, "\tmove.b %s, %%d0 | d0 is offset\n", arg_table[loc]);
	fprintf(func_out, "\tclr.b %s\n", arg_table[loc]);
	fprintf(func_out, "\tlsr.w #5, %s | get block index * 8\n", arg_table[loc]);
	fprintf(func_out, "\tmove.w %s, (SP_BASE, %%a5) | store block index\n", arg_table[loc]);
	fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %s.w), %%a1\n", arg_table[loc]);
	fprintf(func_out, "\tmovea.l (%%a1), %%a2 | sp points to start of block\n");
	fprintf(func_out, "\tadda.l %%d0, %%a2 | now sp is correct\n");
}

void new_SP_immd()
{
	// (%a4)+ --> ABSOULTE SP (in a2)
	fprintf(func_out, "\tmoveq.l #0, %%d0\n");
	fprintf(func_out, "\tmoveq.l #0, %%d2\n");
	fprintf(func_out, "\tmove.b (%%a4)+, %%d0\n");
	fprintf(func_out, "\tmove.b (%%a4)+, %%d2\n");
	fprintf(func_out, "\tcmp.b #0xE0, %%d2 | Hack for games with stack at top of RAM\n");
	fprintf(func_out, "\tbne 0f\n");
	fprintf(func_out, "\tsubq.b #1, %%d2\n");
	fprintf(func_out, "\tmove.w #0x100, %%d0\n");
	fprintf(func_out, "0:\n");
	fprintf(func_out, "\tlsl.w #3, %%d2 | d2 is block index * 8\n");
	fprintf(func_out, "\tmove.w %%d2, (SP_BASE, %%a5) | store block index\n");
	fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d2.w), %%a1\n");
	fprintf(func_out, "\tmovea.l (%%a1), %%a2 | sp points to start of block\n");
	fprintf(func_out, "\tadda.l %%d0, %%a2 | now sp is correct\n");
}

//assumes relative PC (word) is in D2, and that flags are set apropriately
void new_PC()
{
	// RELATIVE PC (in d2) --> ABSOULTE PC (in a4)
	fprintf(func_out, "\tmoveq.l #0, %%d0\n");
	fprintf(func_out, "\tmove.b %%d2, %%d0 | d0 is offset\n");
	fprintf(func_out, "\tclr.b %%d2\n");
	fprintf(func_out, "\tlsr.w #5, %%d2 | d2 is block index * 8\n");
	fprintf(func_out, "\tmove.w %%d2, (PC_BASE, %%a5) | store block index\n");
	fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d2.w), %%a1\n");
	fprintf(func_out, "\tmovea.l (%%a1), %%a4 | pc points to start of block\n");
	fprintf(func_out, "\tadda.l %%d0, %%a4 | now pc is correct\n");
}

//reads new PC at current PC
void new_PC_immd(bool read_dir)
{
	// RELATIVE PC (in d2) --> ABSOULTE PC (in a4)
	fprintf(func_out, "\tmoveq.l #0, %%d0\n");
	fprintf(func_out, "\tclr.w %%d2\n");
	if(read_dir) {
		fprintf(func_out, "\tmove.b (%%a4)+, %%d0\n");
		fprintf(func_out, "\tmove.b (%%a4)+, %%d2\n");
	} else {
		fprintf(func_out, "\tmove.b -(%%a4), %%d2\n");
		fprintf(func_out, "\tmove.b -(%%a4), %%d0\n");
	}
	fprintf(func_out, "\tlsl.w #3, %%d2 | d2 is block index * 8\n");
	fprintf(func_out, "\tmove.w %%d2, (PC_BASE, %%a5) | store block index\n");
	fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d2.w), %%a1\n");
	fprintf(func_out, "\tmovea.l (%%a1), %%a4 | pc points to start of block\n");
	fprintf(func_out, "\tadda.l %%d0, %%a4 | now pc is correct\n");
}

void push_PC()
{
	/*ARG_FORMAT dst;
	ARG_FORMAT src;

	dst.dst = true;
	dst.prefix = PREFIX_MEM_REG_INDIR;
	dst.prefix_tag = ARG_SP;
	dst.tag = ARG_MEM;
	dst.special = SPECIAL_DEC_SP;
	dst.size = SIZE16_STACK;

	src.dst = false;
	src.prefix = NONE;
	src.tag = ARG_DT2;*/
	
	fprintf(func_out, "push_PC:\n");
	fprintf(func_out, "\tmove.l %%d2, -(%%sp)\n");
	fprintf(func_out, "\tmove.l %%a4, %%d2\n");
	fprintf(func_out, "\tmove.w (PC_BASE, %%a5), %%d0\n");
	fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d0.w), %%a1\n");
	fprintf(func_out, "\tsub.l (%%a1), %%d2 | pc now relative to block\n");
	fprintf(func_out, "\tlsl.w #5, %%d0 | d0 is now block index * 256\n");
	fprintf(func_out, "\tadd.l %%d0, %%d2 | pc is now correct\n");

	fprintf(func_out, "\tlea (-2, %%a2), %%a2\n");
	fprintf(func_out, "\tmove.b %%d2, (%%a2)\n");
	fprintf(func_out, "\trol.w #8, %%d2\n");
	fprintf(func_out, "\tmove.b %%d2, (%%a2, 1)\n");
	fprintf(func_out, "\tmove.l (%%sp)+, %%d2\n");
	fprintf(func_out, "\trts\n");


	/*write_prefix(&dst, &src, false, TYPE_LD16);

	fprintf(func_out, "\tmove.b %%d2, (%%a0, %%d0.w)\n");
	fprintf(func_out, "\trol.w #8, %%d2\n");
	fprintf(func_out, "\tmove.b %%d2, (1, %%a0, %%d0.w)\n");
	fprintf(func_out, "\tmove.l (%%sp)+, %%d2\n");
	fprintf(func_out, "\trts\n");*/
	
	/*fprintf(func_out, "\tmove.l %%a4, %%d1 | push PC\n");
	fprintf(func_out, "\tsub.l %%a3, %%d1\n");
	fprintf(func_out, "\tmove.w %s, %%a0\n", arg_table[ARG_SP]);
	fprintf(func_out, "\tmove.b %%d1, (-2, %%a3, %%a0) | PC lsb\n");
	fprintf(func_out, "\trol.w #8, %%d1\n");
	fprintf(func_out, "\tmove.b %%d1, (-1, %%a3, %%a0) | PC msb\n");
	fprintf(func_out, "\tsubq.w #2, %%a0\n");
	fprintf(func_out, "\tmove.w %%a0, %s\n", arg_table[ARG_SP]);*/
}

void pop_PC()
{
	/*ARG_FORMAT src;

	src.dst = false;
	src.prefix = PREFIX_MEM_REG_INDIR;
	src.prefix_tag = ARG_SP;
	src.special = SPECIAL_INC_SP;*/
	
	fprintf(func_out, "pop_PC:\n");
	/*write_prefix(&src, 0, false, TYPE_LD16);
	
	fprintf(func_out, "\tclr.l %%d2\n");
	fprintf(func_out, "\tmove.b (1, %%a0, %%d0.w), %%d2\n");
	fprintf(func_out, "\trol.w #8, %%d2\n");
	fprintf(func_out, "\tmove.b (%%a0, %%d0.w), %%d2\n");*/
	fprintf(func_out, "\tmoveq.l #0, %%d0\n");
	fprintf(func_out, "\tclr.w %%d2\n");
	fprintf(func_out, "\tmove.b (%%a2)+, %%d0\n");
	fprintf(func_out, "\tmove.b (%%a2)+, %%d2\n");
	fprintf(func_out, "\tlsl.w #3, %%d2 | d2 is block index * 8\n");
	fprintf(func_out, "\tmove.w %%d2, (PC_BASE, %%a5) | store block index\n");
	fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d2.w), %%a1\n");
	fprintf(func_out, "\tmovea.l (%%a1), %%a4 | pc points to start of block\n");
	fprintf(func_out, "\tadda.l %%d0, %%a4 | now pc is correct\n");

	//new_PC();
	fprintf(func_out, "\trts\n");
	/*fprintf(func_out, "\tmove.w %s, %%a0 | pop PC\n", arg_table[ARG_SP]);
	fprintf(func_out, "\tclr.l %%d1\n");
	fprintf(func_out, "\tmove.b (1, %%a3, %%a0), %%d1 | msb\n");
	fprintf(func_out, "\trol.w #8, %%d1\n");
	fprintf(func_out, "\tmove.b (%%a3, %%a0), %%d1 | lsb\n");
	fprintf(func_out, "\taddq.w #2, %%a0\n");
	fprintf(func_out, "\tmove.w %%a0, %s\n", arg_table[ARG_SP]);
	fprintf(func_out, "\tadd.l %%a3, %%d1\n");
	fprintf(func_out, "\tmove.l %%d1, %%a4\n");*/
}

void write_mem_special_prefix(ARG_FORMAT *arg)
{
	//if(arg->special == SPECIAL_DEC_SP) {
	//	fprintf(func_out, "\tsubq.w #2, %s\n", arg_table[ARG_SP]);
	//}
}

void write_mem_special_suffix(ARG_FORMAT *arg)
{
	if(arg->special == SPECIAL_INC_HL) {
		fprintf(func_out, "\taddq.w #1, %s\n", arg_table[ARG_H]);
	} else if(arg->special == SPECIAL_DEC_HL) {
		fprintf(func_out, "\tsubq.w #1, %s\n", arg_table[ARG_H]);
	}// else if(arg->special == SPECIAL_INC_SP) {
	//	fprintf(func_out, "\taddq.w #2, %s\n", arg_table[ARG_SP]);
	//}
}

void write_false_mem(int opcode_type, ARG_FORMAT *other)
{
	if(opcode_type == TYPE_LD8) {
		if(other->tag != ARG_DT2)
			fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[other->tag]);
	} else if(opcode_type == TYPE_LD16) {
		if(other->tag != ARG_DT2)
			fprintf(func_out, "\tmove.w %s, %%d2\n", arg_table[other->tag]);
		else if(other->prefix == PREFIX_GET_AF) {
			fprintf(func_out, "\tlsl.w #8, %%d2\n");
			fprintf(func_out, "\tor.b %%d5, %%d2\n");
			fprintf(func_out, "\trol.w #8, %%d2\n");
		}
		//will only happen for PUSH rr, or LD (nnnn), SP
		/*if(other->prefix == PREFIX_GET_AF) {
			fprintf(func_out, "\tjsr (%%a3, %%d1.w)\n"); //store lower byte (F), already in d2
			fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[ARG_A]); //store upper byte
			fprintf(func_out, "\taddq.b #1, %%d0\n");
		} else {
			fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[other->tag + 1]); //store lower byte
			fprintf(func_out, "\tjsr (%%a3, %%d1.w)\n");
			fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[other->tag]); //store upper byte
			fprintf(func_out, "\taddq.b #1, %%d0\n");
		}*/
	}
}

/*
Prefix register usage:
	Memory base: %a0
	Memory offset: %d0
	Function base: %a3
	Function offset: %d1
	Output from prefix: %d2
	Input to prefix: %d3
*/

/*void new_HL()
{
	fprintf(func_out, "\tclr.w %%d3\n");
	fprintf(func_out, "\tmove.b %s, %%d3\n", arg_table[ARG_H]);
	fprintf(func_out, "\tlsl.w #3, %%d3\n");
	fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d3.w), %%a2\n");
	fprintf(func_out, "\tmove.l (%%a2)+, (HL_BASE, %%a5)\n");
	fprintf(func_out, "\tmove.w (%%a2), (HL_FUNC, %%a5)\n");
}*/
/*
void new_SP()
{
	fprintf(func_out, "\tclr.w %%d3\n");
	fprintf(func_out, "\tmove.b %s, %%d3\n", arg_table[ARG_SP]);
	fprintf(func_out, "\tlsl.w #3, %%d3\n");
	fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d3.w), %%a2\n");
	fprintf(func_out, "\tmove.l (%%a2)+, (SP_BASE, %%a5)\n");
	fprintf(func_out, "\tmove.w (%%a2), (SP_FUNC, %%a5)\n");
}*/

void write_prefix(ARG_FORMAT *arg, ARG_FORMAT *other, bool read_modify, int opcode_type)
{
	char lable[1024];
	char no_carry[1024], no_zero[1024], no_subtract[1024];
	if(arg->prefix == PREFIX_MEM_REG_INDIR) {
		/*if(arg->prefix_tag == ARG_H || arg->prefix_tag == ARG_SP) {
			if(arg->special == SPECIAL_DEC_SP) {
				fprintf(func_out, "\tsubq.b #2, %s\n", arg_table[ARG_P]);
				fprintf(func_out, "\tbcc 0f\n");
				fprintf(func_out, "\tsubq.b #1, %s\n", arg_table[ARG_SP]);
				new_SP();
				fprintf(func_out, "0:\n");
			}
			fprintf(func_out, "\tclr.w %%d0\n");
			fprintf(func_out, "\tmovea.l %s, %%a0\n",
				reg_base[arg->prefix_tag]);
			fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[arg->prefix_tag + 1]);
			if(arg->dst && !read_modify)
				fprintf(func_out, "\tmove.w %s, %%d1\n", reg_func_base[arg->prefix_tag]);
			if(arg->special == SPECIAL_INC_HL || arg->special == SPECIAL_DEC_HL
			|| arg->special == SPECIAL_INC_SP) {
				if(arg->special == SPECIAL_INC_HL) {
					fprintf(func_out, "\taddq.b #1, %s\n", arg_table[ARG_L]);
					fprintf(func_out, "\tbcc 0f\n");
					fprintf(func_out, "\taddq.b #1, %s\n", arg_table[ARG_H]);
					new_HL();
				} else if(arg->special == SPECIAL_DEC_HL) {
					fprintf(func_out, "\tsubq.b #1, %s\n", arg_table[ARG_L]);
					fprintf(func_out, "\tbcc 0f\n");
					fprintf(func_out, "\tsubq.b #1, %s\n", arg_table[ARG_H]);
					new_HL();
				} else if(arg->special == SPECIAL_INC_SP) {
					fprintf(func_out, "\taddq.b #2, %s\n", arg_table[ARG_P]);
					fprintf(func_out, "\tbcc 0f\n");
					fprintf(func_out, "\taddq.b #1, %s\n", arg_table[ARG_SP]);
					new_SP();
				}
				fprintf(func_out, "0:\n");
				if(arg->dst && !read_modify) fprintf(func_out, "\ttst.w %%d1\n");
			}
		} else {*/
			//write_mem_special_prefix(arg);
			//if(arg->special == SPECIAL_DEC_SP)
			//	fprintf(func_out, "\tsubq.w #2, %s\n", arg_table[ARG_SP]);
			//if(arg->prefix_tag == ARG_SP) return; //no need for SP prefix
			if(arg->prefix_tag != ARG_DT3)
				fprintf(func_out, "\tmove.w %s, %%d3\n", arg_table[arg->prefix_tag]);

			if(arg->special == SPECIAL_INC_HL)
				fprintf(func_out, "\taddq.w #1, %s\n", arg_table[ARG_H]);
			else if(arg->special == SPECIAL_DEC_HL)
				fprintf(func_out, "\tsubq.w #1, %s\n", arg_table[ARG_H]);
			//else if(arg->special == SPECIAL_INC_SP)
			//	fprintf(func_out, "\taddq.w #2, %s\n", arg_table[ARG_SP]);

			//write_mem_special_suffix(arg);
			fprintf(func_out, "\tclr.w %%d0\n");
			fprintf(func_out, "\tmove.b %%d3, %%d0\n");
			fprintf(func_out, "\tclr.b %%d3\n");
			fprintf(func_out, "\tlsr.w #5, %%d3\n");
			fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d3.w), %%a1\n");
			fprintf(func_out, "\tmovea.l (%%a1)+, %%a0\n");
			if(arg->dst && !read_modify) fprintf(func_out, "\tmove.w (%%a1), %%d1\n");
		//}
		if(arg->dst && !read_modify) { //check for special write
			get_lable(lable);
			fprintf(func_out, "\tbeq %s\n", lable); //no special write
			write_false_mem(opcode_type, other); //get arg into d2
			if(arg->size == SIZE16) {
				fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
				fprintf(func_out, "\tmove.l (NEXT_EVENT, %%a5), (SAVE_EVENT_MEM16, %%a5)\n");
				fprintf(func_out, "\tmove.w %%d4, (SAVE_COUNT_MEM16, %%a5)\n");
				fprintf(func_out, "\tmove.l #write16_finish, (NEXT_EVENT, %%a5)\n");
				fprintf(func_out, "\tmoveq #-1, %%d4\n");
				/*if(arg->prefix_tag == ARG_H) { //d3 needs to be set
					fprintf(func_out, "\tclr.w %%d3\n");
					fprintf(func_out, "\tmove.b (GB_H, %%a5), %%d3\n");
					fprintf(func_out, "\tlsl.w #3, %%d3\n");
				} else if(arg->prefix_tag == ARG_SP) {
					fprintf(func_out, "\tclr.w %%d3\n");
					fprintf(func_out, "\tmove.b (GB_SP, %%a5), %%d3\n");
					fprintf(func_out, "\tlsl.w #3, %%d3\n");
				}*/
			} else if(arg->size == SIZE16_STACK) {
				fprintf(func_out, "\tmove.l (NEXT_EVENT, %%a5), (SAVE_EVENT_MEM16, %%a5)\n");
				fprintf(func_out, "\tmove.w %%d4, (SAVE_COUNT_MEM16, %%a5)\n");
				fprintf(func_out, "\tmove.l #write16_stack_finish, (NEXT_EVENT, %%a5)\n");
				fprintf(func_out, "\tmoveq #-1, %%d4\n");
				/*if(arg->prefix_tag == ARG_SP) {
					fprintf(func_out, "\tclr.w %%d3\n");
					fprintf(func_out, "\tmove.b (GB_SP, %%a5), %%d3\n");
					fprintf(func_out, "\tlsl.w #3, %%d3\n");
				}*/
			} else
				fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
			fprintf(func_out, "\tjmp (%%a3, %%d1.w)\n");
			fprintf(func_out, "%s:\n", lable);
		}
		if(read_modify) {
			fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[arg->tag]);
			arg->tag = ARG_DT2;
		}
	} else if(arg->prefix == PREFIX_MEM_IMMD_INDIR) {
		fprintf(func_out, "\tclr.w %%d0\n");
		fprintf(func_out, "\tclr.w %%d3\n");
		fprintf(func_out, "\tmove.b (%%a4)+, %%d0\n");
		fprintf(func_out, "\tmove.b (%%a4)+, %%d3\n");
		fprintf(func_out, "\tlsl.w #3, %%d3\n");
		fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d3.w), %%a1\n");
		fprintf(func_out, "\tmovea.l (%%a1)+, %%a0\n");
		if(arg->dst && !read_modify) {
			get_lable(lable);
			fprintf(func_out, "\tmove.w (%%a1), %%d1\n");
			fprintf(func_out, "\tbeq %s\n", lable);
			
			write_false_mem(opcode_type, other);
			
			if(arg->size == SIZE16) {
				fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
				fprintf(func_out, "\tmove.l (NEXT_EVENT, %%a5), (SAVE_EVENT_MEM16, %%a5)\n");
				fprintf(func_out, "\tmove.w %%d4, (SAVE_COUNT_MEM16, %%a5)\n");
				fprintf(func_out, "\tmove.l #write16_finish, (NEXT_EVENT, %%a5)\n");
				fprintf(func_out, "\tmoveq #-1, %%d4\n");
			} else if(arg->size == SIZE16_STACK) {
				fprintf(func_out, "\tmove.l (NEXT_EVENT, %%a5), (SAVE_EVENT_MEM16, %%a5)\n");
				fprintf(func_out, "\tmove.w %%d4, (SAVE_COUNT_MEM16, %%a5)\n");
				fprintf(func_out, "\tmove.l #write16_stack_finish, (NEXT_EVENT, %%a5)\n");
				fprintf(func_out, "\tmoveq #-1, %%d4\n");
			} else
				fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
				
			fprintf(func_out, "\tjmp (%%a3, %%d1.w)\n");
			fprintf(func_out, "%s:\n", lable);
		}
		if(read_modify) {
			fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[arg->tag]);
			arg->tag = ARG_DT2;
		}
	} else if(arg->prefix == PREFIX_MEM_FF00) {
		fprintf(func_out, "\tclr.w %%d0\n");
		fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[arg->prefix_tag]);
		fprintf(func_out, "\tmovea.l (MEM_TABLE+2040, %%a5), %%a0\n");
		if(arg->dst) {
			fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
			write_false_mem(opcode_type, other);
			fprintf(func_out, "\tmove.w %%d0, %%d1\n");
			fprintf(func_out, "\tadd.w %%d1, %%d1\n");
			fprintf(func_out, "\tlea io_write_table:l, %%a1\n");
			fprintf(func_out, "\tmovea.w (%%a1, %%d1.w), %%a1\n");
			fprintf(func_out, "\tjmp (%%a3, %%a1.w)\n");
		}
	} else if(arg->prefix == PREFIX_SP_IMMD) {
		get_SP(ARG_DT2);
		fprintf(func_out, "\tmove.b %s, %%d1\n", arg_table[ARG_IMMD8]);
		fprintf(func_out, "\text.w %%d1\n");
		//FLAG START
#ifdef ACCURATE_HALF_CARRY
		fprintf(func_out, "\tmove.w %%d1, (LAST_SRC, %%a5)\n");
		fprintf(func_out, "\tmove.w %%d2, (LAST_DST, %%a5)\n", arg_table[ARG_SP]);
#endif
		//FLAG END
		fprintf(func_out, "\tadd.w %%d1, %%d2\n");
		//FLAG START
		update_carry_flag();
		fprintf(func_out, "\tmove.b #0x40, %%d7 | set 16 bit add, clear subtract/zero flag\n");
		//FLAG END
	} else if(arg->prefix == PREFIX_GET_IMMD16) {
		fprintf(func_out, "\tmove.b (%%a4, 1), %%d2\n");
		fprintf(func_out, "\trol.w #8, %%d2\n");
		fprintf(func_out, "\tmove.b (%%a4), %%d2\n");
		fprintf(func_out, "\taddq.w #2, %%a4\n");
	} else if(arg->prefix == PREFIX_GET_AF) {
		get_lable(no_carry); get_lable(no_zero); get_lable(no_subtract);
		fprintf(func_out, "\tclr.b %%d2\n");
		fprintf(func_out, "\tbtst.b #0, %%d6\n");
		fprintf(func_out, "\tbeq %s\n", no_carry);
		fprintf(func_out, "\tbset #4, %%d2 | set gb carry\n");
		fprintf(func_out, "%s:\n", no_carry);

		fprintf(func_out, "\tbtst.b #2, %%d7\n");
		fprintf(func_out, "\tbeq %s\n", no_zero);
		fprintf(func_out, "\tbset #7, %%d2 | set gb zero\n");
		fprintf(func_out, "%s:\n", no_zero);

		fprintf(func_out, "\tbtst.b #5, %%d7\n");
		fprintf(func_out, "\tbeq %s\n", no_subtract);
		fprintf(func_out, "\tbset #6, %%d2 | set gb subtract\n");
		fprintf(func_out, "%s:\n", no_subtract);
#ifdef ACCURATE_HALF_CARRY
		fprintf(func_out, "\tjsr calculate_half_carry :l\n");
#endif
	} else if(arg->prefix == PREFIX_GET_SP && !arg->dst) {
		get_SP(arg->tag);
	}
}

void write_suffix(ARG_FORMAT *arg)
{
	char lable[1024];

	if(arg->prefix == PREFIX_MEM_REG_INDIR && arg->dst) {
		get_lable(lable);
		//if(arg->prefix_tag == ARG_H) fprintf(func_out, "\tmove.w (HL_FUNC, %%a5), %%d1\n");
		//else if(arg->prefix_tag == ARG_SP) fprintf(func_out, "\tmove.w (SP_FUNC, %%a5), %%d1\n");
		//else
		fprintf(func_out, "\tmove.w (%%a1), %%d1\n");

		fprintf(func_out, "\tbeq %s\n", lable);
		fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
		fprintf(func_out, "\tjmp (%%a3, %%d1.w)\n");
		fprintf(func_out, "%s:\n", lable);
		fprintf(func_out, "\tmove.b %%d2, (%%a0, %%d0.w)\n");
	} else if(arg->prefix == PREFIX_GET_SP && arg->dst) {
		new_SP(arg->tag);
	}
}

/*
void write_suffix(ARG_FORMAT *arg)
{
	if(arg->suffix == SUFFIX_INC) {
		fprintf(func_out, "\taddq.w #1, %s\n", arg_table[arg->suffix_tag]);
	} else if(arg->suffix == SUFFIX_DEC) {
		fprintf(func_out, "\tsubq.w #1, %s\n", arg_table[arg->suffix_tag]);
	}
}*/

bool write_LD8(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	if(src->tag == dst->tag) return false;
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, TYPE_LD8);
	write_prefix(dst, src, false, TYPE_LD8);
	if(dst->prefix != PREFIX_MEM_FF00) {
		fprintf(func_out, "\tmove.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
		//if(dst->tag == ARG_H) new_HL();
		fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
		next_instruction();
	}
	return true;
}

bool write_LD16(ARG_FORMAT *src, ARG_FORMAT *dst)
{	
	if(src->tag == dst->tag && src->prefix == dst->prefix) return false;
	dst->size = SIZE16;
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);

	if(src->prefix == PREFIX_GET_IMMD16) {
		//SPECIAL CASE...prefix_get_immd16 generates poor code here
		if(dst->prefix == PREFIX_GET_SP) new_SP_immd();
		else {
			fprintf(func_out, "\tmove.b (%%a4)+, %s\n", arg_table[dst->tag + 1]);
			fprintf(func_out, "\tmove.b (%%a4)+, %s\n", arg_table[dst->tag]);
		}
		fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
		next_instruction();
		return true;
	}

	write_prefix(src, dst, false, TYPE_LD16);
	write_prefix(dst, src, false, TYPE_LD16);
	
	if(dst->tag == ARG_MEM) { //handle proper endianess
		if(src->prefix == PREFIX_GET_SP) {
			fprintf(func_out, "\tmove.b %s, (%%a0, %%d0.w)\n", arg_table[src->tag]);
			fprintf(func_out, "\trol.w #8, %s\n", arg_table[src->tag]);
			fprintf(func_out, "\tmove.b %s, (1, %%a0, %%d0.w)\n", arg_table[src->tag]);
		} else {
			fprintf(func_out, "\tmove.b %s, (1, %%a0, %%d0.w)\n", arg_table[src->tag]);
			fprintf(func_out, "\tmove.b %s, (%%a0, %%d0.w)\n", arg_table[src->tag + 1]);
		}
	} else if(src->tag == ARG_MEM) { //handle proper endianess
		fprintf(func_out, "\tmove.b (1, %%a0, %%d0.w), %s\n", arg_table[dst->tag]);
		fprintf(func_out, "\tmove.b (%%a0, %%d0.w), %s\n", arg_table[dst->tag + 1]);
	} else {
		fprintf(func_out, "\tmove.w %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	}
	//if(dst->tag == ARG_H) new_HL();
	//else if(dst->tag == ARG_SP) new_SP();
	write_suffix(dst);
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_PUSH(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, false, TYPE_LD16);
	if(dst->prefix == PREFIX_GET_AF) {
		fprintf(func_out, "\tmove.b %%d5, -(%%a2)\n");
		fprintf(func_out, "\tmove.b %%d2, -(%%a2)\n");
	} else {
		fprintf(func_out, "\tmove.b %s, -(%%a2)\n", arg_table[dst->tag]);
		fprintf(func_out, "\tmove.b %s, -(%%a2)\n", arg_table[dst->tag + 1]);
	}
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_POP(ARG_FORMAT *dst)
{
	char no_half_carry[1024], test_zero[1024], no_subtract[1024];
	
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->prefix == PREFIX_GET_AF) {
		get_lable(no_half_carry);
		get_lable(test_zero);
		get_lable(no_subtract);
		fprintf(func_out, "\tmove.b (%%a2)+, %%d2 | restore flags\n");
		fprintf(func_out, "\tmove.b (%%a2)+, %%d5\n");
		fprintf(func_out, "\tbtst.l #4, %%d2\n");
		fprintf(func_out, "\tsne %%d1\n");
		fprintf(func_out, "\tadd.b %%d1, %%d1\n");
		fprintf(func_out, "\tmove.w %%sr, %%d6\n");
#ifdef ACCURATE_HALF_CARRY
		fprintf(func_out, "\tbtst.l #5, %%d2\n");
		fprintf(func_out, "\tbeq %s\n", no_half_carry);
		set_half_carry_flag();
		fprintf(func_out, "\tbra %s\n", test_zero);
		fprintf(func_out, "%s:\n", no_half_carry);
		clear_half_carry_flag();
#endif
		fprintf(func_out, "%s:\n", test_zero);
		fprintf(func_out, "\tbtst.l #7, %%d2\n");
		fprintf(func_out, "\tseq %%d1\n");
		fprintf(func_out, "\ttst.b %%d1\n");
		fprintf(func_out, "\tmove.w %%sr, %%d7\n");
		fprintf(func_out, "\tbtst.l #6, %%d2\n");
		fprintf(func_out, "\tbeq %s\n", no_subtract);
		set_subtract_flag();
		fprintf(func_out, "%s:\n", no_subtract);
	} else {
		fprintf(func_out, "\tmove.b (%%a2)+, %s\n", arg_table[dst->tag + 1]);
		fprintf(func_out, "\tmove.b (%%a2)+, %s\n", arg_table[dst->tag]);
	}
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_ADD(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	//FLAG START
	fprintf(func_out, "\tmove.b %s, (LAST_SRC, %%a5)\n", arg_table_static[src->tag]);
	fprintf(func_out, "\tmove.b %s, (LAST_DST, %%a5)\n", arg_table_static[dst->tag]);
	//FLAG END
	fprintf(func_out, "\tadd.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	//FLAG START
	update_zero_flag();
	update_carry_flag();
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_ADC(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(src->tag != ARG_DT0)
		fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[src->tag]); //get src in d0
	fprintf(func_out, "\tbtst #0, %%d6\n"); //test carry flag
	fprintf(func_out, "\tsne %%d1\n"); //if it's set, set d1 (to -1)
	//FLAG START
	fprintf(func_out, "\tmove.b %%d0, (LAST_SRC, %%a5)\n");
	fprintf(func_out, "\tmove.b %s, (LAST_DST, %%a5)\n", arg_table_static[dst->tag]);
	fprintf(func_out, "\tmove.b %%d1, (LAST_FLAG, %%a5)\n");
	//FLAG END
	fprintf(func_out, "\tadd.b %%d1, %%d1 | carry to extend\n");
	fprintf(func_out, "\taddx.b %%d0, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_zero_flag();
	update_carry_flag();
	fprintf(func_out, "\tori.b #0x80, %%d7\n");
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_SUB(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	//FLAG START
	fprintf(func_out, "\tmove.b %s, (LAST_SRC, %%a5)\n", arg_table_static[src->tag]);
	fprintf(func_out, "\tmove.b %s, (LAST_DST, %%a5)\n", arg_table_static[dst->tag]);
	//FLAG END
	fprintf(func_out, "\tsub.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	//FLAG START
	update_zero_flag();
	update_carry_flag();
	set_subtract_flag();
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_SBC(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(src->tag != ARG_DT0)
		fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[src->tag]); //get src in d0
	fprintf(func_out, "\tbtst.b #0, %%d6\n"); //test carry flag
	fprintf(func_out, "\tsne %%d1\n"); //if it's set, set d1 (to -1)
	//FLAG START
	fprintf(func_out, "\tmove.b %%d0, (LAST_SRC, %%a5)\n");
	fprintf(func_out, "\tmove.b %s, (LAST_DST, %%a5)\n", arg_table_static[dst->tag]);
	fprintf(func_out, "\tmove.b %%d1, (LAST_FLAG, %%a5)\n");
	//FLAG END
	fprintf(func_out, "\tadd.b %%d1, %%d1 | carry to extend\n");
	fprintf(func_out, "\tsubx.b %%d0, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_zero_flag();
	update_carry_flag();
	fprintf(func_out, "\tori.b #0xA0, %%d7 | set subtract, specify carry\n");
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_AND(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	fprintf(func_out, "\tand.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	//FLAG START
	update_zero_flag();
	clear_carry_flag();
	set_half_carry_flag();
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_OR(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	fprintf(func_out, "\tor.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	//FLAG START
	update_zero_flag();
	clear_carry_flag();
	clear_half_carry_flag();
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_XOR(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(src->tag == ARG_A) {
		fprintf(func_out, "\teor.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	} else {
		//because m68k eor instruction is stupid
		fprintf(func_out, "\tmove.b %s, %%d1\n", arg_table[src->tag]); 
		fprintf(func_out, "\teor.b %%d1, %s\n", arg_table[dst->tag]);
	}
	//FLAG START
	update_zero_flag();
	clear_carry_flag();
	clear_half_carry_flag();
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_CP(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	//won't work unless dst is gb_A, which it always should be
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	//FLAG START
#ifdef ACCURATE_HALF_CARRY
	fprintf(func_out, "\tmove.b %s, (LAST_SRC, %%a5)\n", arg_table_static[src->tag]);
	fprintf(func_out, "\tmove.b %s, (LAST_DST, %%a5)\n", arg_table_static[dst->tag]);
#endif
	//FLAG END
	fprintf(func_out, "\tcmp.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	//FLAG START
	update_zero_flag();
	update_carry_flag();
#ifdef ACCURATE_HALF_CARRY
	set_subtract_flag();
#endif
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_INC(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	//FLAG START
#ifdef ACCURATE_HALF_CARRY
	fprintf(func_out, "\tmove.b #1, (LAST_SRC, %%a5)\n");
	fprintf(func_out, "\tmove.b %s, (LAST_DST, %%a5)\n", arg_table_static[dst->tag]);
#endif
	//FLAG END
	fprintf(func_out, "\taddq.b #1, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_zero_flag();
	//FLAG END
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_DEC(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	//FLAG START
#ifdef ACCURATE_HALF_CARRY
	fprintf(func_out, "\tmove.b #1, (LAST_SRC, %%a5)\n");
	fprintf(func_out, "\tmove.b %s, (LAST_DST, %%a5)\n", arg_table_static[dst->tag]);
#endif
	//FLAG END
	fprintf(func_out, "\tsubq.b #1, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_zero_flag();
#ifdef ACCURATE_HALF_CARRY
	set_subtract_flag();
#endif
	//FLAG END
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_CPL()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tnot.b %s\n", arg_table[ARG_A]);
	//FLAG START
#ifdef ACCURATE_HALF_CARRY
	set_half_carry_flag();
	set_subtract_flag();
#endif
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_CCF()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tnot.b %%d6\n");
#ifdef ACCURATE_HALF_CARRY
	clear_half_carry_flag();
	clear_subtract_flag();
#endif
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_SCF()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tst %%d6\n");
#ifdef ACCURATE_HALF_CARRY
	clear_half_carry_flag();
	clear_subtract_flag();
#endif
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_DI()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tbclr #31, %%d7\n");
	fprintf(func_out, "\tmove.l (NEXT_EVENT, %%a5), %%a0\n");
	fprintf(func_out, "\tcmpa.l #enable_intr_func, %%a0\n");
	fprintf(func_out, "\tbne 0f\n");
	fprintf(func_out, "\tmove.l (SAVE_EVENT_EI, %%a5), (NEXT_EVENT, %%a5)\n");
	fprintf(func_out, "\tmove.w (SAVE_COUNT_EI, %%a5), %%d4\n");
	fprintf(func_out, "0:\n");
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

void enable_intr()
{
	char lable[128];

	get_lable(lable);
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	fprintf(func_out, "\tmovea.l (NEXT_EVENT, %%a5), %%a0\n");
	fprintf(func_out, "\tcmpa.l #enable_intr_func, %%a0\n");
	fprintf(func_out, "\tbne %s\n", lable);
	fprintf(func_out, "\ttst.w %%d4\n");
	next_instruction2(lable);
	fprintf(func_out, "%s:\n", lable);
	fprintf(func_out, "\tmove.w %%d4, (SAVE_COUNT_EI, %%a5)\n");
	fprintf(func_out, "\tmove.l (NEXT_EVENT, %%a5), (SAVE_EVENT_EI, %%a5)\n");
	fprintf(func_out, "\tmove.l #enable_intr_func, (NEXT_EVENT, %%a5)\n");
	fprintf(func_out, "\tmoveq #0, %%d4\n");
	
	/*fprintf(func_out, "\tmovea.l (MEM_TABLE+2040, %%a5) ,%%a0\n");
	fprintf(func_out, "\tbset #31, %%d7 | enable interrupts\n");
	fprintf(func_out, "\tcmp.b #1, (CPU_HALT, %%a5)\n"); //was a halt pending?
	fprintf(func_out, "\tbne 0f\n");
	fprintf(func_out, "\tmove.b (IF, %%a0), %%d0\n");
	fprintf(func_out, "\tand.b (IE, %%a0), %%d0\n");
	fprintf(func_out, "\tbne 0f\n"); //don't bother halting if there's an intr waiting
	fprintf(func_out, "\tmoveq #-1, %%d4\n");
	fprintf(func_out, "\tmove.b #-1, (CPU_HALT, %%a5)\n");
	fprintf(func_out, "0:\n");
	fprintf(func_out, "\tjsr check_interrupts\n");*/
}

bool write_EI()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	enable_intr();
	//fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_ADD16(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->prefix == PREFIX_GET_SP) { //HACK!! (doesn't set flags right...)
		fprintf(func_out, "\tmove.b (%%a4)+, %%d0\n");
		fprintf(func_out, "\text.w %%d0\n");
		fprintf(func_out, "\text.l %%d0\n");
		fprintf(func_out, "\tadda.l %%d0, %%a2\n");
		fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
		next_instruction();
		return true;
	}
	
	if(src->tag == ARG_IMMD8) {
		fprintf(func_out, "\tmove.b %s, %%d1\n", arg_table[ARG_IMMD8]);
		fprintf(func_out, "\text.w %%d1\n");
	} else if(src->prefix == PREFIX_GET_SP) get_SP(ARG_DT1);
	else fprintf(func_out, "\tmove.w %s, %%d1\n", arg_table[src->tag]);
	src->tag = ARG_DT1; //hack to get src in reg, add wont work w/ mem to mem
	//FLAG START
#ifdef ACCURATE_HALF_CARRY
	fprintf(func_out, "\tmove.w %s, (LAST_SRC, %%a5)\n", arg_table[src->tag]);
	fprintf(func_out, "\tmove.w %s, (LAST_DST, %%a5)\n", arg_table[dst->tag]);
#endif
	//FLAG END
	fprintf(func_out, "\tadd.w %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	//FLAG START
	update_carry_flag();
	if(dst->tag == ARG_SP) fprintf(func_out, "\tclr.b %%d7 | clear zero/subtract\n");
#ifdef ACCURATE_HALF_CARRY
	else clear_subtract_flag();
#endif
	fprintf(func_out, "\tori #0x40, %%d7 | set 16bit add\n");
	//FLAG END
	//if(dst->tag == ARG_H) new_HL();
	//else if(dst->tag == ARG_SP) new_SP();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_INC16(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->prefix == PREFIX_GET_SP)
		fprintf(func_out, "\tadda.l #1, %%a2\n");
	else fprintf(func_out, "\taddq.w #1, %s\n", arg_table[dst->tag]);
	//if(dst->tag == ARG_H) new_HL();
	//else if(dst->tag == ARG_SP) new_SP();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_DEC16(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->prefix == PREFIX_GET_SP)
		fprintf(func_out, "\tsuba.l #1, %%a2\n");
	else fprintf(func_out, "\tsubq.w #1, %s\n", arg_table[dst->tag]);
	//if(dst->tag == ARG_H) new_HL();
	//else if(dst->tag == ARG_SP) new_SP();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_RLCA()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\trol.b #1, %s\n", arg_table[ARG_A]);
	//FLAG START
	update_carry_flag();
	clear_half_carry_flag();
	fprintf(func_out, "\tclr.b %%d7 | clear zero/subtract\n");
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_RLA()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	carry_to_extend();
	fprintf(func_out, "\troxl.b #1, %s\n", arg_table[ARG_A]);
	//FLAG START
	update_carry_flag();
	clear_half_carry_flag();
	fprintf(func_out, "\tclr.b %%d7 | clear zero/subtract\n");
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_RRCA()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tror.b #1, %s\n", arg_table[ARG_A]);
	//FLAG START
	update_carry_flag();
	clear_half_carry_flag();
	fprintf(func_out, "\tclr.b %%d7 | clear zero/subtract\n");
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_RRA()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	carry_to_extend();
	fprintf(func_out, "\troxr.b #1, %s\n", arg_table[ARG_A]);
	//FLAG START
	update_carry_flag();
	clear_half_carry_flag();
	fprintf(func_out, "\tclr.b %%d7 | clear zero/subtract\n");
	//FLAG END
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_RLC(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(dst->tag != ARG_A && dst->tag != ARG_DT2) {
		fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[dst->tag]);
		fprintf(func_out, "\trol.b #1, %%d2\n", arg_table[dst->tag]);
	} else 
		fprintf(func_out, "\trol.b #1, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_carry_flag();
	update_zero_flag();
	clear_half_carry_flag();
	//FLAG END
	if(dst->tag != ARG_A && dst->tag != ARG_DT2)
		fprintf(func_out, "\tmove.b %%d2, %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_RL(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	carry_to_extend();
	if(dst->tag != ARG_A && dst->tag != ARG_DT2) {
		fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[dst->tag]);
		fprintf(func_out, "\troxl.b #1, %%d2\n", arg_table[dst->tag]);
	} else 
		fprintf(func_out, "\troxl.b #1, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_carry_flag();
	update_zero_flag();
	clear_half_carry_flag();
	//FLAG END
	if(dst->tag != ARG_A && dst->tag != ARG_DT2)
		fprintf(func_out, "\tmove.b %%d2, %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_RRC(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(dst->tag != ARG_A && dst->tag != ARG_DT2) {
		fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[dst->tag]);
		fprintf(func_out, "\tror.b #1, %%d2\n", arg_table[dst->tag]);
	} else 
		fprintf(func_out, "\tror.b #1, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_carry_flag();
	update_zero_flag();
	clear_half_carry_flag();
	//FLAG END
	if(dst->tag != ARG_A && dst->tag != ARG_DT2)
		fprintf(func_out, "\tmove.b %%d2, %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_RR(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	carry_to_extend();
	if(dst->tag != ARG_A && dst->tag != ARG_DT2) {
		fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[dst->tag]);
		fprintf(func_out, "\troxr.b #1, %%d2\n", arg_table[dst->tag]);
	} else 
		fprintf(func_out, "\troxr.b #1, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_carry_flag();
	update_zero_flag();
	clear_half_carry_flag();
	//FLAG END
	if(dst->tag != ARG_A && dst->tag != ARG_DT2)
		fprintf(func_out, "\tmove.b %%d2, %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_SLA(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(dst->tag != ARG_A && dst->tag != ARG_DT2) {
		fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[dst->tag]);
		fprintf(func_out, "\tasl.b #1, %%d2\n", arg_table[dst->tag]);
	} else 
		fprintf(func_out, "\tasl.b #1, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_carry_flag();
	update_zero_flag();
	clear_half_carry_flag();
	//FLAG END
	if(dst->tag != ARG_A && dst->tag != ARG_DT2)
		fprintf(func_out, "\tmove.b %%d2, %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_SRA(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(dst->tag != ARG_A && dst->tag != ARG_DT2) {
		fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[dst->tag]);
		fprintf(func_out, "\tasr.b #1, %%d2\n", arg_table[dst->tag]);
	} else 
		fprintf(func_out, "\tasr.b #1, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_carry_flag();
	update_zero_flag();
	clear_half_carry_flag();
	//FLAG END
	if(dst->tag != ARG_A && dst->tag != ARG_DT2)
		fprintf(func_out, "\tmove.b %%d2, %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_SRL(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(dst->tag != ARG_A && dst->tag != ARG_DT2) {
		fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[dst->tag]);
		fprintf(func_out, "\tlsr.b #1, %%d2\n", arg_table[dst->tag]);
	} else 
		fprintf(func_out, "\tlsr.b #1, %s\n", arg_table[dst->tag]);
	//FLAG START
	update_carry_flag();
	update_zero_flag();
	clear_half_carry_flag();
	//FLAG END
	if(dst->tag != ARG_A && dst->tag != ARG_DT2)
		fprintf(func_out, "\tmove.b %%d2, %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_BIT(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	dst->dst = false; //because dst is read only in this case
	write_prefix(dst, src, false, 0);
	fprintf(func_out, "\tbtst.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	update_zero_flag();
	//clear_subtract_flag();
	set_half_carry_flag();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_SET(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, src, true, 0);
	fprintf(func_out, "\tbset.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_RES(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, src, true, 0);
	fprintf(func_out, "\tbclr.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_SWAP(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(dst->tag == ARG_A) {
		fprintf(func_out, "\trol.b #4, %s\n", arg_table[dst->tag]);
	} else {
		if(dst->tag != ARG_DT2) fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[dst->tag]);
		fprintf(func_out, "\trol.b #4, %%d2\n");
	}
	update_zero_flag();
	clear_half_carry_flag();
	clear_carry_flag();
	if(dst->tag != ARG_A && dst->prefix != PREFIX_MEM_REG_INDIR)
		fprintf(func_out, "\tmove.b %%d2, %s\n", arg_table[dst->tag]);
	else if(dst->prefix == PREFIX_MEM_REG_INDIR)
		write_suffix(dst);
	//if(dst->tag == ARG_H) new_HL();
	fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
	next_instruction();
	return true;
}

bool write_JP(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	
	if(dst->tag == ARG_H) {
		fprintf(func_out, "\tclr.l %%d2\n");
		fprintf(func_out, "\tmove.w %s, %%d2\n", arg_table[dst->tag]);
		new_PC();
	} else new_PC_immd(true);
	
	if(dst->tag == ARG_H) fprintf(func_out, "\tsubq.w #1, %%d4\n");
	else fprintf(func_out, "\tsubq.w #4, %%d4\n");
	next_instruction();
	return true;
}

bool write_Jcc(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	char lable[1024];
	get_lable(lable);
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->tag == ARG_FNC || dst->tag == ARG_FC) {
		fprintf(func_out, "\tmove.w %%d6, %%ccr\n");
		if(dst->tag == ARG_FNC) fprintf(func_out, "\tbcs %s\n", lable);
		else fprintf(func_out, "\tbcc %s\n", lable);
	} else {
		fprintf(func_out, "\tmove.w %%d7, %%ccr\n");
		if(dst->tag == ARG_FNZ) fprintf(func_out, "\tbeq %s\n", lable);
		else fprintf(func_out, "\tbne %s\n", lable);
	}
	new_PC_immd(true);
	fprintf(func_out, "\tsubq.w #4, %%d4\n");
	next_instruction2(lable);
	fprintf(func_out, "%s:\n", lable);
	fprintf(func_out, "\tlea (2, %%a4), %%a4\n");
	fprintf(func_out, "\tsubq.w #3, %%d4\n");
	next_instruction();
	return true;
}

bool write_JR(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	dst->dst = false;
	write_prefix(dst, 0, false, 0);
	fprintf(func_out, "\tmove.b %s, %%d1\n", arg_table[dst->tag]);
	fprintf(func_out, "\text.w %%d1\n");
	fprintf(func_out, "\text.l %%d1\n");
	fprintf(func_out, "\tadda.l %%d1, %%a4\n");
	fprintf(func_out, "\tsubq.w #3, %%d4\n");
	next_instruction();
	return true;
}

bool write_JRcc(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	char lable[1024];
	get_lable(lable);
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, 0, false, 0);
	if(dst->tag == ARG_FNC || dst->tag == ARG_FC) {
		fprintf(func_out, "\tmove.w %%d6, %%ccr\n");
		if(dst->tag == ARG_FNC) fprintf(func_out, "\tbcs %s\n", lable);
		else fprintf(func_out, "\tbcc %s\n", lable);
	} else {
		fprintf(func_out, "\tmove.w %%d7, %%ccr\n");
		if(dst->tag == ARG_FNZ) fprintf(func_out, "\tbeq %s\n", lable);
		else fprintf(func_out, "\tbne %s\n", lable);
	}
	fprintf(func_out, "\tmove.b %s, %%d1\n", arg_table[src->tag]);
	fprintf(func_out, "\text.w %%d1\n");
	fprintf(func_out, "\text.l %%d1\n");
	fprintf(func_out, "\tadda.l %%d1, %%a4\n");
	fprintf(func_out, "\tsubq.w #3, %%d4\n");
	next_instruction2(lable);
	fprintf(func_out, "%s:\n", lable);
	if(src->tag == ARG_IMMD8) fprintf(func_out, "\taddq.l #1, %%a4\n");
	fprintf(func_out, "\tsubq.w #2, %%d4\n");
	next_instruction();
	return true;
}

bool write_CALL(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tlea (2, %%a4), %%a4\n");
	fprintf(func_out, "\tjsr push_PC :l\n");
	new_PC_immd(false);
	fprintf(func_out, "\tsubq.w #6, %%d4\n");
	next_instruction();
	return true;
}

bool write_CALLcc(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	char lable[1024];
	get_lable(lable);
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tlea (2, %%a4), %%a4\n");
	if(dst->tag == ARG_FNC || dst->tag == ARG_FC) {
		fprintf(func_out, "\tmove.w %%d6, %%ccr\n");
		if(dst->tag == ARG_FNC) fprintf(func_out, "\tbcs %s\n", lable);
		else fprintf(func_out, "\tbcc %s\n", lable);
	} else {
		fprintf(func_out, "\tmove.w %%d7, %%ccr\n");
		if(dst->tag == ARG_FNZ) fprintf(func_out, "\tbeq %s\n", lable);
		else fprintf(func_out, "\tbne %s\n", lable);
	}
	fprintf(func_out, "\tjsr push_PC :l\n");
	new_PC_immd(false);
	fprintf(func_out, "\tsubq.w #6, %%d4\n");
	next_instruction2(lable);
	fprintf(func_out, "%s:\n", lable);
	fprintf(func_out, "\tsubq.w #3, %%d4\n");
	next_instruction();
	return true;
}

bool write_RET()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tjsr pop_PC :l\n");
	fprintf(func_out, "\tsubq.w #4, %%d4\n");
	next_instruction();
	return true;
}

bool write_RETI()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tjsr pop_PC :l\n");
	fprintf(func_out, "\tmovea.l (MEM_TABLE+2040, %%a5) ,%%a0\n");
	fprintf(func_out, "\tbset #31, %%d7 | enable interrupts\n");
	fprintf(func_out, "\tcmp.b #1, (CPU_HALT, %%a5)\n"); //was a halt pending?
	fprintf(func_out, "\tbne 0f\n");
	fprintf(func_out, "\tmove.b (IF, %%a0), %%d0\n");
	fprintf(func_out, "\tand.b (IE, %%a0), %%d0\n");
	fprintf(func_out, "\tbne 0f\n"); //don't bother halting if there's an intr waiting
	fprintf(func_out, "\tmoveq #-1, %%d4\n");
	fprintf(func_out, "\tmove.b #-1, (CPU_HALT, %%a5)\n");
	fprintf(func_out, "0:\n");
	fprintf(func_out, "\tjsr check_interrupts\n");
	fprintf(func_out, "\tsubq.w #4, %%d4\n");
	next_instruction();
	return true;
}

bool write_RETcc(ARG_FORMAT *dst)
{
	char lable[1024];
	get_lable(lable);
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	
	if(dst->tag == ARG_FNC || dst->tag == ARG_FC) {
		fprintf(func_out, "\tmove.w %%d6, %%ccr\n");
		if(dst->tag == ARG_FNC) fprintf(func_out, "\tbcs %s\n", lable);
		else fprintf(func_out, "\tbcc %s\n", lable);
	} else {
		fprintf(func_out, "\tmove.w %%d7, %%ccr\n");
		if(dst->tag == ARG_FNZ) fprintf(func_out, "\tbeq %s\n", lable);
		else fprintf(func_out, "\tbne %s\n", lable);
	}
	fprintf(func_out, "\tjsr pop_PC :l\n");
	fprintf(func_out, "\tsubq.w #5, %%d4\n");
	next_instruction2(lable);
	fprintf(func_out, "%s:\n", lable);
	fprintf(func_out, "\tsubq.w #2, %%d4\n");
	next_instruction();
	return true;
}

bool write_RST(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tjsr push_PC :l\n");
	fprintf(func_out, "\tmoveq.l %s, %%d2\n", arg_table[dst->tag]);
	new_PC();
	fprintf(func_out, "\tsubq.w #4, %%d4\n");
	next_instruction();
	return true;
}

bool write_HALT()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tbtst #31, %%d7\n");
	fprintf(func_out, "\tbeq 0f\n");
	fprintf(func_out, "\tmoveq #-1, %%d4\n");
	fprintf(func_out, "\tmove.b #-1, (CPU_HALT, %%a5)\n");
	fprintf(func_out, "\tbra 1f\n");
	fprintf(func_out, "0:\n");
	fprintf(func_out, "\tmove.b #1, (CPU_HALT, %%a5)\n");
	fprintf(func_out, "1:\n");
	fprintf(func_out, "\tsubq.w #1, %%d4\n");
	next_instruction();
	return true;
}

bool write_DAA()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tcmpi.b #0x99, %%d5\n");
	fprintf(func_out, "\tbhi 0f\n");
	fprintf(func_out, "\tbtst #0, %%d6\n");
	fprintf(func_out, "\tbne 0f\n");
	fprintf(func_out, "\tmoveq #0x00, %%d0\n");
	fprintf(func_out, "\tbclr #0, %%d6\n");
	fprintf(func_out, "\tbra 1f\n");
	fprintf(func_out, "0:\n");
	fprintf(func_out, "\tmoveq #0x60, %%d0\n");
	fprintf(func_out, "\tbset #0, %%d6\n");
	fprintf(func_out, "1:\n");
	fprintf(func_out, "\tmove.b %%d5, %%d1\n");
	fprintf(func_out, "\tandi.b #0x0f, %%d1\n");
	fprintf(func_out, "\tcmpi.b #0x9, %%d1\n");
	fprintf(func_out, "\tbhi 0f\n");
	fprintf(func_out, "\tmoveq #0, %%d2\n");
	fprintf(func_out, "\tmove.l %%d0, -(%%a7)\n");
	fprintf(func_out, "\tjsr calculate_half_carry :l\n");
	fprintf(func_out, "\tmove.l (%%a7)+, %%d0\n");
	fprintf(func_out, "\tbtst #5, %%d2\n");
	fprintf(func_out, "\tbeq 1f\n");
	fprintf(func_out, "0:\n");
	fprintf(func_out, "\tori.b #0x06, %%d0\n");
	fprintf(func_out, "1:\n");
	fprintf(func_out, "\tmove.b %%d5, (LAST_DST, %%a5)\n");
	fprintf(func_out, "\tmove.b %%d0, (LAST_SRC, %%a5)\n");
	fprintf(func_out, "\tbtst #5, %%d7\n");
	fprintf(func_out, "\tbeq 0f\n");
	fprintf(func_out, "\tsub.b %%d0, %%d5\n");
	update_zero_flag();
	set_subtract_flag();
	fprintf(func_out, "\tbra 1f\n");
	fprintf(func_out, "0:\n");
	fprintf(func_out, "\tadd.b %%d0, %%d5\n");
	update_zero_flag();
	fprintf(func_out, "1:\n");
	fprintf(func_out, "\tsubq.w #1, %%d4\n");
	next_instruction();
	return true;
}

void generate_int()
{
	fprintf(func_out, "generate_int: | input: %%d2, number of int\n");
	fprintf(func_out, "\tbclr #31, %%d7 | disable interrupts\n");
	fprintf(func_out, "\tclr.b (CPU_HALT, %%a5)\n");
	fprintf(func_out, "\tjsr push_PC\n");
	new_PC();
	fprintf(func_out, "\trts\n");
}


void fill_arg(ARG_FORMAT *arg, char *a, int i, bool dst)
{
	arg->prefix = NONE;
	arg->prefix_tag = NONE;
	arg->special = NONE;
	arg->dst = dst;
	arg->size = SIZE8;
	
	if(strcmp(a, "(BC)") == 0 || strcmp(a, "(DE)") == 0 || strcmp(a, "(HL)") == 0) {
		cycles++;
		arg->prefix = PREFIX_MEM_REG_INDIR;
		if(strcmp(a, "(BC)") == 0) {
			arg->prefix_tag = ARG_B; arg->name = OP_BC_INDIR;
		} else if(strcmp(a, "(DE)") == 0) {
			arg->prefix_tag = ARG_D; arg->name = OP_DE_INDIR;
		} else {
			arg->prefix_tag = ARG_H; arg->name = OP_HL_INDIR;
		}
		arg->tag = ARG_MEM;
	} else if(strcmp(a, "(nn)") == 0) {
		cycles += 3;
		arg->prefix = PREFIX_MEM_IMMD_INDIR;
		arg->tag = ARG_MEM;
		arg->name = OP_IMMD_INDIR;
	} else if(strcmp(a, "(HL)+") == 0 || strcmp(a, "(HL)-") == 0) {
		cycles++;
		arg->prefix = PREFIX_MEM_REG_INDIR;
		arg->prefix_tag = ARG_H;
		arg->tag = ARG_MEM;
		if(strcmp(a, "(HL)+") == 0) { arg->special = SPECIAL_INC_HL; arg->name = OP_HL_INC; }
		else { arg->special = SPECIAL_DEC_HL; arg->name = OP_HL_DEC; }
	/*} else if(strcmp(a, "(SP)+") == 0 || strcmp(a, "(SP)-") == 0) {
		cycles += 2;
		//arg->prefix = PREFIX_MEM_REG_INDIR;
		//arg->prefix_tag = ARG_SP;
		arg->tag = ARG_SP;
		if(strcmp(a, "(SP)+") == 0) { arg->special = SPECIAL_INC_SP; arg->name = OP_SP_INC; }
		else { arg->special = SPECIAL_DEC_SP; arg->name = OP_SP_DEC; }*/
	} else if(strcmp(a, "A") == 0) {
		arg->tag = ARG_A;
		arg->name = OP_A;
	} else if(strcmp(a, "HL") == 0) {
		arg->tag = ARG_H;
		arg->name = OP_HL;
	} else if(strcmp(a, "SP") == 0) {
		arg->prefix = PREFIX_GET_SP;
		arg->tag = ARG_DT2;
		arg->name = OP_SP;
	} else if(strcmp(a, "SP+byte") == 0) {
		cycles++;
		arg->prefix = PREFIX_SP_IMMD;
		arg->tag = ARG_DT2;
		arg->name = OP_SP_IMMD;
	} else if(strcmp(a, "byte") == 0) {
		cycles++;
		arg->tag = ARG_IMMD8;
		arg->name = OP_IMMD8;
		//if(dst) ERROR
	} else if(strcmp(a, "word") == 0) {
		cycles += 2;
		arg->tag = ARG_DT2;
		arg->prefix = PREFIX_GET_IMMD16;
		arg->name = OP_IMMD16;
	} else if(strcmp(a, "(FF00+byte)") == 0) {
		cycles += 2;
		arg->prefix = PREFIX_MEM_FF00;
		arg->prefix_tag = ARG_IMMD8;
		arg->tag = ARG_MEM;
		arg->name = OP_FF00_IMMD;
	} else if(strcmp(a, "(FF00+C)") == 0) {
		cycles++;
		arg->prefix = PREFIX_MEM_FF00;
		arg->prefix_tag = ARG_C;
		arg->tag = ARG_MEM;
		arg->name = OP_FF00_C;
	} else if(strcmp(a, "rrr") == 0 || strcmp(a, "RRR") == 0) {
		if(i == 6) {
			cycles++;
			arg->prefix = PREFIX_MEM_REG_INDIR;
			arg->prefix_tag = ARG_H;
			arg->tag = ARG_MEM;
			arg->name = OP_HL_INDIR;
		} else if(i == 0) { arg->tag = ARG_B; arg->name = OP_B; }
		else if(i == 1) { arg->tag = ARG_C; arg->name = OP_C; }
		else if(i == 2) { arg->tag = ARG_D; arg->name = OP_D; }
		else if(i == 3) { arg->tag = ARG_E; arg->name = OP_E; }
		else if(i == 4) { arg->tag = ARG_H; arg->name = OP_H; }
		else if(i == 5) { arg->tag = ARG_L; arg->name = OP_L; }
		else if(i == 7) { arg->tag = ARG_A; arg->name = OP_A; }
	} else if(strcmp(a, "dd") == 0) {
		if(i == 0) { arg->tag = ARG_B; arg->name = OP_BC; }
		else if(i == 1) { arg->tag = ARG_D; arg->name = OP_DE; }
		else if(i == 2) { arg->tag = ARG_H; arg->name = OP_HL; }
		else if(i == 3) { arg->prefix = PREFIX_GET_SP; arg->tag = ARG_DT2; arg->name = OP_SP; }
	} else if(strcmp(a, "qq") == 0) {
		if(i == 0) { arg->tag = ARG_B; arg->name = OP_BC; }
		else if(i == 1) {arg->tag = ARG_D; arg->name = OP_DE; }
		else if(i == 2) {arg->tag = ARG_H; arg->name = OP_HL; }
		else if(i == 3) {
			//if(!dst) {
				arg->prefix = PREFIX_GET_AF;
				arg->tag = ARG_DT2;
			//} else arg->tag = ARG_A;
			arg->name = OP_AF;
		}
	} else if(strcmp(a, "iii") == 0) {
		arg->tag = ARG_0 + i;
		arg->name = OP_0 + i;
	} else if(strcmp(a, "cc") == 0) {
		arg->tag = ARG_FNZ + i;
		arg->name = OP_FNZ + i;
	} else if(strcmp(a, "ttt") == 0) {
		arg->tag = ARG_R00 + i;
		arg->name = OP_R00 + i;
	}
}

char process_line(char *line)
{
	OPCODE_HEADER *table;
	ARG_FORMAT src_format, dst_format;
	int i = 0, j;
	int bit = 0;
	bool ok = false;
	unsigned char value = 0;
	int si = 0;
	char current = 0;
	char opcode[1024];
	char dst[1024];
	char src[1024];
	char lable[1024];
	int src_variations;
	int dst_variations;
	int src_pos, dst_pos;
	int src_i, dst_i;
	SPECIAL_BIT special[2] = {{-1, 0, {0,0,0,0,0}}, {-1, 0, {0,0,0,0,0}}};
	
	i = 0; prefix = 0;
read_byte: //mmm...lable/goto
	while(bit < 8) {
		if(current != 0 && current != line[i]) { current = 0; si++; }
		switch(line[i]) {
		case '0': bit++; break;
		case '1': value += (0x80 >> bit); bit++; break;
		case 'R': case 'r': case 'q': case 'd': case 'i': case 'c': case 't':
			if(special[si].pos == -1) {
				special[si].pos = bit;
				special[si].num = 1;
				special[si].type[0] = line[i];
			} else if(special[si].type[0] == line[i]) {
				special[si].pos = bit;
				special[si].type[special[si].num] = line[i];
				special[si].num++;
			}
			current = line[i];
			bit++;
			break;
		}
		i++;
	}

	if(value == 0xCB && special[0].pos == -1 && special[1].pos == -1) {
		prefix = 0xCB;
		value = 0;
		bit = 0;
		current = 0;
		goto read_byte; //yum
	}

	while(line[i] != ':' && line[i] != '\n') i++;
	if(line[i] == '\n') return 0;
	i++;
	while(line[i] == ' ') i++;
	
	j = 0;
	while(line[i] != ' ' && line[i] != '\n') { opcode[j] = line[i]; i++; j++; }
	opcode[j] = 0;

	while(line[i] == ' ') i++;
	if(line[i] != '\n' && line[i] != 0) {
		j = 0;
		while(line[i] != ',' && line[i] != '\n') {
			if(line[i] != ' ') { dst[j] = line[i]; j++; }
			i++;
		}
		dst[j] = 0;
		i++;
	} else dst[0] = 0;

	while(line[i] == ' ') i++;
	if(line[i] != '\n' && line[i] != 0) {
		j = 0;
		while(line[i] != '\n') {
			if(line[i] != ' ') { src[j] = line[i]; j++; }
			i++;
		}
		src[j] = 0;
	} else src[0] = 0;

	if(strcmp(src, "rrr") == 0 || strcmp(src, "RRR") == 0 ||
		strcmp(src, "iii") == 0 || strcmp(src, "ttt") == 0) src_variations = 8;
	else if(strcmp(src, "dd") == 0 || strcmp(src, "qq") == 0 ||
		strcmp(src, "cc") == 0) src_variations = 4;
	else src_variations = 1;

	if(strcmp(dst, "rrr") == 0 || strcmp(dst, "RRR") == 0 ||
		strcmp(dst, "iii") == 0 || strcmp(dst, "ttt") == 0) dst_variations = 8;
	else if(strcmp(dst, "dd") == 0 || strcmp(dst, "qq") == 0 ||
		strcmp(dst, "cc") == 0) dst_variations = 4;
	else dst_variations = 1;

	if(strcmp(dst, special[0].type) == 0) dst_pos = special[0].pos;
	else if(strcmp(dst, special[1].type) == 0) dst_pos = special[1].pos;
	else dst_pos = -1;

	if(strcmp(src, special[0].type) == 0) src_pos = special[0].pos;
	else if(strcmp(src, special[1].type) == 0) src_pos = special[1].pos;
	else src_pos = -1;

	if(prefix) table = suffix_table;
	else table = opcode_table;

	for(src_i = 0 ; src_i < src_variations ; src_i++) {
		for(dst_i = 0 ; dst_i < dst_variations ; dst_i++) {
			opcode_index = value;
			if(prefix) cycles = 2;
			else cycles = 1;

			if(dst[0] != 0) {
				opcode_index |= dst_i << (7 - dst_pos);
				fill_arg(&dst_format, dst, dst_i, true);
			}
			if(src[0] != 0) {
				opcode_index |= src_i << (7 - src_pos);
				fill_arg(&src_format, src, src_i, false);
			}

			if(strcmp(opcode, "LD8") == 0) {
				ok = write_LD8(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_LD;
			} else if(strcmp(opcode, "LD16") == 0) {
				if(strcmp(dst, "SP") == 0 || strcmp(src, "SP") == 0 ||
				strcmp(dst, "HL") == 0) cycles++;
				ok = write_LD16(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_LD;
			} else if(strcmp(opcode, "PUSH") == 0) {
				cycles += 3;
				ok = write_PUSH(&dst_format);
				table[opcode_index].opcode_name = OP_PUSH;
			} else if(strcmp(opcode, "POP") == 0) {
				cycles += 2;
				ok = write_POP(&dst_format);
				table[opcode_index].opcode_name = OP_POP;
			} else if(strcmp(opcode, "ADD") == 0) {
				ok = write_ADD(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_ADD;
			} else if(strcmp(opcode, "ADC") == 0) {
				ok = write_ADC(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_ADC;
			} else if(strcmp(opcode, "SUB") == 0) {
				ok = write_SUB(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_SUB;
			} else if(strcmp(opcode, "SBC") == 0) {
				ok = write_SBC(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_SBC;
			} else if(strcmp(opcode, "AND") == 0) {
				ok = write_AND(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_AND;
			} else if(strcmp(opcode, "OR") == 0) {
				ok = write_OR(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_OR;
			} else if(strcmp(opcode, "XOR") == 0) {
				ok = write_XOR(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_XOR;
			} else if(strcmp(opcode, "CP") == 0) {
				ok = write_CP(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_CP;
			} else if(strcmp(opcode, "INC") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_INC(&dst_format);
				table[opcode_index].opcode_name = OP_INC;
			} else if(strcmp(opcode, "DEC") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_DEC(&dst_format);
				table[opcode_index].opcode_name = OP_DEC;
			} else if(strcmp(opcode, "CPL") == 0) {
				ok = write_CPL();
				table[opcode_index].opcode_name = OP_CPL;
			} else if(strcmp(opcode, "CCF") == 0) {
				ok = write_CCF();
				table[opcode_index].opcode_name = OP_CCF;
			} else if(strcmp(opcode, "SCF") == 0) {
				ok = write_SCF();
				table[opcode_index].opcode_name = OP_SCF;
			} else if(strcmp(opcode, "DI") == 0) {
				ok = write_DI();
				table[opcode_index].opcode_name = OP_DI;
			} else if(strcmp(opcode, "EI") == 0) {
				ok = write_EI();
				table[opcode_index].opcode_name = OP_EI;
			} else if(strcmp(opcode, "ADD16") == 0) {
				if(strcmp(dst, "SP") == 0) cycles += 2;
				else cycles++;
				ok = write_ADD16(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_ADD;
			} else if(strcmp(opcode, "INC16") == 0) {
				cycles++;
				ok = write_INC16(&dst_format);
				table[opcode_index].opcode_name = OP_INC;
			} else if(strcmp(opcode, "DEC16") == 0) {
				cycles++;
				ok = write_DEC16(&dst_format);
				table[opcode_index].opcode_name = OP_DEC;
			} else if(strcmp(opcode, "RLCA") == 0) {
				ok = write_RLCA();
				table[opcode_index].opcode_name = OP_RLCA;
			} else if(strcmp(opcode, "RLA") == 0) {
				ok = write_RLA();
				table[opcode_index].opcode_name = OP_RLA;
			} else if(strcmp(opcode, "RRCA") == 0) {
				ok = write_RRCA();
				table[opcode_index].opcode_name = OP_RRCA;
			} else if(strcmp(opcode, "RRA") == 0) {
				ok = write_RRA();
				table[opcode_index].opcode_name = OP_RRA;
			} else if(strcmp(opcode, "RLC") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_RLC(&dst_format);
				table[opcode_index].opcode_name = OP_RLC;
			} else if(strcmp(opcode, "RL") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_RL(&dst_format);
				table[opcode_index].opcode_name = OP_RL;
			} else if(strcmp(opcode, "RRC") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_RRC(&dst_format);
				table[opcode_index].opcode_name = OP_RRC;
			} else if(strcmp(opcode, "RR") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_RR(&dst_format);
				table[opcode_index].opcode_name = OP_RR;
			} else if(strcmp(opcode, "SLA") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_SLA(&dst_format);
				table[opcode_index].opcode_name = OP_SLA;
			} else if(strcmp(opcode, "SRA") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_SRA(&dst_format);
				table[opcode_index].opcode_name = OP_SRA;
			} else if(strcmp(opcode, "SRL") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_SRL(&dst_format);
				table[opcode_index].opcode_name = OP_SRL;
			} else if(strcmp(opcode, "BIT") == 0) {
				ok = write_BIT(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_BIT;
			} else if(strcmp(opcode, "SET") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_SET(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_SET;
			} else if(strcmp(opcode, "RES") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_RES(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_RES;
			} else if(strcmp(opcode, "SWAP") == 0) {
				if(dst_format.prefix_tag == ARG_H) cycles++;
				ok = write_SWAP(&dst_format);
				table[opcode_index].opcode_name = OP_SWAP;
			} else if(strcmp(opcode, "JP") == 0) {
				ok = write_JP(&dst_format);
				table[opcode_index].opcode_name = OP_JP;
			} else if(strcmp(opcode, "Jcc") == 0) {
				ok = write_Jcc(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_JP;
			} else if(strcmp(opcode, "JR") == 0) {
				ok = write_JR(&dst_format);
				table[opcode_index].opcode_name = OP_JR;
			} else if(strcmp(opcode, "JRcc") == 0) {
				ok = write_JRcc(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_JR;
			} else if(strcmp(opcode, "CALL") == 0) {
				ok = write_CALL(&dst_format);
				table[opcode_index].opcode_name = OP_CALL;
			} else if(strcmp(opcode, "CALLcc") == 0) {
				ok = write_CALLcc(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_CALL;
			} else if(strcmp(opcode, "RET") == 0) {
				ok = write_RET();
				table[opcode_index].opcode_name = OP_RET;
			} else if(strcmp(opcode, "RETI") == 0) {
				cycles = 4;
				ok = write_RETI();
				table[opcode_index].opcode_name = OP_RETI;
			} else if(strcmp(opcode, "RETcc") == 0) {
				ok = write_RETcc(&dst_format);
				table[opcode_index].opcode_name = OP_RET;
			} else if(strcmp(opcode, "RST") == 0) {
				ok = write_RST(&dst_format);
				table[opcode_index].opcode_name = OP_RST;
			} else if(strcmp(opcode, "HALT") == 0) {
				ok = write_HALT();
				table[opcode_index].opcode_name = OP_HALT;
			} else if(strcmp(opcode, "DAA") == 0) {
				ok = write_DAA();
				table[opcode_index].opcode_name = OP_DAA;
			}

			if(src[0]) table[opcode_index].src_name = src_format.name;
			if(dst[0]) table[opcode_index].dst_name = dst_format.name;
			
			if(ok) {
				opcode_count++;
				sprintf(lable, "opcode%02X%02X", prefix, opcode_index);
				strcpy(table[opcode_index].func_name, lable);
				fprintf(func_out, "opcode%02X%02X_end: ", prefix, opcode_index);
				if(src[0] == 0 && dst[0] == 0) fprintf(func_out, "| %s\n",
					opcode_names[table[opcode_index].opcode_name]);
				else if(src[0] == 0) fprintf(func_out, "| %s %s\n",
					opcode_names[table[opcode_index].opcode_name],
					operand_names[dst_format.name]);
				else fprintf(func_out, "| %s %s, %s\n",
					opcode_names[table[opcode_index].opcode_name],
					operand_names[dst_format.name],
					operand_names[src_format.name]);
			}
		}
	}

	return 1;
}

int main(int argc, void *argv[])
{
	char line[MAX_LINE_LENGTH];
	int i;

	//if(argc != 3) {
	//	printf("ERROR: wrong number of args\n");
	//	return 0;
	//}
	in = fopen("opcode_desc.txt", "r");
	func_out = fopen("gameboy_opcodes.s", "w");
	table_out = fopen("table_out.txt", "w");
	line[0] = 0;
	memset(opcode_table, 0, sizeof(OPCODE_HEADER) * 256);
	memset(suffix_table, 0, sizeof(OPCODE_HEADER) * 256);
	
	fprintf(func_out, ".global jump_table\n");
	fprintf(func_out, ".global opcode_table\n");
	fprintf(func_out, ".global jump_table2\n");
	fprintf(func_out, ".global suffix_table\n");
	fprintf(func_out, ".global size_table\n");

	fprintf(func_out, ".global generate_int\n\n");
	fprintf(func_out, ".extern io_read\n");
	fprintf(func_out, ".extern io_write\n\n");
	fprintf(func_out, ".include \"gbasm.h\"\n\n");
	fprintf(func_out, ".data\n");
	fprintf(func_out, "opcode_start:\n");
	

	opcode_count = 0;

	while(fgets(line, MAX_LINE_LENGTH, in)) {
		if(strcmp(line, "\n") == 0) break;
		//printf("start: %s", line); getchar();
		process_line(line);
	}

	/*
	clr.l %d0
	move.b (%a4),%d0
	addq.l #1,%a4
	lsl.l #2,%d0
	lea jump_table,%a0
	move.l (%a0,%d0.l),%a0
	jbsr (%a0)
	*/

	fprintf(func_out, "opcode00CB:\n");
	fprintf(func_out, "\tmove.b (%%a4)+, (opcode00CB_end - opcode00CB + (%d) - 2, %%a6)\n",
		-(256-0xCB) * 256);
	fprintf(func_out, "\tjmp (0x0FB4, %%a6)\n");
	fprintf(func_out, "opcode00CB_end:\n");
	
	//fprintf(func_out, "\tlea (jump_table2, %%pc), %%a0\n");
	//fprintf(func_out, "\tclr.w %%d0\n");
	//fprintf(func_out, "\tmove.b (%%a4)+, %%d0\n");
	//fprintf(func_out, "\tadd.w %%d0, %%d0\n"); //d0 *= 4;
	//fprintf(func_out, "\tmove.w (%%a0, %%d0.w), %%d0\n");
	//fprintf(func_out, "\tjmp (%%a3, %%d0.w)\n");
	
	for(i = 0; i < 256; i++) {
		if(opcode_table[i].func_name[0] || i == 0xCB) continue;
		opcode_index = i; prefix = 0;
		sprintf(line, "opcode%02X%02X", 0, i);
		strcpy(opcode_table[i].func_name, line);
		fprintf(func_out, "opcode%02X%02X:\n", 0, i);
		fprintf(func_out, "\tsubq.w #1, %%d4\n");
		next_instruction();
		fprintf(func_out, "opcode%02X%02X_end:\n", 0, i);
	}
	//calculate_half_carry();
	push_PC();
	pop_PC();
	generate_int();

	strcpy(opcode_table[0xCB].func_name, "opcode00CB");
	
	fprintf(func_out, "\njump_table:\n");
	for(i = 0 ; i < 256 ; i++) {
		//if(i == 0xfd) fprintf(func_out, ".word special_write16 - function_base\n");
		//else if(i == 0xfc) fprintf(func_out, ".word special_write16_stack - function_base\n");
		//else if(i == 0xf4) fprintf(func_out, ".word special_write16_return - function_base\n");
		if(opcode_table[i].func_name[0]) fprintf(func_out, ".word %s - function_base\n", opcode_table[i].func_name);
		else fprintf(func_out, ".word BAD\n");
	}

	fprintf(func_out, "\njump_table2:\n");
	for(i = 0 ; i < 256 ; i++) {
		if(suffix_table[i].func_name[0]) fprintf(func_out, ".word %s - function_base\n", suffix_table[i].func_name);
		else fprintf(func_out, ".word opcode0000 - function_base\n");
	}
	
	fprintf(func_out, "\n.if SIZE_TABLE\n");
	fprintf(func_out, "\nsize_table:\n");
	for(i = 0; i < 256; i++) {
		if(opcode_table[i].func_name[0] && i != 0xCB)
			fprintf(func_out, ".word %s_end - %s\n", opcode_table[i].func_name, opcode_table[i].func_name);
		else
			fprintf(func_out, ".word 0\n");
	}
	for(i = 0; i < 256; i++) {
		if(suffix_table[i].func_name[0])
			fprintf(func_out, ".word %s_end - %s\n", suffix_table[i].func_name, suffix_table[i].func_name);
		else
			fprintf(func_out, ".word 0\n");
	}
	fprintf(func_out, "\n.endif\n");


	fprintf(func_out, "\n.if GB_DEBUG\n");
	fprintf(func_out, "\nopcode_table:\n");
	for(i = 0 ; i < 256 ; i++) {
		fprintf(func_out, ".byte %d, %d, %d\n",
			opcode_table[i].opcode_name, opcode_table[i].dst_name, opcode_table[i].src_name);
	}

	fprintf(func_out, "\nsuffix_table:\n");
	for(i = 0 ; i < 256 ; i++) {
		fprintf(func_out, ".byte %d, %d, %d\n",
			suffix_table[i].opcode_name, suffix_table[i].dst_name, suffix_table[i].src_name);
	}
	fprintf(func_out, "\n.endif\n");

	fprintf(func_out, "| %d opcode functions generated\n", opcode_count);

	fclose(in);
	fclose(func_out);
	fclose(table_out);

	return 0;
}
