#include <stdio.h>
#include <string.h>
#include <stdarg.h>

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

#define OPCODE_SIZE 70
#define PREFIX_OPCODE_SIZE 60
#define IO_WRITE_SIZE 60
#define MEM_WRITE_SIZE 60
	
OPCODE_HEADER opcode_table[256];
OPCODE_HEADER suffix_table[256];
int cycles_table[512];
int event_table[256];
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
//gb_sp - %a2
//gb_data - %a5
//gb_mem - %a3
//opcode_block - %a6
//gb_A - %d5
//gb_flags - %d6 
//gb_bc - %d2
//gb_de - %d3
//gb_hl - %d7
//counter - %d4

//FLAG FORMAT
//[0] - carry flag
//[2] - zero flag
//[23:16] - last a (used for bcd)

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
	ARG_NUMBER,
};

char swap_table[ARG_NUMBER] = {
	0, //A
	1, //B
	0, //C
	1, //D
	0, //E
	1, //H
	0, //L
};

char *arg_table[ARG_NUMBER] = {
	"%d5",		//A
	"%d2",		//B
	"%d2",		//C
	"%d3",		//D
	"%d3",		//E
	"%d7",		//H
	"%d7",		//L
	"(%a5, 6)",		//SP
	"(%a5, 7)",		//P
	"%d0",			//DT0
	"%d1",			//DT1
	"%d2",			//DT2
	"%d3",			//DT3
	"(%a0, %d0.w)",	//(MEM)
	"(%a4)+",		//immd8
	"#0", "#1", "#2", "#3", "#4", "#5", "#6", "#7",
	"0x00", "0x08", "0x10", "0x18", "0x20", "0x28", "0x30", "0x38",
};

char *arg_table_static[ARG_NUMBER] = {
	"%d5",		//A
	"%d2",		//B
	"%d2",		//C
	"%d3",		//D
	"%d3",		//E
	"%d7",		//H
	"%d7",		//L
	"(%a5, 6)",		//SP
	"(%a5, 7)",		//P
	"%d0",			//DT0
	"%d1",			//DT1
	"%d2",			//DT2
	"%d3",			//DT3
	"(%a0, %d0.w)",	//MEM
	"(%a4)",		//immd8
	"#0", "#1", "#2", "#3", "#4", "#5", "#6", "#7",
	"0x00", "0x08", "0x10", "0x18", "0x20", "0x28", "0x30", "0x38",
};

char *upper_bits[] = {
	"#16",
	"#17",
	"#18",
	"#19"
	"#20",
	"#21",
	"#22",
	"#23",
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

/*void next_instruction2(char *lable)
{
	int offset;

	if(opcode_index < 128) offset = 256 * opcode_index;
	else offset = -(256-opcode_index) * 256;
	if(prefix == 0xCB) offset += OPCODE_SIZE;
	offset += 6; //skip over mem entry
	
	//hack to get around stupid assembler
	if(prefix == 0x00 && opcode_index == 0x80)
		fprintf(func_out, "\tNEXT_INSTRUCTION 20+NEXT_INSTRUCTION_SIZE + (%d)\n",
		offset);
	else
		fprintf(func_out, "\tNEXT_INSTRUCTION %s - opcode%02X%02X + (%d)\n",
		lable, prefix, opcode_index, offset);
}*/

void next_instruction()
{
	//char lable[1024];
	//sprintf(lable, "opcode%02X%02X_end", prefix, opcode_index);
	//next_instruction2(lable);
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
/*void update_carry_flag() { fprintf(func_out, "\tmove.w %%sr, %%d6 | update carry\n"); }
void update_zero_flag() { fprintf(func_out, "\tmove.w %%sr, %%d7 | update zero\n"); }
void update_zc_flags()
{
	fprintf(func_out, "\tmove.w %%sr, %%d6 | update carry\n");
	fprintf(func_out, "\tmove.w %%d6, %%d7 | update zero\n");
}*/

void updateZC()
{
	fprintf(func_out, "\tmove.w %%sr, %%d6 | update zero, carry\n");
}

void updateC_clearZ_fast(char *op, ...)
{
	va_list ap;
	
	fprintf(func_out, "\tclr.w %%d6\n");
	va_start(ap, op);
	vfprintf(func_out, op, ap);
	va_end(ap);
	fprintf(func_out, "\taddx.w %%d6, %%d6 | update carry, clear zero\n");
}

void updateC_clearZ(char *op, ...)
{
	va_list ap;
	
	fprintf(func_out, "\tclr.w %%d6\n");
	va_start(ap, op);
	vfprintf(func_out, op, ap);
	va_end(ap);
	fprintf(func_out, "\tbcc 0f\n");
	fprintf(func_out, "\tori.b #0x01, %%d6 | update carry, clear zero\n");
	fprintf(func_out, "0:\n");
}

void updateZ_clearC(char *op, ...)
{
	va_list ap;
	
	fprintf(func_out, "\tclr.w %%d6\n");
	va_start(ap, op);
	vfprintf(func_out, op, ap);
	va_end(ap);
	fprintf(func_out, "\tbne 0f\n");
	fprintf(func_out, "\tori.b #0x04, %%d6 | update zero, clear carry\n");
	fprintf(func_out, "0:\n");
}

void updateZ(char *op, ...)
{
	va_list ap;
	
	//fprintf(func_out, "\tmoveq #0x04, %%d0\n");
	fprintf(func_out, "\tor.b #0x04, %%d6\n");
	va_start(ap, op);
	vfprintf(func_out, op, ap);
	va_end(ap);
	fprintf(func_out, "\tbeq 0f\n");
	fprintf(func_out, "\teor.b #0x04, %%d6 | update zero\n");
	fprintf(func_out, "0:\n");
}

void updateC(char *op, ...)
{
	va_list ap;
	
	//fprintf(func_out, "\tmoveq #0x01, %%d0\n");
	fprintf(func_out, "\tor.b #0x01, %%d6\n");
	va_start(ap, op);
	vfprintf(func_out, op, ap);
	va_end(ap);
	fprintf(func_out, "\tbcs 0f\n");
	fprintf(func_out, "\teor.b #0x01, %%d6 | update carry\n");
	fprintf(func_out, "0:\n");
}

//void set_subtract_flag() { fprintf(func_out, "\tori.b #0x20, %%d7 | set subtract\n"); }
//void clear_subtract_flag() { fprintf(func_out, "\tandi.b #~0x20, %%d7 | clear subtract\n"); }
//void clear_carry_flag() { fprintf(func_out, "\tclr.b %%d6 | clear carry\n"); }
//void clear_zero_flag() { fprintf(func_out, "\tclr.b %%d7 | clear zero\n"); }

void carry_to_extend()
{
	//fprintf(func_out, "\tbtst.b #0, %%d6 | copy carry to extend\n");
	//fprintf(func_out, "\tsne %%d1\n"); //Z clear - 0xff, Z set - 0x00
	//fprintf(func_out, "\tadd.b %%d1, %%d1\n"); //set extend flag with 0xff+0xff, clear with 0+0
	fprintf(func_out, "\tlsr.b #1, %%d6 | copy carry to extend\n");
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

void write_mem_access_patch(char *arg)
{
	int offset;

	if(opcode_index < 128) offset = 256 * opcode_index;
	else offset = -(256-opcode_index) * 256;
	offset += MEM_WRITE_SIZE + IO_WRITE_SIZE + 6;
	if(prefix == 0x00) offset += PREFIX_OPCODE_SIZE;
	if(event_table[opcode_index] == 0) offset += 2; //skip over subq
	
	if(prefix == 0xff) {
		fprintf(func_out, "\tmove.b %s, (6f-function_base+2, %%a3)\n", arg);
	} else {
		fprintf(func_out, "\tmove.b %s, (6f - opcode%02X%02X + 2 + (%d), %%a6)\n",
			arg, prefix, opcode_index, offset);
	}
}

void write_bra(char *bra, int target_opcode, int offset)
{
	int current_offset;
	int target_offset;
	//CALL is opcode 0xCD
	
	if(target_opcode < 128) target_offset = 256 * target_opcode;
	else target_offset = -(256-target_opcode) * 256;
	target_offset += MEM_WRITE_SIZE + IO_WRITE_SIZE + PREFIX_OPCODE_SIZE + 6;
	target_offset += offset;

	if(opcode_index < 128) current_offset = 256 * opcode_index;
	else current_offset = -(256-opcode_index) * 256;
	current_offset += MEM_WRITE_SIZE + IO_WRITE_SIZE + 6;
	if(prefix == 0x00) current_offset += PREFIX_OPCODE_SIZE;

	fprintf(func_out, "5:\n");
	fprintf(func_out, "\t%s opcode%02X%02X - 5b + (%d)\n", bra, prefix, opcode_index, target_offset - current_offset - 2);
}

//returns gb relative SP in loc
void get_SP(short loc)
{
	fprintf(func_out, "\tmove.l %%a2, %s\n", arg_table[loc]);
	write_mem_access_patch("(SP_BASE, %a5)");
	fprintf(func_out, "6:\n");
	fprintf(func_out, "\tsub.l (0x7f02, %%a6), %s | sp now relative to block\n", arg_table[loc]);
	fprintf(func_out, "\tadd.l (SP_BLOCK, %%a5), %s | sp is now correct\n", arg_table[loc]);
}

void new_SP(short loc)
{
	// RELATIVE SP --> ABSOULTE SP (in a2)
	fprintf(func_out, "\t| new_SP():\n");
	fprintf(func_out, "\tmoveq #0, %%d0\n");
	fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[loc]);
	fprintf(func_out, "\tswap %s\n", arg_table[loc]);
	fprintf(func_out, "\tmove.b %s, (SP_BASE, %%a5)\n", arg_table[loc]);
	write_mem_access_patch(arg_table[loc]);
	fprintf(func_out, "6:\n");
	fprintf(func_out, "\tmovea.l (0x7f02, %%a6), %%a2\n");
	fprintf(func_out, "\tadda.l %%d0, %%a2\n");
	fprintf(func_out, "\tswap %s\n", arg_table[loc]);
}

void new_SP_immd()
{
	// (%a4)+ --> ABSOULTE SP (in a2)

	fprintf(func_out, "\t| new_SP_immd():\n");
	fprintf(func_out, "\tmoveq #0, %%d0\n");
	fprintf(func_out, "\tmove.b (%%a4)+, %%d0\n");
	fprintf(func_out, "\tmove.b (%%a4)+, %%d1\n");
	fprintf(func_out, "\tcmp.b #0xE0, %%d1 | Hack for games with stack at top of RAM\n");
	fprintf(func_out, "\tbne 0f\n");
	fprintf(func_out, "\tsubq.b #1, %%d1\n");
	fprintf(func_out, "\tmove.w #0x100, %%d0\n");
	fprintf(func_out, "0:\n");
	fprintf(func_out, "\tmove.b %%d1, (SP_BASE, %%a5)\n");
	write_mem_access_patch("%d1");
	fprintf(func_out, "6:\n");
	fprintf(func_out, "\tmovea.l (0x7f02, %%a6), %%a2\n");
	fprintf(func_out, "\tadda.l %%d0, %%a2\n");
}

//assumes relative PC (word) is in D2, and that flags are set apropriately
void new_PC_HL()
{
	fprintf(func_out, "\t| new_PC_HL():\n");
	fprintf(func_out, "\tmoveq #0, %%d0\n");
	fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[ARG_H]);
	fprintf(func_out, "\tswap %s\n", arg_table[ARG_H]);
	fprintf(func_out, "\tmove.b %s, (PC_BASE, %%a5)\n", arg_table[ARG_H]);
	write_mem_access_patch(arg_table[ARG_H]);
	fprintf(func_out, "6:\n");
	fprintf(func_out, "\tmovea.l (0x7f02, %%a6), %%a4\n");
	fprintf(func_out, "\tadda.l %%d0, %%a4\n");
	fprintf(func_out, "\tswap %s\n", arg_table[ARG_H]);
}

//reads new PC at current PC
void new_PC_immd(bool read_dir)
{
	fprintf(func_out, "\t| new_PC_immd():\n");
	fprintf(func_out, "\tmoveq #0, %%d0\n");
	if(read_dir) {
		fprintf(func_out, "\tmove.b (%%a4)+, %%d0\n");
		fprintf(func_out, "\tmove.b (%%a4), %%d1\n");
	} else {
		fprintf(func_out, "\tmove.b -(%%a4), %%d1\n");
		fprintf(func_out, "\tmove.b -(%%a4), %%d0\n");
	}
	fprintf(func_out, "\tmove.b %%d1, (PC_BASE, %%a5)\n");
	write_mem_access_patch("%d1");
	fprintf(func_out, "6:\n");
	fprintf(func_out, "\tmovea.l (0x7f02, %%a6), %%a4\n");
	fprintf(func_out, "\tadda.l %%d0, %%a4\n");
}

void push_PC()
{
	fprintf(func_out, "\tmove.l %%a4, %%d1\n");
	write_mem_access_patch("(PC_BASE, %a5)");
	fprintf(func_out, "6:\n");
	fprintf(func_out, "\tsub.l (0x7f02, %%a6), %%d1 | pc now relative to block\n");
	fprintf(func_out, "\tadd.l (PC_BLOCK, %%a5), %%d1 | pc is now correct\n");

	fprintf(func_out, "\tsubq.l #2, %%a2\n");
	fprintf(func_out, "\tmove.b %%d1, (%%a2)\n");
	fprintf(func_out, "\trol.w #8, %%d1\n");
	fprintf(func_out, "\tmove.b %%d1, (%%a2, 1)\n");
}

void pop_PC()
{
	fprintf(func_out, "\tmoveq #0, %%d0\n");
	fprintf(func_out, "\tmove.b (%%a2)+, %%d0\n");
	fprintf(func_out, "\tmove.b (%%a2)+, %%d1\n");
	fprintf(func_out, "\tmove.b %%d1, (PC_BASE, %%a5)\n");
	write_mem_access_patch("%d1");
	fprintf(func_out, "6:\n");
	fprintf(func_out, "\tmovea.l (0x7f02, %%a6), %%a4\n");
	fprintf(func_out, "\tadda.l %%d0, %%a4\n");
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

void write_prefix(ARG_FORMAT *arg, ARG_FORMAT *other, bool read_modify, int opcode_type)
{
	//char lable[1024];
	//char no_carry[1024], no_zero[1024], no_subtract[1024];
	if(arg->prefix == PREFIX_MEM_REG_INDIR) {

		fprintf(func_out, "\tmoveq #0, %%d0\n");
		fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[arg->prefix_tag]);
		
		//fprintf(func_out, "\tmove.b %s, (%%a6)\n", arg_table[arg->prefix_tag]);
		
		if(!arg->dst && !read_modify || arg->size == SIZE16) {
			fprintf(func_out, "\tswap %s\n", arg_table[arg->prefix_tag]);
			write_mem_access_patch(arg_table[arg->prefix_tag]);
			fprintf(func_out, "\tswap %s\n", arg_table[arg->prefix_tag]);
			fprintf(func_out, "6:\n");
			fprintf(func_out, "\tmovea.l (0x7f02, %%a6), %%a0\n");
			if(arg->special == SPECIAL_INC_HL) {
				fprintf(func_out, "\text.w %s\n", arg_table[ARG_H]);
				fprintf(func_out, "\taddq.l #1, %s\n", arg_table[ARG_H]);
			} else if(arg->special == SPECIAL_DEC_HL) {
				fprintf(func_out, "\text.w %s\n", arg_table[ARG_H]);
				fprintf(func_out, "\tsubq.l #1, %s\n", arg_table[ARG_H]);
			}
		} else {
			if(!read_modify && other->tag != ARG_DT1) {
				if(swap_table[other->tag]) {
					fprintf(func_out, "\tmove.l %s, %%d1\n", arg_table[other->tag]);
					fprintf(func_out, "\tswap %%d1\n");
				} else {
					fprintf(func_out, "\tmove.b %s, %%d1\n", arg_table[other->tag]);
				}
				other->tag = ARG_DT1;
			}
			fprintf(func_out, "\tswap %s\n", arg_table[arg->prefix_tag]);
			write_mem_access_patch(arg_table[arg->prefix_tag]);
			fprintf(func_out, "\tswap %s\n", arg_table[arg->prefix_tag]);
			if(arg->special == SPECIAL_INC_HL) {
				fprintf(func_out, "\text.w %s\n", arg_table[ARG_H]);
				fprintf(func_out, "\taddq.l #1, %s\n", arg_table[ARG_H]);
			} else if(arg->special == SPECIAL_DEC_HL) {
				fprintf(func_out, "\text.w %s\n", arg_table[ARG_H]);
				fprintf(func_out, "\tsubq.l #1, %s\n", arg_table[ARG_H]);
			}
			
			fprintf(func_out, "6:\n");
			if(!read_modify) {
				fprintf(func_out, "\tjmp (0x7f00, %%a6)\n");
			} else {
				fprintf(func_out, "\tlea (0x7f02, %%a6), %%a1\n");
				fprintf(func_out, "\tmove.l (%%a1)+, %%a0\n");
				fprintf(func_out, "\tmove.b (%%a0, %%d0.w), %%d1\n");
				arg->tag = ARG_DT1;
			}

			/*fprintf(func_out, "\tlea (0x7f00, %%a6), %%a1\n");
			
			fprintf(func_out, "\tmove.l (%%a1)+, %%a0\n");
			if(!read_modify) {
				fprintf(func_out, "\tmove.w (%%a1), %%d1\n");
				fprintf(func_out, "\tbeq 0f\n");
				write_false_mem(opcode_type, other); //get arg into d2
				if(arg->size == SIZE16) {
					//fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
					fprintf(func_out, "\tmove.l (NEXT_EVENT, %%a5), (SAVE_EVENT_MEM16, %%a5)\n");
					fprintf(func_out, "\tmove.w %%d4, (SAVE_COUNT_MEM16, %%a5)\n");
					fprintf(func_out, "\tmove.l #write16_finish, (NEXT_EVENT, %%a5)\n");
					fprintf(func_out, "\tmoveq #-1, %%d4\n");
				} //else {
					//fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
				//}
				fprintf(func_out, "\tjmp (%%a3, %%d1.w)\n");
				fprintf(func_out, "0:\n");
			}*/
		}

		/*if(arg->prefix_tag != ARG_DT3)
			fprintf(func_out, "\tmove.w %s, %%d3\n", arg_table[arg->prefix_tag]);

		fprintf(func_out, "\tclr.w %%d0\n");
		fprintf(func_out, "\tmove.b %%d3, %%d0\n");
		fprintf(func_out, "\tclr.b %%d3\n");
		fprintf(func_out, "\tlsr.w #5, %%d3\n");
		fprintf(func_out, "\tlea (MEM_TABLE, %%a5, %%d3.w), %%a1\n");
		fprintf(func_out, "\tmovea.l (%%a1)+, %%a0\n");
		if(arg->dst && !read_modify) fprintf(func_out, "\tmove.w (%%a1), %%d1\n");*/

		//if(read_modify) {
		//	fprintf(func_out, "\tmove.b %s, %%d2\n", arg_table[arg->tag]);
		//	arg->tag = ARG_DT2;
		//}
	} else if(arg->prefix == PREFIX_MEM_IMMD_INDIR) {
		fprintf(func_out, "\tmoveq #0, %%d0\n");
		fprintf(func_out, "\tmove.b (%%a4)+, %%d0\n");
		
		//fprintf(func_out, "\tmove.b %s, (%%a6)\n", arg_table[arg->prefix_tag]);
		
		if(!arg->dst && !read_modify || arg->size == SIZE16) {
			write_mem_access_patch("(%a4)+");
			fprintf(func_out, "6:\n");
			fprintf(func_out, "\tmovea.l (0x7f02, %%a6), %%a0\n");
		} else {
			if(!read_modify && other->tag != ARG_DT1) {
				if(swap_table[other->tag]) {
					fprintf(func_out, "\tmove.l %s, %%d1\n", arg_table[other->tag]);
					fprintf(func_out, "\tswap %%d1\n");
				} else {
					fprintf(func_out, "\tmove.b %s, %%d1\n", arg_table[other->tag]);
				}
				other->tag = ARG_DT1;
			}

			write_mem_access_patch("(%a4)+");
			fprintf(func_out, "6:\n");

			if(!read_modify) {
				fprintf(func_out, "\tjmp (0x7f00, %%a6)\n");
			} else {
				fprintf(func_out, "\tlea (0x7f02, %%a6), %%a1\n");
				fprintf(func_out, "\tmove.l (%%a1)+, %%a0\n");
				fprintf(func_out, "\tmove.b (%%a0, %%d0.w), %%d1\n");
				arg->tag = ARG_DT1;
			}
		}
	} else if(arg->prefix == PREFIX_MEM_FF00) {
		fprintf(func_out, "\tmoveq #0, %%d0\n");
		fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[arg->prefix_tag]);
		fprintf(func_out, "\tmovea.l (-1*256+2, %%a6), %%a0\n");
		
		if(arg->dst) {
			fprintf(func_out, "\tmove.b %%d5, %%d1\n");
			//fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
			write_mem_access_patch("%d0");
			fprintf(func_out, "6:\n");
			fprintf(func_out, "\tjmp (0x7f%02X, %%a6)\n", 6 + MEM_WRITE_SIZE);
		}
	} else if(arg->prefix == PREFIX_SP_IMMD) {
		get_SP(ARG_DT1);
		fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[ARG_IMMD8]);
		fprintf(func_out, "\text.w %%d0\n");
		updateC_clearZ_fast("\tadd.w %%d0, %%d1\n");
	} else if(arg->prefix == PREFIX_GET_IMMD16) {
		fprintf(func_out, "\tmove.b (%%a4, 1), %%d1\n");
		fprintf(func_out, "\trol.w #8, %%d1\n");
		fprintf(func_out, "\tmove.b (%%a4), %%d1\n");
		fprintf(func_out, "\taddq.w #2, %%a4\n");
	} else if(arg->prefix == PREFIX_GET_AF) {
		fprintf(func_out, "\tmoveq #0, %%d0\n");
		fprintf(func_out, "\tbtst #0, %%d6\n");
		fprintf(func_out, "\tbeq 0f\n");
		fprintf(func_out, "\tori.b #0x10, %%d0 | set gb carry\n");
		fprintf(func_out, "0:\n");
		fprintf(func_out, "\tbtst #2, %%d6\n");
		fprintf(func_out, "\tbeq 0f\n");
		fprintf(func_out, "\tori.b #0x80, %%d0 | set gb zero\n");
		fprintf(func_out, "0:\n");
	} else if(arg->prefix == PREFIX_GET_SP && !arg->dst) {
		get_SP(arg->tag);
	}
}

void write_suffix(ARG_FORMAT *arg)
{
	if(arg->prefix == PREFIX_MEM_REG_INDIR && arg->dst) {
		fprintf(func_out, "\tjmp (%%a1)\n");
		//get_lable(lable);
		//fprintf(func_out, "\tmove.w (%%a1), %%d1\n");
		//fprintf(func_out, "\tbeq %s\n", lable);
		//fprintf(func_out, "\tjmp (%%a3, %%d1.w)\n");
		//fprintf(func_out, "%s:\n", lable);
		//fprintf(func_out, "\tmove.b %%d2, (%%a0, %%d0.w)\n");
	} else if(arg->prefix == PREFIX_GET_SP && arg->dst) {
		new_SP(ARG_H);//arg->tag); //hack...
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
	if(src->name == OP_HL_INDIR && dst->name == OP_HL_INDIR) return false;
	
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(src->tag == dst->tag) {
		//fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
		//next_instruction();
		return true;
	}
	write_prefix(src, dst, false, TYPE_LD8);
	write_prefix(dst, src, false, TYPE_LD8);
	if(dst->prefix == NONE) {
		if(src->prefix == NONE) {
			if(strcmp(arg_table[src->tag], arg_table[dst->tag]) == 0 && swap_table[src->tag]) { //high to low
				fprintf(func_out, "\tmove.l %s, %%d0\n", arg_table[src->tag]);
				fprintf(func_out, "\tswap %%d0\n");
				fprintf(func_out, "\tmove.b %%d0, %s\n", arg_table[dst->tag]);
			} else if(strcmp(arg_table[src->tag], arg_table[dst->tag]) == 0 && swap_table[dst->tag]) { //low to high
				fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[src->tag]);
				fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
				fprintf(func_out, "\tmove.b %%d0, %s\n", arg_table[dst->tag]);
			} else if(swap_table[dst->tag] && swap_table[src->tag]) {
				fprintf(func_out, "\tmove.l %s, %%d0\n", arg_table[src->tag]);
				fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[dst->tag]);
				fprintf(func_out, "\tmove.l %%d0, %s\n", arg_table[dst->tag]);
			} else if(!swap_table[dst->tag] && !swap_table[src->tag]) {
				fprintf(func_out, "\tmove.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
			} else if(!swap_table[dst->tag] && swap_table[src->tag]) {
				fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
				fprintf(func_out, "\tmove.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
				fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
			} else if(swap_table[dst->tag] && !swap_table[src->tag]) {
				fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
				fprintf(func_out, "\tmove.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
				fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
			}
		} else {
			if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
			fprintf(func_out, "\tmove.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
			if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
		}
		//if(dst->tag == ARG_H) new_HL();
		//fprintf(func_out, "\tsubq.w #%d, %%d4\n", cycles);
		//next_instruction();
	}
	return true;
}

bool write_LD16(ARG_FORMAT *src, ARG_FORMAT *dst)
{	
	dst->size = SIZE16;
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(src->tag == dst->tag && src->prefix == dst->prefix) {
		return true;
	}

	if(src->prefix == PREFIX_GET_IMMD16) {
		//SPECIAL CASE...prefix_get_immd16 generates poor code here
		if(dst->prefix == PREFIX_GET_SP) {
			new_SP_immd();
		} else {
			fprintf(func_out, "\tmove.b (%%a4)+, %s\n", arg_table[dst->tag]);
			fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
			fprintf(func_out, "\tmove.b (%%a4)+, %s\n", arg_table[dst->tag]);
			fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
		}
		
		return true;
	} else if(dst->prefix == PREFIX_GET_SP) {
		//this will handle the LD SP, HL instruction (that's all)
		new_SP(src->tag);

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
			fprintf(func_out, "\tmove.b %s, (%%a0, %%d0.w)\n", arg_table[src->tag]);
			fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
			fprintf(func_out, "\tmove.b %s, (1, %%a0, %%d0.w)\n", arg_table[src->tag]);
		}
	} else if(src->prefix == PREFIX_SP_IMMD) {
		fprintf(func_out, "\tmove.b %%d1, %s\n", arg_table[dst->tag]);
		fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
		fprintf(func_out, "\trol.w #8, %%d1\n");
		fprintf(func_out, "\tmove.b %%d1, %s\n", arg_table[dst->tag]);
		fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	} else {
		fprintf(func_out, "\tmove.l %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	}
	write_suffix(dst);

	return true;
}

bool write_PUSH(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, false, TYPE_LD16);
	if(dst->prefix == PREFIX_GET_AF) {
		fprintf(func_out, "\tmove.b %%d5, -(%%a2)\n");
		fprintf(func_out, "\tmove.b %%d0, -(%%a2)\n");
	} else {
		fprintf(func_out, "\tmove.l %s, %%d0\n", arg_table[dst->tag]);
		fprintf(func_out, "\tswap %%d0\n");
		fprintf(func_out, "\tmove.b %%d0, -(%%a2)\n");
		fprintf(func_out, "\tmove.b %s, -(%%a2)\n", arg_table[dst->tag]);
	}

	return true;
}

bool write_POP(ARG_FORMAT *dst)
{
	//char no_half_carry[1024], test_zero[1024], no_subtract[1024];
	
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->prefix == PREFIX_GET_AF) {
		fprintf(func_out, "\tmove.b (%%a2)+, %%d0 | restore flags\n");
		fprintf(func_out, "\tmove.b (%%a2)+, %%d5\n");
		fprintf(func_out, "\tmoveq #0, %%d6\n");
		fprintf(func_out, "\tbtst #7, %%d0\n");
		fprintf(func_out, "\tbeq 0f\n");
		fprintf(func_out, "\tori #0x04, %%d6 | set zero\n");
		fprintf(func_out, "0:\n");
		fprintf(func_out, "\tbtst #4, %%d0\n");
		fprintf(func_out, "\tbeq 0f\n");
		fprintf(func_out, "\tori.b #0x01, %%d6 | set carry\n");
		fprintf(func_out, "0:\n");
	} else {
		fprintf(func_out, "\tmove.b (%%a2)+, %s\n", arg_table[dst->tag]);
		fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
		fprintf(func_out, "\tmove.b (%%a2)+, %s\n", arg_table[dst->tag]);
		fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	}

	return true;
}

bool write_ADD(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	fprintf(func_out, "\tmove.b %%d5, %%d6\n");
	fprintf(func_out, "\tswap %%d6\n");
	fprintf(func_out, "\tadd.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	updateZC();
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	return true;
}

bool write_ADC(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	if(src->prefix != NONE || src->tag == ARG_IMMD8) {
		fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[src->tag]); //get src in d0
		src->tag = ARG_DT0;
	}
	carry_to_extend();
	fprintf(func_out, "\tmove.b %%d5, %%d6\n");
	fprintf(func_out, "\tswap %%d6\n");
	fprintf(func_out, "\teor.b %%d1, %%d1 | addx doesn't set zero flag, only clears it\n");
	fprintf(func_out, "\taddx.b %s, %%d5\n", arg_table[src->tag]);
	updateZC();
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	return true;
}

bool write_SUB(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	fprintf(func_out, "\tmove.b %%d5, %%d6\n");
	fprintf(func_out, "\tswap %%d6\n");
	fprintf(func_out, "\tsub.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	updateZC();
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	return true;
}

bool write_SBC(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	if(src->prefix != NONE || src->tag == ARG_IMMD8) {
		fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[src->tag]); //get src in d0
		src->tag = ARG_DT0;
	}
	carry_to_extend();
	fprintf(func_out, "\tmove.b %%d5, %%d6\n");
	fprintf(func_out, "\tswap %%d6\n");
	fprintf(func_out, "\teor.b %%d1, %%d1 | subx doesn't set zero flag, only clears it\n");
	fprintf(func_out, "\tsubx.b %s, %%d5\n", arg_table[src->tag]);
	updateZC();
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	return true;
}

bool write_AND(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	//fprintf(func_out,
	updateZ_clearC("\tand.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	return true;
}

bool write_OR(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	updateZ_clearC("\tor.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	return true;
}

bool write_XOR(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(src->tag == ARG_A) {
		fprintf(func_out, "\tclr.b %%d5\n");
		updateZC();
		return true;
	}

	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	if(src->prefix != NONE || src->tag == ARG_IMMD8) {
		fprintf(func_out, "\tmove.b %s, %%d0\n", arg_table[src->tag]);
		src->tag = ARG_DT0;
	}
	updateZ_clearC("\teor.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	return true;
}

bool write_CP(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	//won't work unless dst is gb_A, which it always should be
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, dst, false, 0);
	write_prefix(dst, src, false, 0);
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	fprintf(func_out, "\tcmp.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	//FLAG START
	updateZC();
	//FLAG END
	if(swap_table[src->tag]) fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
	return true;
}

bool write_INC(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	updateZ("\taddq.b #1, %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	return true;
}

bool write_DEC(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	updateZ("\tsubq.b #1, %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	return true;
}

bool write_CPL()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tnot.b %s\n", arg_table[ARG_A]);
	return true;
}

bool write_CCF()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\teori.b #0x01, %%d6\n");
	return true;
}

bool write_SCF()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tori.b #0x01, %%d6\n");
	return true;
}

bool write_DI()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tclr.b (IME, %%a5)\n");
	return true;
}

bool write_EI()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tjmp (ei_function-function_base, %%a3)\n");
	return true;
}

bool write_ADD16(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->prefix == PREFIX_GET_SP) { //HACK!! (doesn't set flags right...)
		fprintf(func_out, "\tmove.b (%%a4)+, %%d0\n");
		fprintf(func_out, "\text.w %%d0\n");
		fprintf(func_out, "\tadda.l %%d0, %%a2\n");
	} else {
		if(src->prefix == PREFIX_GET_SP) {
			get_SP(ARG_DT0);
			fprintf(func_out, "\tadd.b %%d0, %s\n", arg_table[dst->tag]);
			fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
			fprintf(func_out, "\trol.w #8, %%d0\n");
			updateC("\taddx.b %%d0, %s\n", arg_table[dst->tag]);
			fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
		} else {
			fprintf(func_out, "\tadd.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
			fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
			if(src->tag != dst->tag) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
			updateC("\taddx.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
			fprintf(func_out, "\tswap %s\n", arg_table[src->tag]);
			if(src->tag != dst->tag) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
		}
	}

	return true;
}

bool write_INC16(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->prefix == PREFIX_GET_SP) {
		fprintf(func_out, "\taddq.l #1, %%a2\n");
	} else {
		fprintf(func_out, "\text.w %s\n", arg_table[dst->tag]);
		fprintf(func_out, "\taddq.l #1, %s\n", arg_table[dst->tag]);
	}
	
	return true;
}

bool write_DEC16(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->prefix == PREFIX_GET_SP) {
		fprintf(func_out, "\tsubq.l #1, %%a2\n");
	} else {
		fprintf(func_out, "\text.w %s\n", arg_table[dst->tag]);
		fprintf(func_out, "\tsubq.l #1, %s\n", arg_table[dst->tag]);
	}

	return true;
}

bool write_RLCA()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index); 
	updateC_clearZ("\trol.b #1, %s\n", arg_table[ARG_A]);
	return true;
}

bool write_RLA()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	carry_to_extend();
	updateC_clearZ_fast("\troxl.b #1, %s\n", arg_table[ARG_A]);
	return true;
}

bool write_RRCA()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	updateC_clearZ("\tror.b #1, %s\n", arg_table[ARG_A]);
	return true;
}

bool write_RRA()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	carry_to_extend();
	updateC_clearZ_fast("\troxr.b #1, %s\n", arg_table[ARG_A]);
	return true;
}

bool write_RLC(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	fprintf(func_out, "\trol.b #1, %s\n", arg_table[dst->tag]);
	updateZC();
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	return true;
}

bool write_RL(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	carry_to_extend();
	fprintf(func_out, "\troxl.b #1, %s\n", arg_table[dst->tag]);
	updateZC();
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	return true;
}

bool write_RRC(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	fprintf(func_out, "\tror.b #1, %s\n", arg_table[dst->tag]);
	updateZC();
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	return true;
}

bool write_RR(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	carry_to_extend();
	fprintf(func_out, "\troxr.b #1, %s\n", arg_table[dst->tag]);
	updateZC();
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	return true;
}

bool write_SLA(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	fprintf(func_out, "\tasl.b #1, %s\n", arg_table[dst->tag]);
	updateZC();
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	return true;
}

bool write_SRA(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	fprintf(func_out, "\tasr.b #1, %s\n", arg_table[dst->tag]);
	updateZC();
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	return true;
}

bool write_SRL(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	fprintf(func_out, "\tlsr.b #1, %s\n", arg_table[dst->tag]);
	updateZC();
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	write_suffix(dst);
	return true;
}

bool write_BIT(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	dst->dst = false; //because dst is read only in this case
	write_prefix(dst, src, false, 0);
	if(swap_table[dst->tag]) {
		updateZ("\tbtst #%d, %s\n", src->tag-ARG_0+16, arg_table[dst->tag]);
	} else {
		updateZ("\tbtst.b %s, %s\n", arg_table[src->tag], arg_table[dst->tag]);
	}
	return true;
}

bool write_SET(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, src, true, 0);
	if(swap_table[dst->tag]) {
		fprintf(func_out, "\tbset #%d, %s\n", src->tag-ARG_0+16, arg_table[dst->tag]);
	} else {
		fprintf(func_out, "\tori.b #0x%02X, %s\n", (unsigned char)1 << (src->tag - ARG_0), arg_table[dst->tag]);
	}
	write_suffix(dst);
	return true;
}

bool write_RES(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, src, true, 0);
	if(swap_table[dst->tag]) {
		fprintf(func_out, "\tbclr #%d, %s\n", src->tag-ARG_0+16, arg_table[dst->tag]);
	} else {
		fprintf(func_out, "\tandi.b #0x%02X, %s\n", (unsigned char)~(1 << (src->tag - ARG_0)), arg_table[dst->tag]);
	}
	write_suffix(dst);
	return true;
}

bool write_SWAP(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(dst, 0, true, 0);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	updateZ_clearC("\trol.b #4, %s\n", arg_table[dst->tag]);
	if(swap_table[dst->tag]) fprintf(func_out, "\tswap %s\n", arg_table[dst->tag]);
	write_suffix(dst);

	return true;
}

bool write_JP(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->tag == ARG_H) new_PC_HL();
	else new_PC_immd(true);

	return true;
}

bool write_Jcc(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	if(dst->tag == ARG_FNC || dst->tag == ARG_FC) {
		fprintf(func_out, "\tbtst #0, %%d6\n");
		if(dst->tag == ARG_FNC) write_bra("beq", 0xC3, 0);
		else write_bra("bne", 0xC3, 0);
	} else {
		fprintf(func_out, "\tbtst #2, %%d6\n");
		if(dst->tag == ARG_FNZ) write_bra("beq", 0xC3, 0);
		else write_bra("bne", 0xC3, 0);
	}
	fprintf(func_out, "\taddq.l #2, %%a4\n");

	return true;
}

bool write_JR(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	dst->dst = false;
	write_prefix(dst, 0, false, 0);
	fprintf(func_out, "\tmove.b %s, %%d1\n", arg_table[dst->tag]);
	fprintf(func_out, "\text.w %%d1\n");
	fprintf(func_out, "\tadda.w %%d1, %%a4\n");
	return true;
}

bool write_JRcc(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	write_prefix(src, 0, false, 0);
	if(dst->tag == ARG_FNC || dst->tag == ARG_FC) {
		fprintf(func_out, "\tbtst #0, %%d6\n");
		if(dst->tag == ARG_FNC) write_bra("beq", 0x18, 0);
		else write_bra("bne", 0x18, 0);
	} else {
		fprintf(func_out, "\tbtst #2, %%d6\n");
		if(dst->tag == ARG_FNZ) write_bra("beq", 0x18, 0);
		else write_bra("bne", 0x18, 0);
	}
	fprintf(func_out, "\taddq.l #1, %%a4\n");

	return true;
}

bool write_CALL(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\taddq.l #2, %%a4\n");
	push_PC();
	new_PC_immd(false);

	return true;
}

bool write_CALLcc(ARG_FORMAT *src, ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\taddq.l #2, %%a4\n");
	if(dst->tag == ARG_FNC || dst->tag == ARG_FC) {
		fprintf(func_out, "\tbtst #0, %%d6\n");
		if(dst->tag == ARG_FNC) write_bra("beq", 0xCD, 2);
		else write_bra("bne", 0xCD, 2);
	} else {
		fprintf(func_out, "\tbtst #2, %%d6\n");
		if(dst->tag == ARG_FNZ) write_bra("beq", 0xCD, 2);
		else write_bra("bne", 0xCD, 2);
	}

	return true;
}

bool write_RET()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	pop_PC();

	return true;
}

bool write_RETI()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	pop_PC();
	fprintf(func_out, "\tjmp (enable_intr_entry-function_base, %%a3)\n");

	return true;
}

bool write_RETcc(ARG_FORMAT *dst)
{
	char lable[1024];
	get_lable(lable);
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tsubq.w #1, %%d4\n"); //RETcc takes one more cycles than RET
	if(dst->tag == ARG_FNC || dst->tag == ARG_FC) {
		fprintf(func_out, "\tbtst #0, %%d6\n");
		if(dst->tag == ARG_FNC) write_bra("beq", 0xC9, 0);
		else write_bra("bne", 0xC9, 0);
	} else {
		fprintf(func_out, "\tbtst #2, %%d6\n");
		if(dst->tag == ARG_FNZ) write_bra("beq", 0xC9, 0);
		else write_bra("bne", 0xC9, 0);
	}

	return true;
}

bool write_RST(ARG_FORMAT *dst)
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	push_PC();
	fprintf(func_out, "\tclr.b (PC_BASE, %%a5)\n");
	fprintf(func_out, "\tmovea.l (%%a6, 2), %%a4\n");
	if(dst->tag == ARG_R08) fprintf(func_out, "\taddq.l #8, %%a4 | now pc is correct\n");
	else if(dst->tag != ARG_R00) fprintf(func_out, "\tlea (%s, %%a4), %%a4 | now pc is correct\n", arg_table[dst->tag]);

	return true;
}

bool write_HALT()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tcmp.b #HALT_AFTER_EI, (CPU_HALT, %%a5)\n");
	fprintf(func_out, "\tbne 0f\n");
	fprintf(func_out, "\tst (IME, %%a5)\n");
	fprintf(func_out, "0:\n");
	fprintf(func_out, "\ttst.b (IME, %%a5)\n");
	fprintf(func_out, "\tbeq 1f\n");
	fprintf(func_out, "\tmoveq #-1, %%d4\n");
	fprintf(func_out, "\tmove.b #HALT_ACTIVE, (CPU_HALT, %%a5)\n");
	fprintf(func_out, "\tbra 2f\n");
	fprintf(func_out, "1:\n");
	fprintf(func_out, "\tmove.b #HALT_PENDING, (CPU_HALT, %%a5)\n");
	fprintf(func_out, "2:\n");

	return true;
}

bool write_DAA()
{
	fprintf(func_out, "opcode%02X%02X:\n", prefix, opcode_index);
	fprintf(func_out, "\tmove.b %%d5, %%d0 | d0 is current a\n");
	fprintf(func_out, "\tswap %%d6 | d5 is old a\n");
	fprintf(func_out, "\tmove.b %%d6, %%d5 | d5 is old a\n");
	fprintf(func_out, "\tbtst #16, %%d6\n");
	fprintf(func_out, "\tbeq no_carry\n");
	fprintf(func_out, "\tsub.b %%d5, %%d0\n");
	fprintf(func_out, "\tbcc daa_sub\n");
	fprintf(func_out, "daa_add: | current a was bigger...this means last instruction was add\n");
	fprintf(func_out, "\tsub.b %%d1, %%d1 |set zero, clear extend\n");	
	fprintf(func_out, "\tabcd %%d0, %%d5 | redo operation in bcd\n");
	updateZC();
	fprintf(func_out, "\tbra 0f	\n");
	fprintf(func_out, "no_carry:\n");
	fprintf(func_out, "\tsub.b %%d5, %%d0\n");
	fprintf(func_out, "\tbcc daa_add\n");
	fprintf(func_out, "daa_sub:\n");
	fprintf(func_out, "\tneg.b %%d0\n");
	fprintf(func_out, "\tsub.b %%d1, %%d1 |set zero, clear extend\n");
	fprintf(func_out, "\tsbcd %%d0, %%d5 | redo operation in bcd\n");
	updateZC();
	fprintf(func_out, "0:\n");
	
	return true;
}

void generate_int()
{
	fprintf(func_out, "generate_int: | input: %%d0, number of int\n");
	fprintf(func_out, "\tclr.b (IME, %%a5) | disable interrupts\n");
	fprintf(func_out, "\tclr.b (CPU_HALT, %%a5)\n");
	push_PC();
	fprintf(func_out, "\tclr.b (PC_BASE, %%a5)\n");
	fprintf(func_out, "\tmovea.l (%%a6, 2), %%a4\n");
	fprintf(func_out, "\tadda.l %%d0, %%a4\n");
	fprintf(func_out, "\tjmp (%%a1)\n");

	fprintf(func_out, "generate_int_event: | input: %%d0, number of int\n");
	fprintf(func_out, "\tclr.b (IME, %%a5) | disable interrupts\n");
	fprintf(func_out, "\tclr.b (CPU_HALT, %%a5)\n");
	push_PC();
	fprintf(func_out, "\tclr.b (PC_BASE, %%a5)\n");
	fprintf(func_out, "\tmovea.l (%%a6, 2), %%a4\n");
	fprintf(func_out, "\tadda.l %%d0, %%a4\n");
	fprintf(func_out, "\tEND_EVENT end_generate_int_event\n");
	fprintf(func_out, "end_generate_int_event:\n");
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
		arg->tag = ARG_DT1;
		arg->name = OP_SP;
	} else if(strcmp(a, "SP+byte") == 0) {
		cycles++;
		arg->prefix = PREFIX_SP_IMMD;
		arg->tag = ARG_DT1;
		arg->name = OP_SP_IMMD;
	} else if(strcmp(a, "byte") == 0) {
		cycles++;
		arg->tag = ARG_IMMD8;
		arg->name = OP_IMMD8;
		//if(dst) ERROR
	} else if(strcmp(a, "word") == 0) {
		cycles += 2;
		arg->tag = ARG_DT1;
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
		else if(i == 3) { arg->prefix = PREFIX_GET_SP; arg->tag = ARG_DT1; arg->name = OP_SP; }
	} else if(strcmp(a, "qq") == 0) {
		if(i == 0) { arg->tag = ARG_B; arg->name = OP_BC; }
		else if(i == 1) {arg->tag = ARG_D; arg->name = OP_DE; }
		else if(i == 2) {arg->tag = ARG_H; arg->name = OP_HL; }
		else if(i == 3) {
			//if(!dst) {
				arg->prefix = PREFIX_GET_AF;
				arg->tag = ARG_DT1;
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
				//event_table[opcode_index] = 1;
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
				if(dst_format.tag != ARG_H) cycles = 4;
				event_table[opcode_index] = 1;
				ok = write_JP(&dst_format);
				table[opcode_index].opcode_name = OP_JP;
			} else if(strcmp(opcode, "Jcc") == 0) {
				cycles = 3;
				event_table[opcode_index] = 1;
				ok = write_Jcc(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_JP;
			} else if(strcmp(opcode, "JR") == 0) {
				cycles = 3;
				event_table[opcode_index] = 1;
				ok = write_JR(&dst_format);
				table[opcode_index].opcode_name = OP_JR;
			} else if(strcmp(opcode, "JRcc") == 0) {
				cycles = 2;
				event_table[opcode_index] = 1;
				ok = write_JRcc(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_JR;
			} else if(strcmp(opcode, "CALL") == 0) {
				cycles = 6;
				event_table[opcode_index] = 1;
				ok = write_CALL(&dst_format);
				table[opcode_index].opcode_name = OP_CALL;	
			} else if(strcmp(opcode, "CALLcc") == 0) {
				cycles = 3;
				event_table[opcode_index] = 1;
				ok = write_CALLcc(&src_format, &dst_format);
				table[opcode_index].opcode_name = OP_CALL;
			} else if(strcmp(opcode, "RET") == 0) {
				cycles = 4;
				event_table[opcode_index] = 1;
				ok = write_RET();
				table[opcode_index].opcode_name = OP_RET;
			} else if(strcmp(opcode, "RETI") == 0) {
				cycles = 4;
				event_table[opcode_index] = 1;
				ok = write_RETI();
				table[opcode_index].opcode_name = OP_RETI;
			} else if(strcmp(opcode, "RETcc") == 0) {
				cycles = 1;
				event_table[opcode_index] = 1;
				ok = write_RETcc(&dst_format);
				table[opcode_index].opcode_name = OP_RET;
			} else if(strcmp(opcode, "RST") == 0) {
				cycles = 4;
				event_table[opcode_index] = 1;
				ok = write_RST(&dst_format);
				table[opcode_index].opcode_name = OP_RST;
			} else if(strcmp(opcode, "HALT") == 0) {
				event_table[opcode_index] = 1;
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
				if(prefix == 0) cycles_table[opcode_index] = cycles;
				else cycles_table[opcode_index + 256] = cycles;
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
	//table_out = fopen("table_out.txt", "w");
	line[0] = 0;
	memset(opcode_table, 0, sizeof(OPCODE_HEADER) * 256);
	memset(suffix_table, 0, sizeof(OPCODE_HEADER) * 256);
	memset(cycles_table, 0, sizeof(int) * 512);
	memset(event_table, 0, sizeof(int) * 256);
	
	fprintf(func_out, ".global jump_table\n");
	fprintf(func_out, ".global opcode_table\n");
	fprintf(func_out, ".global jump_table2\n");
	fprintf(func_out, ".global suffix_table\n");
	fprintf(func_out, ".global size_table\n");
	fprintf(func_out, ".global cycles_table\n");
	fprintf(func_out, ".global event_table\n");

	fprintf(func_out, ".global generate_int\n");
	fprintf(func_out, ".global generate_int_event\n\n");
	//fprintf(func_out, ".extern io_read\n");
	//fprintf(func_out, ".extern io_write\n\n");
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
	
	strcpy(opcode_table[0].func_name, "opcode0000");
	opcode_index = 0; prefix = 0;
	cycles_table[0] = 1;
	fprintf(func_out, "opcode0000:\n");
	//fprintf(func_out, "\tsubq.w #1, %%d4\n");
	//next_instruction();
	fprintf(func_out, "opcode0000_end: | NOP\n");
	
	strcpy(opcode_table[0xCB].func_name, "opcode00CB");
	fprintf(func_out, "opcode00CB:\n");
	fprintf(func_out, "\tmove.b (%%a4)+, (opcode00CB_end - opcode00CB + (%d) - 2, %%a6)\n",
		-(256-0xCB) * 256 + 6 + MEM_WRITE_SIZE + IO_WRITE_SIZE + PREFIX_OPCODE_SIZE);
	fprintf(func_out, "\tjmp (0x7F%02X, %%a6)\n", 6 + MEM_WRITE_SIZE + IO_WRITE_SIZE);
	fprintf(func_out, "opcode00CB_end:\n");

	fprintf(func_out, "opcode_illegal:\n");
	fprintf(func_out, "\tmove.w #1, (ERROR, %%a5) | Illegal Opcode\n");
	fprintf(func_out, "\tjmp (return-function_base, %%a3)\n");
	
	//fprintf(func_out, "\tlea (jump_table2, %%pc), %%a0\n");
	//fprintf(func_out, "\tclr.w %%d0\n");
	//fprintf(func_out, "\tmove.b (%%a4)+, %%d0\n");
	//fprintf(func_out, "\tadd.w %%d0, %%d0\n"); //d0 *= 4;
	//fprintf(func_out, "\tmove.w (%%a0, %%d0.w), %%d0\n");
	//fprintf(func_out, "\tjmp (%%a3, %%d0.w)\n");
	//calculate_half_carry();
	//push_PC();
	//pop_PC();
	prefix = 0xff;
	generate_int();

	
	
	fprintf(func_out, "\njump_table:\n");
	for(i = 0 ; i < 256 ; i++) {
		//if(i == 0xfd) fprintf(func_out, ".word special_write16 - function_base\n");
		//else if(i == 0xfc) fprintf(func_out, ".word special_write16_stack - function_base\n");
		//else if(i == 0xf4) fprintf(func_out, ".word special_write16_return - function_base\n");
		if(opcode_table[i].func_name[0]) fprintf(func_out, ".word %s - function_base\n", opcode_table[i].func_name);
		else fprintf(func_out, ".word opcode_illegal - function_base\n");
	}

	fprintf(func_out, "\njump_table2:\n");
	for(i = 0 ; i < 256 ; i++) {
		if(suffix_table[i].func_name[0]) fprintf(func_out, ".word %s - function_base\n", suffix_table[i].func_name);
		else fprintf(func_out, ".word opcode0000 - function_base\n");
	}
	
	//fprintf(func_out, "\n.if SIZE_TABLE\n");
	fprintf(func_out, "\nsize_table:\n");
	for(i = 0; i < 256; i++) {
		if(opcode_table[i].func_name[0] && i != 0xCB)
			fprintf(func_out, ".byte %s_end - %s\n", opcode_table[i].func_name, opcode_table[i].func_name);
		else
			fprintf(func_out, ".byte -1\n");
	}
	for(i = 0; i < 256; i++) {
		if(suffix_table[i].func_name[0])
			fprintf(func_out, ".byte %s_end - %s\n", suffix_table[i].func_name, suffix_table[i].func_name);
		else
			fprintf(func_out, ".byte -1\n");
	}
	//fprintf(func_out, "\n.endif\n");

	fprintf(func_out, "\ncycles_table:\n");
	for(i = 0; i < 512; i++) {
		fprintf(func_out, ".byte %d\n", cycles_table[i]);
	}

	fprintf(func_out, "\nevent_table:\n");
	for(i = 0; i < 256; i++) {
		fprintf(func_out, ".byte %d\n", event_table[i]);
	}

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
	//fclose(table_out);

	return 0;
}
