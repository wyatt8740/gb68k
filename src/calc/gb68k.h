// Header File
// Created 7/29/2004; 10:53:49 PM

#ifndef __GB68K__
#define __GB68K__

#define GB_MAJOR 0
#define GB_MINOR 4
#define GB_REVISION 0
#define GB_ID 0x72458763 //just a random number...
#define ROM_FILE_VERSION 0
#define SAVE_FILE_VERSION 1
#define SETTINGS_FILE_VERSION 0
#define DLL_MAJOR 2
#define DLL_MINOR 0

//#define GB_DEBUG

enum MBC_TYPES {
	BAD_MBC, //(or not supported)
	NO_MBC,
	MBC1,
	MBC2,
	MBC3,
	MBC5,
};

typedef struct _OPCODE_HEADER {
	unsigned char opcode_name;
	unsigned char dst_name;
	unsigned char src_name;
} OPCODE_HEADER;

typedef struct _MEM_PTR {
	unsigned char *ptr;										//start of memory block
	unsigned short write_func;						//specail action for reading
	unsigned short filler;								//allign on 8 bytes
} MEM_PTR;

typedef struct _BANK_HEADER {
	unsigned char first_loc;							//which file contains first half of bank
	unsigned char first_offset;						//offset into first file
	unsigned char second_loc;							//which file contains second half of bank
	unsigned char second_offset;					//offset into second file
} BANK_HEADER;

//included with save file for each rom
typedef struct _SAVE_HEADER {
	unsigned short file_size;
	unsigned short version;
	unsigned char frame_skip;
	unsigned char enable_timer;
	unsigned char y_offset;
	unsigned char UNUSED;
	unsigned short rle_size;
} SAVE_HEADER;

//contains global emulator settings
typedef struct _GB_SETTINGS {
	unsigned short file_size;
	unsigned short version;
	unsigned char show_fps;
	unsigned char archive_sram;
} GB_SETTINGS;

typedef struct _GB_DATA {
	unsigned short hl;										//register
	unsigned short bc;										//register
	unsigned short de;										//register
	unsigned short last_src;							//used to get half carry
	unsigned short last_dst;							//also for half carry
	unsigned short pc_base;								//index of current pc segment
	unsigned short sp_base;								//index of current sp segment
	unsigned char frame_counter;					//used for frame skipping
	unsigned char cpu_halt;								//flag to indicate cpu is halted
	unsigned char *next_event;						//function pointer to next cyclic event
	unsigned char *save_event_ei;					//place for ei to save event
	unsigned char *save_event_mem16;			//place for 16bit mem write to save event
	short save_count_ei;									//place for ei to save counter
	short save_count_mem16;								//place for 16bit mem write to save counter
	short error;													//contains reason for error
	MEM_PTR mem_ptr[256];									//pointers to each segment of memory
	unsigned char *ram;										//ptr to ram
	unsigned char *rom_ptr[43];						//ptrs to each file of rom
	unsigned char *bg_tilemap;						//pointer set by lcdc
	unsigned char *window_tilemap;				//pointer set by lcdc
	unsigned char *bg_window_gfx;					//pointer to cached palettized gfx
	unsigned char *bg_window_tiledata;		//pointer to raw gfx in vram
	unsigned char *bg_window_update_pal;	//pointer set by lcdc
	BANK_HEADER *bank_table;							//used to switch rom banks
	unsigned char bg_palette[8];					//stores bg palette, 2 bytes/color
	unsigned char ob0_palette[6];					//object palette 0
	unsigned char ob1_palette[6];					//object palette 1
	unsigned char pal_update[384];				//bitmask for each tile and each palette
	unsigned char bg_gfx[384 * 16];				//tiles with bg palette applied
	unsigned char obp0_gfx[256 * 16];			//tiles with obj0 palette applied
	unsigned char obp1_gfx[256 * 16];			//tiles with obj1 palette applied
	unsigned char mask_gfx[384 * 8];			//tile masks
	unsigned char quit;										//flag set when it's time to quit
	unsigned char breakpoint;							//flag set when we hit breakpoint
	unsigned char last_flag;							//used to get half carry
	unsigned char cart_type;							//type of loaded cart
	unsigned char current_rom;						//which bank are we in
	unsigned char rom_banks;							//how much rom
	unsigned char current_ram;						//which bank are we in
	unsigned char ram_banks;							//how much ram
	unsigned char mbc_mode;								//for mcb1, specifies rom/ram banking
	unsigned char y_offset;								//scroll offset
	unsigned char break_counter;					//counts number of times breakpoint is reached
	unsigned char timer_counter;					//to slow down timer update
	unsigned char frame_skip;
	unsigned char show_fps;
	unsigned char archive_sram;
	unsigned char enable_timer;
	char vti;															//are we on VTI
	char hw_version;											//whats the HW version?
	char calc_type;												//89/92/V200
	char int3_enabled;										//was ai3 enabled?
	char ints_redirected;									//have the ints been redirected yet?
	INT_HANDLER old_int[AUTO_INT_COUNT];	//save the default ints
} GB_DATA;

#ifndef __IN_DLL__
register unsigned long gb_A asm("%d5");
register unsigned long gb_F0 asm("%d6");
register unsigned long gb_F1 asm("%d7");
register unsigned char *gb_pc asm("%a4");
register unsigned char *gb_sp asm("%a2");
register unsigned long gb_cycles asm("%d4");

register void *mem_base asm("%a3");
register unsigned long temp0 asm("%d3");
#endif

register GB_DATA *gb_data asm("%a5");

extern unsigned short function_base;
extern unsigned short io_write_offset;
extern unsigned short bg_gfx_write_offsets[];
extern unsigned short write_disable_offset;
extern unsigned short mbc1_offsets[];
extern unsigned short mbc2_offsets[];
extern unsigned short mbc3_offsets[];
extern unsigned short mbc5_offsets[];
extern unsigned short no_mbc_offsets[];
extern short jump_table[256];
extern short jump_table2[256];
extern short io_write_table[256];
extern short P1_89;
extern short P1_92;
extern unsigned short size_table[512];

#define WRITE16_OPCODE 0xfd
#define WRITE16_STACK_OPCODE 0xfc
#define WRITE16_RETURN_OPCODE 0xf4

#define LY 0x44
#define LYC 0x45
#define IE 0xff
#define IF 0x0f

extern unsigned char *opcode_block;
extern char cyclic_events[];
extern void *screen_buffer;
void draw_screen();
void apply_patch89();
void apply_patch92();
void reset_timer();

#endif