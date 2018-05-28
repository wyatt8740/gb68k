// C Source File
// Created 3/31/2005; 5:13:07 PM

#define __IN_DLL__
#include <tigcclib.h>
#include "gbsram.h"
#include "lzfo1.h"
#include "gb68k.h"
#include "gbsetup.h"
#include "gbinit.h"

const unsigned char battery_table[] = {
	0,	//00
	0,	//01
	0,	//02
	1,	//03
	0,	//04
	0,	//05
	1,	//06
	0,	//07
	0,	//08
	1,	//09
	0,	//0A
	0,	//0B
	0,	//0C
	1,	//0D
	0,	//0E
	1,	//0F
	1,	//10
	0,	//11
	0,	//12
	1,	//13
	0,	//14
	0,	//15
	0,	//16
	1,	//17
	0,	//18
	0,	//19
	0,	//1A
	1,	//1B
	0,	//1C
	0,	//1D
	1,	//1E
};
		

SYM_ENTRY *file_entry(const char *name)
{
	SYM_ENTRY *entry = NULL;
	
	FolderOp(NULL, FOP_LOCK | FOP_ALL_FOLDERS);
	entry = SymFindFirst(NULL, FO_RECURSE | FO_SKIP_TEMPS);
	while(entry) {
		if(!entry->flags.bits.folder && strncmp(entry->name, name, 8) == 0) break;
		else entry = SymFindNext();
	}
	FolderOp(NULL, FOP_UNLOCK | FOP_ALL_FOLDERS);
	return entry;
}

void *file_pointer(const char *name)
{
	SYM_ENTRY *entry = file_entry(name);
	if(entry == NULL) return NULL;
	else return HeapDeref(entry->handle) + 2;
}

void add_tag(char *data, const char *tag)
{
	*data++ = 0;
	while(*tag) *data++ = *tag++;
	*data++ = 0;
	*data = OTH_TAG;
}

unsigned short rle_compress(unsigned char *src, unsigned char *dst, unsigned short size)
{
	unsigned short rle_size = 0;
	unsigned short i = 0;
	unsigned char run_length;
	unsigned char run_char;
	const unsigned char flag = 255;

	while(i < size){
		run_length = 1;
		run_char = *src;

		while(*(++src) == run_char && run_length < 255){
			run_length++;
			if(i + run_length >= size) break;
		}

		if(run_length == 2){
			run_length--;
			src--;
		}

		if(run_length > 1 || run_char == flag){
			*dst++ = flag;
			*dst++ = run_char;
			*dst++ = run_length;
			rle_size += 3;
		} else {
			*dst++ = run_char;
			rle_size++;
		}

		i += run_length;
	}

	return rle_size;
}

void rle_decompress(unsigned char *scr, unsigned char *dst, unsigned short size)
{
	unsigned short i = 0;
	short j;
	const unsigned char flag = 255;
	unsigned char run_char;
	unsigned char run_length;

	while(i < size){
		run_char = *scr++;

		if(run_char == flag){
			run_char = *scr++;
			run_length = *scr++;
		} else
			run_length = 1;

		for(j = 0 ; j < run_length ; j++)
			*dst++ = run_char;

		i += run_length;
	}
}

void advance_rtc(unsigned long sec)
{
top:	
	while(sec >= 60L * 60L * 24L) {
		gb_data->rtc_current[RTC_DL]++;
		if(gb_data->rtc_current[RTC_DL] == 0x00) {
			gb_data->rtc_current[RTC_DH]++;
			if(gb_data->rtc_current[RTC_DH] & 0x02) {
				gb_data->rtc_current[RTC_DH] &= ~0x02;
				gb_data->rtc_current[RTC_DH] |= 0x80;
			}
		}
		sec -= 60L * 60L * 24L;
	}
	while(sec >= 60 * 60) {
		gb_data->rtc_current[RTC_H]++;
		if(gb_data->rtc_current[RTC_H] == 24) {
			gb_data->rtc_current[RTC_H]= 0x00;
			sec += 60L * 60L * 24L;
			goto top;
		}
		sec -= 60 * 60;
	}
	while(sec >= 60) {
		gb_data->rtc_current[RTC_M]++;
		if(gb_data->rtc_current[RTC_M] == 60) {
			gb_data->rtc_current[RTC_M] = 0x00;
			sec += 60 * 60;
			goto top;
		}
		sec -= 60;
	}
	while(sec >= 1) {
		gb_data->rtc_current[RTC_S]++;
		if(gb_data->rtc_current[RTC_S] == 60) {
			gb_data->rtc_current[RTC_S] = 0x00;
			sec += 60;
			goto top;
		}
		sec--;
	}
}

unsigned short save_ram_size(char check_bat)
{
	if(!battery_table[gb_data->rom_ptr[0][0x147]] && check_bat) return 0; //no battery...don't save
	else if(gb_data->ram_banks == 4) return 0x8000; //32k cart ram
	else if(gb_data->ram_banks == 1) {
		if(gb_data->ram_blocks == 31) return 0x2000; //8k cart ram
		else if(gb_data->ram_blocks == 7) return 0x800; //2k cart ram
		else if(gb_data->ram_blocks == 1) return 0x200; //512k mbc2 memory
		else return 0; //??
	} else return 0;
}

char save_sram()
{
	SAVE_HEADER header;
	GB_SETTINGS settings;
	SYM_ENTRY *sym_ptr;
	char file_name[9];
	char *data;
	char *pack_data = NULL;
	char *pack_work;
	unsigned long size;
	unsigned long pack_size = 0;
	//short archived;
	char status;
	
	char *rle_data;
	unsigned short rle_size = 0;
	
	/*unsigned long temp_size = 5120;
	char *temp_data = malloc(temp_size);
	char *temp_pack = malloc(LZFO_MAX_OUTSIZE(temp_size));
	char *temp_work = malloc(MEMREQ_LZFO_PACK);
	unsigned long temp_psize;
	
	status = lzfo_pack(temp_data, temp_size, temp_pack, &temp_psize, temp_work);
	clrscr();
	printf("%d", status);
	pause();*/
	

	size = save_ram_size(1);
	
	if(size != 0) {
		ST_helpMsg("Compressing...");
		rle_data = HeapAllocPtr(size);
		if(rle_data == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
		rle_size = rle_compress(gb_data->ram + 0x4200, rle_data, size);
		free(gb_data->ram); gb_data->ram = NULL; //make some space
	
		pack_data = HeapAllocPtr(LZFO_MAX_OUTSIZE(rle_size));
		if(pack_data == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
		pack_work = HeapAllocPtr(MEMREQ_LZFO_PACK);
		if(pack_work == NULL) {
			gb_data->error = ERROR_OUT_OF_MEM; HeapFreePtr(rle_data); HeapFreePtr(pack_data); return FALSE;
		}
		OSSetSR(0x0700);
		status = lzfo_pack(rle_data, rle_size, pack_data, &pack_size, pack_work);
		OSSetSR(0x0000);
		HeapFreePtr(rle_data);
		HeapFreePtr(pack_work);
		if(status != LZFO_E_OK) { gb_data->error = ERROR_COMPRESS; HeapFreePtr(pack_data); return FALSE; }
	}

	sprintf(file_name, "%ssv", gb_data->rom_name);
	sym_ptr = SymFindPtr(SYMSTR(file_name), 0);
	if(sym_ptr != NULL && sym_ptr->flags.bits.archived == 1) {
		if(!EM_moveSymFromExtMem(SYMSTR(file_name), HS_NULL)) {
			gb_data->error = ERROR_ARCHIVE;
			if(pack_data) HeapFreePtr(pack_data);
			return FALSE;
		}
		//archived = TRUE;
	}// else archived = FALSE;
	sym_ptr = DerefSym(SymAdd(SYMSTR(file_name)));
	if(sym_ptr == NULL) { gb_data->error = ERROR_FILE_SYS; return FALSE; }

	sym_ptr->handle = HeapAlloc(pack_size + sizeof(SAVE_HEADER) + 7);
	if(sym_ptr->handle == H_NULL) {
		gb_data->error = ERROR_OUT_OF_MEM;
		if(pack_data) HeapFreePtr(pack_data);
		return FALSE;
	}
	data = HLock(sym_ptr->handle);
	header.file_size = (unsigned short)(pack_size + sizeof(SAVE_HEADER) + 5);
	header.version = SAVE_FILE_VERSION;
	header.y_offset = gb_data->y_offset;
	header.frame_skip = gb_data->frame_skip;
	header.enable_timer = gb_data->enable_timer;
	header.enable_serial = gb_data->enable_serial;
	header.sram_savestate = gb_data->sram_savestate;
	header.rle_size = rle_size;
	memcpy(header.rtc, gb_data->rtc_current, RTC_NUMBER);
	if(gb_data->ams207 && gb_data->hw_version >= 2) header.seconds = Timer_Start();
	memcpy(data, &header, sizeof(SAVE_HEADER));
	data += sizeof(SAVE_HEADER);
	if(pack_size != 0) {
		memcpy(data, pack_data, pack_size);
		data += pack_size;
	}
	add_tag(data, "GBSV");
	HeapUnlock(sym_ptr->handle);
	if(pack_data) HeapFreePtr(pack_data);
	
	if(gb_data->archive_sram) {
		if(!EM_moveSymToExtMem(SYMSTR(file_name), HS_NULL)) gb_data->error = ERROR_ARCHIVE;
	}
	
	//now create file to save global gb settings
	sym_ptr = SymFindPtr(SYMSTR("gb68ksv"), 0);
	if(sym_ptr != NULL && sym_ptr->flags.bits.archived == 1) {
		if(!EM_moveSymFromExtMem(SYMSTR("gb68ksv"), HS_NULL)) {
			gb_data->error = ERROR_ARCHIVE;
			return FALSE;
		}
	}
	sym_ptr = DerefSym(SymAdd(SYMSTR("gb68ksv")));
	if(sym_ptr == NULL) { gb_data->error = ERROR_FILE_SYS; return FALSE; }

	sym_ptr->handle = HeapAlloc(sizeof(GB_SETTINGS) + 7);
	if(sym_ptr->handle == H_NULL) {
		gb_data->error = ERROR_OUT_OF_MEM;
		return FALSE;
	}
	data = HLock(sym_ptr->handle);
	
	settings.file_size = (unsigned short)(sizeof(GB_SETTINGS) + 5);
	settings.version = SETTINGS_FILE_VERSION;
	settings.show_fps = gb_data->show_fps;
	settings.archive_sram = gb_data->archive_sram;
	memcpy(data, &settings, sizeof(GB_SETTINGS));
	data += sizeof(GB_SETTINGS);
	
	add_tag(data, "GBSV");
	HeapUnlock(sym_ptr->handle);
	
	if(gb_data->archive_sram) {
		if(!EM_moveSymToExtMem(SYMSTR("gb68ksv"), HS_NULL)) gb_data->error = ERROR_ARCHIVE;
	}
	
	return TRUE;
}

char load_sram()
{
	SAVE_HEADER *header;
	GB_SETTINGS *settings;
	char file_name[9];
	char *pack_data;
	unsigned short pack_size;
	unsigned short size;
	unsigned short mem_needed;
	unsigned short rle_size = 0;
	char *pack_work;	
	char *rle_data;
	
	//defaults
	gb_data->enable_timer = TRUE;
	if(gb_data->calc_type == 0) gb_data->y_offset = 36;
	else gb_data->y_offset = 8;
	gb_data->frame_skip = 2;
	gb_data->show_fps = TRUE;
	gb_data->archive_sram = FALSE;
	gb_data->sram_savestate = TRUE;
	gb_data->enable_serial = TRUE;
	
	pack_data = file_pointer("gb68ksv");
	if(pack_data != NULL) {
		settings = (GB_SETTINGS *)(pack_data - 2);
		if(settings->version == 0) {
			gb_data->show_fps = settings->show_fps;
			gb_data->archive_sram = settings->archive_sram;
		}
	}

	sprintf(file_name, "%ssv", gb_data->rom_name);
	pack_data = file_pointer(file_name);
	if(pack_data == NULL) {
		options_menu();
		pack_size = 0;
	} else {
		
		pack_data -= 2;
		header = (SAVE_HEADER *)pack_data;
	
		if(header->version == 0) {
			pack_size = header->file_size - 11;
			rle_size = *(unsigned short *)(pack_data + 4);
			pack_data += 6; //skip rle size, pack size, and version
		} else if(header->version <= 2) {
			pack_size = header->file_size - sizeof(SAVE_HEADER) - 5;
			rle_size = header->rle_size;
			gb_data->enable_timer = header->enable_timer;
			gb_data->y_offset = header->y_offset;
			gb_data->frame_skip = header->frame_skip;
			pack_data += sizeof(SAVE_HEADER) - 10; //10 bytes added from v1 -> v2
			
			if(header->version == 2) {
				gb_data->sram_savestate = header->sram_savestate;
				gb_data->enable_serial = header->enable_serial;
				memcpy(gb_data->rtc_current, header->rtc, 5);
				if(gb_data->ams207 && gb_data->hw_version >= 2) advance_rtc(Timer_Start() - header->seconds);
				pack_data += 10;
			}
		} else { //invalid file version
			pack_size = 0;
		}
		if(header->version != 2) options_menu();
	}
	
	mem_needed = 0x4200 + save_ram_size(0);
	gb_data->ram = HeapAllocPtr(mem_needed);
	if(gb_data->ram == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
	memset(gb_data->ram, 0x00, mem_needed);
	
	if(pack_size != 0) {
		pack_work = HeapAllocPtr(MEMREQ_LZFO_UNPACK(pack_size));
		if(pack_work == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
		lzfo_unpack(pack_data, pack_size, gb_data->ram + 0x4200, rle_size, pack_work);
		HeapFreePtr(pack_work);
		
		size = save_ram_size(1);
		rle_data = HeapAllocPtr(size);
		if(rle_data == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; } 
		memcpy(rle_data, gb_data->ram + 0x4200, size);
		rle_decompress(rle_data, gb_data->ram + 0x4200, size);
		HeapFreePtr(rle_data);
	}
	
	return TRUE;
}

char save_state(short s)
{
	STATE_HEADER state;
	SYM_ENTRY *sym_ptr;
	HANDLE f, pack_file;
	char file_name[9];
	char *pack_data;
	char *pack_work;
	unsigned short mem_needed;
	unsigned long pack_size;
	short status;
	
	//save cpu state
	state.version = STATE_FILE_VERSION;
	state.hl = gb_data->hl;
	state.bc = gb_data->bc;
	state.de = gb_data->de;
	state.a = gb_data->a;
	state.f = gb_data->f;
	state.pc = gb_data->pc;
	state.sp = gb_data->sp;
	memcpy(state.rtc_current, gb_data->rtc_current, RTC_NUMBER);
	memcpy(state.rtc_latched, gb_data->rtc_latched, RTC_NUMBER);
	state.next_event = gb_data->next_event;
	state.event_counter = gb_data->event_counter;
	state.cpu_halt = gb_data->cpu_halt;
	state.ime = gb_data->ime;
	state.current_rom = gb_data->current_rom;
	state.current_ram = gb_data->current_ram;
	state.ram_enable = gb_data->ram_enable;
	state.rtc_enable = gb_data->rtc_enable;
	state.rtc_latch = gb_data->rtc_latch;

	ST_helpMsg("Compressing...");
	
	//save ram
	f = HeapAlloc(sizeof(STATE_HEADER) + 0x4200);
	if(f == H_NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
	pack_work = HeapAllocPtr(MEMREQ_LZFO_PACK);
	if(pack_work == NULL) { HeapFree(f); gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
	pack_data = HLock(f) + sizeof(STATE_HEADER);
	OSSetSR(0x0700);
	status = lzfo_pack(gb_data->ram, 0x4200, pack_data, &pack_size, pack_work);
	OSSetSR(0x0000);
	if(status != LZFO_E_OK) { HeapFree(f); HeapFreePtr(pack_work); gb_data->error = ERROR_COMPRESS; return FALSE; }
	state.file_size = sizeof(STATE_HEADER) + pack_size + 5;
	state.mem_pack_size = pack_size;
	
	//add in sram if it exists, and the settings say it should be included
	mem_needed = save_ram_size(0);
	if(gb_data->sram_savestate && mem_needed != 0) {
		HeapUnlock(f);
		f = HeapRealloc(f, sizeof(STATE_HEADER) + pack_size + mem_needed);
		pack_data = HLock(f) + sizeof(STATE_HEADER) + pack_size;
		OSSetSR(0x0700);
		status = lzfo_pack(gb_data->ram + 0x4200, mem_needed, pack_data, &pack_size, pack_work);
		OSSetSR(0x0000);
		if(status != LZFO_E_OK) { HeapFree(f); HeapFreePtr(pack_work); gb_data->error = ERROR_COMPRESS; return FALSE; }
		state.file_size += pack_size;
		state.sram_pack_size = pack_size;
	} else {
		state.sram_pack_size = 0;
	}
	
	HeapUnlock(f);
	HeapFreePtr(pack_work);
	
	pack_file = HeapRealloc(f, state.file_size + 2);
	if(pack_file == H_NULL) { HeapFree(f); gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
	memcpy(HeapDeref(pack_file), &state, sizeof(STATE_HEADER));
	add_tag(HeapDeref(pack_file) + state.file_size - 5, "GBST");
	
	sprintf(file_name, "%ss%d", gb_data->rom_name, s);
	sym_ptr = SymFindPtr(SYMSTR(file_name), 0);
	if(sym_ptr != NULL && sym_ptr->flags.bits.archived == 1) {
		if(!EM_moveSymFromExtMem(SYMSTR(file_name), HS_NULL)) {
			gb_data->error = ERROR_ARCHIVE;
			HeapFree(pack_file);
			return FALSE;
		}
	}
	sym_ptr = DerefSym(SymAdd(SYMSTR(file_name)));
	if(sym_ptr == NULL) { HeapFree(pack_file); gb_data->error = ERROR_FILE_SYS; return FALSE; }
	sym_ptr->handle = pack_file;
	
	if(gb_data->archive_sram) {
		if(!EM_moveSymToExtMem(SYMSTR(file_name), HS_NULL)) gb_data->error = ERROR_ARCHIVE;
	}
	
	return TRUE;
}

char load_state(short s)
{
	STATE_HEADER *state;
	char file_name[9];
	char *data;
	char *pack_data;
	char *pack_work;
	
	sprintf(file_name, "%ss%d", gb_data->rom_name, s);
	data = file_pointer(file_name);
	if(data == NULL) return TRUE;
	state = (STATE_HEADER *)(data - 2);
	if(state->version != STATE_FILE_VERSION) return FALSE;
	pack_data = (char*)state + sizeof(STATE_HEADER);
	
	pack_work = HeapAllocPtr(MEMREQ_LZFO_UNPACK(state->mem_pack_size));
	if(pack_work == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
	lzfo_unpack(pack_data, state->mem_pack_size, gb_data->ram, 0x4200, pack_work);
	
	if(gb_data->sram_savestate && state->sram_pack_size != 0 && save_ram_size(0) != 0) {
		HeapFreePtr(pack_work);
		pack_work = HeapAllocPtr(MEMREQ_LZFO_UNPACK(state->sram_pack_size));
		pack_data += state->mem_pack_size;
		lzfo_unpack(pack_data, state->sram_pack_size, gb_data->ram + 0x4200, save_ram_size(0), pack_work);
	}
	HeapFreePtr(pack_work);
	
	gb_data->hl = state->hl;
	gb_data->bc = state->bc;
	gb_data->de = state->de;
	gb_data->a = state->a;
	gb_data->f = state->f;
	gb_data->pc = state->pc;
	gb_data->sp = state->sp;
	memcpy(gb_data->rtc_current, state->rtc_current, 5);
	memcpy(gb_data->rtc_latched, state->rtc_latched, 5);
	gb_data->next_event = state->next_event;
	gb_data->event_counter = state->event_counter;
	gb_data->cpu_halt = state->cpu_halt;
	gb_data->ime = state->ime;
	gb_data->current_rom = state->current_rom;
	gb_data->current_ram = state->current_ram;
	gb_data->ram_enable = state->ram_enable;
	gb_data->rtc_enable = state->rtc_enable;
	gb_data->rtc_latch = state->rtc_latch;
	memset(gb_data->pal_update, 0, 384);
	
	return TRUE;
}