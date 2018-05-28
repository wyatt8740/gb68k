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

void init_mem()
{
	unsigned short *func;
	unsigned char *ram;
	short i, j, index;

	mem_base = &function_base;

	//set rom bank0/bank1
	if(gb_data->cart_type == MBC1) func = mbc1_offsets;
	else if(gb_data->cart_type == MBC2) func = mbc2_offsets;
	else if(gb_data->cart_type == MBC3) func = mbc3_offsets;
	else if(gb_data->cart_type == MBC5) func = mbc5_offsets;
	else func = no_mbc_offsets;

	for(index = 0, j = 0; j < 8; j++) {
		for(i = 0 ; i < 16 ; i++, index++) {
			gb_data->mem_ptr[index].ptr = gb_data->rom_ptr[0] + index * 256;
			gb_data->mem_ptr[index].write_func = func[j];
		}
	}

	ram = gb_data->ram;
	//set vido ram
	for(i = 0 ; i < 24 ; i++) {
		gb_data->mem_ptr[i + 128].ptr = ram;
		gb_data->mem_ptr[i + 128].write_func = bg_gfx_write_offsets[i];
		ram += 256;
	}
	for(; i < 32 ; i++) {
		gb_data->mem_ptr[i + 128].ptr = ram;
		gb_data->mem_ptr[i + 128].write_func = 0;
		ram += 256;
	}
	//set internal ram/echo
	for(i = 0 ; i < 30 ; i++) {
		gb_data->mem_ptr[i + 192].ptr = ram;
		gb_data->mem_ptr[i + 192].write_func = 0;
		gb_data->mem_ptr[i + 224].ptr = ram;
		gb_data->mem_ptr[i + 224].write_func = 0;
		ram += 256;
	}
	//finish internal, non-echoed ram
	for(; i < 32 ; i++) {
		gb_data->mem_ptr[i + 192].ptr = ram;
		gb_data->mem_ptr[i + 192].write_func = 0;
		ram += 256;
	}
	//OAM
	gb_data->mem_ptr[254].ptr = ram;
	gb_data->mem_ptr[254].write_func = 0;
	ram += 256;
	//io ports
	gb_data->mem_ptr[255].ptr = ram;
	gb_data->mem_ptr[255].write_func = io_write_offset;
	ram += 256;

	//set ram bank
	if(gb_data->ram_banks == 0) {
		//mbc2 built in memory
		if(gb_data->cart_type == MBC2) {
			gb_data->mem_ptr[160].ptr = ram;
			gb_data->mem_ptr[160].write_func = 0;
			gb_data->mem_ptr[161].ptr = ram + 256;
			gb_data->mem_ptr[161].write_func = 0;
			i = 2;
		} else i = 0;

		for(; i < 32 ; i++) {
			gb_data->mem_ptr[i + 160].ptr = ram; //point to something (for reading)
			gb_data->mem_ptr[i + 160].write_func = write_disable_offset;
		}
	} else {
		for(i = 0 ; i < 32 ; i++) {
			gb_data->mem_ptr[i + 160].ptr = ram;
			gb_data->mem_ptr[i + 160].write_func = 0;
			ram += 256;
		}
	}
}

#ifdef GB_DEBUG
char *get_immd(char *s, unsigned char *addr, unsigned char name, short *len)
{
	if(name == OP_IMMD8) {
		sprintf(s, "%02X", *(addr + 1));
		*len = *len + 1;
	} else if(name == OP_IMMD16) {
		sprintf(s, "%02X%02X", *(addr + 2), *(addr + 1));
		*len = *len + 2;
	} else if(name == OP_IMMD_INDIR) {
		sprintf(s, "(%02X%02X)", *(addr + 2), *(addr + 1));
		*len = *len + 2;
	} else if(name == OP_FF00_IMMD) {
		sprintf(s, "(FF00+%02X)", *(addr + 1));
		*len = *len + 1;
	} else {
		sprintf(s, "SP+%02X", *(addr + 1));
		*len = *len + 1;
	}

	return s;
}

short display_instruction(short x, short y, unsigned char *addr)
{
	OPCODE_HEADER *table;
	unsigned char opcode = *addr;
	unsigned short relative_addr;
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

	if(opcode == 0xCB) {
		addr++;
		opcode = *addr;
		table = suffix_table;
		len++;
	} else table = opcode_table;

	if(table[opcode].dst_name < OP_IMMD8) dst = (char *)operand_names[table[opcode].dst_name];
	else dst = get_immd(dst_name, addr, table[opcode].dst_name, &len);

	if(table[opcode].src_name < OP_IMMD8) src = (char *)operand_names[table[opcode].src_name];
	else src = get_immd(src_name, addr, table[opcode].src_name, &len);

	if(table[opcode].src_name == OP_NONE && table[opcode].dst_name == OP_NONE) format = 2;
	else if(table[opcode].src_name == OP_NONE) format = 1;
	else format = 0;

	relative_addr = (unsigned long)addr -
		(unsigned long)gb_data->mem_ptr[gb_data->pc_base >> 3].ptr +
		(gb_data->pc_base << 5);

	printf_xy(x, y, opcode_string[format], relative_addr, opcode,
			opcode_names[table[opcode].opcode_name], dst, src);

	return len;
}

void disassemble(short x, short y, short len, unsigned char *addr)
{
	short i;

	for(i = 0 ; i < len ; i++) {
		addr += display_instruction(x, y, addr);
		y += 6;
	}
}

void show_memory(short x, short y, short len, unsigned short addr)
{
	unsigned char *block;
	short offset;

	while(len) {
		offset = addr & 0x00ff;
		block = gb_data->mem_ptr[(addr & 0xff00) >> 8].ptr;

		printf_xy(x, y, "%02x", block[offset]);
		len--;
		addr++;
		x += 14;
		if(x > 146) { x = 0; y += 8; }
	}
}

void write_memory(unsigned char byte, unsigned short addr)
{
	unsigned char *block;
	short offset;

	offset = addr & 0x00ff;
	block = gb_data->mem_ptr[(addr & 0xff00) >> 8].ptr;

	clrscr();
	printf_xy(0, 0, "%lx, %x", (unsigned long)block, offset);
	ngetchx();

	block[offset] = byte;
}

void display_flags(short x, short y)
{
	unsigned char C, Z, N, H = 0;

	C = !!(gb_F0 & 1);
	Z = !!(gb_F1 & 4);
	N = !!(gb_F1 & 32);
	/*if(gb_F1 & 64) { //last was 16 bit add
		H = !!(((*(short *)(gb_data->last_dst) + *(short *)(gb_data->last_src)) & 4096) !=
			((*(short *)(gb_data + 8) ^ *(short *)(gb_data + 10)) & 4096));
	} else if(N) { //last was 8 bit add
		H = !!(((gb_data->last_dst - gb_data->last_src) & 16) !=
			((gb_data->last_src ^ gb_data->last_dst) & 16));
	} else { //last was 8 bit sub
		H = !!(((gb_data->last_src + gb_data->last_dst) & 16) !=
			((gb_data->last_src ^ gb_data->last_dst) & 16));
	}*/

	printf_xy(x, y, "F: (ZNHC) %d%d%d%d", Z, N, H, C);
}
#endif

void emulate_frame();
void emulate_step();

void show_bank()
{
	clrscr();
	printf_xy(0, 0, "bank: %d", gb_data->current_rom);
	pause();
}

void show_d3(unsigned short d3 asm("%d3"))
{
	//asm("movem.l %d0-%d7/%a0-%a6, -(%a7)");
	clrscr();
	printf("d3: %d", d3);
	pause();
	//clrscr();
	//asm("movem.l (%a7)+, %d0-%d7/%a0-%a6");
}

short create_opcode_block()
{
	short i;
	
	opcode_block = HeapAllocPtr(0xfff0 - 2);
	if(opcode_block == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
	for(i = 0; i < 127; i++) {
		memcpy(opcode_block + 0x8000 + 256 * i, mem_base + jump_table[i], 180);
		memcpy(opcode_block + 0x8000 + 256 * i + 180, mem_base + jump_table2[i], 76);
	}
	memcpy(opcode_block + 0x8000 + 256 * i, mem_base + jump_table[i], 180);
	memcpy(opcode_block + 0x8000 + 256 * i + 180, mem_base + jump_table2[i], 50);

	for(i = 0; i < 128; i++) {
		memcpy(opcode_block + 256 * i, mem_base + jump_table[i + 128], 180);
		memcpy(opcode_block + 256 * i + 180, mem_base + jump_table2[i + 128], 76);
	}
	
	return TRUE;
}

void emulate()
{
	short i, k;
	unsigned short rel_sp;

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
		reset_timer();
		emulate_frame();
		if(gb_data->quit) {
			while(1) {
				cleanup();
				if(opcode_block) { HeapFreePtr(opcode_block); opcode_block = NULL; }
				if(LoadDLL("gb68klib", GB_ID, DLL_MAJOR, DLL_MINOR) != DLL_OK) { gb_data->error = ERROR_DLL; return; }
				i = esc_menu();
				UnloadDLL();
				if(i == 1 || i == -1) return;
				if(!init()) return;
				if(!create_opcode_block()) return;
				reset_timer();
				emulate_step();
			}
		}
		
		#ifdef GB_DEBUG
		while(1) {
			rel_sp = (unsigned long)gb_sp -
				(unsigned long)gb_data->mem_ptr[gb_data->sp_base >> 3].ptr +
				(gb_data->sp_base << 5);
			FontSetSys(F_4x6);
			clrscr();
			disassemble(0, 0, 5, gb_pc);
			printf_xy(0, 30, "A: %02x", (unsigned char)gb_A);
			display_flags(30, 40);
			printf_xy(0, 36, "BC: %04x", gb_data->bc);
			printf_xy(0, 42, "DE: %04x", gb_data->de);
			printf_xy(0, 48, "HL: %04x", gb_data->hl);
			printf_xy(0, 54, "SP: %04x", rel_sp);
			printf_xy(0, 60, "LY: %02x, IME:%d", gb_data->ram[0x4144], !!(gb_F1 & 0x80000000));
			printf_xy(0, 66, "ROM %d, Counter: %d", gb_data->current_rom, (short)gb_cycles);
			printf_xy(0, 72, "LCDC: %02X, STAT: %02X, DIV: %02X",
				gb_data->ram[0x4140], gb_data->ram[0x4141], gb_data->ram[0x4104]);
			printf_xy(0, 78, "IE: %02X, IF: %02X", gb_data->ram[0x410f], gb_data->ram[0x41ff]);
			printf_xy(0, 84, "HALT: %d", gb_data->cpu_halt);
			//show_memory(0, 78, 1, gb_data->hl);
			FontSetSys(F_6x8);
			k = get_key();
			if(k == SEL_KEY) i = 1;
			else if(k == SHIFT_KEY) i = 10;
			else if(k == DMND_KEY) i = 100;
			else if(k == DOWN_KEY) i = 1000;
			else if(k == UP_KEY) { gb_data->breakpoint = 0; i = 1; }
			else i = 1;
			while(i) {
				emulate_step();
				i--;
			}
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
	unsigned short mem_needed;
	char save_screen[LCD_SIZE];
	char rom_name[9];
	short i;
	
	//asm("movem.l %d0-%d7/%a0-%a6, -(%sp)");

	/*unsigned short max = 0;

	for(i = 0; i < 256; i++) {
		if(size_table[i] > size_table[max]) max = i;
	}
	clrscr();
	printf("%02X - %d", max, size_table[max]);
	ngetchx();

	max = 0;
	for(i = 256; i < 512; i++) {
		if(size_table[i] > size_table[max]) max = i;
	}
	clrscr();
	printf("%02X - %d", max - 256, size_table[max]);
	ngetchx();*/

	screen_buffer = NULL;
	opcode_block = NULL;
	gb_data->error = ERROR_NONE;

	memcpy(save_screen, LCD_MEM, LCD_SIZE);
	gb_data = HeapAllocPtr(sizeof(GB_DATA));
	if(gb_data == NULL) goto quit;
	memset(gb_data, 0, sizeof(GB_DATA));
	
	gb_data->vti = IsVTI();
	gb_data->hw_version = HW_VERSION;
	gb_data->calc_type = CALCULATOR;
	
	if(LoadDLL("gb68klib", GB_ID, DLL_MAJOR, DLL_MINOR) != DLL_OK) { gb_data->error = ERROR_DLL; goto quit; }
	select_rom(rom_name);
	if(rom_name[0] == 0) goto quit;
	if(!init_rom(rom_name)) goto quit;

	//8k video ram, 8k internal ram, 512 bytes of extra stuff
	mem_needed = 0x2000 + 0x2000 + 0x200;
	if(gb_data->ram_banks == 4) mem_needed += 0x8000; //32k cart ram
	else if(gb_data->ram_banks != 0) mem_needed += 0x2000; //8k cart ram
	else if(gb_data->cart_type == MBC2)
		mem_needed += 512; //mbc2 ram

	gb_data->ram = HeapAllocPtr(mem_needed);
	if(gb_data->ram == NULL) { gb_data->error = ERROR_OUT_OF_MEM; goto quit; }
	memset(gb_data->ram, 0x00, mem_needed);
	init_mem();
	if(!load_state(rom_name)) goto quit;

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
	if(!init()) { gb_data->error = ERROR_OUT_OF_MEM; goto quit; }
	
	if(gb_data->calc_type == 0) {
		screen_buffer = HeapAllocPtr(24*132*2);
		apply_patch89();
	} else {
		screen_buffer = HeapAllocPtr(24*160*2);
		apply_patch92();
	}
	if(screen_buffer == NULL) { gb_data->error = ERROR_OUT_OF_MEM; goto quit; }
	
	gb_A = 0x01;
	gb_F0 = 0;
	gb_F1 = 0;
	gb_data->cpu_halt = 0;
	gb_data->pc_base = 0;
	gb_pc = gb_data->rom_ptr[0] + 0x100;
	gb_data->hl = 0x014D;
	gb_data->bc = 0x0013;
	gb_data->de = 0x00d8;
	gb_sp = gb_data->ram + 0x41FE;
	gb_data->sp_base = 0xFF * 8; //2040

	//gb_data->hl_base = (unsigned long)gb_data->mem_ptr[gb_data->hl >> 8].ptr;
	//gb_data->hl_func = gb_data->mem_ptr[gb_data->hl >> 8].write_func;

	//gb_data->sp_base = (unsigned long)gb_data->mem_ptr[gb_data->sp >> 8].ptr;
	//gb_data->sp_func = gb_data->mem_ptr[gb_data->sp >> 8].write_func;
	
	UnloadDLL();
	
	if(!create_opcode_block()) goto quit;
	
	emulate();
	GrayOff();
	memcpy(LCD_MEM, save_screen, LCD_SIZE);
	if(opcode_block) { HeapFreePtr(opcode_block); opcode_block = NULL; }
	if(LoadDLL("gb68klib", GB_ID, DLL_MAJOR, DLL_MINOR) != DLL_OK) { gb_data->error = ERROR_DLL; goto quit; }
	if(!save_state(rom_name)) goto quit;

quit:
	UnloadDLL();
	cleanup();
	if(screen_buffer) { HeapFreePtr(screen_buffer); screen_buffer = NULL; }
	if(opcode_block) { HeapFreePtr(opcode_block); opcode_block = NULL; }
	
	memcpy(LCD_MEM, save_screen, LCD_SIZE);
	if(gb_data == NULL) ST_helpMsg("ERROR - out of memory");
	else {
		if(gb_data->error == ERROR_OUT_OF_MEM) ST_helpMsg("ERROR - out of memory");
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
		HeapFreePtr(gb_data);
	}
	
	//asm("movem.l (%sp)+, %d0-%d7/%a0-%a6");
}

void _main()
{
	asm("movem.l %d0-%d7/%a0-%a6, -(%sp)");
	start();
	asm("movem.l (%sp)+, %d0-%d7/%a0-%a6");
}
