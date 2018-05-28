// Header File
// Created 7/29/2004; 10:53:49 PM

#ifndef __GB68K__
#define __GB68K__

#define GB_MAJOR 0
#define GB_MINOR 5
#define GB_REVISION 6
#define GB_ID 0x72458763 //just a random number...
#define ROM_FILE_VERSION 0
#define SAVE_FILE_VERSION 2
#define STATE_FILE_VERSION 0
#define SETTINGS_FILE_VERSION 0
#define DLL_MAJOR 8 //0.5.6
#define DLL_MINOR 0

//this will return the value of 1 sec timer on AMS 2.07 and above
#define Timer_Start _rom_call(unsigned long,(void),5F8)

//#define GB_DEBUG

#define OPCODE_SIZE 70
#define PREFIX_OPCODE_SIZE 60
#define IO_WRITE_SIZE 60
#define MEM_WRITE_SIZE 60

enum MBC_TYPES {
	BAD_MBC, //(or not supported)
	NO_MBC,
	MBC1,
	MBC2,
	MBC3,
	MBC5,
};

enum RTC_REGS {
	RTC_S,
	RTC_M,
	RTC_H,
	RTC_DL,
	RTC_DH,
	RTC_NUMBER,
};

typedef struct _OPCODE_HEADER {
	unsigned char opcode_name;
	unsigned char dst_name;
	unsigned char src_name;
} OPCODE_HEADER;

typedef struct _MEM_PTR {
	unsigned short move;
	unsigned char *ptr;										//start of memory block
	unsigned char filler[250];						//allign on 256 bytes
} MEM_PTR;

typedef struct _BANK_HEADER {
	unsigned char first_loc;							//which file contains first half of bank
	unsigned char first_offset;						//offset into first file
	unsigned char second_loc;							//which file contains second half of bank
	unsigned char second_offset;					//offset into second file
} BANK_HEADER;

//(almost) all of the global data is in this structure, which is allocated dynamically
typedef struct _GB_DATA {
	//start off with gb cpu state
	unsigned long pc_base;								//index of current pc segment
	unsigned long sp_base;								//index of current sp segment
	unsigned char frame_counter;					//used for frame skipping
	unsigned char cpu_halt;								//flag to indicate cpu is halted
	unsigned short next_event;						//function pointer to next cyclic event
	short error;													//contains reason for error
	//the reg variables are cached here when the emulation engine is paused, and C code is running
	unsigned short pc;										
	unsigned short sp;
	unsigned short event_counter;
	void *mem_base;
	unsigned char a;
	unsigned char f;
	unsigned short hl;
	unsigned short bc;
	unsigned short de;
	//misc data
	void *light_plane;
	void *dark_plane;
	unsigned char *ram;										//ptr to ram
	unsigned char *rom_ptr[43];						//ptrs to each file of rom
	unsigned char *bg_tilemap;						//pointer set by lcdc
	unsigned char *window_tilemap;				//pointer set by lcdc
	unsigned char *bg_window_gfx;					//pointer to cached palettized gfx
	unsigned char *bg_window_tiledata;		//pointer to raw gfx in vram
	unsigned char *bg_window_update_pal;	//pointer set by lcdc
	BANK_HEADER *bank_table;							//used to switch rom banks
	unsigned char *rtc_block;							//256 byte buffer where latched rtc data is stored
	char *rom_name;												//name of rom file
	unsigned char bg_palette[8];					//stores bg palette, 2 bytes/color
	unsigned char ob0_palette[6];					//object palette 0
	unsigned char ob1_palette[6];					//object palette 1
	unsigned char pal_update[384];				//bitmask for each tile and each palette
	unsigned char bg_gfx[384 * 16];				//tiles with bg palette applied
	unsigned char obp0_gfx[256 * 16];			//tiles with obj0 palette applied
	unsigned char obp1_gfx[256 * 16];			//tiles with obj1 palette applied
	unsigned char mask_gfx[384 * 8];			//tile masks
	unsigned char ime;										//interrupt enable
	unsigned char halt_ly_check;					//break out of 0, 2, 3 loop when LY reaches this value
	unsigned char rtc_enable;							//is an rtc register set in the ram bank?
	unsigned char rtc_latch;							//used to latch rtc registers into memory
	unsigned char rtc_current[RTC_NUMBER];//current_rtc regs
	unsigned char rtc_latched[RTC_NUMBER];//latched rtc regs
	unsigned char on_pressed;							//flag set when the ON key is pressed
	unsigned char quit;										//flag set when it's time to quit
	unsigned char breakpoint;							//flag set when we hit breakpoint
	unsigned char cart_type;							//type of loaded cart
	unsigned char current_rom;						//which bank are we in
	unsigned char rom_banks;							//how much rom
	unsigned char current_ram;						//which bank are we in
	unsigned char ram_banks;							//how many ram banks
	unsigned char ram_blocks;							//how many 256kb blocks per bank? (-1, for dbf)
	unsigned char ram_enable;							//is ram enabled?
	unsigned char mbc_mode;								//for mcb1, specifies rom/ram banking
	unsigned char y_offset;								//scroll offset
	unsigned char break_counter;					//counts number of times breakpoint is reached
	unsigned char timer_counter;					//to slow down timer update
	unsigned char timer_speed;
	unsigned char timer_shift;
	//these are all options that can be changed from the menu
	unsigned char frame_skip;							//how often should we draw the screen?
	unsigned char show_fps;								//what it says
	unsigned char archive_sram;						//should generated files be auto-archived?
	unsigned char enable_timer;						//enable the timer? (NOT the rtc on mbc3)
	unsigned char enable_serial;					//should we TRY to properly emulate the serial port?
	unsigned char sram_savestate;					//include sram with save states?
	//these are flags that describe the current calculator platform
	char vti;															//are we on VTI
	char ams207;													//true if the ams > 2.07 (and the clock is availiable)
	char hw_version;											//whats the HW version?
	char calc_type;												//89/92/V200
	char int3_enabled;										//was ai3 enabled?
	char ints_redirected;									//have the ints been redirected yet?
	INT_HANDLER old_int[AUTO_INT_COUNT];	//save the default ints
} GB_DATA;

register GB_DATA *gb_data asm("%a5");

extern unsigned char function_base[];
extern unsigned short io_write_offset;
extern unsigned short bg_gfx_write_offsets[];
extern unsigned short write_disable_offset;
extern unsigned short write_default_offset;
extern unsigned short mbc1_offsets[8];
extern unsigned short mbc2_offsets[8];
extern unsigned short mbc3_offsets[8];
extern unsigned short mbc5_offsets[8];
extern unsigned short no_mbc_offsets[8];
extern short jump_table[256];
extern short jump_table2[256];
extern short io_write_table[256];
extern short P1_89;
extern short P1_92;
extern char size_table[512];
extern char io_write_size_table[256];
extern char bg_gfx_write_size;
extern char io_write_size;
extern char write_default_size;
extern char mbc1_size_table[8];
extern char mbc2_size_table[8];
extern char mbc3_size_table[8];
extern char mbc5_size_table[8];
extern char no_mbc_size_table[8];
extern unsigned char cycles_table[512];
extern unsigned char event_table[256];
extern unsigned char next_instruction[];
extern unsigned char next_instruction1[];
extern unsigned char next_instruction2[];
extern unsigned char next_instruction_size;
extern unsigned char next_instruction1_size;
extern unsigned char next_instruction2_size;

#define WRITE16_OPCODE 0xfd
#define WRITE16_STACK_OPCODE 0xfc
#define WRITE16_RETURN_OPCODE 0xf4

#define LY 0x44
#define LYC 0x45
#define IE 0xff
#define IF 0x0f

extern unsigned char *opcode_block;
extern char mode2_func[];
extern void *screen_buffer;
void draw_screen();
void apply_patch89();
void apply_patch92();
void reset_timer();
void reset_stat();
void reset_banks();
void reset_LCDC();
void reset_palette();

#endif