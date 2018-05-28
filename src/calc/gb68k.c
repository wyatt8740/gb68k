// C Source File
// Created 7/22/2004; 4:43:10 PM

#include <tigcclib.h>
#include "gb68k.h"
#include "gbsetup.h"
#include "gbsram.h"
#include "gbinit.h"

//gb_pc - %a4
//gb_data - %a5
//gb_mem - %a6
//gb_A %d5
//gb_F %d6
//temp - %d0

//TODO - make halt jump to cyclic event automatically

extern GB_DATA *gb_data_store;

const char title[] = {'G', 'B', '6', '8', 'K', ' ',
	'v', '0'+GB_MAJOR, '.', '0'+GB_MINOR, '.', '0'+GB_REVISION, ' ',
	'b', 'y', ' ', 'B', 'e', 'n', ' ', 'I', 'n', 'g', 'r', 'a', 'm', 0};

#ifdef GB_DEBUG
extern OPCODE_HEADER opcode_table[256];
extern OPCODE_HEADER suffix_table[256];

enum OPCODE_NAMES { //40 totla...6 bits
	OP_NOP, OP_LD, OP_PUSH, OP_POP, OP_ADD, OP_ADC, OP_SUB, OP_SBC, OP_AND, OP_OR, OP_XOR, OP_CP,
	OP_INC, OP_DEC, OP_DAA, OP_CPL, OP_CCF, OP_SCF, OP_HALT, OP_DI, OP_EI, OP_STOP, OP_SWAP,
	OP_RLCA, OP_RLA, OP_RRCA, OP_RRA, OP_RLC, OP_RL, OP_RRC, OP_RR, OP_SLA, OP_SRA, OP_SRL,
	OP_BIT, OP_SET, OP_RES, OP_JP, OP_JR, OP_CALL, OP_RET, OP_RETI, OP_RST,
};

const char *opcode_names[] = {
	"NOP", "LD", "PUSH", "POP", "ADD", "ADC", "SUB", "SBC", "AND", "OR", "XOR", "CP",
	"INC", "DEC", "DAA", "CPL", "CCF", "SCF", "HALT", "DI", "EI", "STOP", "SWAP",
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
#endif
/*
void init_mem()
{
	MEM_PTR *mem_ptr = (MEM_PTR *)opcode_block;
	unsigned short *func;
	//unsigned char *ram;
	short i, j, index;

	//set rom bank0/bank1
	if(gb_data->cart_type == MBC1) func = mbc1_offsets;
	else if(gb_data->cart_type == MBC2) func = mbc2_offsets;
	else if(gb_data->cart_type == MBC3) func = mbc3_offsets;
	else if(gb_data->cart_type == MBC5) func = mbc5_offsets;
	else func = no_mbc_offsets;
	
	//ram = gb_data->rom_ptr[0];
	for(index = 128, j = 0; j < 8; j++) {
		//disable rtc latch registers if the rtc isn't availiable
		if(gb_data->cart_type == MBC3 && gb_data->rtc_block == NULL && j >= 6) func = no_mbc_offsets;
		for(i = 0 ; i < 16 ; i++, index++, ram += 256) {
			//mem_ptr[index].ptr = ram;
			mem_ptr[index].write_func = func[j];
		}
	}

	//ram = gb_data->ram;
	//set vido ram
	for(i = 0 ; i < 24 ; i++) {
		//mem_ptr[i].ptr = ram;
		mem_ptr[i].write_func = bg_gfx_write_offsets[i];
		//ram += 256;
	}
	for(; i < 32 ; i++) {
		//mem_ptr[i].ptr = ram;
		mem_ptr[i].write_func = 0;
		//ram += 256;
	}
	//set internal ram/echo
	for(i = 0 ; i < 30 ; i++) {
		//mem_ptr[i + 64].ptr = ram;
		mem_ptr[i + 64].write_func = 0;
		//mem_ptr[i + 96].ptr = ram;
		mem_ptr[i + 96].write_func = 0;
		//ram += 256;
	}
	//finish internal, non-echoed ram
	for(; i < 32 ; i++) {
		//mem_ptr[i + 64].ptr = ram;
		mem_ptr[i + 64].write_func = 0;
		//ram += 256;
	}
	//OAM
	//mem_ptr[126].ptr = ram;
	mem_ptr[126].write_func = 0;
	//ram += 256;
	//io ports
	//mem_ptr[127].ptr = ram;
	mem_ptr[127].write_func = io_write_offset;
	//ram += 256;
	
	for(i = 0 ; i < 32 ; i++) {
		//mem_ptr[i + 32].ptr = ram;
		mem_ptr[i + 32].write_func = write_disable_offset;
	}
	
}*/

#ifdef GB_DEBUG
char *get_immd(char *s, unsigned char *addr, unsigned char name, short *len)
{
	if(name == OP_IMMD8) {
		sprintf(s, "%02X", *(addr));
		*len = *len + 1;
	} else if(name == OP_IMMD16) {
		sprintf(s, "%02X%02X", *(addr + 1), *(addr));
		*len = *len + 2;
	} else if(name == OP_IMMD_INDIR) {
		sprintf(s, "(%02X%02X)", *(addr + 1), *(addr));
		*len = *len + 2;
	} else if(name == OP_FF00_IMMD) {
		sprintf(s, "(FF00+%02X)", *(addr));
		*len = *len + 1;
	} else {
		sprintf(s, "SP+%02X", *(addr));
		*len = *len + 1;
	}

	return s;
}

short display_instruction(short x, short y, unsigned short addr)
{
	MEM_PTR *mem_table = (MEM_PTR *)opcode_block;
	OPCODE_HEADER *table;
	unsigned char opcode;
	unsigned char *laddr;
	short len = 1;
	char src_name[16];
	char dst_name[16];
	short format;
	char *src;
	char *dst;
	const char *opcode_string[] = {
		"%04X: %02X - %s %s, %s",
		"%04X: %02X - %s %s",
		"%04X: %02X - %s",
	};
	
	if(addr < 0x8000) laddr = mem_table[128 + ((addr & 0xff00) >> 8)].ptr + (addr & 0x00ff);
	else laddr = mem_table[((addr - 0x8000) & 0xff00) >> 8].ptr + (addr & 0x00ff);
	
	opcode = *laddr++;

	if(opcode == 0xCB) {
		opcode = *laddr++;
		table = suffix_table;
		len++;
	} else table = opcode_table;

	if(table[opcode].dst_name < OP_IMMD8) dst = (char *)operand_names[table[opcode].dst_name];
	else dst = get_immd(dst_name, laddr, table[opcode].dst_name, &len);

	if(table[opcode].src_name < OP_IMMD8) src = (char *)operand_names[table[opcode].src_name];
	else src = get_immd(src_name, laddr, table[opcode].src_name, &len);

	if(table[opcode].src_name == OP_NONE && table[opcode].dst_name == OP_NONE) format = 2;
	else if(table[opcode].src_name == OP_NONE) format = 1;
	else format = 0;

	printf_xy(x, y, opcode_string[format], addr, opcode,
			opcode_names[table[opcode].opcode_name], dst, src);

	return len;
}

void disassemble(short x, short y, short len, unsigned short addr)
{
	short i;

	for(i = 0 ; i < len ; i++) {
		addr += display_instruction(x, y, addr);
		y += 6;
	}
}

void show_memory(short x, short y, short len, unsigned short addr)
{
	MEM_PTR *mem_table = (MEM_PTR *)opcode_block;
	unsigned char *laddr;

	while(len) {
		if(addr < 0x8000) laddr = mem_table[128 + ((addr & 0xff00) >> 8)].ptr + (addr & 0x00ff);
		else laddr = mem_table[((addr - 0x8000) & 0xff00) >> 8].ptr + (addr & 0x00ff);

		printf_xy(x, y, "%02x", *laddr);
		len--;
		addr++;
		x += 14;
		if(x > 146) { x = 0; y += 8; }
	}
}

/*void write_memory(unsigned char byte, unsigned short addr)
{
	unsigned char *block;
	short offset;

	offset = addr & 0x00ff;
	block = gb_data->mem_ptr[(addr & 0xff00) >> 8].ptr;

	clrscr();
	printf_xy(0, 0, "%lx, %x", (unsigned long)block, offset);
	ngetchx();

	block[offset] = byte;
}*/

void show_bank()
{
	clrscr();
	printf_xy(0, 0, "bank: %d", gb_data->current_rom);
	pause();
}

#endif

void show_d3(unsigned short d3 asm("%d3"))
{
	//asm("movem.l %d0-%d7/%a0-%a6, -(%a7)");
	clrscr();
	printf("d3: %d", d3);
	pause();
	//clrscr();
	//asm("movem.l (%a7)+, %d0-%d7/%a0-%a6");
}

void emulate_entry();

short create_opcode_block()
{
	unsigned char *base;
	unsigned short *func;
	unsigned char *table;
	unsigned char *ram;
	unsigned short offset;
	short i, j, index;
	
	//movea.l immd, %a0 - 0010 0000 0111 1100 - 207C

	opcode_block = HeapAllocPtr(0xfff0 - 2);
	if(opcode_block == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
	//memset(opcode_block, 0x00, 0xfff0 - 2);
	
	//set rom bank0/bank1
	if(gb_data->cart_type == MBC1) {
		func = mbc1_offsets; table = mbc1_size_table;
	} else if(gb_data->cart_type == MBC2) {
		func = mbc2_offsets; table = mbc2_size_table;
	} else if(gb_data->cart_type == MBC3) {
		func = mbc3_offsets; table = mbc3_size_table;
	} else if(gb_data->cart_type == MBC5) {
		func = mbc5_offsets; table = mbc5_size_table;
	} else {
		func = no_mbc_offsets; table = no_mbc_size_table;
	}
	
	ram = gb_data->rom_ptr[0];
	for(index = 0, j = 0; j < 8; j++) {
		//disable rtc latch registers if the rtc isn't availiable
		if(gb_data->cart_type == MBC3 && gb_data->rtc_block == NULL && j >= 6) {
			func = no_mbc_offsets;
			table = no_mbc_size_table;
		}
		for(i = 0 ; i < 16 ; i++, index++, ram += 256) {
			base = opcode_block + 0x8000 + 256 * index;
			offset = 6;
			*(unsigned short *)base = 0x207C;
			*(unsigned long *)(base + 2) = (unsigned long)ram;
			memcpy(base + offset, gb_data->mem_base + func[j], MEM_WRITE_SIZE);
			offset += table[j];
			memcpy(base + offset, next_instruction1, next_instruction1_size);
			offset += next_instruction1_size - 6;
#ifndef GB_DEBUG
			*(short *)(base + offset) = 256 * index + offset + 4;
#endif		
		}
	}
	
	ram = gb_data->ram;
	//set vido ram
	for(i = 0 ; i < 24 ; i++) {
		base = opcode_block + 256 * i;
		offset = 6;
		*(unsigned short *)base = 0x207C;
		*(unsigned long *)(base + 2) = (unsigned long)ram;
		memcpy(base + offset, gb_data->mem_base + bg_gfx_write_offsets[i], MEM_WRITE_SIZE);
		offset += bg_gfx_write_size;
		memcpy(base + offset, next_instruction1, next_instruction1_size);
		offset += next_instruction1_size - 6;
#ifndef GB_DEBUG
		*(short *)(base + offset) = -(128-i) * 256 + offset + 4;
#endif
		ram += 256;
	}
	
	for(; i < 32 ; i++) {
		base = opcode_block + 256 * i;
		offset = 6;
		*(unsigned short *)base = 0x207C;
		*(unsigned long *)(base + 2) = (unsigned long)ram;
		memcpy(base + offset, gb_data->mem_base + write_default_offset, write_default_size);
		offset += write_default_size - 6;
#ifndef GB_DEBUG
		*(short *)(base + offset) = -(128-i) * 256 + offset + 4;
#endif
		ram += 256;
	}
	
	//set internal ram/echo
	for(i = 0 ; i < 30 ; i++) {
		base = opcode_block + 256 * (i + 64);
		offset = 6;
		*(unsigned short *)base = 0x207C;
		*(unsigned long *)(base + 2) = (unsigned long)ram;
		memcpy(base + offset, gb_data->mem_base + write_default_offset, write_default_size);
		offset += write_default_size - 6;
#ifndef GB_DEBUG
		*(short *)(base + offset) = -(128-(i+64)) * 256 + offset + 4;
#endif
		base = opcode_block + 256 * (i + 96);
		offset = 6;
		*(unsigned short *)base = 0x207C;
		*(unsigned long *)(base + 2) = (unsigned long)ram;
		memcpy(base + offset, gb_data->mem_base + write_default_offset, write_default_size);
		offset += write_default_size - 6;
#ifndef GB_DEBUG
		*(short *)(base + offset) = -(128-(i+96)) * 256 + offset + 4;
#endif
		ram += 256;
	}
	
	//finish internal, non-echoed ram
	for(; i < 32 ; i++) {
		base = opcode_block + 256 * (i + 64);
		offset = 6;
		*(unsigned short *)base = 0x207C;
		*(unsigned long *)(base + 2) = (unsigned long)ram;
		memcpy(base + offset, gb_data->mem_base + write_default_offset, write_default_size);
		offset += write_default_size - 6;
#ifndef GB_DEBUG
		*(short *)(base + offset) = -(128-(i+64)) * 256 + offset + 4;
#endif
		ram += 256;
	}
	
	//OAM
	base = opcode_block + 256 * 126;
	offset = 6;
	*(unsigned short *)base = 0x207C;
	*(unsigned long *)(base + 2) = (unsigned long)ram;
	memcpy(base + offset, gb_data->mem_base + write_default_offset, write_default_size);
	offset += write_default_size - 6;
#ifndef GB_DEBUG
	*(short *)(base + offset) = -(128-126) * 256 + offset + 4;
#endif
	ram += 256;
	
	//io ports
	base = opcode_block + 256 * 127;
	offset = 6;
	*(unsigned short *)base = 0x207C;
	*(unsigned long *)(base + 2) = (unsigned long)ram;
	memcpy(base + offset, gb_data->mem_base + io_write_offset, MEM_WRITE_SIZE);
	offset += io_write_size;
	memcpy(base + offset, next_instruction1, next_instruction1_size);
	offset += next_instruction1_size - 6;
#ifndef GB_DEBUG
	*(short *)(base + offset) = -(128-127) * 256 + offset + 4;
#endif
	ram += 256;
	
	for(i = 0 ; i < 32 ; i++) {
		base = opcode_block + 256 * (i + 32);
		offset = 6;
		*(unsigned short *)base = 0x207C;
		*(unsigned long *)(base + 2) = (unsigned long)ram;
		memcpy(base + offset, gb_data->mem_base + write_default_offset, write_default_size);
		offset += write_default_size - 6;
#ifndef GB_DEBUG
		*(short *)(base + offset) = -(128-(i+32)) * 256 + offset + 4;
#endif
		ram += 256;
	}
	
	for(i = 0; i < 128; i++) {
		base = opcode_block + 0x8000 + 256 * i;
		//base_offset = 0x8000 + 256 * i;
		offset = 6 + MEM_WRITE_SIZE;
		memcpy(base + offset, gb_data->mem_base + io_write_table[i], IO_WRITE_SIZE);
		if(io_write_size_table[i] != 0) {
			offset += io_write_size_table[i];
			//*(short *)(opcode_block + base_offset + offset) = 0x4A44; //tst.w %d4
			//offset += 2;
			memcpy(base + offset, next_instruction1, next_instruction1_size);
			offset += next_instruction1_size - 6;
#ifndef GB_DEBUG
			*(short *)(base + offset) = 256 * i + offset + 4;
#endif
		}
		
		//base_offset = 0x8000 + 256 * i;
		offset = 6 + MEM_WRITE_SIZE + IO_WRITE_SIZE;
		*(short *)(base + offset) = (0x5144 | cycles_table[i + 256] << 9); //subq.w #X, %d4
		offset += 2;
		memcpy(base + offset, gb_data->mem_base + jump_table2[i], PREFIX_OPCODE_SIZE-2);
		offset += size_table[i + 256];
		memcpy(base + offset, next_instruction1, next_instruction1_size);
		offset += next_instruction1_size - 6;
#ifndef GB_DEBUG
		*(short *)(base + offset) = 256 * i + offset + 4;
#endif
	
		//base_offset = 0x8000 + 256 * i;
		offset = 6 + MEM_WRITE_SIZE + IO_WRITE_SIZE + PREFIX_OPCODE_SIZE;
		if(size_table[i] >= 0) { //illegal instructions don't need next_instruction
			if(event_table[i]) {
				//write opcode
				memcpy(base + offset, gb_data->mem_base + jump_table[i], size_table[i]);
				offset += size_table[i];
				//write subq
				*(short *)(base + offset) = (0x5144 | cycles_table[i] << 9); //subq.w #X, %d4
				offset += 2;
				//use next instructon that checks for events
				memcpy(base + offset, next_instruction, next_instruction_size);
				offset += next_instruction_size - 14;
			} else {
				//write subq
				*(short *)(base + offset) = (0x5144 | cycles_table[i] << 9); //subq.w #X, %d4
				offset += 2;
				//write opcode
				memcpy(base + offset, gb_data->mem_base + jump_table[i], size_table[i]);
				offset += size_table[i];
				//use next instruction that doesn't check for events
				memcpy(base + offset, next_instruction1, next_instruction1_size);
				offset += next_instruction1_size - 6;
			}
#ifndef GB_DEBUG
			//patch next instruction handler so that it self modifies itself at the right address
			*(short *)(base + offset) = 256 * i + offset + 4;
#endif
		} else {
			//write opcode
			memcpy(base + offset, gb_data->mem_base + jump_table[i], OPCODE_SIZE);
		}
		
		base = opcode_block + 256 * i;
		//base_offset = 256 * i;
		offset =  6 + MEM_WRITE_SIZE;
		memcpy(base + offset, gb_data->mem_base + io_write_table[i + 128], IO_WRITE_SIZE);
		if(io_write_size_table[i + 128] != 0) {
			offset += io_write_size_table[i + 128];
			//*(short *)(opcode_block + base_offset + offset) = 0x4A44; //tst.w %d4
			//offset += 2;
			memcpy(base + offset, next_instruction1, next_instruction1_size);
			offset += next_instruction1_size - 6;
#ifndef GB_DEBUG
			*(short *)(base + offset) = -(128-i) * 256 + offset + 4;
#endif
		}
		
		//base_offset = 256 * i;
		offset = 6 + MEM_WRITE_SIZE + IO_WRITE_SIZE;
		*(short *)(base + offset) = (0x5144 | cycles_table[i + 384] << 9); //subq.w #X, %d4
		offset += 2;
		memcpy(base + offset, gb_data->mem_base + jump_table2[i + 128], PREFIX_OPCODE_SIZE-2);
		offset += size_table[i + 384];
		memcpy(base + offset, next_instruction1, next_instruction1_size);
		offset += next_instruction1_size - 6;
#ifndef GB_DEBUG
		*(short *)(base + offset) = -(128-i) * 256 + offset + 4;
#endif

		//base_offset = 256 * i;
		offset = 6 + MEM_WRITE_SIZE + IO_WRITE_SIZE + PREFIX_OPCODE_SIZE;
		if(size_table[i + 128] >= 0) { //illegal instructions don't need next_instruction
			if(event_table[i + 128]) {
				memcpy(base + offset, gb_data->mem_base + jump_table[i + 128], size_table[i + 128]);
				offset += size_table[i + 128];
				//write subq
				*(short *)(base + offset) = (0x5144 | cycles_table[i + 128] << 9); //subq.w #X, %d4
				offset += 2;
				memcpy(base + offset, next_instruction, next_instruction_size);
				offset += next_instruction_size - 14;
			} else {
				//write subq
				*(short *)(base + offset) = (0x5144 | cycles_table[i + 128] << 9); //subq.w #X, %d4
				offset += 2;
				memcpy(base + offset, gb_data->mem_base + jump_table[i + 128], size_table[i + 128]);
				offset += size_table[i + 128];
				memcpy(base + offset, next_instruction1, next_instruction1_size);
				offset += next_instruction1_size - 6;
			}
#ifndef GB_DEBUG
			*(short *)(base + offset) = -(128-i) * 256 + offset + 4;
#endif
		} else {
			memcpy(base + offset, gb_data->mem_base + jump_table[i + 128], OPCODE_SIZE);
		}
	}
	
	//init_mem();
	
	return TRUE;
}

char emulate()
{
	short i, k;

	/*clrscr();
	disassemble(0, 0, 5, gb_pc);
	printf_xy(0, 40, "A: %02x", (unsigned char)gb_A);
	///////display_flags(36, 40);
	printf_xy(0, 48, "BC: %04x", gb_data->bc);
	printf_xy(0, 56, "DE: %04x", gb_data->de);
	printf_xy(0, 64, "HL: %04x", gb_data->hl);
	printf_xy(0, 72, "SP: %04x", gb_data->sp);
	printf_xy(0, 80, "LY: %d", gb_data->io[LY]);
	//printf_xy(0, 88, "IF: %x, IE: %x, IME: %d", gb_data->io[IF], gb_data->io[IE], !!(gb_F1 & (1L << 31)));
	//printf_xy(0, 80, "PC BASE: %d", gb_data->pc_base / 8);
	show_memory(0, 88, 10, 0xffb6);

	k = ngetchx();
	if(k == KEY_ESC) break;
	else if(k == KEY_F1) i = 10;
	else if(k == KEY_F2) i = 100;
	else if(k == KEY_F3) i = 1000;
	else if(k == KEY_F4) i = 10000;
	else if(k == KEY_F5) i = 1000000;
	else i = 1;*/
	
	while(1) {
		emulate_entry();
		if(gb_data->error != ERROR_NONE) {
			return FALSE;
		} else if(gb_data->on_pressed) {
			return TRUE;
		} else if(gb_data->quit) {
			cleanup();
			if(opcode_block) { HeapFreePtr(opcode_block); opcode_block = NULL; }
			if(LoadDLL("gb68klib", GB_ID, DLL_MAJOR, DLL_MINOR) != DLL_OK) { gb_data->error = ERROR_DLL; return FALSE; }
			
			i = esc_menu();
			UnloadDLL();
			if(i == 1 || i == -1) return TRUE;
			if(!init()) return FALSE;
			//if(!create_opcode_block()) return FALSE;
		}
		/*if(gb_data->error != ERROR_NONE) return FALSE;
		else if(gb_data->quit) {
			while(1) {
				cleanup();
				if(opcode_block) { HeapFreePtr(opcode_block); opcode_block = NULL; }
				if(LoadDLL("gb68klib", GB_ID, DLL_MAJOR, DLL_MINOR) != DLL_OK) { gb_data->error = ERROR_DLL; return FALSE; }
				
				i = esc_menu();
				UnloadDLL();
				if(i == 1 || i == -1) return TRUE;
				if(!init()) return FALSE;
				if(!create_opcode_block()) return FALSE;
				emulate_entry();
			}
		}*/
		
		#ifdef GB_DEBUG
		while(1) {
			FontSetSys(F_4x6);
			clrscr();
			disassemble(0, 0, 5, gb_data->pc);
			printf_xy(0, 30, "AF: %02X%02X (ZC:%d%d)", gb_data->a, ((gb_data->f&4) << 5) | ((gb_data->f&1) << 4),
				!!(gb_data->f & 4), !!(gb_data->f & 1));
			printf_xy(0, 36, "BC: %04X", gb_data->bc);
			printf_xy(0, 42, "DE: %04X", gb_data->de);
			printf_xy(0, 48, "HL: %04X", gb_data->hl);
			printf_xy(0, 54, "SP: %04X", gb_data->sp);
			
			printf_xy(0, 60, "LY: %02X, LCDC: %02X, STAT: %02X", gb_data->ram[0x4144], gb_data->ram[0x4140], gb_data->ram[0x4141]);
			printf_xy(0, 66, "ROM %02X/%02X, RAM: %02X/%02X, Ram En: %d, RTC En: %d",
				gb_data->current_rom, gb_data->rom_banks, gb_data->current_ram, gb_data->ram_banks, !!gb_data->ram_enable, !!gb_data->rtc_enable);
			printf_xy(0, 72, "DIV: %02X, Counter: %d", gb_data->ram[0x4104], gb_data->event_counter);
			printf_xy(0, 78, "IE: %02X, IF: %02X, HALT: %d, IME: %d",
				gb_data->ram[0x41ff], gb_data->ram[0x410f], gb_data->cpu_halt, !!gb_data->ime);
			printf_xy(0, 84, "Current S: %d, m: %d, h: %d, d: %02X%02X",
				gb_data->rtc_current[RTC_S],
				gb_data->rtc_current[RTC_M],
				gb_data->rtc_current[RTC_H],
				gb_data->rtc_current[RTC_DH],
				gb_data->rtc_current[RTC_DL]);
			/*printf_xy(0, 90, "Latch S: %d, m: %d, h: %d, d: %02X%02X",
				gb_data->rtc_latched[RTC_S],
				gb_data->rtc_latched[RTC_M],
				gb_data->rtc_latched[RTC_H],
				gb_data->rtc_latched[RTC_DH],
				gb_data->rtc_latched[RTC_DL]);*/
			show_memory(0, 90, 8, 0xc380);
			FontSetSys(F_6x8);
			
			if(opcode_block) { HeapFreePtr(opcode_block); opcode_block = NULL; }
			pause();
			emulate_entry();
			
			/*k = get_key();
			if(k == SEL_KEY) i = 1;
			else if(k == SHIFT_KEY) i = 2;
			else if(k == DMND_KEY) i = 100;
			else if(k == DOWN_KEY) i = 1000;
			else if(k == UP_KEY) { gb_data->breakpoint = 0; i = 1; }
			else i = 1;
			
			while(i > 0) {
				if(opcode_block) { HeapFreePtr(opcode_block); opcode_block = NULL; }
				emulate_entry();
				i--;
			}*/
		}
		#endif
	}
}

extern short IsVTI(void);
asm("
IsVTI:
    trap   #12         /* enter supervisor mode. returns old (%sr) in %d0.w   */
    move.w #0x3000,%sr /* set a non-existing flag in %sr (but keep s-flag !!) */
    swap   %d0         /* save %d0.w content in upper part of %d0             */
    move.w %sr,%d0     /* get %sr content and check for non-existing flag     */
    btst   #12,%d0     /* this non-existing flag can only be set on the VTI   */
    bne    __VTI
    swap   %d0         /* restore old %sr content and return 0                */
    move.w %d0,%sr
    moveq  #0,%d0
    rts
__VTI:
    swap   %d0         /* restore old %sr content and return 1                */
    move.w %d0,%sr
    moveq  #1,%d0
    rts
");

void start(void)
{
	char save_screen[LCD_SIZE];
	char rom_name[9];
	short i;

	/*unsigned short max = 0;

	for(i = 0; i < 256; i++) {
		if(size_table[i] > size_table[max]) max = i;
	}
	clrscr();
	printf("%02X - %d", max, size_table[max] + next_instruction_size);
	ngetchx();

	max = 0;
	for(i = 256; i < 512; i++) {
		if(size_table[i] > size_table[max]) max = i;
	}
	clrscr();
	printf("%02X - %d", max - 256, size_table[max] + next_instruction1_size);
	ngetchx();*/
	
	/*
	for(i = 0; i < 512; i++) {
		if(size_table[i] > 40) {
			clrscr();
			printf("%03X - %d", i, size_table[i]);
			ngetchx();
		}
	}
	
	for(i = 0; i < 256; i++) {
		if(io_write_size_table[i] > 40) {
			clrscr();
			printf("IO %02X - %d", i, io_write_size_table[i]);
			ngetchx();
		}
	}
	*/
	
	/*
	unsigned short size;
	
	for(i = 0; i < 256; i++) {
		size = size_table[i] + 2;
		if(event_table[i]) size += next_instruction_size;
		else size += next_instruction1_size;
		if(size > OPCODE_SIZE) {
			clrscr();
			printf("Opcode: %02X - %d", i, size);
			ngetchx();
		}
		
		size = size_table[i + 256] + 2 + next_instruction1_size;
		if(size > PREFIX_OPCODE_SIZE) {
			clrscr();
			printf("Prefix: %02X - %d", i, size);
			ngetchx();
		}
		
		size = io_write_size_table[i] + next_instruction1_size;
		if(size > IO_WRITE_SIZE) {
			clrscr();
			printf("IO write: %02X - %d", i, size);
			ngetchx();
		}
	}*/

	screen_buffer = NULL;
	opcode_block = NULL;
	memcpy(save_screen, LCD_MEM, LCD_SIZE);
	gb_data = HeapAllocPtr(sizeof(GB_DATA));
	
	if(gb_data == NULL) goto quit;
	gb_data_store = gb_data; //keep a pointer in mem for use in ISR
	memset(gb_data, 0, sizeof(GB_DATA));
	gb_data->error = ERROR_NONE;
	
	gb_data->mem_base = function_base;
	gb_data->vti = IsVTI();
	gb_data->hw_version = HW_VERSION;
	gb_data->calc_type = CALCULATOR;
	gb_data->ams207 = (TIOS_entries >= 0x607);
	
	if(LoadDLL("gb68klib", GB_ID, DLL_MAJOR, DLL_MINOR) != DLL_OK) { gb_data->error = ERROR_DLL; goto quit; }
	select_rom(rom_name);
	if(rom_name[0] == 0) goto quit;
	if(!init_rom(rom_name)) goto quit;

	gb_data->rom_name = rom_name;
	if(!load_sram()) goto quit;

	//memcpy(opcode_block + 0x8000 + 80, cyclic_events, 80);

	//clrscr();
	//printf("%lX", (unsigned long)mem_base+jump_table[0]);
	//ngetchx();

	/*clrscr();
	for(i = 0; i < 6; i++) {
		printf("%02X, %02X\n", opcode_block[i + 0x8000], *((unsigned char *)jump_table[0] + i));
	}
	printf("%lX", jump_table[0xff]);
	ngetchx();*/
	randomize();
	if(!init()) { gb_data->error = ERROR_OUT_OF_MEM; goto quit; }
	
	if(gb_data->calc_type == 0) {
		screen_buffer = HeapAllocPtr(24*132*2);
		apply_patch89();
	} else {
		screen_buffer = HeapAllocPtr(24*160*2);
		apply_patch92();
	}
	if(screen_buffer == NULL) { gb_data->error = ERROR_OUT_OF_MEM; goto quit; }
	
	gb_data->a = 0x01;
	gb_data->f = 0x05; //bits 0 and 2 set
	gb_data->hl = 0x014D;
	gb_data->bc = 0x0013;
	gb_data->de = 0x00d8;
	gb_data->pc = 0x0100;
	gb_data->sp = 0xFFFE;
	gb_data->cpu_halt = 0;
	gb_data->ram[0x4140] = 0x91; //LCDC
	gb_data->ram[0x4147] = 0xFC; //BGP
	gb_data->ram[0x4148] = 0xFF; //OBP0
	gb_data->ram[0x4149] = 0xFF; //OBP1
	gb_data->ram[0x4104] = rand() & 0xff; //DIV
	gb_data->current_rom = 1;
	gb_data->rtc_latch = 1;
	gb_data->next_event = (unsigned long)mode2_func - (unsigned long)function_base;
	
	UnloadDLL();
	
	//if(!create_opcode_block()) goto quit;
	
	if(!emulate()) goto quit;
	GrayOff();
	memcpy(LCD_MEM, save_screen, LCD_SIZE);
	if(opcode_block) { HeapFreePtr(opcode_block); opcode_block = NULL; }
	if(LoadDLL("gb68klib", GB_ID, DLL_MAJOR, DLL_MINOR) != DLL_OK) { gb_data->error = ERROR_DLL; goto quit; }
	if(gb_data->on_pressed) {
		if(!save_state(9)) goto quit;
	}
	if(!save_sram()) goto quit;
quit:
	UnloadDLL();
	cleanup();
	if(screen_buffer) { HeapFreePtr(screen_buffer); screen_buffer = NULL; }
	if(opcode_block) { HeapFreePtr(opcode_block); opcode_block = NULL; }
	
	memcpy(LCD_MEM, save_screen, LCD_SIZE);
	if(gb_data == NULL) {
		ST_helpMsg("ERROR - out of memory");
	} else {
		if(gb_data->error == ERROR_OUT_OF_MEM) ST_helpMsg("ERROR - out of memory");
		else if(gb_data->error == ERROR_ILLEGAL_INSTRUCTION) ST_helpMsg("ERROR - illegal instuction");
		else if(gb_data->error == ERROR_COMPRESS) ST_helpMsg("ERROR - compression failed");
		else if(gb_data->error == ERROR_FILE_SYS) ST_helpMsg("ERROR - file system failure");
		else if(gb_data->error == ERROR_MISSING_FILE) ST_helpMsg("ERROR - missing ROM file");
		else if(gb_data->error == ERROR_DLL) ST_helpMsg("ERROR - DLL failure");
		else if(gb_data->error == ERROR_UNSUPPORTED) ST_helpMsg("ERROR - ROM not supported");
		else if(gb_data->error == ERROR_ARCHIVE) ST_helpMsg("ERROR - archive failure");
		else if(gb_data->error == ERROR_NONE) ST_helpMsg(title);
		else ST_helpMsg("ERROR - unknown error code");
		if(gb_data->ram) HeapFreePtr(gb_data->ram);
		if(gb_data->bank_table) HeapFreePtr(gb_data->bank_table);
		if(gb_data->rtc_block) HeapFreePtr(gb_data->rtc_block);
		HeapFreePtr(gb_data);
	}
}

void _main()
{
	asm("movem.l %d0-%d7/%a0-%a6, -(%sp)");
	start();
	asm("movem.l (%sp)+, %d0-%d7/%a0-%a6");
}
