// Header File
// Created 4/5/2005; 2:09:22 PM

#ifndef __GBSRAM__
#define __GBSRAM__

#include "gb68k.h"
#include "gbdll.h"

//included with save file for each rom
typedef struct _SAVE_HEADER {
	unsigned short file_size;
	unsigned short version;
	unsigned char frame_skip;
	unsigned char enable_timer;
	unsigned char y_offset;
	unsigned char sram_savestate;
	unsigned short rle_size;
	unsigned char enable_serial;
	unsigned char rtc[RTC_NUMBER];
	unsigned long seconds;
} SAVE_HEADER;

//contains global emulator settings
typedef struct _GB_SETTINGS {
	unsigned short file_size;
	unsigned short version;
	unsigned char show_fps;
	unsigned char archive_sram;
} GB_SETTINGS;

//header for save state files
typedef struct _STATE_HEADER {
	unsigned short file_size;
	unsigned short version;
	unsigned short mem_pack_size;
	unsigned short sram_pack_size;
	unsigned short hl;
	unsigned short bc;
	unsigned short de;
	unsigned short pc;
	unsigned short sp;
	unsigned short next_event;
	short event_counter;
	unsigned char a;
	unsigned char f;
	unsigned char cpu_halt;
	unsigned char ime;
	unsigned char ram_enable;	
	unsigned char current_rom;
	unsigned char current_ram;
	unsigned char rtc_enable;
	unsigned char rtc_latch;
	unsigned char rtc_current[RTC_NUMBER];
	unsigned char rtc_latched[RTC_NUMBER];
} STATE_HEADER;

#define MEMREQ_LZFO_PACK ((unsigned int)((1<<13)*4U+256))
#define MEMREQ_LZFO_UNPACK(P_SIZE) ((unsigned int)((P_SIZE<16384?P_SIZE:16384)*2U))
#define LZFO_MAX_OUTSIZE(IN_SIZE)       (IN_SIZE+6)

#ifdef __IN_DLL__
char save_sram();
char load_sram();
char save_state(short s);
char load_state(short s);
void *file_pointer(const char *name);
#else
#define save_sram _DLL_call(char, (), DLL_SAVE_SRAM)
#define load_sram _DLL_call(char, (), DLL_LOAD_SRAM)
#define save_state _DLL_call(char, (short), DLL_SAVE_STATE)
#define load_state _DLL_call(char, (short), DLL_LOAD_STATE)
#define file_pointer _DLL_call(void *, (const char *), DLL_FILE_POINTER)
#endif

#endif