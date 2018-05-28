// C Source File
// Created 3/31/2005; 5:13:07 PM

#define __IN_DLL__
#include <tigcclib.h>
#include "gbsram.h"
#include "lzfo1.h"
#include "gb68k.h"
#include "gbsetup.h"

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

unsigned short rle_compress(unsigned char *src, unsigned char *dst, unsigned short size)
{
	unsigned short rle_size = 0;
	unsigned short i = 0;
	unsigned char run_length;
	unsigned char run_char;
	unsigned char flag = 255;

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
	unsigned char flag = 255;
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

unsigned short save_ram_size()
{
	if(!battery_table[gb_data->rom_ptr[0][0x147]]) return 0; //no battery...don't save
	else if(gb_data->ram_banks == 4) return 0x8000; //32k cart ram
	else if(gb_data->ram_banks != 0) return 0x2000; //8k cart ram
	else if(gb_data->cart_type == MBC2)
		return 512; //mbc2 ram
	else return 0;
}

char save_state(char *file)
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
	

	size = save_ram_size();
	
	if(size != 0) {
		ST_helpMsg("Compressing...");
		rle_data = HeapAllocPtr(size);
		if(rle_data == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
		rle_size = rle_compress(gb_data->ram + 0x4200, rle_data, size);
		free(gb_data->ram); gb_data->ram = NULL;
	
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

	sprintf(file_name, "%ssv", file);
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
	header.rle_size = rle_size;
	memcpy(data, &header, sizeof(SAVE_HEADER));
	data += sizeof(SAVE_HEADER);
	if(pack_size != 0) {
		memcpy(data, pack_data, pack_size);
		data += pack_size;
	}
	*(unsigned char *)(data++) = 0;
	*(unsigned char *)(data++) = 'G';
	*(unsigned char *)(data++) = 'B';
	*(unsigned char *)(data++) = 'S';
	*(unsigned char *)(data++) = 'V';
	*(unsigned char *)(data++) = 0;
	*(unsigned char *)(data) = OTH_TAG;
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
	
	*(unsigned char *)(data++) = 0;
	*(unsigned char *)(data++) = 'G';
	*(unsigned char *)(data++) = 'B';
	*(unsigned char *)(data++) = 'S';
	*(unsigned char *)(data++) = 'V';
	*(unsigned char *)(data++) = 0;
	*(unsigned char *)(data) = OTH_TAG;
	HeapUnlock(sym_ptr->handle);
	
	if(gb_data->archive_sram) {
		if(!EM_moveSymToExtMem(SYMSTR("gb68ksv"), HS_NULL)) gb_data->error = ERROR_ARCHIVE;
	}
	
	return TRUE;
}

char load_state(char *file)
{
	SAVE_HEADER *header;
	GB_SETTINGS *settings;
	char file_name[9];
	char *pack_data;
	unsigned short pack_size;
	unsigned short size;
	unsigned short rle_size;
	char *pack_work;	
	char *rle_data;
	
	//defaults
	gb_data->enable_timer = TRUE;
	if(gb_data->calc_type == 0) gb_data->y_offset = 36;
	else gb_data->y_offset = 8;
	gb_data->frame_skip = 2;
	gb_data->show_fps = TRUE;
	gb_data->archive_sram = FALSE;

	sprintf(file_name, "%ssv", file);
	pack_data = file_pointer(file_name);
	if(pack_data == NULL) return TRUE;

	//size = *(unsigned short *)(pack_data - 2) - 7;
	//memcpy(gb_data->ram + 0x4200, pack_data, size);
	//return TRUE;

	size = save_ram_size();
	header = (SAVE_HEADER *)(pack_data - 2);

	if(header->version == 0) {
		pack_size = header->file_size - 11;
		rle_size = *(unsigned short *)(pack_data + 2);
		pack_data += 4; //skip rle size and version
	} else if(header->version == 1) {
		pack_size = header->file_size - sizeof(SAVE_HEADER) - 5;
		rle_size = header->rle_size;
		gb_data->enable_timer = header->enable_timer;
		gb_data->y_offset = header->y_offset;
		gb_data->frame_skip = header->frame_skip;
		pack_data += sizeof(SAVE_HEADER) - 2;
	} else goto load_settings;
	
	if(pack_size != 0) {
		pack_work = HeapAllocPtr(MEMREQ_LZFO_UNPACK(pack_size));
		if(pack_work == NULL) { gb_data->error = ERROR_OUT_OF_MEM; return FALSE; }
		lzfo_unpack(pack_data, pack_size, gb_data->ram + 0x4200, rle_size, pack_work);
		HeapFreePtr(pack_work);
		
		rle_data = HeapAllocPtr(size);
		memcpy(rle_data, gb_data->ram + 0x4200, size);
		rle_decompress(rle_data, gb_data->ram + 0x4200, size);
		HeapFreePtr(rle_data);
	}
	
	//now load global settings
load_settings:
	pack_data = file_pointer("gb68ksv");
	if(pack_data == NULL) return TRUE;
	
	settings = (GB_SETTINGS *)(pack_data - 2);
	if(settings->version == 0) {
		gb_data->show_fps = settings->show_fps;
		gb_data->archive_sram = settings->archive_sram;
	}

	return TRUE;
}